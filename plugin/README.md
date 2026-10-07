# Pendo Mobile SDK tools (Beta)

A [Claude Code](https://claude.com/claude-code) plugin, also usable from Cursor and Codex, that installs the Pendo Mobile SDK in your app, checks an existing install, fixes what is wrong with it, and writes a support report for Pendo Technical Support.

It supports native iOS, native Android, React Native, Expo, Flutter and .NET MAUI, and installs the 3.x SDK.

- [What it does](#what-it-does)
- [Before you start](#before-you-start)
- [Install the plugin](#install-the-plugin)
- [Quick start](#quick-start)
- [Modes](#modes)
- [Arguments](#arguments)
- [How your repo is kept safe](#how-your-repo-is-kept-safe)
- [What you get back](#what-you-get-back)
- [Doctor: reading the findings](#doctor-reading-the-findings)
- [Support report](#support-report)
- [Troubleshooting](#troubleshooting)

## What it does

An install run does these steps, in order:

1. Detects the platform (and, for iOS, Android and Expo, which variant of it).
2. Stops if Pendo is already installed.
3. Checks your project against the SDK's minimum versions.
4. Asks for your API key and URL scheme, or uses clearly marked placeholders.
5. Creates a branch named `pendo-install-<platform>`.
6. Adds the SDK dependency, `setup()`, `startSession()` where your app has a real user ID, and the deep-link scheme for Pendo Designer pairing.
7. Builds the app, in `verify` mode only.
8. Prints a report of what changed and what is left for you to do.

## Before you start

| You need | Why |
|---|---|
| **A clean git tree** | The install modes refuse to run on uncommitted changes (override with `--force-dirty`). Git is the rollback. |
| **Your Pendo API key and URL scheme** | Pendo UI → **Settings** → **Subscription settings** → select the app → **App Details**. The key looks like a UUID, the scheme like `pendo-xxxxxxxx`. |
| **The platform toolchain**, for `verify` | Xcode (iOS), Gradle and a JDK (Android), Node (React Native, Expo), Flutter, or .NET with the `maui` workload. Not needed for `integrate`, `detect`, `report` or the doctor's read-only check. |

You do not need the key or scheme to start. If you do not have them, the install writes `YOUR_API_KEY_HERE` and `YOUR_SCHEME_ID_HERE`. The report lists every place they were written. The app compiles with them, but no analytics reach Pendo and Designer pairing does not work until you replace them.

## Install the plugin

**Claude Code**

```
/plugin marketplace add pendo-io/pendo-mobile-sdk
/plugin install pendo-mobile-sdk-tools@pendo-mobile-sdk
```

**Cursor and Codex** use a symlink to the skill. See the [repository README](../README.md#install-via-claude-code-cursor-or-codex-beta) for the one-time setup.

To update, see [Keeping it up to date](../README.md#install-via-claude-code-cursor-or-codex-beta) and the [changelog](CHANGELOG.md).

## Quick start

Open your app's repo in Claude Code, commit or stash your changes, and ask in plain words:

> Install Pendo in this app.

Or invoke the skill directly:

```
/pendo-mobile-sdk-tools:install-pendo-mobile
```

The skill detects the platform, asks for the key and scheme once, creates `pendo-install-<platform>`, makes the edits, and prints a report. Then:

1. Read **Replace before this works** in the report, if present, and replace the placeholders:
   ```bash
   grep -rn "YOUR_API_KEY_HERE\|YOUR_SCHEME_ID_HERE" .
   ```
2. Review the diff on the new branch.
3. Build the app. `integrate` does not build; run `--mode verify`, or `bash <skill-dir>/scripts/verify-build.sh <platform>` from the app root.
4. Commit and open a pull request.

## Modes

| You want to… | Mode | Writes files? | Asks for your key? |
|---|---|---|---|
| Know what package or framework this app needs, or whether Pendo is already installed | `detect` | No | Never |
| Install Pendo | `integrate` (default) | Yes, on a new branch | Yes, or uses placeholders |
| Install Pendo and prove it compiles | `verify` | Yes, on a new branch | Yes, or uses placeholders |
| Audit or fix an existing install | `doctor` | Only the fixes you pick, on a new branch | Only if a fix needs it |
| Send Pendo support a report about your app's Pendo setup | `report` | Only if you say yes: two report files, never committed | Never |

Without `--mode`, the skill picks one from your request: a question gets `detect`, "install" gets `integrate`, "check that it builds" gets `verify`, "why isn't Pendo working?" gets `doctor`, and "a report for Pendo support" gets `report`. The first line of the report says which mode ran.

A passing `verify` build proves the code is valid. If placeholders were written, it does not prove Pendo is live.

## Arguments

| Argument | Meaning |
|---|---|
| `--mode detect\|integrate\|verify\|doctor\|report` | How far to run. Default `integrate`. |
| `--api-key KEY` | Your Pendo integration key. Skips the question. |
| `--scheme pendo-xxxx` | Your Designer pairing scheme. Skips the question. |
| `--platform ios\|android\|react-native\|expo\|flutter\|maui` | Skips platform detection. Use it in a monorepo or when two platforms match. |
| `--dry-run` | Plans the install and writes nothing, not even a branch. Cannot be combined with `--mode verify`. With `--mode report`, shows the report and skips the question about saving it. |
| `--force-dirty` | Runs on a tree with uncommitted changes. Your changes are tracked separately in the report. |

## Example prompts

Plain language works for every case:

| Goal | Say |
|---|---|
| Install | "Install Pendo in this app." |
| Install with credentials | "Install Pendo. My key is `<key>` and my scheme is `pendo-xxxx`." |
| Preview | "Show me what installing Pendo would change, without changing anything." |
| Install and build | "Install Pendo and verify that the app still builds." |
| Ask a question | "Which Pendo SDK package does this app need?" |
| Check an install | "Why isn't Pendo working in this app?" |
| Audit | "Check my Pendo integration." |
| Support report | "Create a report for Pendo support." |

And the explicit forms:

```
/pendo-mobile-sdk-tools:install-pendo-mobile --mode detect
/pendo-mobile-sdk-tools:install-pendo-mobile --dry-run
/pendo-mobile-sdk-tools:install-pendo-mobile --mode verify --platform android
/pendo-mobile-sdk-tools:install-pendo-mobile --mode doctor
/pendo-mobile-sdk-tools:install-pendo-mobile --mode report
/pendo-mobile-sdk-tools:install-pendo-mobile --api-key <key> --scheme pendo-xxxx
```

## How your repo is kept safe

- **Clean tree required.** `integrate` and `verify` stop before touching anything if `git status` shows changes.
- **Everything happens on a new branch.** `pendo-install-<platform>` for installs, `pendo-doctor-<platform>` for doctor fixes. Nothing is committed for you.
- **A failed run cleans up after itself.** If the install stops partway, it reverts its own edits, returns you to your original branch and deletes the new one. Under `--force-dirty` it reverts only its own changes and leaves your uncommitted work alone.
- **It never invents a visitor or account ID.** `startSession()` is written only when the app has a real identifier at runtime. Otherwise you get `setup()` alone and the report tells you.
- **It never sends credentials as IDs.** Tokens, passwords and keys are never used as a visitor or account ID.
- **It never upgrades an existing install.** If Pendo is already there, install modes stop and doctor reports.

## What you get back

An install report, abridged. The values are illustrative.

```markdown
## Pendo install complete

**Mode:** integrate — installed, not built
**Platform:** react-native / bare
**Branch:** pendo-install-react-native
**SDK version:** 3.14.5
**Working tree:** clean before the run
**Pendo config:** ⚠ PLACEHOLDERS — this install is not live until they are replaced (see below)

### Replace before this works
- `YOUR_API_KEY_HERE` in `App.tsx:12` — your Pendo integration key. Until then no analytics reach Pendo.
- `YOUR_SCHEME_ID_HERE` in `ios/MyApp/Info.plist:41`, `android/app/src/main/AndroidManifest.xml:28` — your Designer scheme. Until then Designer pairing never works.
Both are at Pendo UI → Settings → Subscription settings → select the app → App Details.

### Files changed
- `package.json` — added the Pendo SDK dependency.
- `App.tsx` — `PendoSDK.setup()` at app start.

### Build
Not run — mode `integrate` installs without building. Nothing here has been proven to compile.

### Requires your attention
- `startSession` was not written: no user identifier found in the app.
```

A doctor report lists findings by severity:

```markdown
## Pendo doctor

**Mode:** doctor — analysis only, nothing changed
**Health:** 0 critical, 1 high, 1 medium, 0 low

| ID | Severity | Check | Where | Fix |
|---|---|---|---|---|
| D1 | HIGH | CRED-PLACEHOLDER | `App.tsx:12` | needs-input |
| D2 | MEDIUM | SESSION-LOGOUT | `src/auth.ts:88` | auto |
```

After the report, doctor asks which fixes to apply: `all`, a list like `D1,D2`, or `none`.

## Doctor: reading the findings

**Severity**

| Level | Meaning |
|---|---|
| CRITICAL | Wrong or leaked data reaches Pendo and cannot be taken back (a made-up visitor ID, a credential sent as an ID). |
| HIGH | Pendo does not run, or the build breaks. |
| MEDIUM | Pendo runs, but a feature is broken (pairing, screens, sessions). |
| LOW | Hygiene, or a check that could not be verified. |

**Fix type**

| Type | Meaning |
|---|---|
| `auto` | Follows directly from the install steps. Doctor applies it when you pick it. |
| `needs-input` | Needs a value or a decision from you, such as the key, the scheme, which identifier to use, or whether to apply a fix adapted to your app. Doctor asks once. |
| `manual` | Work this tool does not do (major upgrades, AGP or `compileSdk` changes, choosing between two dependency mechanisms). Reported with the remedy; cannot be picked. |

Doctor changes nothing until you pick fixes, and it asks for a clean tree first. After applying each fix it runs the same check again and reports `fixed` only if the check now passes. It can then run a build if you ask.

On a 2.x install doctor runs only the checks that do not depend on the SDK generation, and lists the rest as not checked. It never upgrades across a major version.

When Pendo's standard fix would break something your app does on purpose (for example, `setup()` runs after login because your API key comes from your backend), doctor proposes a fix that fits your app and says why, or leaves the change to you.

## Support report

`report` writes up your app's Pendo setup for Pendo Technical Support, so a support ticket starts with the facts instead of a round of questions. It only reads your repo and never asks for your key.

The report covers:
- **Summary:** platform, Pendo SDK version and the newest 3.x, install state, navigation, and the most important findings.
- **App, framework and build:** bundle IDs or application IDs, targets and flavors, minimum OS versions, and the build settings that affect Pendo.
- **Libraries that matter to Pendo:** navigation, modals and sheets, UI kits, gestures, lists, WebViews, and other analytics, crash and session replay SDKs, with declared and resolved versions.
- **Pendo SDK:** how it is added, and where `setup()`, `startSession()`, navigation wrappers and pairing schemes are wired, with file and line.
- **Environment:** toolchain versions.
- **Integration check:** doctor's findings, the checks that passed, and the ones that could not run.

**What is never in it:** API keys, credentials, and real visitor or account values. A script masks them before the report is shown (`<redacted:literal>`), and checks the files again before they are saved. Your app's name, bundle IDs and `pendo-` pairing schemes are included, because support needs them to find your app.

**Saving:** the report is shown in chat first. If you say yes, it is saved in your app's root as `pendo-support-report.md`, with the same data as `pendo-support-report.json`. The files are not staged or committed. Attach both to your support ticket.

## Troubleshooting

| What you see | What it means and what to do |
|---|---|
| **"Pendo install stopped" at Phase 0** | The working tree has uncommitted changes. Commit or stash, or re-run with `--force-dirty`. `--mode detect` runs on a dirty tree. |
| **Install stops because Pendo is already installed** | An existing install is never overwritten. If setup is complete there is nothing to do. If it is partial (`setup()` is missing), run `--mode doctor` to finish the wiring. |
| **Install stops on Android Gradle Plugin below 8.0** | AGP 8.0 or newer is a hard requirement. Upgrade it, then re-run. |
| **A requirement is reported "indeterminate" or "not applicable"** | The value could not be read without building (indeterminate) or cannot exist in this repo shape (not applicable, such as managed Expo's native minimums). Neither blocks the install. Run `--mode verify` to close the indeterminate ones. |
| **Build says "not verified"** | A toolchain is missing, the script ran from the wrong directory, or the build failed with no mention of Pendo, so the failure cannot be blamed on the install. It is not a failure and not a pass. Read the per-head line for the reason. In a monorepo run `verify-build.sh` from the app root. |
| **Build PASS but no data in Pendo** | A placeholder is still in the repo. Run the `grep` from [Quick start](#quick-start) and replace it. |
| **Expo app does not run Pendo in Expo Go** | Expo Go cannot run the Pendo SDK. Use a development build (`expo-dev-client`). |
| **Pendo is installed through CocoaPods (native iOS)** | Doctor flags it as `DEP-CHANNEL`: the CocoaPods registry goes read-only in December 2026 and Pendo stops publishing there. Move to Swift Package Manager. |
| **MAUI install fails with `NETSDK1147`** | The `maui` workload is missing. Run `dotnet workload install maui` (on macOS with the official installer, `sudo $(which dotnet) workload install maui`). |
| **Detection picks the wrong platform in a monorepo** | Pass `--platform`. The skill asks rather than guesses when signals conflict. |
| **The skill is not found after installing the plugin** | Run `/reload-plugins`. For Cursor and Codex check that the symlink points at `plugin/skills/install-pendo-mobile`. |

## Feedback

This integration is in Beta. Please [open an issue](https://github.com/pendo-io/pendo-mobile-sdk/issues) with problems or feedback.
