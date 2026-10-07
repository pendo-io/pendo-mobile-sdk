#!/usr/bin/env python3
"""Print the toolchain versions that matter for one platform, as JSON."""
import argparse
import json
import os
import platform
import re
import subprocess
import sys

DEFAULT_TIMEOUT_SECONDS = 20
GRADLE_TIMEOUT_SECONDS = 120
HAS_DIGIT = re.compile(r"\d")
TABLE_RULE = re.compile(r"^-{5,}$")
GRADLE_VERSION_LINE = re.compile(r"^Gradle \d")
GRADLEW_LABEL = "gradlew"
WORKLOADS_LABEL = "dotnet workloads"
QUIET_TOOL_ENV = {"DOTNET_NOLOGO": "1", "DOTNET_SKIP_FIRST_TIME_EXPERIENCE": "1"}

IOS_TOOLS = (("xcodebuild", ["xcodebuild", "-version"]), ("pod", ["pod", "--version"]),
             ("swift", ["swift", "--version"]))
ANDROID_TOOLS = (("java", ["java", "-version"]), (GRADLEW_LABEL, ["./gradlew", "--version"]))
JS_TOOLS = (("node", ["node", "--version"]), ("yarn", ["yarn", "--version"]), ("npm", ["npm", "--version"]))

PLATFORM_TOOLS = {
    "ios": IOS_TOOLS,
    "android": ANDROID_TOOLS,
    "react-native": JS_TOOLS + IOS_TOOLS + ANDROID_TOOLS,
    "expo": JS_TOOLS + (("expo", ["npx", "--no-install", "expo", "--version"]),) + IOS_TOOLS + ANDROID_TOOLS,
    "flutter": (("flutter", ["flutter", "--version"]), ("dart", ["dart", "--version"])) + IOS_TOOLS + ANDROID_TOOLS,
    "maui": (("dotnet", ["dotnet", "--version"]), (WORKLOADS_LABEL, ["dotnet", "workload", "list"])),
}


def run_command(argv, cwd, timeout):
    completed = subprocess.run(argv, cwd=cwd, capture_output=True, text=True, timeout=timeout, check=True,
                               env={**os.environ, **QUIET_TOOL_ENV})
    return completed.stdout if completed.stdout.strip() else completed.stderr


def first_line(text):
    return next((line.strip() for line in (text or "").splitlines() if line.strip()), "")


def version_line(output):
    versioned = (line.strip() for line in output.splitlines() if HAS_DIGIT.search(line))
    return next(versioned, first_line(output))


def workload_ids(output):
    lines = [line.strip() for line in output.splitlines()]
    rule = next((index for index, line in enumerate(lines) if TABLE_RULE.match(line)), None)
    if rule is None:
        return version_line(output)
    ids = []
    for line in lines[rule + 1:]:
        if not line:
            break
        ids.append(line.split()[0])
    return ", ".join(ids) or "none installed"


def gradle_version(output):
    lines = (line.strip() for line in output.splitlines())
    return next((line for line in lines if GRADLE_VERSION_LINE.match(line)), version_line(output))


OUTPUT_PARSERS = {WORKLOADS_LABEL: workload_ids, GRADLEW_LABEL: gradle_version}


def gradle_project_dir(app_root):
    nested = os.path.join(app_root, "android")
    return nested if os.path.isfile(os.path.join(nested, "gradlew")) else app_root


def describe(label, argv, app_root, run):
    is_gradle = argv[0] == "./gradlew"
    timeout = GRADLE_TIMEOUT_SECONDS if is_gradle else DEFAULT_TIMEOUT_SECONDS
    cwd = gradle_project_dir(app_root) if is_gradle else app_root
    if is_gradle and not os.path.isfile(os.path.join(cwd, "gradlew")):
        return "no gradlew script in the repo"
    try:
        return OUTPUT_PARSERS.get(label, version_line)(run(argv, cwd, timeout))
    except FileNotFoundError:
        return "not installed"
    except PermissionError:
        return "not executable"
    except subprocess.TimeoutExpired:
        return "timed out"
    except subprocess.CalledProcessError as failure:
        return f"failed (exit {failure.returncode})"


def collect(platform_name, app_root=".", run=run_command):
    tools = {label: describe(label, argv, app_root, run) for label, argv in PLATFORM_TOOLS[platform_name]}
    return {"os": f"{platform.system()} {platform.release()} ({platform.machine()})", "tools": tools}


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("platform", choices=sorted(PLATFORM_TOOLS))
    parser.add_argument("--app-root", default=".")
    args = parser.parse_args(argv)
    print(json.dumps(collect(args.platform, args.app_root), indent=2))
    return 0


if __name__ == "__main__":
    sys.exit(main())
