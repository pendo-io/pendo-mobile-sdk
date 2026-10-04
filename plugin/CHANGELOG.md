# Changelog

Changes to the `pendo-mobile-sdk-tools` plugin and its `install-pendo-mobile` skill. The version is the `version` field in `.claude-plugin/plugin.json`.

## 1.1.0 — 2026-10-01

### Added
- **Doctor mode** (`--mode doctor`): checks an existing Pendo Mobile SDK integration and reports problems by severity (critical, high, medium, low). It fixes only the problems you pick, on a new `pendo-doctor-<platform>` branch, and can run a build afterwards. The check itself never asks for credentials and never changes files.
- **`--force-dirty`**: lets an install, or doctor's fixes, run in a repo with uncommitted changes. Your own changes are listed separately, and any file holding both is marked for review.

### Changed
- The iOS deployment target is read from the app target in the Xcode project, not from the Podfile.
- An install that stops partway now undoes its own edits and deletes its branch, including under `--force-dirty` and in monorepos.
- Smaller skill instructions, so each run uses less of your assistant's context.

## 1.0.0 — 2026-09-20

- First release: installs the Pendo Mobile SDK in native iOS, native Android, React Native, Expo, Flutter and .NET MAUI apps, with `detect`, `integrate` and `verify` modes.
