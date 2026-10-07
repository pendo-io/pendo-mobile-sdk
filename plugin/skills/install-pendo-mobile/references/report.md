# Report — a support report for Pendo Technical Support

Read only in `--mode report`, after `SKILL.md` Phases 1–4. You enter with `platform`, `subPlatform`, the one `references/<platform>.md` read in Phase 2, Phase 3's state (`complete`, `partial`, or no install), and every Phase 4 outcome.

Report reads only. Its one write is `pendo-support-report.md` and `pendo-support-report.json`, in R4, and only after the user says yes. It never asks for a credential, never creates a branch, and never stages or commits anything.

**The report never contains an API key, a credential or secret of any kind, or a real visitor or account value.** In tables and in the JSON, describe identifiers by kind ("`user.id` from the login response"), never by value. The app name, its bundle ID or applicationId, and its `pendo-` pairing scheme are allowed: TS needs them to find the app.

**Quote init and session calls as the repo has them.** TS needs their real shape, and R3's script masks every string literal inside Pendo's init and identity calls (`setup`, `startSession`, 2.x `initSDK`, `setVisitorId`, `setAccountId` and the rest, in call or Objective-C message form), so do not mask those values yourself, even in doctor's evidence lines (this overrides D2's `<redacted>` rule in this mode); its count tells the user what was hidden. That includes string options such as `environmentName: 'staging'`, so name each option in the integration map by its key. Any other line you quote that holds a key, credential or identifier value (an assignment such as `val visitor = "…"`, a config entry): replace the value with `<redacted:literal>` yourself, because the script only masks literals inside init and session calls and values with a known secret shape.

## R1 Collect

1. **Doctor's analysis.** Run doctor's D1 (`references/doctor.md`) in full, including its Version check. Keep every finding exactly as D1 produced it. If Phase 3 found no install, run only D1's `REQ` check and say the other checks were skipped because Pendo is not installed.
2. **App:** the app name, bundle ID(s) or applicationId(s), Android build types and product flavors, iOS targets and Xcode schemes, and app extensions. Name the signal that decided `platform` and `subPlatform`.
3. **Pendo SDK:** the package, the installed version (lockfile first, then the declared dependency), the newest 3.x, the generation, and how it is added (SPM, CocoaPods, vendored, Gradle, npm, pub, NuGet). If only a range such as `3.14.+` is declared and no lockfile pins it, report the range and say no lockfile pins it. Take the newest 3.x from D1's Version check; with no install, run that check's `latest_sdk_version.py` command yourself.
4. **Integration map**, each item with `file:line`:
   - every init call and how many there are
   - every `startSession` and `endSession` call, with the kind of visitor and account ID it passes
   - the navigation library and its Pendo wrapper or observer
   - per native head, the pairing scheme and whether the URL handler passes it to Pendo
   - Metro config, ProGuard/R8 rules, and the Expo config plugin, where they apply
   - any `environmentName`, custom host or other Pendo option passed to init
5. **Framework and build:** the framework and language versions (React Native, Expo SDK, Flutter, Dart, .NET, Swift, Kotlin), minimum OS versions, minify/R8, Hermes, React Native's New Architecture, and whether the iOS target is SwiftUI, UIKit or both.
6. **Requirements:** every Phase 4 row with the value read, the floor, and its outcome. Anything Phase 4 or the platform reference sends to "Requires your attention" (for example Expo Go) goes here as its own row: this template has no such section.
7. **Libraries that matter to Pendo.** Run `python3 "<skill-dir>/scripts/list_dependencies.py" <platform> --app-root <app root>` and use its JSON as it is. It reads the manifests and lockfiles and returns `relevant` (libraries on its curated list, by category) and `direct` (every direct dependency), each with the declared and the resolved version, plus the files it read (`sources`) and the lockfiles it could not read (`unread`). On React Native, Expo and Flutter it also reads the `ios/` and `android/` projects: a curated library declared there is in `relevant` with `head` set to `ios` or `android`. In the table, write it as `<name> (iOS)` or `<name> (Android)`. Then list WebView use by file and line: `WKWebView`, `android.webkit.WebView`, `react-native-webview`, `webview_flutter`, `flutter_inappwebview`, MAUI `WebView`.

   | Category | Why TS looks at it |
   |---|---|
   | core | the framework versions every other answer depends on |
   | navigation | how screens change, which decides how Pendo names and tracks screens |
   | modals_sheets | sheets and modals draw over a screen; guides and taps inside them depend on how they are shown |
   | ui_kit | custom and third-party components change what can be tagged |
   | gestures_animation | gesture libraries can take a touch before the app's own views see it |
   | lists | lists reuse their row views, which matters when tagging a row |
   | webview | content inside a WebView is web content, not native views |
   | architecture | state and lifecycle frameworks change when screens appear |
   | analytics, session_replay, crash | these SDKs also watch screens, taps or the app lifecycle, so TS checks them first when Pendo misses screens or taps |

   The curated list is data in `scripts/relevant_libraries.json`: add libraries there, not in a single run.
8. **Environment:** run `python3 "<skill-dir>/scripts/collect_env.py" <platform> --app-root <app root>` and use its JSON as it is. A missing toolchain from Phase 1 is reported here.
9. **Working tree:** `clean`, or `dirty` with the number of changed paths from `git status --porcelain`.
10. **Skill version:** the `version` in the plugin manifest at `<skill-dir>/../../.claude-plugin/plugin.json`. If the file or its `version` field is missing, use `unversioned`.

## R2 Render

Fill in this template. The report describes the app first and diagnoses it last: everything up to "Pendo SDK" is facts, and the "Integration check" section holds every judgment.

**Write values, not explanations.** `**Platform:** .NET MAUI`, not `maui / not applicable (MAUI has no sub-platform)`. Leave out a field that does not apply to this platform instead of writing why. Explanations belong only in findings. In the JSON, use `""` or `[]` for a value that doesn't exist. List anything you could not read in the Integration check's "Not checked" list, with why.

Name platforms as people write them: React Native, Expo, iOS, Android, Flutter, .NET MAUI. Add the sub-platform in brackets only where it exists: `Expo (managed)`, `iOS (SwiftUI)`, `Android (Kotlin)`.

When Pendo is not installed, still name the package this platform would use and the newest 3.x. Put `not installed` for the installed version, generation and mechanism (in the JSON too), leave the integration map out, lead "Most important" with "Pendo is not installed", and make the Integration check section the `REQ` findings plus one line: "Pendo is not installed. Run `--mode integrate` to install it."

````markdown
# Pendo Mobile SDK support report (`--mode report`)

Generated <ISO-8601 time> by install-pendo-mobile <skill version>. Keys, credentials and visitor or account values are masked.

## Summary
- **Platform:** <platform name> [(<subPlatform>)]
- **Pendo SDK:** <package> <installed version> (newest 3.x: <version or unverified>)
- **Install state:** <complete | partial | not installed>
- **Navigation:** <library and version, or "none">
- **Findings:** <n> critical, <n> high, <n> medium, <n> low
- **Most important:** <up to three one-line findings, most severe first, or "none">

## App
<name, bundle IDs or applicationId, targets, flavors, extensions: one line each>

## Framework and build
<framework and language versions, minimum OS versions, and the build settings that affect Pendo (minify/R8, Hermes, New Architecture, UI framework): one line each>

## Libraries that matter to Pendo
| Category | Library | Declared | Resolved |
|---|---|---|---|

WebViews: <file:line for each, or "none">.

## Pendo SDK
<package, installed version, newest 3.x, generation, how it is added>

### Integration map
| Item | Where | Details |
|---|---|---|

## Environment
<one line per tool from `collect_env.py`>

## Integration check
- **Working tree:** <clean | dirty, n changed paths>

### Requirements
| Constraint | Value | Floor | Outcome |
|---|---|---|---|

### Findings
| ID | Severity | Check | Where | Fix |
|---|---|---|---|---|

<doctor's per-finding detail>

### Passed
- <check title>: <value>

### Not checked
- <check title>: <reason>
````

Fill the Integration check from doctor's D2 output, without D2's header lines, with these changes:
- **Check names.** Write each check by its Title from the table in `references/doctor.md`, not its ID: `Logout ends the session`, not `SESSION-LOGOUT`. For a `PLATFORM-STEP`, add the step: `Platform install step (ProGuard)`. The JSON keeps the IDs.
- **Not checked** lists only checks that apply to this platform but could not run or had nothing to check in this app ("Logout ends the session: the app has no logout path"), and anything you could not read. Leave out a check that never applies to this platform, such as `Expo development build` outside Expo. This overrides doctor's rule to list not-applicable checks.
- **On a 2.x install,** put every check skipped because of the SDK generation on one line: `Not run on a 2.x install: Init call, Init location, Pairing scheme, …`.

The report's data goes in a separate JSON file, not in the Markdown, so TS can load it into tools.

The JSON file uses exactly this schema:

```json
{
  "schema_version": 1,
  "generated_at": "ISO-8601",
  "skill_version": "",
  "app": {"platform": "", "sub_platform": "", "name": "", "bundle_ids": [], "targets_or_flavors": []},
  "sdk": {"package": "", "installed": "", "latest_3x": "", "generation": "", "mechanism": ""},
  "integration": {
    "init_sites": [{"file": "", "line": 0}],
    "session_sites": [{"file": "", "line": 0, "call": "startSession|endSession", "visitor_kind": "", "account_kind": ""}],
    "navigation": {"library": "", "wrapper": ""},
    "pairing": [{"head": "ios|android", "scheme": "", "handler": "present|missing|not_applicable"}],
    "build_config": {}
  },
  "requirements": [{"constraint": "", "value": "", "floor": "", "outcome": "pass|mismatch|indeterminate|not_applicable"}],
  "findings": [{"id": "", "severity": "", "check": "", "where": "", "fix": "auto|needs-input|manual"}],
  "libraries": {"sources": [], "unread": [], "relevant": [{"name": "", "category": "", "declared": "", "resolved": "", "head": "ios|android"}], "direct": [{"name": "", "declared": "", "resolved": ""}]},
  "webviews": [{"file": "", "line": 0, "kind": ""}],
  "working_tree": "clean|dirty",
  "environment": {}
}
```

## R3 Redact

Pass the rendered report to the script on stdin, with a **quoted** heredoc so the shell expands nothing in it. Then run the same two commands for the JSON, so it gets its own temp file and its own summary line:

```bash
REDACTED="$(mktemp "${TMPDIR:-/tmp}/pendo-support-report.XXXXXX")" && echo "$REDACTED"
python3 "<skill-dir>/scripts/redact_report.py" > "$REDACTED" <<'PENDO_SUPPORT_REPORT_EOF'
<the rendered report>
PENDO_SUPPORT_REPORT_EOF
```

Note the path it prints: later commands may not keep shell variables, so use that path, not `$REDACTED`. Never write the unredacted text to a file. Show the contents of the Markdown file, which is the redacted report (the JSON is not shown in chat), and never any part of the text from before redaction. If the script is missing or fails, do not show the report: say redaction could not run and stop.

After the report, add only these lines: the script's one-line summary from stderr for each file (for example "redacted 3 value(s): email=1, literal=2"), and either R4's question or, under `--dry-run`, a note that saving was skipped.

## R4 Offer to save

Skip this step under `--dry-run`.

Ask once: "Save this report to `pendo-support-report.md` and its data to `pendo-support-report.json` in `<app root>`?"
- **No:** write nothing, and say nothing was saved.
- **Yes:** if either file exists, ask whether to overwrite them or save as `pendo-support-report-<YYYYMMDD-HHMM>.md` and `.json`. Copy R3's two redacted files to them, so the saved text is exactly what the script produced, not a copy you typed. Then run `python3 "<skill-dir>/scripts/redact_report.py" --check < <file>` on each. If either does not exit `0`, delete both files, say they were not saved and why, and stop. Do not stage them, commit them, or add them to `.gitignore`. Tell the user both full paths and that they can attach both to their Pendo support ticket.
