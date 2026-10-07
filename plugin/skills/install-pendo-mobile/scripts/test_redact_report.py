import io
import json
import unittest

from redact_report import EXIT_SECRETS_FOUND, main, redact

FAKE_JWT = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhcHAta2V5LXRlc3QifQ.c2lnbmF0dXJlLXZhbHVlLXRlc3Q"
LITERAL = "<redacted:literal>"
MIN_PIECE = 3


class RedactTest(unittest.TestCase):
    def test_masks_every_literal_in_init_and_session_calls(self):
        cases = {
            "setup key": (f'Pendo.setup(this, "{FAKE_JWT}", null, null)',
                          f'Pendo.setup(this, "{LITERAL}", null, null)'),
            "session literals": ("PendoSDK.startSession('user123', 'acme', {}, {});",
                                 f"PendoSDK.startSession('{LITERAL}', '{LITERAL}', {{}}, {{}});"),
            "MAUI StartSession": ('pendo.StartSession("jane.doe", "acme-corp", null, null);',
                                  f'pendo.StartSession("{LITERAL}", "{LITERAL}", null, null);'),
            "literal after a nested call": ("PendoSDK.startSession(String(42), 'acme')",
                                            f"PendoSDK.startSession(String(42), '{LITERAL}')"),
            "ternary branch": ('Pendo.startSession(debug ? "test-user" : user.id, "")',
                               f'Pendo.startSession(debug ? "{LITERAL}" : user.id, "")'),
            "per-platform keys": ("PendoSDK.setup(Platform.OS === 'ios' ? 'iosKeyValue1' : 'androidKeyValue2', opts)",
                                  f"PendoSDK.setup(Platform.OS === '{LITERAL}' ? '{LITERAL}' : '{LITERAL}', opts)"),
            "kotlin if expression": ('Pendo.setup(this, if (BuildConfig.DEBUG) "devKeyValue" else "prodKeyValue", null, null)',
                                     f'Pendo.setup(this, if (BuildConfig.DEBUG) "{LITERAL}" else "{LITERAL}", null, null)'),
            "init option": ("PendoSDK.setup(PENDO_KEY, { environmentName: 'staging' })",
                            f"PendoSDK.setup(PENDO_KEY, {{ environmentName: '{LITERAL}' }})"),
            "session map value": ('Pendo.startSession(id, "", mapOf("email" to "jane@x.io"), null)',
                                  f'Pendo.startSession(id, "", mapOf("email" to "{LITERAL}"), null)'),
            "template literals": ("PendoSDK.startSession(`jane-${x}`, 'acme')",
                                  f"PendoSDK.startSession(`{LITERAL}`, '{LITERAL}')"),
            "template literal key": ("PendoSDK.setup(`abcd1234realkey`)", f"PendoSDK.setup(`{LITERAL}`)"),
            "escaped quote": ('Pendo.startSession("ja\\"ne-visitor", "acme")',
                              f'Pendo.startSession("{LITERAL}", "{LITERAL}")'),
            "raw string": ('Pendo.startSession("""\njane-visitor\n""", "")',
                           f'Pendo.startSession("""{LITERAL}""", "")'),
            "blank line inside the call": ('Pendo.setup(\n    this,\n\n    "abcd1234realkey",\n    null)',
                                           f'Pendo.setup(\n    this,\n\n    "{LITERAL}",\n    null)'),
            "call quoted in inline code": ('Init: `Pendo.setup(this, "abcd1234realkey")` in onCreate',
                                           f'Init: `Pendo.setup(this, "{LITERAL}")` in onCreate'),
            "truncated call in inline code": ('Init: `Pendo.setup(this, "abcd1234realkey"` and more',
                                              f'Init: `Pendo.setup(this, "{LITERAL}"` and more'),
            "objective-c 2.x init": ('[[PendoManager sharedManager] initSDK:@"key-1234567" initParams:params];',
                                     f'[[PendoManager sharedManager] initSDK:@"{LITERAL}" initParams:params];'),
            "objective-c session": ('[PendoManager.sharedManager startSession:@"jane" accountId:@"acme" '
                                    'visitorData:@{@"plan": @"gold"} accountData:nil];',
                                    f'[PendoManager.sharedManager startSession:@"{LITERAL}" accountId:@"{LITERAL}" '
                                    f'visitorData:@{{@"plan": @"{LITERAL}"}} accountData:nil];'),
            "android 2.x init": ('Pendo.initSDK(this, "key-1234567", initParams)', f'Pendo.initSDK(this, "{LITERAL}", initParams)'),
            "identity setter": ('initParams.setVisitorId("jane")', f'initParams.setVisitorId("{LITERAL}")'),
            "identity property": ('initParams.visitorId = @"jane";', f'initParams.visitorId = @"{LITERAL}";'),
            "truncated call in a code block": ('```kotlin\nPendo.setup(\n    this,\n    "abcd1234realkey",\n```',
                                               f'```kotlin\nPendo.setup(\n    this,\n    "{LITERAL}",\n```'),
        }
        for name, (given, expected) in cases.items():
            with self.subTest(name):
                self.assertEqual(redact(given)[0], expected)

    def test_masks_each_secret_shape(self):
        cases = {
            "bare jwt": (f"token in config: {FAKE_JWT}", "token in config: <redacted:jwt>"),
            "bearer": ("Authorization: Bearer abcDEF123456ghiJKL", "Authorization: <redacted:bearer>"),
            "key=value": ('apiKey = "s3cr3tValue99"', 'apiKey = "<redacted:secret>"'),
            "json key": ('"apiKey": "abcd1234realkey"', '"apiKey": "<redacted:secret>"'),
            "env file": ("PENDO_API_KEY=abcd1234realkey", "PENDO_API_KEY=<redacted:secret>"),
            "prefixed name": ('pendoApiKey = "abcd1234realkey"', 'pendoApiKey = "<redacted:secret>"'),
            "Info.plist": ("<key>PendoAppKey</key>\n<string>abcd1234realkey</string>",
                           "<key>PendoAppKey</key>\n<string><redacted:secret></string>"),
            "strings.xml": ('<string name="pendo_api_key">abcd1234realkey</string>',
                            '<string name="pendo_api_key"><redacted:secret></string>'),
            "home folder": ('url = uri("/Users/roman.doe/Desktop/sdk/build")', 'url = uri("/Users/<redacted:user>/Desktop/sdk/build")'),
            "linux home": ("app root /home/jane/src/shop", "app root /home/<redacted:user>/src/shop"),
            "windows home": ("C:\\Users\\jane\\src\\shop", "C:\\Users\\<redacted:user>\\src\\shop"),
            "email": ("visitorData: { email: 'jane.doe@acme.com' }", "visitorData: { email: '<redacted:email>' }"),
            "hex": ("secret blob 9f86d081884c7d659a2feaa0c55ad015a3bf4f1b", "secret blob <redacted:hex>"),
            "base64": ("blob Zm9vYmFyQmF6UXV4MTIzNDU2Nzg5MGFiY2RlZmdoaWprbG1u done",
                       "blob <redacted:base64> done"),
        }
        for name, (given, expected) in cases.items():
            with self.subTest(name):
                self.assertEqual(redact(given)[0], expected)

    def test_masks_every_piece_of_a_split_key(self):
        def assert_no_piece_left(pieces, text):
            redacted = redact(text)[0]
            for piece in pieces:
                self.assertNotIn(piece, redacted)

        for split in range(MIN_PIECE, len(FAKE_JWT) - MIN_PIECE):
            head, tail = FAKE_JWT[:split], FAKE_JWT[split:]
            with self.subTest(split=split):
                assert_no_piece_left((head, tail), f'let key = "{head}" +\n    "{tail}"')
        thirds = (FAKE_JWT[:30], FAKE_JWT[30:60], FAKE_JWT[60:])
        assert_no_piece_left(thirds, 'val key = "' + '" + "'.join(thirds) + '"')

    def test_keeps_safe_values(self):
        safe = [
            'PendoSDK.setup("YOUR_API_KEY_HERE", { library: NavigationLibraryType.ExpoRouter })',
            '"ios-scheme": "YOUR_SCHEME_ID_HERE"',
            "<key>PendoAppKey</key>\n<string>YOUR_API_KEY_HERE</string>",
            "<key>CFBundleURLSchemes</key>\n<array><string>pendo-aaaa1111</string></array>",
            "applicationId com.acme.shop, scheme pendo-aaaa1111",
            "android/app/src/main/java/com/acme/shop/ShopApplication.kt:9",
            "PendoNavigationContainerWrapper2Impl in src/App.tsx",
            "rn-pendo-sdk 3.14.2, maven 3.14.5.10846",
            "token = response.data.token",
            "initParams.visitorId = user.identifier;",
            "visitorId: taken from the login response",
            "setupView(\"Welcome\")",
            "Pendo.startSession(session.user.id, session.user.orgId, null, null)",
            "PendoSDK.startSession(user.id, '', {}, {})",
            'Pendo.startSession(session.user.id, "", mapOf("email" to session.user.email), null)',
            "PendoSDK.startSession(user.id, org.id, {'plan': user.plan}, {})",
            "Call `startSession(` after login.\n\nIt doesn't run while it's offline.",
            'One `Pendo.setup(` call is present.\n  implementation(group = "sdk.pendo.io", name = "pendoIO")',
        ]
        for text in safe:
            with self.subTest(text):
                self.assertEqual(redact(text)[0], text)

    def test_counts_masks_by_kind(self):
        _, counts = redact(f'Pendo.setup(this, "{FAKE_JWT}"); mail jane@acme.com and bob@acme.com')
        self.assertEqual(dict(counts), {"literal": 1, "email": 2})

    def test_json_block_stays_valid_and_redaction_is_idempotent(self):
        block = json.dumps({"session_sites": [{"evidence": "startSession('user123')"}],
                            "note": f"Bearer {FAKE_JWT}"})
        once = redact(block)[0]
        self.assertEqual(json.loads(once)["note"], "<redacted:bearer>")
        self.assertEqual(redact(once)[0], once)


class MainTest(unittest.TestCase):
    def run_main(self, argv, text):
        out, err = io.StringIO(), io.StringIO()
        code = main(argv, io.StringIO(text), out, err)
        return code, out.getvalue(), err.getvalue()

    def test_filter_writes_redacted_text_and_summary(self):
        code, out, err = self.run_main([], "mail jane@acme.com\n")
        self.assertEqual((code, out, err), (0, "mail <redacted:email>\n", "redacted 1 value(s): email=1\n"))

    def test_check_mode_exit_codes(self):
        self.assertEqual(self.run_main(["--check"], "mail jane@acme.com")[:2], (EXIT_SECRETS_FOUND, ""))
        self.assertEqual(self.run_main(["--check"], "nothing secret here")[:2], (0, ""))


if __name__ == "__main__":
    unittest.main()
