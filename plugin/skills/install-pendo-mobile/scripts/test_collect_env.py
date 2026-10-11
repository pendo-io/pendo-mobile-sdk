import os
import subprocess
import tempfile
import unittest
from unittest import mock

from collect_env import collect, run_command, version_line


def fake_runner(outputs):
    def run(argv, cwd, timeout):
        result = outputs[argv[0]]
        if isinstance(result, Exception):
            raise result
        return result
    return run


class CollectEnvTest(unittest.TestCase):
    def test_reports_first_versioned_line(self):
        gradle_banner = "\n------------------------------------------------------------\nGradle 8.10.2\n----\n"
        self.assertEqual(version_line(gradle_banner), "Gradle 8.10.2")

    def test_gradle_version_is_read_past_a_wrapper_download(self):
        output = ("Downloading https://services.gradle.org/distributions/gradle-6.7-all.zip\n"
                  "..........10%..........100%\n\n------------------------------------------------------------\n"
                  "Gradle 6.7\n------------------------------------------------------------\n\nKotlin: 1.3.72\n")
        with tempfile.TemporaryDirectory() as app_root:
            open(os.path.join(app_root, "gradlew"), "w").close()
            tools = collect("android", app_root, run=fake_runner({"java": "openjdk 17", "./gradlew": output}))["tools"]
        self.assertEqual(tools["gradlew"], "Gradle 6.7")

    def test_missing_and_hung_tools_are_reported_not_raised(self):
        outputs = {"xcodebuild": "Xcode 26.0\nBuild version 17A324", "pod": FileNotFoundError(),
                   "swift": subprocess.TimeoutExpired("swift", 20)}
        tools = collect("ios", run=fake_runner(outputs))["tools"]
        self.assertEqual(tools, {"xcodebuild": "Xcode 26.0", "pod": "not installed", "swift": "timed out"})

    def test_cross_platform_frameworks_report_both_native_heads(self):
        tools = collect("react-native", run=lambda argv, cwd, timeout: "v1")["tools"]
        self.assertEqual(list(tools), ["node", "yarn", "npm", "xcodebuild", "pod", "swift", "java", "gradlew"])

    def test_gradlew_that_cannot_run_is_reported(self):
        with tempfile.TemporaryDirectory() as app_root:
            open(os.path.join(app_root, "gradlew"), "w").close()
            outputs = {"java": "openjdk 17", "./gradlew": PermissionError(13, "Permission denied")}
            tools = collect("android", app_root, run=fake_runner(outputs))["tools"]
        self.assertEqual(tools["gradlew"], "not executable")

    def test_dotnet_workloads_lists_installed_ids(self):
        table = ("Installed Workload Id      Manifest Version       Installation Source\n"
                 "--------------------------------------------------------------------\n"
                 "{rows}\n"
                 "Use `dotnet workload search` to find additional workloads to install.\n")
        rows = "maui-android               10.0.0/10.0.100        SDK 10.0.100\nmaui-ios                   10.0.0/10.0.100        SDK 10.0.100\n"
        cases = {
            "with a version header": ("Workload version: 9.0.101.1\n\n" + table.format(rows=rows), "maui-android, maui-ios"),
            "without a version header": (table.format(rows=rows), "maui-android, maui-ios"),
            "none installed": (table.format(rows=""), "none installed"),
        }
        for name, (output, expected) in cases.items():
            with self.subTest(name):
                tools = collect("maui", run=fake_runner({"dotnet": output}))["tools"]
                self.assertEqual(tools["dotnet workloads"], expected)

    def test_gradlew_runs_in_android_folder_for_cross_platform(self):
        with tempfile.TemporaryDirectory() as app_root:
            os.mkdir(os.path.join(app_root, "android"))
            open(os.path.join(app_root, "android", "gradlew"), "w").close()
            seen = {}

            def run(argv, cwd, timeout):
                seen[argv[0]] = cwd
                return "v1"

            collect("react-native", app_root, run=run)
        self.assertEqual((seen["./gradlew"], seen["node"]), (os.path.join(app_root, "android"), app_root))

    def test_missing_gradle_wrapper_is_not_a_missing_tool(self):
        with tempfile.TemporaryDirectory() as app_root:
            tools = collect("android", app_root, run=fake_runner({"java": "openjdk 17", "./gradlew": FileNotFoundError()}))["tools"]
        self.assertEqual(tools["gradlew"], "no gradlew script in the repo")

    def test_failed_command_reports_only_its_exit_code(self):
        failure = subprocess.CalledProcessError(
            1, "npx", output="", stderr='npm warn Unknown user config (//corp.jfrog.io/api/npm/:always-auth)\n')
        tools = collect("maui", run=fake_runner({"dotnet": failure}))["tools"]
        self.assertEqual(tools["dotnet"], "failed (exit 1)")

    def test_run_command_prefers_stdout_over_stderr_warnings(self):
        cases = {
            "stdout has the version": (subprocess.CompletedProcess([], 0, "52.0.1\n", "npm warn config 2\n"), "52.0.1\n"),
            "version only on stderr": (subprocess.CompletedProcess([], 0, "", 'openjdk version "17.0.2"\n'),
                                       'openjdk version "17.0.2"\n'),
        }
        for name, (completed, expected) in cases.items():
            with self.subTest(name), mock.patch("collect_env.subprocess.run", return_value=completed):
                self.assertEqual(run_command(["tool"], ".", 5), expected)

    def test_run_command_turns_off_the_dotnet_first_run_banner(self):
        completed = subprocess.CompletedProcess([], 0, stdout="10.0.401\n", stderr="")
        with mock.patch("collect_env.subprocess.run", return_value=completed) as run:
            run_command(["dotnet", "--version"], ".", 5)
        self.assertEqual(run.call_args.kwargs["env"]["DOTNET_NOLOGO"], "1")


if __name__ == "__main__":
    unittest.main()
