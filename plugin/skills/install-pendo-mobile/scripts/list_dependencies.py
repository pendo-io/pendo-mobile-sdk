#!/usr/bin/env python3
"""List an app's direct dependencies and the ones that matter to Pendo, with versions, as JSON."""
import argparse
import fnmatch
import json
import os
import re
import sys

try:
    import tomllib
except ModuleNotFoundError:
    tomllib = None

RELEVANT_LIBRARIES_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "relevant_libraries.json")
CATEGORIES = ("core", "navigation", "modals_sheets", "ui_kit", "gestures_animation", "lists", "webview",
              "architecture", "analytics", "session_replay", "crash")
SKIPPED_DIRS = frozenset({"node_modules", "Pods", "build", "DerivedData", "bin", "obj"})
UNPARSED_LOCKFILES = ("pnpm-lock.yaml", "bun.lockb")
EXTERNAL_SOURCE_PREFIX = "from "
GIT_REFERENCE_KEYS = ("tag", "branch", "commit")

YARN_VERSION = re.compile(r'^\s+version:?\s+"?([^"\s]+)"?')
POD_LINE = re.compile(r'^  - "?([^\s"(]+)(?: \(([^)]*)\))?"?:?$')
EXTERNAL_SOURCES_HEADER = "EXTERNAL SOURCES:"
EXTERNAL_SOURCE_POD = re.compile(r'^  "?([^\s":]+)"?:$')
EXTERNAL_SOURCE_FIELD = re.compile(r'^    :(\w+): "?([^"]*)"?$')
REMOTE_LOCATION = re.compile(r"^(?:https?://|git@|ssh://)")
SPM_REFERENCE = re.compile(r'repositoryURL = "([^"]+)";\s*requirement = \{([^}]*)\}')
SPM_REQUIREMENT_FIELD = re.compile(r"(\w+) = ([^;]+);")
GRADLE_CONFIGURATIONS = ("implementation", "api", "compileOnly", "runtimeOnly", "kapt", "ksp",
                         "debugImplementation", "releaseImplementation")
GRADLE_COORDINATE = re.compile(
    rf"\b(?:{'|'.join(GRADLE_CONFIGURATIONS)})\s*\(?\s*(?:platform\(|enforcedPlatform\()?"
    r"""["']([\w.\-]+):([\w.\-]+)(?::([^"']+))?["']""")
GRADLE_NAMED_COORDINATE = re.compile(
    rf"\b(?:{'|'.join(GRADLE_CONFIGURATIONS)})\s*\(?\s*group\s*[:=]\s*[\"']([^\"']+)[\"']\s*,\s*"
    r"""name\s*[:=]\s*["']([^"']+)["'](?:\s*,\s*version\s*[:=]\s*["']([^"']+)["'])?""")
YAML_COMMENT = re.compile(r"(?:^|\s)#.*$")
GRADLE_LOCK_LINE = re.compile(r"^([\w.\-]+:[\w.\-]+):([^=]+)=")
PUBSPEC_SECTION = re.compile(r"^(dependencies|dev_dependencies):\s*$")
PUBSPEC_ENTRY = re.compile(r"^  ([\w-]+):\s*(.*)$")
PUBSPEC_LOCK_PACKAGE = re.compile(r"^  ([\w-]+):\s*$")
PUBSPEC_LOCK_VERSION = re.compile(r'^    version: "?([^"\s]+)"?')
PACKAGE_REFERENCE = re.compile(r"<PackageReference\b([^>]*?)(/>|>(.*?)</PackageReference>)", re.S)
PACKAGE_VERSION = re.compile(r"<PackageVersion\b([^>]*)/?>")
XML_ATTRIBUTE = re.compile(r'(\w+)="([^"]*)"')
VERSION_ELEMENT = re.compile(r"<Version>([^<]+)</Version>")


def read_text(path):
    try:
        with open(path, encoding="utf-8") as handle:
            return handle.read()
    except (OSError, UnicodeDecodeError):
        return None


def read_json(path):
    text = read_text(path)
    try:
        return json.loads(text) if text is not None else None
    except json.JSONDecodeError:
        return None


def find_files(app_root, predicate):
    found = []
    for directory, subdirectories, files in os.walk(app_root):
        subdirectories[:] = sorted(name for name in subdirectories
                                   if name not in SKIPPED_DIRS and not name.startswith("."))
        found += [os.path.join(directory, name) for name in sorted(files) if predicate(directory, name)]
    return found


class Reading:
    """Declared and resolved versions gathered from one app's files."""

    def __init__(self, app_root):
        self.app_root = app_root
        self.declared = {}
        self.resolved = {}
        self.sources = []
        self.unread = []

    def source(self, path):
        relative = os.path.relpath(path, self.app_root)
        if relative not in self.sources:
            self.sources.append(relative)

    def declare(self, name, version=""):
        if version or name not in self.declared:
            self.declared[name] = version or ""


def yarn_lock_versions(text):
    """Version for each `name@range` spec in a yarn.lock, v1 or Berry."""
    versions, specs = {}, []
    for line in text.splitlines():
        if line and not line[0].isspace() and not line.startswith("#") and line.rstrip().endswith(":"):
            specs = [spec.strip().strip('"').replace("@npm:", "@", 1) for spec in line.rstrip()[:-1].split(",")]
            continue
        found = YARN_VERSION.match(line)
        if found and specs:
            versions.update(dict.fromkeys(specs, found.group(1)))
            specs = []
    return versions


def yarn_resolved(versions, name, declared_range):
    exact = versions.get(f"{name}@{declared_range}")
    if exact:
        return exact
    candidates = {version for spec, version in versions.items() if yarn_spec_name(spec) == name}
    return candidates.pop() if len(candidates) == 1 else ""


def yarn_spec_name(spec):
    spec = spec.strip().strip('"')
    at = spec.find("@", 1)
    return spec[:at] if at > 0 else spec


def package_lock_versions(data):
    packages = data.get("packages")
    if packages:
        return {path[len("node_modules/"):]: entry.get("version", "") for path, entry in packages.items()
                if path.startswith("node_modules/") and "/node_modules/" not in path}
    return {name: entry.get("version", "") for name, entry in data.get("dependencies", {}).items()}


def read_npm(reading):
    manifest_path = os.path.join(reading.app_root, "package.json")
    manifest = read_json(manifest_path)
    if manifest is None:
        return
    reading.source(manifest_path)
    for section in ("devDependencies", "dependencies"):
        for name, version in manifest.get(section, {}).items():
            reading.declare(name, version)
    yarn_lock = os.path.join(reading.app_root, "yarn.lock")
    package_lock = os.path.join(reading.app_root, "package-lock.json")
    if os.path.isfile(yarn_lock):
        reading.source(yarn_lock)
        versions = yarn_lock_versions(read_text(yarn_lock) or "")
        reading.resolved.update({name: yarn_resolved(versions, name, declared_range)
                                 for name, declared_range in reading.declared.items()})
    elif os.path.isfile(package_lock):
        reading.source(package_lock)
        reading.resolved.update(package_lock_versions(read_json(package_lock) or {}))
    reading.unread += [name for name in UNPARSED_LOCKFILES if os.path.isfile(os.path.join(reading.app_root, name))]


def podfile_lock_sections(text):
    sections, current = {}, None
    for line in text.splitlines():
        if line and not line[0].isspace():
            current = line.rstrip(":")
            sections[current] = []
        elif current:
            found = POD_LINE.match(line)
            if found:
                sections[current].append((found.group(1).split("/")[0], found.group(2) or ""))
    return sections


def podfile_lock_external_sources(text):
    """Each pod's `EXTERNAL SOURCES` fields, such as `{"git": url, "tag": "1.0"}` or `{"path": dir}`."""
    sources, current, in_section = {}, None, False
    for line in text.splitlines():
        if line and not line[0].isspace():
            in_section = line.rstrip() == EXTERNAL_SOURCES_HEADER
            continue
        pod = EXTERNAL_SOURCE_POD.match(line) if in_section else None
        field = EXTERNAL_SOURCE_FIELD.match(line) if in_section else None
        if pod:
            current = pod.group(1)
            sources[current] = {}
        elif field and current:
            sources[current][field.group(1)] = field.group(2)
    return sources


def is_local_source(source):
    return "git" not in source and not REMOTE_LOCATION.match(source.get("podspec", ""))


def git_reference(source):
    return next((f"{key} {source[key]}" for key in GIT_REFERENCE_KEYS if key in source), "")


def read_cocoapods(reading, skip_local_pods=False):
    for path in find_files(reading.app_root, lambda _, name: name == "Podfile.lock"):
        text = read_text(path) or ""
        sections = podfile_lock_sections(text)
        external_sources = podfile_lock_external_sources(text)
        reading.source(path)
        for name, version in sections.get("PODS", []):
            reading.resolved.setdefault(name, version)
        for name, constraint in sections.get("DEPENDENCIES", []):
            if not constraint.startswith(EXTERNAL_SOURCE_PREFIX):
                reading.declare(name, constraint)
                continue
            source = external_sources.get(name, {})
            if not (skip_local_pods and is_local_source(source)):
                reading.declare(name, git_reference(source))


def repository_name(url):
    return url.rstrip("/").rsplit("/", 1)[-1].removesuffix(".git")


def spm_requirement(body):
    fields = dict(SPM_REQUIREMENT_FIELD.findall(body))
    value = fields.get("minimumVersion") or fields.get("version") or fields.get("branch") or fields.get("revision", "")
    return f"{fields.get('kind', '')} {value.strip(chr(34))}".strip()


def read_swift_packages(reading):
    referenced = False
    for path in find_files(reading.app_root, lambda _, name: name == "project.pbxproj"):
        references = SPM_REFERENCE.findall(read_text(path) or "")
        if references:
            reading.source(path)
            referenced = True
        for url, body in references:
            reading.declare(repository_name(url), spm_requirement(body))
    pinned = {}
    for path in find_files(reading.app_root, lambda _, name: name == "Package.resolved"):
        data = read_json(path) or {}
        reading.source(path)
        for pin in data.get("pins") or data.get("object", {}).get("pins", []):
            state = pin.get("state", {})
            name = repository_name(pin.get("location") or pin.get("repositoryURL") or pin.get("package", ""))
            pinned[name] = state.get("version") or state.get("branch") or state.get("revision", "")[:7]
    reading.resolved.update(pinned)
    if not referenced:
        for name in pinned:
            reading.declare(name)


def read_ios(reading):
    read_cocoapods(reading)
    read_swift_packages(reading)


def read_ios_head(reading):
    """A cross-platform app's iOS project. Pods from a local path or podspec are its own plugins, listed by its layer."""
    read_cocoapods(reading, skip_local_pods=True)
    read_swift_packages(reading)


def catalog_libraries(catalog):
    versions = catalog.get("versions", {})
    for entry in catalog.get("libraries", {}).values():
        if isinstance(entry, str):
            group, artifact, *version = entry.split(":")
            yield f"{group}:{artifact}", version[0] if version else ""
            continue
        module = entry.get("module") or f"{entry.get('group')}:{entry.get('name')}"
        version = entry.get("version", "")
        if isinstance(version, dict):
            version = versions.get(version["ref"], "") if "ref" in version else version.get("strictly", "")
        yield module, str(version)


def read_android(reading):
    def is_gradle_file(_, name):
        return name.endswith((".gradle", ".gradle.kts")) and not name.startswith("settings.")

    for path in find_files(reading.app_root, is_gradle_file):
        text = read_text(path) or ""
        coordinates = GRADLE_COORDINATE.findall(text) + GRADLE_NAMED_COORDINATE.findall(text)
        if coordinates:
            reading.source(path)
        for group, artifact, version in coordinates:
            reading.declare(f"{group}:{artifact}", version)
    for path in find_files(reading.app_root, lambda _, name: name.endswith(".versions.toml")):
        if tomllib is None:
            reading.unread.append(os.path.relpath(path, reading.app_root))
            continue
        try:
            catalog = tomllib.loads(read_text(path) or "")
        except tomllib.TOMLDecodeError:
            reading.unread.append(os.path.relpath(path, reading.app_root))
            continue
        reading.source(path)
        for module, version in catalog_libraries(catalog):
            reading.declare(module, version)
    for path in find_files(reading.app_root, lambda _, name: name == "gradle.lockfile"):
        reading.source(path)
        for line in (read_text(path) or "").splitlines():
            found = GRADLE_LOCK_LINE.match(line)
            if found:
                reading.resolved.setdefault(found.group(1), found.group(2))


def read_flutter(reading):
    pubspec_path = os.path.join(reading.app_root, "pubspec.yaml")
    pubspec = read_text(pubspec_path)
    if pubspec is None:
        return
    reading.source(pubspec_path)
    in_section = False
    for line in pubspec.splitlines():
        if line and not line[0].isspace():
            in_section = bool(PUBSPEC_SECTION.match(line))
            continue
        found = PUBSPEC_ENTRY.match(line) if in_section else None
        if found:
            reading.declare(found.group(1), YAML_COMMENT.sub("", found.group(2)).strip().strip("'\""))
    lock_path = os.path.join(reading.app_root, "pubspec.lock")
    lock = read_text(lock_path)
    if lock is None:
        return
    reading.source(lock_path)
    package = None
    for line in lock.splitlines():
        header, version = PUBSPEC_LOCK_PACKAGE.match(line), PUBSPEC_LOCK_VERSION.match(line)
        if header:
            package = header.group(1)
        elif version and package:
            reading.resolved[package] = version.group(1)


def read_maui(reading):
    central = {}
    for path in find_files(reading.app_root, lambda _, name: name == "Directory.Packages.props"):
        reading.source(path)
        for attributes in PACKAGE_VERSION.findall(read_text(path) or ""):
            fields = dict(XML_ATTRIBUTE.findall(attributes))
            central[fields.get("Include", "")] = fields.get("Version", "")
    for path in find_files(reading.app_root, lambda _, name: name.endswith(".csproj")):
        references = PACKAGE_REFERENCE.findall(read_text(path) or "")
        if references:
            reading.source(path)
        for attributes, _, body in references:
            fields = dict(XML_ATTRIBUTE.findall(attributes))
            name = fields.get("Include") or fields.get("Update", "")
            child = VERSION_ELEMENT.search(body or "")
            reading.declare(name, fields.get("Version") or (child.group(1) if child else "") or central.get(name, ""))
    for path in find_files(reading.app_root, lambda _, name: name == "packages.lock.json"):
        reading.source(path)
        for packages in (read_json(path) or {}).get("dependencies", {}).values():
            for name, entry in packages.items():
                reading.resolved.setdefault(name, entry.get("resolved", ""))


READERS = {"react-native": ("npm", read_npm), "expo": ("npm", read_npm), "ios": ("ios", read_ios),
           "android": ("maven", read_android), "flutter": ("pub", read_flutter), "maui": ("nuget", read_maui)}
NATIVE_HEADS = (("ios", "ios", read_ios_head), ("android", "maven", read_android))
CROSS_PLATFORMS = frozenset({"react-native", "expo", "flutter"})


def load_relevant_libraries():
    with open(RELEVANT_LIBRARIES_FILE, encoding="utf-8") as handle:
        return json.load(handle)


def category_of(name, rules):
    lowered = name.lower()
    return next((rule["category"] for rule in rules if fnmatch.fnmatchcase(lowered, rule["match"].lower())), None)


def direct_dependencies(reading):
    return [{"name": name, "declared": version, "resolved": reading.resolved.get(name, "")}
            for name, version in sorted(reading.declared.items(), key=lambda item: item[0].lower())]


def relevant_dependencies(direct, rules, head=None):
    relevant = []
    for entry in direct:
        category = category_of(entry["name"], rules)
        if category:
            found = {"name": entry["name"], "category": category,
                     "declared": entry["declared"], "resolved": entry["resolved"]}
            relevant.append(found | {"head": head} if head else found)
    return relevant


def list_dependencies(platform_name, app_root="."):
    """`direct` comes from the platform's own manifests. A cross-platform app also gets the curated libraries
    declared in its native projects in `relevant`, marked with `head`."""
    ecosystem, read = READERS[platform_name]
    libraries = load_relevant_libraries()
    reading = Reading(app_root)
    read(reading)
    direct = direct_dependencies(reading)
    relevant = relevant_dependencies(direct, libraries[ecosystem])
    sources, unread = list(reading.sources), list(reading.unread)
    if platform_name in CROSS_PLATFORMS:
        for head, head_ecosystem, read_head in NATIVE_HEADS:
            head_reading = Reading(app_root)
            read_head(head_reading)
            relevant += relevant_dependencies(direct_dependencies(head_reading), libraries[head_ecosystem], head)
            sources += [path for path in head_reading.sources if path not in sources]
            unread += [path for path in head_reading.unread if path not in unread]
    relevant.sort(key=lambda entry: (entry["category"], entry["name"].lower()))
    return {"sources": sources, "unread": unread, "relevant": relevant, "direct": direct}


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("platform", choices=sorted(READERS))
    parser.add_argument("--app-root", default=".")
    args = parser.parse_args(argv)
    print(json.dumps(list_dependencies(args.platform, args.app_root), indent=2))
    return 0


if __name__ == "__main__":
    sys.exit(main())
