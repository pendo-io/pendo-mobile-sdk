# Doctor — check an existing Pendo install

Read in `--mode doctor`, after `SKILL.md` Phases 1–4. `--mode report` also reads it, but runs only D1, as `references/report.md` says. You enter with `platform`, `subPlatform`, the one `references/<platform>.md` read in Phase 2, Phase 3's state (`complete` or `partial`; in `report`, also no install), and every Phase 4 outcome.

The analysis (D1, D2) only reads. It never asks for a credential and never writes. Writing starts in D4, and only for fixes the user picked.

## D1 Diagnose

Run every check below that applies to `platform`. Also treat every install step in `references/<platform>.md` as a check: its end state must be present in the repo and match the reference. A step that looks up the current SDK version (Android's `<currentMinor>`) is covered by the Version check below. Its failure is an unverified `DEP-VERSION`, never a stop. A check whose subject does not exist in this repo shape is **not applicable**. Say so in the report. It is not a pass.

**On a 2.x install, run only the checks that do not depend on the SDK generation:** `ID-*`, `INIT-DUPLICATE`, `INIT-CONDITIONAL`, `CRED-PLACEHOLDER`, `SESSION-LOGOUT`, `REQ` and `DEP-GENERATION`. The reference's install steps describe 3.x, so list `PLATFORM-STEP`, `NAV-WRAPPER`, `SCHEME-*`, `DEEPLINK-HANDLER` and `DEP-VERSION` under "not checked — the reference describes 3.x". Writing 3.x steps into a 2.x app is not a fix.

Read `references/identity.md` before the `ID-*` and `SESSION-*` checks. Read `references/detection.md` §6 before `NAV-WRAPPER`.

Session calls are `startSession` and its JWT form (`jwt.startSession`) in the platform's own spelling.

| Check | Title | Finds | Severity | Fix |
|---|---|---|---|---|
| `ID-FABRICATED` | Real visitor and account IDs | a session call whose visitor or account ID is a literal, a test value, or a value made fresh on each launch | CRITICAL | needs-input |
| `ID-CREDENTIAL` | No credentials in IDs or data | a token, password, PIN, key or other credential (`identity.md` §0 Rule 2) passed as an ID or inside visitor/account data | CRITICAL | needs-input |
| `INIT-MISSING` | Init call | no init call (Phase 3 `partial`). Any session call or deep-link handler is dead code | HIGH | needs-input |
| `INIT-DUPLICATE` | One init call | more than one init call that can run in the same build. Separate flavor or DI entry points that each run alone are not duplicates | HIGH | auto |
| `INIT-CONDITIONAL` | Init in every build | init runs only in some builds (debug-only, behind a flag or env check) | HIGH | needs-input |
| `INIT-ORDER` | Init before other Pendo calls | a session call, `WithPendo*` wrapper or other SDK API can run before init | HIGH | auto |
| `INIT-PLACEMENT` | Init location | init is not at the app-init point the reference names (for example inside `useEffect`, a screen, or after an `await`). Report it even when the late placement looks deliberate: init alone collects no analytics, and Pendo's documentation places it at app launch. The init call that `INIT-DUPLICATE` removes is not also reported here; the call that stays is still checked | LOW | auto |
| `CRED-PLACEHOLDER` | No placeholder key or scheme | `YOUR_API_KEY_HERE` (HIGH) or `YOUR_SCHEME_ID_HERE` (MEDIUM) still in the repo | HIGH / MEDIUM | needs-input |
| `ID-COVERAGE` | Session for returning users | a session call reached only on fresh login when the app has code that restores a stored session at launch, or only in some auth bindings or flavors (`identity.md` §3). Stored tokens with no restore code are not a restore path | MEDIUM | auto when a real ID exists on the path, otherwise manual |
| `SESSION-LOGOUT` | Logout ends the session | a logout path that neither calls `endSession` nor starts a session for the next user | MEDIUM | auto |
| `SCHEME-MISSING` | Pairing scheme | a native head with no Pendo pairing scheme (iOS URL type, Android `PendoGateActivity`, Expo plugin option) | MEDIUM | needs-input |
| `SCHEME-MISMATCH` | One pairing scheme per app | different `pendo-` schemes for the same Pendo app (the same API key) across heads or config entries. A repo with several apps, each with its own API key, needs one scheme per app: that is not a finding | MEDIUM | needs-input |
| `DEEPLINK-HANDLER` | Pairing URL reaches Pendo | a scheme is registered but the app's URL handler does not pass the URL to Pendo, as the reference's deep-link step requires | MEDIUM | auto |
| `NAV-WRAPPER` | Navigation wrapper | the navigation library in use has no matching Pendo wrapper or observer, or a wrapper exists for a library not in use | MEDIUM | auto |
| `PLATFORM-STEP` | Platform install step | any other reference install step whose end state is missing or wrong (Metro config, config plugin form, Maven repo, ProGuard when minify is on, `PendoActionListener`, …). Name the step | HIGH if the build breaks or no data flows, otherwise MEDIUM | auto |
| `DEP-DUPLICATE` | One install method | Pendo pulled in through two mechanisms (SPM and CocoaPods, or a vendored framework next to either) | HIGH | manual |
| `DEP-GENERATION` | SDK generation | a 2.x SDK | MEDIUM | manual |
| `DEP-CHANNEL` | Install channel | native `ios` only: Pendo installed through CocoaPods, whose registry goes read-only in December 2026, after which Pendo stops publishing there (`references/ios.md` Tier 3). On React Native, Expo and Flutter, CocoaPods autolinking is the reference's default path, not a finding | MEDIUM | manual |
| `DEP-VERSION` | SDK version | a 3.x install behind the newest stable 3.x release | LOW | auto; manual when the lookup is unverified |
| `REQ` | Minimum versions | each Phase 4 row that is not a pass: AGP below 8.0 is HIGH, another mismatch is MEDIUM, indeterminate is LOW. Not applicable is listed, not a finding | HIGH / MEDIUM / LOW | manual |
| `EXPO-GO` | Expo development build | an Expo app with no development build set up (no `expo-dev-client`, and scripts that start Expo Go) | MEDIUM | manual |

**Severity meaning.** CRITICAL: wrong or leaked data reaches Pendo, and it cannot be taken back. HIGH: Pendo does not run, or the build breaks. MEDIUM: Pendo runs, but a feature is broken (pairing, screens, sessions). LOW: hygiene or unverified.

**When the reference's fix would break the app.** Before proposing the reference's step as the fix, check it against what the app does on purpose: init placed after login because the key comes from the backend, init behind a consent check, a feature flag. If the reference's step would break that, do not propose it. Propose a change that fixes the finding within the app's design, as `needs-input`, and say in **Proposed fix** why the reference's step was not used. If no such change exists, make the finding `manual`.

**Fix types.** `auto` follows directly from the reference's steps. `needs-input` needs a value or a decision from the user. `manual` is work this skill does not do (major upgrades, AGP or `compileSdk` changes, choosing between two dependency mechanisms). Manual findings are reported with the exact remedy, but cannot be selected in D3.

**Identity fixes never invent a value.** For `ID-FABRICATED` and `ID-CREDENTIAL`, search with `identity.md` §2–§3. If a real identifier exists on the same path, propose it and name its source. If none exists, the proposed fix is to remove the session call and keep init only (`identity.md` §0 shared fallback). Name the kind of credential found, never its value.

### Version check

Run this only on a 3.x install. Find the installed version: the lockfile first (`yarn.lock`, `package-lock.json`, `pubspec.lock`, `Package.resolved`, `Podfile.lock`), then the declared dependency. Do not install anything to read it. Then run:

```bash
python3 "<skill-dir>/scripts/latest_sdk_version.py" <channel> --major 3
```

| `platform` | channel |
|---|---|
| `react-native`, `expo` | `npm` |
| `flutter` | `pub` |
| `maui` | `nuget` |
| `android` | `maven` |
| `ios` | `spm`, or `cocoapods` when Pendo comes from the `Podfile` |

Compare the first three parts as numbers (`3.14.5` against `3.14.5.12728` is up to date: the fourth part is a build number). Any non-zero exit means the check is unverified. Report `DEP-VERSION` as LOW with the script's reason, make it `manual` (there is no version to write), and do not drop it. The bump writes the newest version in every file that declares it, including CI-only variants such as an XcodeGen `project-ci.yml`, and in the form the repo already uses: an exact version stays exact, and a dynamic range such as Android's `3.13.+` becomes `3.<newest minor>.+`. Do not flag `changing`/`isChanging` on an Android dependency: Pendo's own guide shows it, and it is harmless next to a `+` range. On `cocoapods`, report `DEP-CHANNEL` too.

## D2 Report

Number the findings `D1`, `D2`, …, from most to least severe. Keep the numbering for D3 and D4.

```markdown
## Pendo doctor

**Mode:** doctor — analysis only, nothing changed
**Platform:** <platform> / <subPlatform>
**Install:** <complete | partial> — <generation>, <installed version> <on 3.x: "(newest 3.x: <version | unverified: reason>)"; on 2.x: "(version check does not apply to 2.x)">
**Health:** <n> critical, <n> high, <n> medium, <n> low
**Working tree:** <clean | uncommitted changes — findings reflect them; applying fixes needs a clean tree or `--force-dirty`>

### Findings
| ID | Severity | Check | Where | Fix |
|---|---|---|---|---|
| D1 | CRITICAL | ID-CREDENTIAL | `path:line` | needs-input |

#### D1 — <one-line title>
- **Evidence:** <up to 3 lines of code, with credential values replaced by `<redacted>`>
- **Why it matters:** <one or two sentences>
- **Proposed fix:** <the concrete change: file, what is added or removed>
- **Needs from you:** <only for needs-input: the exact value to supply>

### Passed
- <each check that ran and passed, one line each>

### Not applicable / not checked
- <each check that does not apply to this repo shape, and each check that could not run, with why>
```

**When there is nothing to fix,** the Findings section says "No findings." and the run ends after the report. Do not ask D3.

**When Phase 3 found no install,** render only the header lines with `**Install:** not installed`, and a `### Next step` giving `--mode integrate`. No findings, no D3.

## D3 Choose fixes

Skip this step under `--dry-run`: end after the report.

Ask once: "Apply which fixes? `all` (every auto and needs-input finding), a list like `D1,D3`, or `none`." Manual findings cannot be picked. If one is listed, say why and drop it. `none` ends the run.

## D4 Apply

Read `references/integrate.md` now, before the first step: the steps below follow its Phases 0, 5 and 7.

1. **Clean tree.** Run `git status --porcelain`. If there is any output and `--force-dirty` was not passed, stop: write nothing, create no branch, and tell the user to commit or stash, or re-run with `--force-dirty`. The D2 report stays as is. With `--force-dirty`, record the paths as `preexistingDirty` and continue, as `references/integrate.md` Phase 0 describes: a file in that list that a fix edits is marked mixed.
2. **Inputs.** Collect every value the picked needs-input fixes need, in one message: API key, scheme, which scheme is right, which identifier to use, whether a conditional init is on purpose. Use `--api-key` and `--scheme` when they were passed, instead of asking. The API key and scheme follow `references/integrate.md` Phase 5's placeholder rules. An identifier never does: it must be a value the app reads at runtime (a variable, model field or token claim, `identity.md` §1–§2), never a literal. If the user offers a literal, refuse it. If the user has no runtime source, that fix becomes "remove the session call"; confirm that choice before applying it. If the user cancels here, stop: nothing was written and no branch exists.
3. **Branch.** Record `originalRef` exactly as `references/integrate.md` Phase 5 step 2 does. Create `pendo-doctor-<platform>`. If that branch already exists, stop and ask for another name. Never reuse it.
4. **Apply** only the picked findings, in this order: dependency, init, session, deep link, navigation, other platform steps. Use the matching step in `references/<platform>.md` as the spec for each edit, or, for a finding whose fix was adapted to the app, the change its **Proposed fix** describes. When two findings touch the same file, change only the lines each picked finding names.
5. **Re-check.** Run each applied finding's check again. It is `fixed` only if the check now passes. Otherwise it is `failed`, with the reason.
6. **Build (optional).** Ask whether to run `bash "<skill-dir>/scripts/verify-build.sh" <platform>`. If yes, follow `references/integrate.md` Phase 7 exactly (app root, exit codes, per-head lines, build churn).

If the run stops after step 3 but before the first edit, run `git checkout <originalRef>` and delete the empty branch with `git branch -d pendo-doctor-<platform>`. If an edit fails partway, stay on the branch, do not switch back, and report what was applied. This differs from an aborted install on purpose: each applied fix was picked by the user and re-checked, so it is left for review rather than thrown away, and switching would carry the uncommitted edits onto `originalRef`.

```markdown
## Pendo doctor — fixes applied

**Branch:** `pendo-doctor-<platform>` (from `<originalRef>`)
**Working tree:** <clean before the run | had uncommitted changes (`--force-dirty`): the paths in `preexistingDirty`>
**Pendo config:** <live | ⚠ PLACEHOLDERS — see Replace before this works>

### Results
| ID | Check | Result |
|---|---|---|
| D2 | INIT-DUPLICATE | fixed |

### Replace before this works
<only when a placeholder was written: the same content as the section of that name in `references/reports.md`>

### Files changed
- `path` — what changed and for which finding. Add "⚠ mixed — also holds your uncommitted changes; review its diff" when the path is in `preexistingDirty`.

### Files the build touched
<only when the build ran: as in `references/reports.md`>

### Build
<not run — the user declined; or the result, worded as `references/reports.md` words it for verify mode>

### Still open
- <every finding not picked, failed, or manual, with its ID and fix type>
```
