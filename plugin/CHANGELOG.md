# Changelog

Changes to the `pendo-mobile-sdk-tools` plugin and its `install-pendo-mobile` skill. The version is the `version` field in `.claude-plugin/plugin.json`.

## 1.2.0 — 2026-10-07

### Added
- **Report mode** (`--mode report`): a support report about your app's Pendo setup, to attach to a Pendo support ticket. Ask for "a report for Pendo support", or run `--mode report`.
  - It covers the app and its build settings, the libraries that matter to Pendo (navigation, modals and sheets, UI kits, analytics, crash and session replay SDKs, WebViews) with their versions, the Pendo SDK version and where it is wired, your toolchain, and doctor's findings.
  - API keys, credentials and visitor or account values are masked by a script before anything is shown, and checked again before saving.
  - It is shown in chat. It is saved as `pendo-support-report.md` and `pendo-support-report.json` only if you say yes, and never committed.

### Changed
- Doctor names each check in plain words in the report, such as "Logout ends the session".
- Doctor recognizes a `setup()` call made through your app's own wrapper or alias.
- When Pendo's standard fix would break something your app does on purpose, doctor proposes a fix that fits your app instead, or leaves the change to you.
- `setup()` that is not at app launch is reported as a low-severity finding.
- An app repo with several Pendo apps, each with its own API key, is expected to have one pairing scheme per app.
- A version bump updates every file that pins the SDK, including CI-only project files.
- Native iOS and Android apps that keep a `package.json` for build tooling are detected as native. XcodeGen and Tuist projects are recognized, and the iOS deployment target is read from `project.yml` or `Project.swift`.
- Install steps load only when installing, so checking and reporting use less of your assistant's context.

## 1.1.0 — 2026-10-04

### Added
- **Doctor mode** (`--mode doctor`): checks an existing Pendo Mobile SDK integration and reports problems by severity (critical, high, medium, low). It fixes only the problems you pick, on a new `pendo-doctor-<platform>` branch, and can run a build afterwards. The check itself never asks for credentials and never changes files.
- **`--force-dirty`**: lets an install, or doctor's fixes, run in a repo with uncommitted changes. Your own changes are listed separately, and any file holding both is marked for review.

### Changed
- The iOS deployment target is read from the app target in the Xcode project, not from the Podfile.
- An install that stops partway now undoes its own edits and deletes its branch, including under `--force-dirty` and in monorepos.
- Smaller skill instructions, so each run uses less of your assistant's context.

## 1.0.0 — 2026-09-20

- First release: installs the Pendo Mobile SDK in native iOS, native Android, React Native, Expo, Flutter and .NET MAUI apps, with `detect`, `integrate` and `verify` modes.
