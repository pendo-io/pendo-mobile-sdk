import contextlib
import http.client
import io
import unittest
import urllib.error

from latest_sdk_version import EXIT_UNVERIFIED, latest_version, main


def serving(body):
    return lambda kind, location: body


def unreachable(kind, location):
    raise urllib.error.URLError("network down")


def cut_off(kind, location):
    raise http.client.IncompleteRead(b"")


class LatestVersionTest(unittest.TestCase):
    def test_compares_numerically_not_lexically(self):
        body = '{"versions": {"3.9.2": {}, "3.14.2": {}, "3.10.0": {}}}'
        self.assertEqual(latest_version("npm", 3, serving(body)), "3.14.2")

    def test_excludes_prereleases_and_other_majors(self):
        body = '{"versions": {"3.14.2": {}, "3.15.0-beta.1": {}, "4.0.0": {}}}'
        self.assertEqual(latest_version("npm", 3, serving(body)), "3.14.2")

    def test_parses_every_channel_shape(self):
        cases = {
            "pub": ('{"versions": [{"version": "3.13.5"}, {"version": "3.14.2"}]}', "3.14.2"),
            "nuget": ('{"versions": ["3.13.9.10194", "3.14.2.10846", "3.14.2.9999"]}', "3.14.2.10846"),
            "maven": (
                "<metadata><versioning><versions><version>3.13.4.1</version>"
                "<version>3.14.5.10846</version></versions></versioning></metadata>",
                "3.14.5.10846",
            ),
            "spm": ("abc123\trefs/tags/3.14.4\ndef456\trefs/tags/3.14.5\n", "3.14.5"),
            "cocoapods": ('{"versions": [{"name": "3.9.1.1"}, {"name": "3.9.2.10806"}]}', "3.9.2.10806"),
        }
        for channel, (body, expected) in cases.items():
            with self.subTest(channel=channel):
                self.assertEqual(latest_version(channel, 3, serving(body)), expected)


class MainTest(unittest.TestCase):
    def run_main(self, argv, fetch):
        out, err = io.StringIO(), io.StringIO()
        with contextlib.redirect_stdout(out), contextlib.redirect_stderr(err):
            code = main(argv, fetch)
        return code, out.getvalue(), err.getvalue()

    def test_prints_version_and_exits_zero(self):
        code, out, _ = self.run_main(["npm"], serving('{"versions": {"3.14.2": {}}}'))
        self.assertEqual((code, out), (0, "3.14.2\n"))

    def test_network_failure_is_unverified(self):
        code, out, err = self.run_main(["maven"], unreachable)
        self.assertEqual((code, out), (EXIT_UNVERIFIED, ""))
        self.assertTrue(err.startswith("unverified: maven lookup failed"))

    def test_broken_responses_are_unverified(self):
        cases = {
            "read cut off": ("npm", cut_off),
            "empty maven version": ("maven", serving("<metadata><version/></metadata>")),
            "null version list": ("nuget", serving('{"versions": null}')),
        }
        for name, (channel, fetch) in cases.items():
            with self.subTest(name):
                code, out, err = self.run_main([channel], fetch)
                self.assertEqual((code, out), (EXIT_UNVERIFIED, ""))
                self.assertTrue(err.startswith(f"unverified: {channel} lookup failed"))

    def test_no_release_in_major_is_unverified(self):
        code, _, err = self.run_main(["npm"], serving('{"versions": {"4.0.0": {}}}'))
        self.assertEqual(code, EXIT_UNVERIFIED)
        self.assertEqual(err, "unverified: no stable 3.x release on npm\n")


if __name__ == "__main__":
    unittest.main()
