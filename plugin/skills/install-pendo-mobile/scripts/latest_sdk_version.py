#!/usr/bin/env python3
"""Print the newest stable Pendo SDK version on one release channel, within one major version."""
import argparse
import http.client
import json
import re
import subprocess
import sys
import urllib.request
import xml.etree.ElementTree as ElementTree

EXIT_UNVERIFIED = 2
DEFAULT_MAJOR = 3
TIMEOUT_SECONDS = 15
STABLE_VERSION = re.compile(r"^\d+(\.\d+)+$")


def npm_versions(body):
    return list(json.loads(body)["versions"])


def pub_versions(body):
    return [entry["version"] for entry in json.loads(body)["versions"]]


def nuget_versions(body):
    return json.loads(body)["versions"]


def maven_versions(body):
    return [node.text for node in ElementTree.fromstring(body).iter("version")]


def git_tag_versions(body):
    return [line.rsplit("/", 1)[-1] for line in body.splitlines() if line]


def cocoapods_versions(body):
    return [entry["name"] for entry in json.loads(body)["versions"]]


CHANNELS = {
    "npm": ("url", "https://registry.npmjs.org/rn-pendo-sdk", npm_versions),
    "pub": ("url", "https://pub.dev/api/packages/pendo_sdk", pub_versions),
    "nuget": ("url", "https://api.nuget.org/v3-flatcontainer/pendo-maui/index.json", nuget_versions),
    "maven": (
        "url",
        "https://software.mobile.pendo.io/artifactory/androidx-release/sdk/pendo/io/pendoIO/maven-metadata.xml",
        maven_versions,
    ),
    "spm": ("git", "https://github.com/pendo-io/pendo-mobile-sdk", git_tag_versions),
    "cocoapods": ("url", "https://trunk.cocoapods.org/api/v1/pods/Pendo", cocoapods_versions),
}


def fetch(kind, location):
    if kind == "git":
        return subprocess.run(
            ["git", "ls-remote", "--tags", "--refs", location],
            capture_output=True, text=True, check=True, timeout=TIMEOUT_SECONDS,
        ).stdout
    with urllib.request.urlopen(location, timeout=TIMEOUT_SECONDS) as response:
        return response.read().decode("utf-8")


def version_key(version):
    return tuple(int(part) for part in version.split("."))


def newest_stable(versions, major):
    stable = [v for v in versions if STABLE_VERSION.match(v) and version_key(v)[0] == major]
    return max(stable, key=version_key, default=None)


def latest_version(channel, major, fetch=fetch):
    kind, location, parse = CHANNELS[channel]
    return newest_stable(parse(fetch(kind, location)), major)


def main(argv=None, fetch=fetch):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("channel", choices=sorted(CHANNELS))
    parser.add_argument("--major", type=int, default=DEFAULT_MAJOR)
    args = parser.parse_args(argv)
    try:
        version = latest_version(args.channel, args.major, fetch)
    except (OSError, http.client.HTTPException, subprocess.SubprocessError,
            ValueError, KeyError, TypeError, ElementTree.ParseError) as error:
        print(f"unverified: {args.channel} lookup failed: {error}", file=sys.stderr)
        return EXIT_UNVERIFIED
    if version is None:
        print(f"unverified: no stable {args.major}.x release on {args.channel}", file=sys.stderr)
        return EXIT_UNVERIFIED
    print(version)
    return 0


if __name__ == "__main__":
    sys.exit(main())
