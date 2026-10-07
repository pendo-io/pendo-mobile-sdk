import json
import os
import tempfile
import unittest

from list_dependencies import CATEGORIES, list_dependencies, load_relevant_libraries


def write_files(root, files):
    for path, content in files.items():
        full = os.path.join(root, path)
        os.makedirs(os.path.dirname(full), exist_ok=True)
        with open(full, "w") as handle:
            handle.write(content)


def listed(platform, files):
    with tempfile.TemporaryDirectory() as root:
        write_files(root, files)
        return list_dependencies(platform, root)


PACKAGE_JSON = json.dumps({
    "dependencies": {"expo-router": "~4.0.0", "@react-navigation/native": "^6.1.0", "lodash": "^4.17.21"},
    "devDependencies": {"react-native-paper": "^5.12.0"},
})


class ListDependenciesTest(unittest.TestCase):
    def test_npm_reads_versions_from_each_lockfile_format(self):
        lockfiles = {
            "yarn v1": ("yarn.lock", '"@react-navigation/native@^6.1.0":\n  version "6.1.18"\n\n'
                                     'expo-router@~4.0.0:\n  version "4.0.9"\n\n'
                                     'lodash@^4.17.21:\n  version "4.17.21"\n'),
            "yarn berry": ("yarn.lock", '__metadata:\n  version: 8\n\n"expo-router@npm:~4.0.0":\n  version: 4.0.9\n'),
            "package-lock": ("package-lock.json", json.dumps({"lockfileVersion": 3, "packages": {
                "node_modules/expo-router": {"version": "4.0.9"}}})),
        }
        for name, (lockfile, content) in lockfiles.items():
            with self.subTest(name):
                result = listed("expo", {"package.json": PACKAGE_JSON, lockfile: content})
                self.assertEqual(result["sources"], ["package.json", lockfile])
                router = next(entry for entry in result["relevant"] if entry["name"] == "expo-router")
                self.assertEqual(router, {"name": "expo-router", "category": "navigation",
                                          "declared": "~4.0.0", "resolved": "4.0.9"})

    def test_npm_lists_relevant_by_category_and_every_direct_dependency(self):
        result = listed("react-native", {"package.json": PACKAGE_JSON})
        self.assertEqual([(entry["name"], entry["category"]) for entry in result["relevant"]],
                         [("@react-navigation/native", "navigation"), ("expo-router", "navigation"),
                          ("react-native-paper", "ui_kit")])
        self.assertEqual([entry["name"] for entry in result["direct"]],
                         ["@react-navigation/native", "expo-router", "lodash", "react-native-paper"])
        self.assertEqual(result["direct"][2], {"name": "lodash", "declared": "^4.17.21", "resolved": ""})

    def test_yarn_lock_resolves_the_version_matching_the_declared_range(self):
        manifest = json.dumps({"dependencies": {"react": "19.1.0", "react-native-paper": "^5.12.0"}})
        lockfiles = {
            "yarn v1": 'react@^16.8.0:\n  version "16.13.1"\n\nreact@19.1.0:\n  version "19.1.0"\n\n'
                       '"react-native-paper@^5.12.0", react-native-paper@^5.14.0:\n  version "5.14.5"\n',
            "yarn berry": '"react@npm:^16.8.0":\n  version: 16.13.1\n\n"react@npm:19.1.0":\n  version: 19.1.0\n',
        }
        for name, content in lockfiles.items():
            with self.subTest(name):
                result = listed("react-native", {"package.json": manifest, "yarn.lock": content})
                self.assertEqual(result["direct"][0], {"name": "react", "declared": "19.1.0", "resolved": "19.1.0"})
        result = listed("react-native", {"package.json": manifest, "yarn.lock": lockfiles["yarn v1"]})
        self.assertEqual(result["direct"][1]["resolved"], "5.14.5")

    def test_hidden_folders_are_not_read(self):
        result = listed("ios", {".worktrees/old/Podfile.lock": "PODS:\n  - SnapKit (5.0.0)\n\nDEPENDENCIES:\n  - SnapKit\n"})
        self.assertEqual(result, {"sources": [], "unread": [], "relevant": [], "direct": []})

    def test_unparsed_lockfile_is_reported(self):
        result = listed("expo", {"package.json": PACKAGE_JSON, "pnpm-lock.yaml": "lockfileVersion: '9.0'\n"})
        self.assertEqual(result["unread"], ["pnpm-lock.yaml"])

    def test_ios_reads_cocoapods_and_swift_packages(self):
        podfile_lock = ("PODS:\n  - Firebase/Analytics (11.2.0):\n    - FirebaseAnalytics (~> 11.2.0)\n"
                        "  - FirebaseAnalytics (11.2.0)\n  - SnapKit (5.7.1)\n\n"
                        "DEPENDENCIES:\n  - Firebase/Analytics\n  - SnapKit (~> 5.0)\n\nCOCOAPODS: 1.16.2\n")
        pbxproj = ('repositoryURL = "https://github.com/airbnb/lottie-ios.git";\n'
                   "\t\t\trequirement = {\n\t\t\t\tkind = upToNextMajorVersion;\n\t\t\t\tminimumVersion = 4.4.0;\n\t\t\t};\n")
        resolved = json.dumps({"version": 2, "pins": [
            {"identity": "lottie-ios", "location": "https://github.com/airbnb/lottie-ios.git",
             "state": {"version": "4.5.0", "revision": "abc"}},
            {"identity": "swift-collections", "location": "https://github.com/apple/swift-collections",
             "state": {"version": "1.1.0"}}]})
        result = listed("ios", {
            "Podfile.lock": podfile_lock,
            "Shop.xcodeproj/project.pbxproj": pbxproj,
            "Shop.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved": resolved,
        })
        self.assertEqual(result["relevant"], [
            {"name": "Firebase", "category": "analytics", "declared": "", "resolved": "11.2.0"},
            {"name": "lottie-ios", "category": "gestures_animation", "declared": "upToNextMajorVersion 4.4.0",
             "resolved": "4.5.0"},
            {"name": "SnapKit", "category": "ui_kit", "declared": "~> 5.0", "resolved": "5.7.1"},
        ])
        self.assertEqual([entry["name"] for entry in result["direct"]], ["Firebase", "lottie-ios", "SnapKit"])

    def test_swift_packages_count_as_direct_when_the_project_lists_none(self):
        resolved = json.dumps({"object": {"pins": [
            {"package": "SnapKit", "repositoryURL": "https://github.com/SnapKit/SnapKit", "state": {"version": "5.7.1"}}]}})
        result = listed("ios", {"Podfile.lock": "PODS:\n  - Sentry (8.36.0)\n\nDEPENDENCIES:\n  - Sentry\n",
                                "Package.resolved": resolved})
        self.assertEqual([(entry["name"], entry["resolved"]) for entry in result["direct"]],
                         [("Sentry", "8.36.0"), ("SnapKit", "5.7.1")])

    def test_android_reads_gradle_files_version_catalog_and_lockfile(self):
        build_gradle = (
            "dependencies {\n"
            '  implementation(platform("androidx.compose:compose-bom:2024.09.00"))\n'
            '  implementation("androidx.compose.ui:ui")\n'
            '  implementation("io.sentry:sentry-android:$sentryVersion")\n'
            "  implementation(libs.navigation.compose)\n"
            "  implementation 'com.squareup.okhttp3:okhttp:4.12.0'\n"
            "  implementation group: 'sdk.pendo.io', name: 'pendoIO', version: '3.14.+', changing: true\n"
            '  implementation(group = "com.airbnb.android", name = "lottie", version = "6.5.0")\n'
            "}\n")
        catalog = ('[versions]\nnavigation = "2.8.0"\n\n[libraries]\n'
                   'navigation-compose = { module = "androidx.navigation:navigation-compose", version.ref = "navigation" }\n')
        lockfile = "androidx.navigation:navigation-compose:2.8.1=releaseRuntimeClasspath\n"
        result = listed("android", {"app/build.gradle.kts": build_gradle, "gradle/libs.versions.toml": catalog,
                                    "app/gradle.lockfile": lockfile})
        self.assertEqual(result["relevant"], [
            {"name": "io.sentry:sentry-android", "category": "crash", "declared": "$sentryVersion", "resolved": ""},
            {"name": "com.airbnb.android:lottie", "category": "gestures_animation", "declared": "6.5.0", "resolved": ""},
            {"name": "androidx.navigation:navigation-compose", "category": "navigation", "declared": "2.8.0",
             "resolved": "2.8.1"},
            {"name": "androidx.compose.ui:ui", "category": "ui_kit", "declared": "", "resolved": ""},
            {"name": "androidx.compose:compose-bom", "category": "ui_kit", "declared": "2024.09.00", "resolved": ""},
        ])
        self.assertIn({"name": "com.squareup.okhttp3:okhttp", "declared": "4.12.0", "resolved": ""}, result["direct"])
        self.assertIn({"name": "sdk.pendo.io:pendoIO", "declared": "3.14.+", "resolved": ""}, result["direct"])
        self.assertIn({"name": "com.airbnb.android:lottie", "declared": "6.5.0", "resolved": ""}, result["direct"])

    def test_flutter_reads_pubspec_and_lock(self):
        pubspec = ("name: shop\ndependencies:\n  flutter:\n    sdk: flutter\n  go_router: ^14.2.0\n"
                   "  http: ^1.2.0\n  pendo_sdk: #3.7.0\n    path: ../pendo\ndev_dependencies:\n  flutter_test:\n    sdk: flutter\n")
        lock = ('packages:\n  go_router:\n    dependency: "direct main"\n    source: hosted\n    version: "14.2.7"\n'
                '  http:\n    dependency: "direct main"\n    version: "1.2.2"\n')
        result = listed("flutter", {"pubspec.yaml": pubspec, "pubspec.lock": lock})
        self.assertEqual(result["relevant"], [
            {"name": "go_router", "category": "navigation", "declared": "^14.2.0", "resolved": "14.2.7"}])
        self.assertEqual([entry["name"] for entry in result["direct"]],
                         ["flutter", "flutter_test", "go_router", "http", "pendo_sdk"])
        self.assertEqual(result["direct"][-1]["declared"], "")

    def test_maui_reads_package_references_and_central_versions(self):
        csproj = ('<Project><ItemGroup>\n<PackageReference Include="CommunityToolkit.Maui" Version="9.1.0" />\n'
                  '<PackageReference Include="Sentry.Maui" />\n'
                  '<PackageReference Include="Newtonsoft.Json">\n  <Version>13.0.3</Version>\n</PackageReference>\n'
                  "</ItemGroup></Project>\n")
        props = '<Project><ItemGroup><PackageVersion Include="Sentry.Maui" Version="4.12.0" /></ItemGroup></Project>'
        result = listed("maui", {"Shop/Shop.csproj": csproj, "Directory.Packages.props": props})
        self.assertEqual(result["relevant"], [
            {"name": "Sentry.Maui", "category": "crash", "declared": "4.12.0", "resolved": ""},
            {"name": "CommunityToolkit.Maui", "category": "ui_kit", "declared": "9.1.0", "resolved": ""}])
        self.assertIn({"name": "Newtonsoft.Json", "declared": "13.0.3", "resolved": ""}, result["direct"])

    def test_cross_platform_apps_add_curated_libraries_from_their_native_projects(self):
        layers = {
            "react-native": ("package.json", json.dumps({"dependencies": {"mixpanel-react-native": "^3.0.0"}}),
                             "MixpanelReactNative", "../node_modules/mixpanel-react-native"),
            "expo": ("package.json", json.dumps({"dependencies": {"mixpanel-react-native": "^3.0.0"}}),
                     "MixpanelReactNative", "../node_modules/mixpanel-react-native"),
            "flutter": ("pubspec.yaml", "name: shop\ndependencies:\n  mixpanel_flutter: ^2.3.0\n",
                        "mixpanel_flutter", ".symlinks/plugins/mixpanel_flutter/ios"),
        }
        for platform, (manifest, manifest_text, plugin_pod, plugin_path) in layers.items():
            with self.subTest(platform):
                podfile_lock = (
                    "PODS:\n  - AppsFlyerFramework (6.15.2)\n  - Instabug (13.0.0)\n  - Sentry (8.36.0)\n\n"
                    "DEPENDENCIES:\n  - AppsFlyerFramework (~> 6.15)\n"
                    "  - Instabug (from `https://github.com/Instabug/Instabug-iOS.git`, tag `13.0.0`)\n"
                    "  - Sentry (from `https://cdn.example.com/Sentry.podspec`)\n"
                    "  - SmartlookAnalytics (from `../node_modules/smartlook/SmartlookAnalytics.podspec`)\n"
                    f"  - {plugin_pod} (from `{plugin_path}`)\n\n"
                    "EXTERNAL SOURCES:\n"
                    "  Instabug:\n    :git: https://github.com/Instabug/Instabug-iOS.git\n    :tag: 13.0.0\n"
                    "  Sentry:\n    :podspec: https://cdn.example.com/Sentry.podspec\n"
                    '  SmartlookAnalytics:\n    :podspec: "../node_modules/smartlook/SmartlookAnalytics.podspec"\n'
                    f'  {plugin_pod}:\n    :path: "{plugin_path}"\n')
                build_gradle = ("dependencies {\n  implementation project(':mixpanel')\n"
                                "  implementation 'io.sentry:sentry-android:7.14.0'\n}\n")
                result = listed(platform, {manifest: manifest_text, "ios/Podfile.lock": podfile_lock,
                                           "android/app/build.gradle": build_gradle})
                layer_name = "mixpanel_flutter" if platform == "flutter" else "mixpanel-react-native"
                self.assertEqual([entry for entry in result["relevant"] if "head" in entry], [
                    {"name": "AppsFlyerFramework", "category": "analytics", "declared": "~> 6.15",
                     "resolved": "6.15.2", "head": "ios"},
                    {"name": "Instabug", "category": "crash", "declared": "tag 13.0.0",
                     "resolved": "13.0.0", "head": "ios"},
                    {"name": "io.sentry:sentry-android", "category": "crash", "declared": "7.14.0",
                     "resolved": "", "head": "android"},
                    {"name": "Sentry", "category": "crash", "declared": "", "resolved": "8.36.0", "head": "ios"},
                ])
                self.assertEqual([entry["name"] for entry in result["direct"]], [layer_name])
                self.assertEqual(result["sources"], [manifest, "ios/Podfile.lock", "android/app/build.gradle"])

    def test_repo_without_manifests_lists_nothing(self):
        for platform in ("expo", "ios", "android", "flutter", "maui"):
            with self.subTest(platform):
                self.assertEqual(listed(platform, {}),
                                 {"sources": [], "unread": [], "relevant": [], "direct": []})

    def test_every_relevant_library_has_a_known_category(self):
        for ecosystem, entries in load_relevant_libraries().items():
            for entry in entries:
                with self.subTest(ecosystem=ecosystem, match=entry["match"]):
                    self.assertIn(entry["category"], CATEGORIES)


if __name__ == "__main__":
    unittest.main()
