---
name: install-pendo-mobile
description: Install and initialize the Pendo Mobile SDK in a mobile app repository — native iOS, native Android, React Native, Expo, Flutter, or .NET MAUI. Detects the platform and framework, adds the SDK dependency, wires setup() and startSession() at the correct lifecycle point, configures the deep-link scheme for Pendo Designer pairing, and verifies the app still builds. Runs in three modes: detect (identify the platform and which Pendo SDK package applies, changing nothing and asking for no credentials), integrate (the default — detect plus the full install), and verify (integrate plus a real build of the result). Use when the user asks to install Pendo, add the Pendo SDK, instrument a mobile app with Pendo, or set up Pendo analytics in an app — and also for read-only questions like which Pendo SDK package a given app needs, which platform or framework a repo is, or whether Pendo is already installed.
argument-hint: "[--mode detect|integrate|verify] [--api-key KEY] [--scheme pendo-xxxx] [--platform ios|android|react-native|expo|flutter|maui] [--dry-run]"
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Install Pendo Mobile SDK

You are installing the Pendo Mobile SDK into the developer's real, live working tree — not a scratch clone, not a PR you can close if it goes wrong. There is no rollback safety net here beyond git itself, so you never fabricate a value that could pass for real and you leave the repo in a state a build can actually verify. Where a credential genuinely is not available yet, the install still proceeds — on a conspicuous, declared placeholder that is reported as unfinished work, never on a plausible-looking invention. Work through the phases in order: refuse a dirty tree, detect the platform, confirm its reference exists, gate on already-installed, check requirements, resolve credentials and branch, dispatch to exactly one platform reference, verify the build, report. **Every phase before "resolve credentials and branch" is read-only by design** — nothing is asked for and nothing is written until every cheap, reversible check has already passed. That ordering is load-bearing: it's what keeps a stop on phase 2, 3, or 4 a true no-op instead of a repo left on a stray branch holding a real API key for a platform that turned out to already be instrumented.

**How far down that sequence you go is the `--mode` argument** — `detect`, `integrate` (the default), or `verify`. Mode sets where the run stops rather than which phases it picks, which is what keeps the four read-only phases identical across all three. See "Modes" below for the phase mapping and for the one place `detect` differs by more than that.

## Argument Parsing

Parse `$ARGUMENTS` for:

- **`--mode <detect|integrate|verify>`** — how far to run. **Defaults to `integrate`** when absent. `full` is accepted as a synonym for `verify`. Any other value is a usage error: name the three modes and stop, before Phase 0 — do not guess which one was meant. See "Modes" below.
- **`--api-key <key>`** — the Pendo integration key. If absent, resolve it in Phase 5 by asking the user; if the user does not have it, Phase 5 falls back to a declared placeholder rather than stopping. Ignored in `detect` mode, which never reaches Phase 5; if it was passed anyway, say so in the report rather than silently discarding it.
- **`--scheme <pendo-xxxx>`** — the Pendo Designer pairing URL scheme, which is what lets the app pair with Pendo Designer for page tagging and guide testing. Same handling as the API key: asked for in Phase 5, placeholder fallback if the user does not have it. **It is needed for a working install and is not the lesser of the two** — an install with a real key and a placeholder scheme reports analytics but can never be tagged. Both live in the same place (Pendo UI → `Settings` → `Subscription settings` → select the app → `App Details`), so ask for them together. Ignored in `detect` mode, which never reaches Phase 5; if it was passed anyway, say so in the report rather than silently discarding it.
- **`--platform <ios|android|react-native|expo|flutter|maui>`** — skips the platform *detection table* in Phase 1 (the six-row table). It does **not** skip sub-platform detection (uikit vs. swiftui, kotlin vs. java, managed vs. prebuilt) — that still runs, because it isn't something the caller can pass on the command line.
- **`--dry-run`** — plan-only mode. Phases 0–4 run exactly as normal (all read-only: dirty tree, detection, reference-existence check, already-installed gate, requirements check) — the user needs to see their real results regardless of dry-run. In Phase 5, still resolve the API key and URL scheme as normal — ask for them, and fall back to the declared placeholder the same way, so the plan reflects the values a real run would actually write — but skip creating the branch. In Phase 6, read the dispatched reference's install steps and narrate what they would change, but never call `Write`/`Edit`/`Bash` to actually make an edit. Skip Phase 7 (build verification) entirely — there's nothing built to verify. Phase 8 renders `**Branch:** (not created — dry run)`, renames `### Files changed` to `### Would change`, and omits `### Build` and `### Files the build touched` (there is no build to have touched anything).

If `$ARGUMENTS` is empty, run in `integrate` mode: proceed to Phase 0 and ask for the API key and scheme when you reach Phase 5.

## Modes

`--mode` sets **where the run stops**, not which phases it picks. Each mode runs a contiguous run of phases in the documented order and then reports; no phase is reordered, and no phase in the middle of a mode's range is skipped. Phases 1–4 do the same *reading* in all three modes and reach the same conclusions about the repo — the longer modes just keep going afterwards.

Two things do differ beyond where a mode stops, and both follow from `detect` writing nothing:

1. **`detect` does not run Phase 0.** That phase exists only to protect a working tree from writes, and `detect` makes none.
2. **In `detect`, a blocking result is a verdict rather than a stop.** Phases 3 and 4 can each halt an install — Pendo already present, AGP below 8.0, a requirements mismatch the user declines. In `integrate` and `verify` those end the run early. In `detect` there is no install to prevent and nothing after Phase 4 but the report, so each one is recorded as a finding and the run continues to the end of Phase 4. The reading is identical; only the consequence differs. Each phase below states its own `detect` behaviour — where a phase says "stop", read it as "stop, unless the mode is `detect`, in which case report the finding and carry on".

| Phase | `detect` | `integrate` (default) | `verify` |
|---|---|---|---|
| 0 Refuse a dirty tree | — *(writes nothing; see below)* | ✅ | ✅ |
| 1 Detect platform and framework | ✅ | ✅ | ✅ |
| 2 Confirm the platform reference exists | ✅ | ✅ | ✅ |
| 3 Already-installed gate | ✅ | ✅ | ✅ |
| 4 Requirements check | ✅ | ✅ | ✅ |
| 5 Resolve credentials, create branch | — | ✅ | ✅ |
| 6 Dispatch to the platform reference | — | ✅ | ✅ |
| 7 Verify the build | — | — | ✅ |
| 8 Report | ✅ *(detect template)* | ✅ | ✅ |

- **`detect`** — answers "what is this repo, and what would Pendo need here?" and changes nothing. **It is the only mode that never asks for a credential**, because it stops before Phase 5: a question about which SDK package an app needs must not cost the user their API key. It reads the platform and sub-platform, confirms the reference exists, runs the already-installed gate, and checks requirements — so its report can name the Pendo package, whether Pendo is already there, and whether the repo can take it at all. It also **does not run Phase 0**: with nothing to write, refusing a dirty tree would be gratuitous. Report a dirty tree as an observation if one exists (the user will hit it in `integrate`), never as a stop.
- **`integrate`** — the default. Everything `detect` does, then the real install: branch, dependency, `setup()`/`startSession()`, deep-link scheme. **It does not build.** Nothing about the result is verified by compilation, so Phase 8 must say exactly that and hand the user the command to check it themselves — see Phase 7 and Phase 8's `### Build`.
- **`verify`** — everything `integrate` does, then Phase 7's real build. Use it when the install must be proven to compile, not just written. This is the only mode that can report a build PASS.

**Which mode to run when the user did not say.** Default to `integrate`. Choose `detect` when the request is a question rather than an instruction — "which Pendo SDK does this app need?", "what framework is this?", "is Pendo already installed here?" — and say which mode you picked and why in the first line of the report, so a user who wanted the install can re-run without re-explaining. Choose `verify` when the user asks for the install to be checked, proven, or confirmed to build, or when they say "and make sure it still builds".

**`--mode` and `--dry-run` are different axes.** Mode is *how far*; `--dry-run` is *whether to write*. `--mode integrate --dry-run` narrates the edits it would make without making them. `--mode detect --dry-run` is redundant — `detect` already writes nothing — so accept it and note in the report that `--dry-run` had no effect. `--mode verify --dry-run` is a contradiction (there is nothing built to verify), and it is a **usage error**: say which two arguments conflict, ask which was meant, and stop before Phase 0 rather than silently downgrading to one of them.

## The phase contract

This router does the detecting and gating; each `references/<platform>.md` file (built in later work, not this one) does the platform-specific editing. The boundary between them is a fixed contract — get it wrong here and every reference file built against it inherits the bug.

This contract governs Phase 6, so it applies in `integrate` and `verify` only. **`detect` never enters a reference file** — it reads one (Phase 2) and uses its Existing Install Indicators (Phase 3), but never dispatches to its install steps, so it needs none of the five values below and must not resolve them.

**A reference file is entered with these five values already resolved, in scope, and never re-asked for:**

| Field | Resolved in | Values |
|---|---|---|
| `apiKey` | Phase 5 | a real Pendo integration key, or the declared placeholder `YOUR_API_KEY_HERE` when the user does not have one — never an invented value |
| `urlScheme` | Phase 5 | a real `pendo-xxxx` scheme, or the declared placeholder `YOUR_SCHEME_ID_HERE` — never an invented value |
| `platform` | Phase 1 | `ios` \| `android` \| `react-native` \| `expo` \| `flutter` \| `maui` |
| `subPlatform` | Phase 1 | see table below — `null` where the platform has no meaningful variant |
| `branchName` | Phase 5 | the branch created before Phase 6's first edit |

`subPlatform` values, and how the router (not the reference) determines them:

| `platform` | `subPlatform` values | Detection heuristic |
|---|---|---|
| `ios` | `uikit` \| `swiftui` | A type conforming to `App` with `@main` in a `.swift` file → `swiftui`. Otherwise, an `AppDelegate.swift` conforming to `UIApplicationDelegate` → `uikit`. |
| `android` | `kotlin` \| `java` | Any `.kt` file under the app module → `kotlin`. Otherwise → `java`. |
| `react-native` | `bare` (constant) | Always `bare` — Expo is its own `platform` value, so nothing to distinguish. |
| `expo` | `managed` \| `prebuilt` | `ios/` and `android/` native directories present **and tracked by git** (`git ls-files ios android` returns something) → `prebuilt`. Absent → `managed`. Present but untracked or gitignored → `managed` too: those are leftover `expo prebuild` output, not developer-maintained sources, and reading them as `prebuilt` makes the install hand-edit throwaway directories. |
| `flutter` | `null` | No variant — Dart is the only language. |
| `maui` | `null` | No variant — the SDK wiring point is identical across MVVM/code-behind. |

**The router decides what `apiKey` and `urlScheme` are; a reference writes what it is handed.** Phase 5 guarantees each is either a real value or one of the two declared placeholders above, and nothing else. A reference file therefore never needs to judge which it received: it writes the resolved value as a literal in every slot, exactly as it would a real one. The prohibition on placeholders that appears in the reference files binds them against **inventing** a value of their own — it is not a licence to refuse, alter, or omit a step because the router-supplied value looks like a placeholder. Omitting the deep-link step on a placeholder scheme, for instance, would leave the install structurally incomplete and hide the very thing the Phase 8 report exists to surface.

**Ask, don't guess, when the signals are absent or contradictory.** These heuristics assume a clean match; real repos sometimes don't give you one — an Objective-C-only iOS app with no `@main` and no `AppDelegate.swift` at all (so neither `uikit` nor `swiftui` matches), or a multi-module Gradle project where "the app module" is ambiguous. In that case, **ask the user directly** which sub-platform applies. Never default to one: the reference file is entered with `subPlatform` already resolved and never re-asks, so a wrong guess sends it off editing the wrong lifecycle file entirely — guessing `uikit` for a SwiftUI app means it edits a nonexistent `AppDelegate` instead of wiring `.onOpenURL`.

**A reference file must end with these two guarantees, no exceptions:**

1. The repo is in a state `scripts/verify-build.sh <platform>` can attempt to build — no half-written files, no dangling syntax from a partial edit.
2. It hands back, for the Phase 8 report: the list of files it *itself* changed (with a one-line reason each), and anything it left unwired (e.g., `startSession` has no real visitor/account identifier because the app has no existing identity source) so Phase 8 can surface it under "Requires your attention" instead of silently shipping it. This list is exclusively the reference's own edits — Phase 7 runs after it and can rewrite committed files on its own (see Phase 7's "Build-caused file churn"); that churn is real but is never this list's to report.

`references/<platform>.md` is named exactly after the `platform` value — `references/ios.md`, `references/android.md`, `references/react-native.md`, `references/expo.md`, `references/flutter.md`, `references/maui.md`.

## Phase 0: Refuse a dirty tree

**Skipped entirely in `detect` mode** — that mode writes nothing, so it has no working tree to protect and no reason to refuse one. Run `git status --porcelain` anyway if it is cheap, and report a dirty tree as an observation (the user will hit this stop the moment they re-run to install), but never stop on it in `detect`.

In `integrate` and `verify`: run `git status --porcelain`. If the output is non-empty, **stop** (see Phase 8's early-exit report). Tell the user to commit or stash their changes first, and do not proceed. This skill edits a working tree the developer is actively using — unlike a workflow that opens a PR you could just close, there is no free rollback here, so a dirty tree is not a warning, it's a hard stop. Nothing has been created yet at this point, so a stop here needs no cleanup. Offer `--mode detect` as the thing they *can* run right now without committing anything.

## Phase 1: Detect platform and framework

Check in this order. **Cross-platform MUST be checked before native iOS/Android** — do not "clean up" this ordering later. React Native and Expo repos contain `react` in `package.json` *alongside* `ios/` and `android/` directories (React Native ships platform-native shells inside the same repo), so a native-first check matches the `ios`/`android` rows on every single React Native or Expo repo before it ever gets a chance to see the `react` signal. The cross-platform rows must win first, or every RN/Expo install misclassifies as native.

| Signal | Platform |
|---|---|
| the `expo` package itself in the repo's own `package.json` dependencies | **expo** (wins over react-native when both present) |
| `react-native` in dependencies, no `expo` package | **react-native** |
| `pubspec.yaml` with a Flutter SDK dependency | **flutter** |
| `*.csproj` referencing `Microsoft.Maui` | **maui** |
| `*.xcodeproj` / `*.xcworkspace`, no `package.json` | **ios** |
| `build.gradle[.kts]` with the Android plugin | **android** |

**The Expo signal is the `expo` package exactly — not the `expo-*` prefix.** Two near-misses route to `react-native`, not to `expo`:

- **An `expo-*` module without `expo`** (say `expo-secure-store` alone) is a bare RN app that has adopted one Expo module. It has no `expo prebuild` or config-plugin pipeline, which is the entire mechanism `references/expo.md` installs through, so dispatching it to Expo would send the run looking for machinery the repo does not have.
- **Anything `expo`-shaped that is only a transitive dependency** — `@expo/config-plugins` pulled in by some unrelated library, for instance — is not a signal at all. This row reads the repo's **own** `package.json` dependencies and devDependencies, never the resolved tree, and never `node_modules/`.

Note also that a naive `grep -i expo` over a JS repo appears to match dozens of files that have nothing to do with Expo: every one of them is the substring inside `export`. Match the dependency key, not the text of the source.

If `--platform` was passed, skip this table and use it directly. If two or more rows match ambiguously (e.g. a monorepo with both a Flutter module and a bare `android/`), read `references/detection.md` before deciding — do not guess. If `references/detection.md` does not exist yet, ask the user directly which platform they mean instead of guessing.

Once `platform` is set, resolve `subPlatform` using the heuristics in the phase contract table above — including its ask-fallback for the no-clean-signal case. This runs even when `--platform` was passed via flag, since sub-platform isn't something the caller supplies.

Now, still in this phase (still read-only — no secrets, no writes), confirm the platform's toolchain is present:

| Platform | Command |
|---|---|
| `ios` | `xcodebuild -version` |
| `android` | `./gradlew --version` |
| `react-native`, `expo` | `node --version` |
| `flutter` | `flutter --version` |
| `maui` | `dotnet --version`, **then `dotnet workload list`** — its output must include `maui` (or at least `maui-android`) |

If the command is missing or errors, what to do depends on the mode — read the next paragraph before acting on this one. In `verify`: warn the user that Phase 7 build verification will be skipped as a result, and get their explicit confirmation before continuing; if they decline, stop here (see Phase 8's early-exit report) — nothing has been created yet. In `integrate` and `detect`: record it and continue without asking.

**Mode changes what an absent toolchain costs, so it changes whether to ask.** Only `verify` builds, so only `verify` loses anything it was going to do — there, ask as written above. In `integrate`, Phase 7 was never going to run, so an absent toolchain is not a reason to interrupt: record it in the report as the reason a later `--mode verify` will not work yet, and continue without asking. In `detect`, report the result and never gate on it. What does **not** change with mode is MAUI's workload check below — a missing MAUI workload breaks Phase 6 too, not just Phase 7, so it is still worth confirming in `integrate`.

**Why `maui` takes a second command.** `dotnet --version` succeeds on any machine with the SDK installed, workloads or not — so on its own it waves the gate through, and what fails instead is **Phase 6's very first action**: `dotnet add package` builds the project's dependency graph, which needs the platform workloads, and dies with `error NETSDK1147` ("the following workloads must be installed"). Measured on a real net10 MAUI app, that put the run past Phase 5 — **branch already created** — before hitting a wall, which is exactly what this phase's read-only ordering exists to prevent. `dotnet workload list` is the check that actually establishes a MAUI build is possible.

If the `maui` workload is absent, the remedy is `dotnet workload install maui` (needs elevation wherever the SDK directory is not user-writable — on macOS with the official installer, `sudo $(which dotnet) workload install maui`). **In `detect`, report that and nothing more** — no warning to accept, no confirmation to give, since that mode installs nothing and so loses nothing. In `integrate` and `verify`, warn and get explicit confirmation — and if the user declines, stop here (see Phase 8's early-exit report; nothing has been created yet), exactly as for a missing toolchain above. When warning, state the stronger consequence plainly: on MAUI it is **not** only Phase 7 that is lost. Neither `dotnet restore` nor `dotnet build` can run either, so continuing means a text-only install — every edit written, the `PackageReference` added by hand per `references/maui.md`'s fallback, and nothing compiled or verified until the workload is installed. Also expect `NETSDK1147` to name `maui-tizen` for any `net*.0`-only shared library in the solution, a workload few developers expect to need; installing `maui` covers it.

## Phase 2: Confirm the platform reference exists

Read `references/<platform>.md` now, in full — this is the **only** read of this file for the entire run; Phase 3 and Phase 6 both reuse this same read, so do not read it a second time, and never read any other platform's reference file.

If it does not exist yet, **stop** (see Phase 8's early-exit report) and tell the user this platform's reference has not been built yet. Do not invent install steps from general knowledge of the Pendo SDK. Nothing has been created yet, so there is nothing to clean up.

## Phase 3: Already-installed gate

Using the `references/<platform>.md` content already read in Phase 2, check its **Existing Install Indicators** section against the repo. If **any** indicator is found: in `detect` mode record it and continue to Phase 4 (see the paragraph at the end of this phase — "is Pendo already installed?" is the question that mode exists to answer, so stopping here would defeat it); in `integrate` and `verify`, **stop** (see Phase 8's early-exit report), change nothing, and report exactly what was found and in which file. Re-running this skill on an already-instrumented repo must be a no-op — it must never duplicate a `setup()` call, overwrite a working configuration, or "fix" something that wasn't broken. This gate exists because **`setup()` is call-once-only on every platform** — iOS, Android, React Native, Flutter, and MAUI all independently document that a second `setup()` call is not idempotent, so writing one into a partially-instrumented repo is not a safe no-op, it's a real bug. Nothing has been created yet at this point either, so a stop here needs no cleanup.

**In `detect` mode this is a finding, not a stop.** "Pendo is already installed, here is where" is one of the answers `detect` exists to give, so record what was found and in which file and carry on to Phase 4 — the requirements are still worth reporting on an already-instrumented repo. Render it as a normal `detect` report with the indicator list, not as an early exit.

**Classify the match before reporting it — a match is either a finished install or a half-finished one, and they need different next steps.** Every reference's indicator table already separates a call site from a dependency or a piece of configuration, and `references/ios.md` names the split outright. Resolve what matched into exactly one of two states by a single test, then carry the state itself — not merely the fact of a match — into whichever Phase 8 template renders.

**The test — is the platform's own initialization call present?** Take its spelling from `references/<platform>.md`, case-sensitively; **do not grep a bare `setup(`**. It is `PendoManager.shared().setup(` on iOS, `Pendo.setup(` on Android, `PendoSDK.setup(` on React Native, Expo and Flutter — and on **MAUI** the `.Setup(` call on the `IPendoService` that `PendoServiceFactory.CreatePendoService()` returns: **capital `S`, the one platform that does not spell it lowercase**, and the one whose indicator table names `PendoServiceFactory.CreatePendoService(` rather than the call itself. A lowercase literal misses it and reports a fully wired MAUI app as partial with "no analytics", on a live install.

1. **Complete** — that initialization call is present. **It is the marker, not any call site**: every platform's docs make it the mandatory, call-once initialization everything else depends on, so nothing runs without it however much else is wired. Report the repo as instrumented, with nothing for this skill to add. If `startSession` or the deep-link scheme is missing alongside it, name that as real remaining work for the developer — it does not make the repo installable here, because re-running would duplicate the initialization call this gate exists to protect.
2. **Partial** — something matched and **the initialization call exists nowhere**. That is the entire remainder by construction, not a list to match against: a dependency, Maven repository, plugin entry, URL scheme or manifest activity; an SDK `import` / `using` / `require` that nothing calls; and — the shape that reads most like a finished install — a `startSession` call or a deep-link handler with no initialization behind it, which is dead code, since both are documented as requiring `setup` first. Pendo is in the build and is not running, so **no analytics flow in this state**. Name which pieces are present and which are missing, and give both ways forward: finish the remaining wiring by hand against Pendo's guide for this platform (https://github.com/pendo-io/pendo-mobile-sdk), or revert the partial install and re-run this skill on a clean tree.

**"Already instrumented — nothing to do" is true of `complete` only.** On a `partial` match it is false — nothing is running and no analytics reach Pendo at all — and it is the one sentence that guarantees nobody ever finishes the job.

**Identify an existing install of either generation — 2.x or 3.x — and stop. Never upgrade one.** The indicator tables are deliberately generation-agnostic and must stay that way: `references/android.md` carries the legacy `io.pendo:pendo-android-sdk` coordinate precisely so a 2.x Android install trips this gate instead of being missed and having 3.x installed on top of it, which is the worst outcome this gate exists to prevent. A 2.x match is the same stop as a 3.x match, not a lesser one.

Where the generation is visible without extra work — a coordinate, a pinned version — name it in the report, because "which Pendo is already here" is exactly what the developer needs to know next. **What this skill does not do is act on it.** Migrating 2.x to 3.x is a different job from installing one: there is no upgrade path in this file, in any reference, or in any mode. Do not offer one, do not write one, and do not route the user anywhere on the strength of the version you read — report what is there and stop.

## Phase 4: Requirements check (Global Constraints)

Compare the repo's actual versions against these **Global Constraints** — the router-level minimums below, not a substitute for whatever the platform reference itself additionally checks:

| Platform | Minimum |
|---|---|
| `ios` | `IPHONEOS_DEPLOYMENT_TARGET` ≥ **11.0** |
| `android` | `minSdkVersion` ≥ **21**, `compileSdkVersion` ≥ **35** (report-only), AGP ≥ **8.0** (hard stop), Kotlin ≥ **1.9.0**, Java ≥ **11** (report-only, and read as `sourceCompatibility`) |
| `react-native` | `react-native` **0.66–0.84**, plus both native minimums above (explicitly restated for both heads) |
| `expo` | Expo SDK **41–56**, plus both native minimums above (explicitly restated as "same underlying native-head minimums as bare RN"). **Expo Go cannot run Pendo — a development build is required.** |
| `flutter` | Flutter ≥ **3.16.0**, Dart ≥ **3.2.0**, plus the Android native minimum above (explicitly restated for Flutter's Android head) |
| `maui` | **.NET 8–10** (read from the application head's `TargetFrameworks` — see below for which `.csproj` that is). Kotlin ≥ 1.9.0 for the Android head — **outcome 4, not applicable**: see the note below the table. |

**Which `.csproj` is the MAUI application head.** A MAUI solution normally holds several, and this phase and Phase 7 must agree on which one they are reading or they can report different .NET versions for the same repo. Use the same two markers `scripts/verify-build.sh`'s `find_maui_head_project()` uses: `<UseMaui>true</UseMaui>` **and** an executable `<OutputType>` (`Exe` or `WinExe`, possibly carrying a per-TFM `Condition`). `UseMaui` alone is not sufficient — Microsoft's MAUI *class library* template sets it too, so on a multi-project solution it matches libraries as readily as the head. If no project carries both, say the head could not be identified and treat the .NET row as indeterminate rather than reading whichever `.csproj` came first.

Note on the `maui` row's Kotlin floor: Pendo states it, so it is not invented and is not dropped — but a .NET MAUI repo has no Kotlin and no Gradle files in it whatsoever, so there is no value in the repo to compare against. The Android head is built by .NET for Android against Pendo's prebuilt `pendo-maui-binding-android` AAR, and the Kotlin that compiled that AAR is fixed inside it. That makes this **outcome 4 (not applicable)** — nothing exists to read — rather than outcome 3, which would strand the identical line under "Requires your attention" on every MAUI install with no action available to clear it. Report it as satisfied by the binding. Do not go looking for a `*.gradle` file to read it from, and do not treat its absence as a mismatch.

Note on the `flutter` row: unlike React Native and Expo, Pendo's Flutter docs restate the **Android** native floor explicitly but never separately restate an iOS floor for Flutter specifically. The iOS 11.0 minimum almost certainly still applies (same underlying native SDK) but treat it as inherited by implication, not a directly-sourced Flutter claim, if this ever needs re-verifying.

### The four outcomes of a constraint check

Every row above resolves to exactly one of these, and **"assume it passes" is not one of them** — a silent assumption is the specific failure this phase exists to prevent.

1. **Pass** — the value was read from the repo and meets the constraint. Nothing further to say.
2. **Mismatch** — the value was read and does not meet it. Handled by the paragraphs below: hard stop for AGP, report-only for the two rows named below, report-and-ask for everything else.
3. **Indeterminate** — the value could not be read from the repo without writing to it, or is not declared anywhere. **Not a stop, and not a pass.** "Unknown" is not "unsupported": the AGP hard stop exists to avoid installing into a project Pendo cannot support, and an unreadable value is not evidence that this is such a project. Continue the run, and report the constraint as **unverified** under Phase 8's "Requires your attention" — naming the constraint, *why* it could not be read, and where the developer can check it themselves. In `verify`, Phase 7's build is the empirical backstop; if a head fails, the unverified constraints are the first suspects and the report should say so. **In `detect` and `integrate` there is no backstop** — no build runs — so an indeterminate constraint stays genuinely open and the report must not imply otherwise: name it, and name `--mode verify` as the way to close it.
4. **Not applicable** — the value cannot exist in this repo shape at all (the native-head minimums on managed Expo, below). Report as not applicable, never in silence. Distinct from indeterminate: there is nothing to read, rather than something readable that could not be reached.

### Which value each constraint reads

Two rows name a concept rather than a file, and Pendo's own docs do not disambiguate them. Read exactly these:

- **Java ≥ 11** → the Android module's `compileOptions { sourceCompatibility }` (with the `targetCompatibility` and `kotlinOptions.jvmTarget` that move with it). **Not the JDK running Gradle.** These routinely disagree — a real Flutter app declares `sourceCompatibility = JavaVersion.VERSION_1_8` while building under JDK 17, so the two readings give opposite answers on the same repo. If the app module declares no `compileOptions` at all, the effective value is AGP's default rather than a repo fact: that is **indeterminate**, not a pass.
- **AGP ≥ 8.0** → the Android Gradle Plugin version the build actually resolves, which is not always in the repo (see below). Not the Gradle wrapper version — a different number, used below only as a fallback inference.

**Pendo documents "JAVA version 11 or higher" and nothing else.** It is one bare bullet in `android/pnddocs/native-android.md` (repeated verbatim in the RN, Flutter, and Expo Android docs); nothing anywhere in `pendo-io/pendo-mobile-sdk` says whether it means the JDK, `compileOptions`, `jvmTarget`, or a Gradle toolchain, and the repo contains no `compileOptions` snippet at all. `sourceCompatibility` is **this skill's reading, not a Pendo statement**: it is the value that sets the module's `org.gradle.jvm.version`, and therefore the one Gradle compares against a published AAR's, whereas the JDK running Gradle is pinned by AGP rather than by Pendo.

### Where these values actually live, per framework

Pendo points every framework at a raw `android { minSdkVersion 21; compileSdkVersion 35 }` snippet in the root `android/build.gradle` (`android/pnddocs/rn-android.md`, `android/pnddocs/flutter-android.md`) — which is **not** where those values live in a stock React Native or Flutter project. The SDK repo documents no framework-specific resolution at all: it never mentions `@react-native/gradle-plugin`, `flutter.compileSdkVersion`, `gradle.properties`, or `buildscript.ext`. Resolve them as below, and treat anything you cannot reach as **indeterminate**.

| Framework | Value | Where it actually is |
|---|---|---|
| `react-native` | AGP | `android/build.gradle` commonly declares `classpath("com.android.tools.build:gradle")` **with no version** — the community template since ~0.71. The version arrives via `android/settings.gradle`'s `includeBuild('../node_modules/@react-native/gradle-plugin')` and is pinned in `node_modules/@react-native/gradle-plugin/gradle/libs.versions.toml` as `agp = "…"`. |
| `flutter` | AGP | `android/settings.gradle`'s `plugins { id "com.android.application" version "…" apply false }`, or a legacy `classpath` in `android/build.gradle`. Normally readable. |
| `flutter` | `compileSdkVersion`, `minSdkVersion` | `android/app/build.gradle` reads `compileSdk = flutter.compileSdkVersion` / `minSdk = flutter.minSdkVersion` in **every** app scaffolded by `flutter create`. The numbers are defaults inside the installed Flutter SDK's own Gradle sources, not in the repo. |
| `expo` / `managed` | every Android value | Not applicable — outcome 4, see the next paragraph. |

**Read `node_modules/` or the Flutter SDK only if they are already present. Never install anything to resolve a Phase 4 value.** Phases 0–4 are read-only by design, and a dependency install is not a neutral read: on a real React Native app it writes ~1.1 GB into the tree, and a `postinstall` hook can rewrite committed files (observed on a real repo: `ios/Podfile.lock` and `ios/<App>.xcodeproj/project.pbxproj`) — dirtying the very tree Phase 0 hard-stops on. A value you would have to write to the repo to obtain is **indeterminate**, and that is the correct answer, not a reason to install.

**Managed Expo: only the Expo SDK row applies.** On `platform = expo` with `subPlatform = managed`, the native-head half of the `expo` row — AGP, Kotlin, Java, `minSdkVersion`, `compileSdkVersion`, `IPHONEOS_DEPLOYMENT_TARGET` — **does not apply, and you must not go looking for it.** None of those values exist in a managed repo: there is no `*.gradle` file and no `*.xcodeproj`, because Expo derives every one of them from the Expo SDK version when `expo prebuild` generates the native projects. That is not a gap in the repo, it is the definition of `managed` (`ios/`/`android/` absent — see the sub-platform table above).

So on managed Expo: check the **Expo SDK 41–56** range and nothing else, and state in the Phase 8 report that the native-head minimums were not applicable rather than leaving it unsaid. This is a genuine "not applicable", not a skipped check — which is why it does not violate the never-skip-silently rule below: the value does not exist to be compared, and the Expo SDK check already stands in for it. Concretely, **the AGP hard stop below does not fire on managed Expo** — a managed repo has no AGP to be below 8.0, and stopping on that basis would block every managed install on a repo that will produce a conforming AGP at prebuild. Everything in this paragraph applies only to `managed`; on `subPlatform = prebuilt` the values are right there in the committed `android/`/`ios/` projects and every row of the table is checked as written.

**AGP is a hard floor, not an ask — for every platform with an Android head whose AGP version actually exists in the repo (`android`, `react-native`, `flutter`, and `expo` when `subPlatform = prebuilt`; see the managed-Expo paragraph above for the one case where there is no AGP to check).** Every other mismatch on this page gets the report-and-ask treatment in the paragraph below; AGP does not. Pendo's docs state `Android Gradle Plugin 8.0 or higher` as a requirement, and AGP 8.0 itself requires Gradle ≥ 8.0 (an Android/Gradle compatibility fact, not a Pendo one) — well above the Gradle 6.2 floor the `exclusiveContent` repository block in `references/android.md` §2 needs just to parse. A repo below AGP 8.0 cannot produce a working install: continuing anyway risks writing a Gradle file that fails to parse, or resolving the dependency onto a toolchain the SDK doesn't support — a failure the developer only discovers once the build breaks, after this skill has already reported success and moved on. If the repo's AGP is **read** and is below **8.0**, **stop immediately** (see Phase 8's early-exit report) — do not ask whether to continue. State plainly that Pendo's SDK requires AGP 8.0+ and that the project's Android Gradle Plugin must be upgraded before this skill can install anything.

**In `detect` mode this is the verdict, not a stop.** Nothing follows Phase 4 there, so a sub-8.0 AGP is exactly the answer the run was asked for: report it as **cannot install — AGP below 8.0**, with the version read and the file it came from, alongside the platform and package findings. Do not render it as an early exit, and do not suppress the rest of the detect report because of it — a developer deciding whether to adopt Pendo needs the whole picture, not just the blocker.

**When AGP cannot be read at all (outcome 3), do not stop — and do not wave it through either.** This is the common case on React Native, where the version is not in the repo. Fall back to the Android head's Gradle wrapper — `gradle/wrapper/gradle-wrapper.properties` under the Android directory (`android/` for `react-native`/`expo`/`flutter`, the repo root for native `android`) — which is a committed file in every Gradle project and needs no dependency install to read. AGP 8.0 requires Gradle ≥ 8.0, so the inference is sound in one direction only:

- **Wrapper's Gradle is below 8.0** → AGP is necessarily below 8.0. Treat this exactly as a read AGP below 8.0, in every mode: **hard stop** in `integrate`/`verify`, stating that the stop came from the wrapper's Gradle version because AGP itself was unreadable — and in `detect`, the same "cannot install" verdict in the report rather than a stop, per the paragraph above.
- **Wrapper's Gradle is 8.0 or above** → AGP is still unproven (Gradle 8 does not imply AGP 8), so AGP stays **unverified** per outcome 3 and the run continues. What this *does* establish is the thing the install itself depends on: the `exclusiveContent` repository block `references/android.md` §2 writes needs Gradle ≥ 6.2 to parse, and that floor is now confirmed directly instead of being inferred from an AGP check that never happened.
- **Wrapper unreadable too** → both unverified; continue, and report both. Name the specific risk: on a pre-6.2 Gradle the `exclusiveContent` block will fail to parse, which a `verify` run surfaces as an Android head failure — and which `integrate`, running no build, leaves for the developer to hit. Say which of those two applies.

Pendo states **no Gradle version requirement anywhere** in `pendo-io/pendo-mobile-sdk` — only AGP 8.0. The Gradle floors used here are Android/Gradle compatibility facts (AGP 8.0 requires Gradle 8.0) and Gradle's own 6.2 release note for `exclusiveContent`, not Pendo claims.

**`compileSdkVersion` and Java `sourceCompatibility` are reported, not asked.** Both are the app module's own build settings, and `references/android.md` already forbids this skill from changing `compileSdkVersion`/`minSdkVersion` — the same reasoning covers `compileOptions`, since retargeting a project's bytecode level is a change to the app, not part of installing an SDK. So a yes/no prompt has no branch in which this skill behaves differently, while the evidence says it fires on nearly every conforming app: React Native's own 0.74 template ships `compileSdkVersion 34`, and `flutter create`'s Android template ships `sourceCompatibility = JavaVersion.VERSION_1_8`. Interrupting every RN and Flutter install for a decision the skill cannot act on is not a safety check.

So: read the value, compare it, and when it falls short put it under Phase 8's "Requires your attention" with the concrete remedy — which file and which property the developer must raise, and that Pendo states `compileSDKVersion 35` and `JAVA version 11` as the floors (`android/pnddocs/native-android.md`). Do not prompt, do not stop, and never omit it. In `verify`, Phase 7 then builds the Android head, which is where a real incompatibility surfaces concretely — a `compileSdk` too low to merge the SDK's manifest, or a Gradle "requires at least JVM runtime version 11" resolution error. A build error naming the actual cause beats a prompt asking the user to predict one. In `integrate` that build does not happen, so the report's remedy line is all the developer gets — which makes writing it properly more important there, not less.

**Kotlin, `minSdkVersion`, `IPHONEOS_DEPLOYMENT_TARGET`, and the bounded framework ranges keep the report-and-ask behavior below** (`react-native` 0.66–0.84, Expo SDK 41–56, the Flutter/Dart floors, .NET 8–10). These decide whether the app is in scope for the reference file's instructions at all, and — unlike the two rows above — none of them trips as a matter of course on a conforming app. A mismatch on any of them doesn't stop the install steps from producing valid files, so report it and let the user decide whether to continue.

If a repo's actual value falls outside the constraint for its platform (AGP, `compileSdkVersion`, and Java excepted — see above) — below a floor, *or above the upper bound of a stated range* (`react-native` and `expo` are bounded ranges, not open floors: a repo above the ceiling fails the install just as one below it does), or below any single sub-value in a multi-value row — **report the mismatch and ask whether to continue. Never skip silently.** If the user declines to continue, **stop** here (see Phase 8's early-exit report) — nothing has been created yet.

**In `detect` mode, report the mismatch and do not ask.** There is nothing after Phase 4 there but the report, so "continue?" has no meaning: the mismatch belongs in the detect report's requirements list, and it sets `Can install` to no with the value read and the floor it missed. Asking a user to authorise continuing into an install this mode was never going to perform is a prompt with no branch behind it.

Whichever outcome a row lands on, it reaches the user: a mismatch as a stop or an ask, a report-only row and an indeterminate row under "Requires your attention", a not-applicable row named as such. **The one forbidden outcome is a constraint that goes unmentioned** — including one that was never actually resolved.

## Phase 5: Resolve credentials and create the branch

**`detect` mode ends before this phase. Skip to Phase 8 and render the detect report.** Do not ask for an API key, do not ask for a scheme, do not create a branch — a read-only question must not cost the user a credential, and that property is only real if this phase is genuinely not entered. If `--api-key` or `--scheme` were passed anyway, leave them unused and note in the report that `detect` did not need them.

Every phase up to this point has been read-only: nothing asked for, nothing written, no branch created. **Now, and only now** — in `integrate` and `verify`:

1. Resolve the API key from `--api-key`; if absent, ask the user for it. Resolve the URL scheme from `--scheme`; if absent, ask the user for it. Ask for **both in one message** rather than one at a time: they sit side by side in the Pendo UI (`Settings` → `Subscription settings` → select the app → `App Details`), so a user who has to go and look is making one trip, not two.

   Asking here, and not earlier, is deliberate: by this point the app is identified, its reference exists, it is not already instrumented, and it meets the requirements — so the credentials are only requested once it is established that Pendo can actually be installed. A run that was going to stop has already stopped, without asking anyone for a key.

   **Both are needed for a working install, but neither is required to proceed.** The API key and scheme live in Pendo's admin UI and frequently belong to somebody else in the organisation — a developer preparing the integration often cannot produce them on the spot, and blocking the whole install until they can would mean the branch cannot even be prepared while the request is outstanding. So when the user does not have one or both:

   - **Write the declared placeholder** — `YOUR_API_KEY_HERE` for the API key, `YOUR_SCHEME_ID_HERE` for the scheme. These are Pendo's own placeholders from its getting-started guides, which is exactly why they are the ones to use: recognizable on sight, trivially greppable, and not invented here.
   - **Announce it; do not ask a second time.** State plainly that the install is being written with placeholders and is not live until they are replaced, then continue.
   - **Carry it into Phase 8 as its own reported state**, not as a footnote — see the `**Pendo config:**` line and the `### Replace before this works` section there.

   **Never invent a plausible-looking value.** The declared placeholder or the real thing — nothing in between. A fabricated key that *looks* real (`a1b2c3d4-…`) or a fabricated scheme (`pendo-abc123`) is the actual hazard here, because it is indistinguishable from a correct install at a glance and so nobody ever goes looking for it. The placeholder's entire value is that it cannot be mistaken for real, and a plausible fake destroys that property while keeping every one of its downsides.

   **What a placeholder costs, precisely, so the report can say it.** A placeholder API key means the SDK initializes and reports to nothing: no analytics arrive and Pendo's own install check (`Pendo SDK was successfully integrated and connected to the server`) never passes. A placeholder scheme means Designer pairing silently never works — no error, just nothing. Both compile, so **a passing `verify` build proves the code is valid, not that Pendo is live**; say that explicitly rather than letting a green build imply a working install.

   **This relaxation does not extend to identifiers.** A placeholder *credential* means no data flows. A placeholder visitor or account identifier means fabricated data flows into the customer's Pendo subscription, indistinguishable from real data, permanently. `references/identity.md`'s ban on placeholder identifiers is absolute and untouched by any of the above: when no real identifier exists, the outcome is still `setup()` with no `startSession` call at all — never `startSession` with invented arguments. Those two failures are not the same kind of thing, and only the second one cannot be undone.
2. *(Skipped under `--dry-run`.)* Capture where to return to, as `originalRef`. Run `git branch --show-current`; if it prints a name, that is `originalRef`. **If it prints nothing, the repo is on a detached HEAD** — a tag checkout, a bisect, a CI or submodule checkout — and there is no branch name to record. Fall back to `git rev-parse HEAD` and record that commit SHA as `originalRef` instead, noting that it is a commit rather than a branch. Never treat the empty string as a branch name: `git checkout ""` does not return anywhere, and the Phase 8 report would render an empty backtick pair as if a branch existed. Then create the working branch: `git checkout -b pendo-install-<platform>` (`platform` has been known since Phase 1, so there's no generic-name placeholder to resolve later). **If the skill stops for any reason between this point and Phase 8's success report, switch back with `git checkout <originalRef>` and say so in the report** — see Phase 8's early-exit report. Checking out a recorded SHA restores the same detached HEAD the run started from, which is the correct no-op.

Under `--dry-run`, do step 1 in full — including the placeholder fallback, so the plan shows the values a real run would actually write rather than a version of the plan the user cannot get — but skip step 2 entirely: no branch is created, and Phase 8 renders `**Branch:** (not created — dry run)`. A dry run whose user has no credentials plans `YOUR_API_KEY_HERE` / `YOUR_SCHEME_ID_HERE` and says so, exactly as the real run would.

## Phase 6: Dispatch to the platform reference

**`detect` mode does not reach this phase** — it stopped at the end of Phase 4. Everything below applies to `integrate` and `verify` only.

Using the `references/<platform>.md` content already read in Phase 2, execute its install steps in order, using the resolved `apiKey`, `urlScheme`, `platform`, `subPlatform`, and `branchName` from the phase contract. Do not re-ask the user for credentials and do not re-run detection — they are already established. Do not open any other platform's reference file for comparison or "just to check."

Under `--dry-run`, narrate what these steps would change instead of calling `Write`/`Edit`/`Bash` to make any of it happen.

## Phase 7: Verify the build

**This phase runs in `verify` mode only.** In `detect` nothing was installed, and in `integrate` — the default — building is deliberately not part of the job. Do not run the script in those modes, and do not treat their silence as a pass: Phase 8's `### Build` section has explicit wording for "not run because of the mode", and using it is mandatory. The one thing that must never happen is an `integrate` run that reads as though the install was verified.

Run:

```bash
bash "<skill-dir>/scripts/verify-build.sh" <platform>
```

`<skill-dir>` is the directory this `SKILL.md` was loaded from — the same directory holding the `references/` folder you read `references/<platform>.md` out of in Phase 2, so its absolute path is already known to you. **Do not hardcode `~/.claude/skills/install-pendo-mobile/`.** A plugin-scoped, project-scoped, or snapshot copy of this skill lives somewhere else entirely, and a wrong path turns a script that is present into one reported absent — a false negative on build verification, which the paragraph below then obliges you to report as "could not run".

**Working directory: the app root, which is not always the git root.** The script probes for `ios/` and `android/` relative to the current directory, and resolves JS or Dart dependencies there too. Run it from the **app root** — the directory holding the app's own manifest (`package.json` for `react-native`/`expo`, `pubspec.yaml` for `flutter`, the Gradle wrapper for `android`) alongside its native directories. In a single-app repo that is the git root and the distinction never arises; in a monorepo it does. Phase 0's `git status` and Phase 5's `git checkout -b` both run at the git root, so that is the natural place to still be standing when Phase 7 begins, while the app itself may be several directories down (observed: a Flutter app at `compass_app/app` inside a pub workspace). The script distinguishes the two cases rather than reporting an empty result: when the current directory has nothing to build but candidate app roots exist below it, it exits `2` with a line beginning `wrong directory` that names them — distinct from its genuine "no app root found" message. Re-run from the directory it names; do not report that verification failed.

**Managed Expo — tell the user what this does before running it.** A managed Expo repo has no `ios/`/`android/` to build, so the script generates them with `npx expo prebuild --no-install`, builds them, and then **deletes exactly the directories it generated**, leaving the tree as it found it. That temporary prebuild is the only way to catch a broken config-plugin output — validating the config alone would let it pass — and the cleanup is what keeps Phase 1's `managed`/`prebuilt` detection and Phase 3's already-installed gate from being poisoned on the next run by directories this skill created. Say both halves in the report's `### Build` section: that native projects were generated to verify, and that they were removed again. If the script leaves them behind (it only removes what it created in that same run), say that instead.

If this script does not exist yet in your installed copy of the skill, say so plainly in the Phase 8 report's `### Build` section — do not report PASS, do not report FAIL, state that verification could not run and why. If Phase 1's toolchain check already found it missing and the user chose to continue anyway, skip this phase entirely and note that in the report instead of attempting it. Skip this phase entirely under `--dry-run` too (see Argument Parsing) — there's nothing built to verify.

**Exit codes**: `0` = build passed. `1` = build failed, **and the failure is attributable to this install**. `2` = not verified — a required toolchain is absent, the script was run from the wrong directory (see above), or the build failed with **no mention of Pendo anywhere in the failing step's own output**, so the script cannot attribute the failure to this install.

That last case applies to **every** native head on every platform — the Android head as much as the iOS one. A pre-existing build failure in a repo this skill has not touched is common and has been reproduced on verified Pendo-free trees (a dead `compile()` Gradle DSL in a third-party module; a `react-native-worklets` CMake ordering failure; a Gradle/JDK class-file version mismatch). Reporting any of those as `1` would tell a developer that installing Pendo broke their app when the evidence says the install never touched the failure. Attribution is deliberately scoped to the failing step's own output rather than the whole run, because a successful `pod install` lists `Pendo (x.y.z)` among its pods and would otherwise make every later, unrelated failure look Pendo-caused.

`2` is never reported as FAIL — but it is also never a silent PASS: `verify-build.sh` **always** prints an `Android head:` / `iOS head:` line per native head, naming which were verified and which were not, and why. For `react-native`/`expo`/`flutter` (dual native heads), carry those per-head lines into Phase 8's report rather than collapsing two heads into one PASS/FAIL word — a head the script could not verify must still be named as such, not folded silently into an overall PASS.

**Build-caused file churn is not this run's own editing, on any platform.** This phase is not read-only: `pod install` can rewrite `Podfile.lock` and the Xcode project on every iOS-bearing head (`ios`, `react-native`, `expo`, `flutter`), Gradle can rewrite wrapper or lock files on Android-bearing heads, and `npx expo prebuild` generates the native directories it then builds on managed Expo. A platform reference may catalog what to expect for its own platform (e.g. `references/flutter.md`'s "Files the build changes on its own") — treat any such list as illustrative, not exhaustive; an app generated by the current tool version can need no migrations and show none of it. After this phase finishes, run `git status --porcelain` and compare it against the reference's own reported edits from Phase 6 (the phase-contract's guarantee 2, above): any path that shows up here but was not in that list is this phase's churn, not this run's editing. Phase 8 reports it separately — see `### Files the build touched` below — rather than folding it into `### Files changed` or leaving it unmentioned.

## Phase 8: Report

**Every report states its mode on its first line.** A reader must never have to infer from the absence of a section whether a build was skipped or merely failed to be mentioned — and the same report shape reaching them from three different modes is exactly how that ambiguity arises.

**In `detect` mode**, produce this structure instead of the install report below — there is no branch, no changed file and no build to report on:

```markdown
## Pendo detect (no changes made)

**Platform:** <platform> / <sub-framework>
**Pendo package:** <the dependency `references/<platform>.md` would add, named exactly as its Dependency section names it, plus what that section says about versioning — including "no version pinned by Pendo" where that is the case, rather than inventing one to fill the line. Where the section is tiered rather than single-valued (iOS picks between SPM, CocoaPods and a vendored framework), name the tier this repo would actually land on and the signal that decides it.>
**Already installed:** <"no — none of the N indicators found", or Phase 3's classified state — complete or partial — with which indicators matched and in which files, plus the SDK generation where it was visible without extra work>
**Can install:** <"yes"; "no — <the blocking constraint and the value read>"; or "no — Pendo is already installed here (<state>)". Phase 3's gate stops an `integrate` run exactly as a failed constraint does, so a repo that clears every requirement but is already instrumented is still one this skill will not install into. Never report "yes" on one.>

### Requirements
- <one line per Global Constraints row for this platform: the value read, the floor, and which of the four outcomes it landed on>

### What an install would do
<Two to five lines, from the reference's own step headings — the dependency, where `setup()` goes, where `startSession()` would go, the deep-link config. Enough to decide whether to proceed; not a full narration. That is `--dry-run`'s job.>

### Requires your attention
- <indeterminate and not-applicable constraints, named with why — no build ran, so none of these were closed empirically>

### Next step
<**When Phase 3 found an existing install, this section is that state's next step and never an install command** — `integrate` would refuse this repo, so offering it sends the user straight into a stop. Give Phase 3's own next step for the classified state: nothing to do (complete), or the wired/unwired split and the two ways forward (partial). Name the SDK generation if it was visible, but never offer an upgrade — this skill has no 2.x-to-3.x path.

Otherwise, the exact command to proceed: `--mode integrate` to install, or `--mode verify` to install and build. State that a Pendo API key **and** a Designer URL scheme are both needed for a working install, and where they are found together (Pendo UI → `Settings` → `Subscription settings` → select the app → `App Details`), so the user can arrive with both — while making clear that not having them yet is not a blocker: the install proceeds with clearly-marked placeholders to replace later. Mention a dirty tree here if one was observed, since `integrate` will refuse it.>
```

**On a completed install** (`integrate` or `verify`), produce exactly this structure:

```markdown
## Pendo install complete

**Mode:** <integrate — installed, not built | verify — installed and built>
**Platform:** <platform> / <sub-framework>
**Branch:** <branch>
**SDK version:** <resolved version> (baseline <pin>)
**Pendo config:** <"live — real API key and scheme" | "⚠ PLACEHOLDERS — this install is not live until they are replaced (see below)">

### Replace before this works
<Include this section only when Phase 5 fell back to a placeholder, and put it here — above "Files changed" — because it is the one thing about this install that is not finished. One line per placeholder: the sentinel written, every `file:line` it was written to, and what to replace it with. State the consequence for each: `YOUR_API_KEY_HERE` means no analytics reach Pendo and its install check will not pass; `YOUR_SCHEME_ID_HERE` means Designer pairing will never work. Name where both values come from (Pendo UI → `Settings` → `Subscription settings` → select the app → `App Details`), and give the grep that finds every site: `grep -rn "YOUR_API_KEY_HERE\|YOUR_SCHEME_ID_HERE" .`. Do not merge this into "Requires your attention" — that section is a list of caveats, and this is a blocking to-do.>

### Files changed
- `path` — what changed

### Files the build touched
- `path` — what the toolchain did and the command that caused it (e.g. "`ios/Podfile.lock` — added by `pod install` during Phase 7"). Omit this whole section if Phase 7's post-build `git status --porcelain` found nothing beyond the files already listed under "Files changed" — and always omit it in `integrate` mode, where no build ran and therefore nothing could have been touched by one.

### Build
<In `integrate` mode, this section is exactly: "Not run — mode `integrate` installs without building. Nothing here has been proven to compile. To verify: `bash <skill-dir>/scripts/verify-build.sh <platform>` from the app root, or re-run this skill with `--mode verify`." Name the app root explicitly if it is not the git root. Never write PASS, FAIL, or a bare "skipped" here, and never omit the section — an install report with no Build line reads as a verified install.
In `verify` mode, report the real result. If Phase 5 fell back to a placeholder, add one line to whatever the result was: a placeholder is a valid string and compiles, so **a PASS here proves the code is valid, not that Pendo is live** — it says nothing about the credentials.
For `ios`/`android` (one build target): PASS with the command, FAIL with the error, or "not verified" with `verify-build.sh`'s own reason.
For `maui`: the script builds the **Android head only** — say which TFM it built (it reads the project's own, e.g. `net10.0-android`), and state that the iOS, MacCatalyst and Windows heads were not verified rather than letting one PASS imply all four.
For `react-native`/`expo`/`flutter` (two native heads): one line per head — PASS with its command, FAIL with its error, or "not verified" with `verify-build.sh`'s own reason (toolchain absent, wrong directory, or a failure whose output never referenced Pendo). Never compress two heads into a single PASS/FAIL word.>

### Requires your attention
- <anything unwired, e.g. startSession has no identifier>
- <every Phase 4 constraint that came back indeterminate — named, with why it could not be read and where to check it>
- <every report-only Phase 4 mismatch (`compileSdkVersion`, Java `sourceCompatibility`) — with the file and property to raise>
- <every Phase 4 constraint that was not applicable to this repo shape (managed Expo's native-head minimums; MAUI's Kotlin floor, which lives in the binding AAR)>
```

Under `--dry-run`, render `**Branch:** (not created — dry run)`, rename `### Files changed` to `### Would change`, and omit `### Build` and `### Files the build touched`.

**On any early exit** — Phase 0's dirty tree, Phase 1's declined toolchain warning, Phase 2's missing reference, Phase 3's already-installed gate, or Phase 4's AGP floor (read directly, or inferred from a Gradle wrapper below 8.0) or declined requirements mismatch — produce this instead. **Unavailable credentials are no longer among these**: Phase 5 falls back to a placeholder and the run completes, reporting under the completed-install template's `**Pendo config:**` line and `### Replace before this works` section above. Every remaining early exit is therefore in Phase 0–4, before a branch exists. **In `detect` mode the only early exit is Phase 2's missing reference**: that mode does not run Phase 0 or Phase 5, and its Phase 3 and Phase 4 stops are findings rendered in the detect report above, not exits.

```markdown
## Pendo install stopped

**Mode:** <the mode that was running>
**Phase:** <phase number and name where it stopped>
**Reason:** <why, in one sentence>
**Branch:** <"none created — still on `<originalRef>`" if the stop happened before Phase 5's branch step, or "returned to `<originalRef>`" if a branch had been created and this run switched back to it. When `originalRef` is a commit SHA rather than a branch name, say so — "returned to detached HEAD at `<sha>`" — never render an empty pair of backticks.>
**Files changed:** <list any files already written, or "none" — this should be "none" for every stop point above, since all of them happen before Phase 6's first edit>

### Next step
<what the user should do to resolve it and re-run — e.g. "commit or stash your changes," "upgrade the project's Android Gradle Plugin to 8.0 or higher," "confirm the toolchain and re-run." **A missing credential is never the reason for a stop** — Phase 5 writes a declared placeholder and the run completes — so no next step here ever asks the user to go and fetch an API key or a scheme before re-running.

When the stop was Phase 3's gate, this is the classified state's own next step, per Phase 3: "already instrumented — nothing to do" for a **complete** install; for a **partial** one, which pieces are wired and which are not, plus the two ways forward (finish the remaining wiring by hand against Pendo's guide for this platform — https://github.com/pendo-io/pendo-mobile-sdk — or revert the partial install and re-run this skill on a clean tree). Name the SDK generation if it was visible without extra work, and stop there: this skill installs, it does not upgrade, so a pre-3.0 install is reported as found and never routed to a migration.>
```

If a branch was created in Phase 5 and the run then stops before this success report, run `git checkout <originalRef>` first, and reflect that switch-back in this template's `Branch` line.

## Constraints

- **Never emit a placeholder visitor or account identifier. This one is absolute.** Not `"user123"`, not `"YOUR_VISITOR_ID"`, not a value invented to make the install look complete. An install that calls `startSession("user123", ...)` compiles, runs, reports success, and pushes fabricated visitors into the customer's Pendo subscription forever — the code path is identical to a correct install, so nothing downstream ever catches it, and the data cannot be un-sent. When no real identifier exists, emit `setup()` and **no `startSession` call at all** (not commented out, not with fake arguments) and report it. See `references/identity.md`. This is the highest-value rule in this skill.
- **Never invent an API key or URL scheme — but do not stop for a missing one either.** These are configuration, not data: a placeholder credential means the SDK reports to nothing, so no analytics arrive and nothing is polluted, which is a categorically smaller failure than the rule above and is fully recoverable by editing one string. So when the user cannot supply one, Phase 5 writes the declared placeholder (`YOUR_API_KEY_HERE`, `YOUR_SCHEME_ID_HERE`) and the run completes. What remains forbidden is a *plausible* fake — an invented key or scheme that looks real defeats the only thing making a placeholder safe, which is that nobody can mistake it for a finished install.
- **Never let a placeholder install read as a finished one.** It gets the `**Pendo config:** ⚠ PLACEHOLDERS` header line and its own `### Replace before this works` section naming every `file:line`, above "Files changed". A `verify` build passing does not change this — placeholders compile.
- **Never report an install as verified in a mode that did not build it.** `integrate` — the default — writes the install and stops. Its report says so in the `### Build` section, in those words, every time. Absence of a build result is not a pass, and the mode being the default does not make the omission self-evident to the reader.
- **`detect` never asks for a credential and never writes.** It stops before Phase 5. If a run in `detect` mode finds itself wanting an API key, a scheme, a branch or an edit, it has left its mode — stop and say so rather than proceeding.
- Never proceed past Phase 0 on a dirty git tree — in `integrate` and `verify`. `detect` does not run Phase 0 at all (it writes nothing); it reports a dirty tree as an observation instead.
- Never ask for credentials or create a branch before Phase 5 — every phase before it must stay read-only, or a stop on Phases 1–4 stops being a true no-op.
- Never skip creating the branch in Phase 5 — a branch must exist before Phase 6 writes anything. This binds wherever Phase 6 runs, so it binds in `integrate` and `verify`; `detect` reaches neither phase.
- If the skill stops after Phase 5's branch was created, always switch back to `originalRef` and say so in the Phase 8 report — never leave the repo on a stray branch after an aborted run. On a detached HEAD, `originalRef` is the commit SHA; never treat an empty `git branch --show-current` as a branch name.
- Never read more than one `references/<platform>.md` in a single run.
- Never guess a `subPlatform` when the detection signals are absent or contradictory — ask.
- Never silently downgrade or skip a Phase 4 requirements mismatch, in either direction (below a floor or above a bounded range's ceiling) — ask. **Exception: AGP below 8.0 is a hard stop, not an ask; `compileSdkVersion` and Java `sourceCompatibility` are reported, not asked** — see Phase 4. A constraint whose value cannot exist in this repo shape (the native-head minimums on managed Expo, MAUI's Kotlin floor) is "not applicable", not "skipped" — report it as such, never in silence.
- **Never treat a Phase 4 constraint you could not read as passing.** An unreadable value is *indeterminate*: report it as unverified and continue, except where a sound inference proves a violation (a Gradle wrapper below 8.0 proves AGP is below 8.0). Never write to the repo — including installing dependencies — to resolve one.
- Never report Phase 7 as PASS or FAIL if `verify-build.sh` didn't actually run — including when the mode is why it didn't.
- Never blame a build failure on this install without evidence that it caused it — `verify-build.sh` returns `1` only when the failing step's own output mentions Pendo, and its `2` verdicts must be carried into the report as "not verified", never as FAIL and never as a silent PASS.
- Never fold Phase 7's own file churn (`pod install`, Gradle, or `expo prebuild` rewriting committed files) into "Files changed" as if this run authored it, and never omit it either — report it under "Files the build touched", per Phase 7's post-build `git status --porcelain` comparison.
