---
name: install-pendo-mobile
description: Install, check, fix or report on the Pendo Mobile SDK in a mobile app repository — native iOS, native Android, React Native, Expo, Flutter, or .NET MAUI. Use when the user asks why Pendo isn't working, or to check, audit, diagnose or fix an existing Pendo setup (doctor: findings by severity, then the fixes the user picks); asks for a report for Pendo support or Technical Support (report: redacted, shown in chat, saved on request); asks to install or add Pendo or instrument an app with it (integrate, the default: dependency, setup() and startSession(), Designer deep-link scheme; verify also builds); or asks a read-only question such as which Pendo SDK package an app needs or whether Pendo is already installed (detect: asks for no credentials).
argument-hint: "[--mode detect|integrate|verify|doctor|report] [--api-key KEY] [--scheme pendo-xxxx] [--platform ios|android|react-native|expo|flutter|maui] [--dry-run] [--force-dirty]"
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Install Pendo Mobile SDK

You are installing the Pendo Mobile SDK into the developer's live working tree, not a scratch clone. Git is the only rollback, so never write a value that could pass for real when it is not. When a credential is not available yet, the install still goes ahead on a clearly declared placeholder that is reported as unfinished work, never on a plausible-looking invention.

Work through the phases in order: refuse a dirty tree, detect the platform, confirm its reference exists, gate on an existing install, check requirements, resolve credentials and branch, run the platform reference, verify the build, report. **Every phase before Phase 5 only reads.** Nothing is asked for and nothing is written until every cheap check has passed, so a stop in Phases 1–4 leaves the repo exactly as it was: no stray branch, no real API key written for a platform that turned out to be instrumented already.

**How far down that sequence you go is the `--mode` argument** — `detect`, `integrate` (the default), or `verify`. Two more modes leave that sequence: `doctor` checks an install that already exists instead of making one, and `report` writes up the app's Pendo setup for Pendo Technical Support. See "Modes".

## Argument Parsing

Parse `$ARGUMENTS` for:

- **`--mode <detect|integrate|verify|doctor|report>`** — how far to run. **Defaults to `integrate`.** `full` is a synonym for `verify`. Any other value is a usage error: name the five modes and stop before Phase 0. Do not guess which one was meant.
- **`--api-key <key>`** — the Pendo integration key. If absent, Phase 5 asks for it and falls back to a declared placeholder if the user does not have it. Ignored in `detect` and `report`; if passed anyway, say so in the report. In `doctor`, used only if a fix picked in D4 needs it; otherwise say in the report that it was not needed.
- **`--scheme <pendo-xxxx>`** — the Designer pairing URL scheme, which lets the app pair with Pendo Designer for page tagging and guide testing. Handled like the API key. **It is needed for a working install, not optional**: a real key with a placeholder scheme reports analytics but can never be tagged. Both live at Pendo UI → `Settings` → `Subscription settings` → select the app → `App Details`, so ask for them together. Ignored in `detect` and `report`; if passed anyway, say so in the report. In `doctor`, handled like `--api-key`.
- **`--platform <ios|android|react-native|expo|flutter|maui>`** — skips Phase 1's six-row detection table only. Sub-platform detection (uikit vs. swiftui, kotlin vs. java, managed vs. prebuilt) still runs.
- **`--dry-run`** — plan only. Phases 0–4 run as normal; they only read. Phase 5 resolves the key and scheme as normal, including the placeholder fallback, so the plan shows the values a real run would write, but creates no branch. Phase 6 reads the install steps and narrates what they would change, and never calls `Write`/`Edit`/`Bash` to make an edit. Phase 7 is skipped. The report renders as `references/reports.md` says for dry runs. With `--mode doctor`, `--dry-run` ends the run after the doctor report, with no fix prompt. With `--mode report`, it shows the report and skips the save question.
- **`--force-dirty`** — lets `integrate`, `verify` and doctor's D4 run on a tree with uncommitted changes, instead of stopping at the clean-tree check. The run records which files were already changed (`preexistingDirty`) and keeps them apart in the report. It has no effect in `detect`, in `report`, or in a doctor run that stops before D4; say so in the report if it was passed.

Empty `$ARGUMENTS` means `integrate`: start at Phase 0 and ask for the key and scheme at Phase 5.

## Modes

`--mode` sets **where the run stops**, not which phases run. Each mode runs a contiguous run of phases in order; none is reordered or skipped in the middle. Phases 1–4 do the same reading in every mode and reach the same conclusions.

Two differences follow from `detect`, `doctor` and `report` not writing during their reading phases:

1. **`detect`, `doctor` and `report` do not run Phase 0.** That phase only protects a working tree from writes; `doctor` runs the same check at D4, before its first write. `report`'s one write is a new untracked file the user asked for, which needs no clean tree.
2. **In `detect`, `doctor` and `report`, a blocking result is a finding, not a stop.** Phases 3 and 4 can halt an install (Pendo already present, AGP below 8.0, a declined mismatch). In `integrate` and `verify` those end the run. In `detect` they are recorded and the run continues to the end of Phase 4. In `doctor` and `report` it becomes a `REQ` finding or the Phase 3 state. Where a phase says "stop", read "stop, unless the mode is `detect`, `doctor` or `report`: then record the finding and carry on".

| Phase | `detect` | `integrate` (default) | `verify` | `doctor` | `report` |
|---|---|---|---|---|---|
| 0 Refuse a dirty tree | — | ✅ | ✅ | — *(at D4, before the first write)* | — |
| 1 Detect platform and framework | ✅ | ✅ | ✅ | ✅ | ✅ |
| 2 Confirm the platform reference exists | ✅ | ✅ | ✅ | ✅ | ✅ |
| 3 Already-installed gate | ✅ | ✅ | ✅ | ✅ *(inverted)* | ✅ *(records the state)* |
| 4 Requirements check | ✅ | ✅ | ✅ | ✅ *(findings)* | ✅ *(findings)* |
| 5 Resolve credentials, create branch | — | ✅ | ✅ | — *(D4 has its own branch step)* | — |
| 6 Run the platform reference | — | ✅ | ✅ | — | — |
| 7 Verify the build | — | — | ✅ | optional, at D4 | — |
| 8 Report | ✅ *(detect template)* | ✅ | ✅ | ✅ *(templates in `references/doctor.md`)* | ✅ *(template in `references/report.md`)* |

- **`detect`** answers "what is this repo, and what would Pendo need here?" and changes nothing. **It is the only mode that never asks for a credential**: a question about which package an app needs must not cost the user their API key. It reports the platform, sub-platform, package, whether Pendo is already there, and whether the repo can take it. It skips Phase 0, but reports a dirty tree as an observation.
- **`integrate`**, the default, does everything `detect` does, then the install: branch, dependency, `setup()`/`startSession()`, deep-link scheme. **It does not build**, and its report must say so and give the command to check it.
- **`verify`** does everything `integrate` does, then Phase 7's real build. It is the only install mode that can report a build PASS.
- **`doctor`** checks an existing Pendo install and fixes what the user picks. It runs Phases 1–4 like `detect`, then leaves the phase sequence and follows `references/doctor.md`: D1 Diagnose, D2 Report, D3 Choose fixes, D4 Apply. It is the one mode that does not stop at a point in the sequence; it branches off after Phase 4. The analysis only reads files and never asks for a credential. It writes only in D4, after the user picks fixes and the tree is clean.
- **`report`** builds a redacted support report for Pendo Technical Support. It runs Phases 1–4 like `detect`, then doctor's D1 analysis, then follows `references/report.md`. It reads only, never asks for a credential, and writes `pendo-support-report.md` and `pendo-support-report.json` only if the user says yes.

**When the user did not name a mode.** Default to `integrate`. Choose `detect` when the request is a question, not an instruction ("which Pendo SDK does this app need?", "what framework is this?", "is Pendo already installed?"), and say in the report's first line which mode you picked and why, so a user who wanted the install can re-run. Choose `verify` when the user asks for the install to be checked, proven, or confirmed to build. Choose `doctor` when the user asks to check, audit, diagnose, review or fix an existing Pendo setup, or asks why Pendo is not working. This wins over `detect`: "what is wrong with my Pendo integration?" is a doctor request even though it is phrased as a question. Choose `report` when the user asks for a report, a summary or an export for Pendo support or Technical Support, or for something to attach to a support ticket. This wins over `doctor` and `detect`.

**Which files a mode reads.** `integrate` and `verify` read `references/integrate.md` before Phase 0: it holds Phases 0, 5, 6 and 7. `doctor` reads it only at D4, before its first write. `detect` and `report` never read it.

**`--mode` and `--dry-run` are separate.** Mode is how far; `--dry-run` is whether to write. `--mode integrate --dry-run` narrates the edits. `--mode detect --dry-run` is redundant: accept it and note that `--dry-run` had no effect. `--mode verify --dry-run` contradicts itself (nothing built to verify): a **usage error**. Name the two arguments, ask which was meant, and stop before Phase 0. `--mode doctor --dry-run` reports and stops before the fix prompt. `--mode report --dry-run` shows the report and skips the save question.

## The phase contract

The router detects and gates; each `references/<platform>.md` does the platform-specific editing. **`detect` and `report` never enter a reference's install steps.** They read the reference in Phase 2 and use its Existing Install Indicators in Phase 3. The five values a reference is entered with, and the two guarantees it ends with, are in `references/integrate.md`.

Every mode resolves `platform` and `subPlatform` in Phase 1:

| `platform` | `subPlatform` | How the router decides |
|---|---|---|
| `ios` | `uikit` \| `swiftui` | A type conforming to `App` with `@main` in a `.swift` file → `swiftui`. Otherwise an `AppDelegate.swift` conforming to `UIApplicationDelegate` → `uikit`. |
| `android` | `kotlin` \| `java` | Any `.kt` file under the app module → `kotlin`. Otherwise `java`. |
| `react-native` | `bare` | Always `bare`: Expo is its own `platform`. |
| `expo` | `managed` \| `prebuilt` | `ios/` and `android/` present **and tracked by git** (`git ls-files ios android` prints something) → `prebuilt`. Absent → `managed`. Present but untracked or gitignored → `managed` too: that is leftover `expo prebuild` output, and treating it as `prebuilt` would hand-edit throwaway directories. |
| `flutter` | `null` | Dart is the only language. |
| `maui` | `null` | The SDK wiring point is the same for MVVM and code-behind. |

**Ask, don't guess, when the signals are absent or contradict each other.** Examples: an Objective-C-only iOS app with no `@main` and no `AppDelegate.swift`, or a multi-module Gradle project where "the app module" is unclear. Never default a `subPlatform`: the reference never re-asks, so a wrong guess edits the wrong lifecycle file (guessing `uikit` for a SwiftUI app edits an `AppDelegate` that does not exist instead of wiring `.onOpenURL`).

`references/<platform>.md` is named after the `platform` value: `ios.md`, `android.md`, `react-native.md`, `expo.md`, `flutter.md`, `maui.md`.

## Phase 0: Refuse a dirty tree

**Skipped in `detect`, `doctor` and `report`.** Run `git status --porcelain` anyway if it is cheap, and report a dirty tree as an observation, never as a stop. `doctor` runs the real check at D4, right before its first write.

In `integrate` and `verify`: follow Phase 0 in `references/integrate.md`, read before this phase.

## Phase 1: Detect platform and framework

**Check cross-platform rows before native ones, and do not reorder them.** React Native and Expo repos carry `ios/` and `android/` next to `react-native` in `package.json`, so a native-first check would misclassify every RN and Expo repo as native.

| Signal | Platform |
|---|---|
| the `expo` package itself in the repo's own `package.json` dependencies | **expo** (wins over react-native when both are present) |
| `react-native` in dependencies, no `expo` package | **react-native** |
| `pubspec.yaml` with a Flutter SDK dependency | **flutter** |
| `*.csproj` referencing `Microsoft.Maui` | **maui** |
| `*.xcodeproj` / `*.xcworkspace`, or an XcodeGen `project.yml` / Tuist `Project.swift` | **ios** |
| `build.gradle[.kts]` with the Android plugin | **android** |

**The Expo signal is the `expo` package exactly, not the `expo-*` prefix.** An `expo-*` module without `expo` (say `expo-secure-store` alone) is a bare RN app: it has no `expo prebuild` or config-plugin pipeline, which is how `references/expo.md` installs. An `expo`-shaped package pulled in only transitively (e.g. `@expo/config-plugins` via another library) is no signal at all. Read the repo's **own** `dependencies` and `devDependencies`, never the resolved tree or `node_modules/`. Note that `grep -i expo` over JS source matches every `export`; match the dependency key, not source text.

**A `package.json` is a cross-platform signal only through the first two rows.** Native apps often keep one for build scripts and tooling. With no `react-native` or `expo` dependency, it does not match a row and does not block the native rows below it.

If `--platform` was passed, use it and skip the table. If two or more rows match (e.g. a monorepo with a Flutter module and a bare `android/`), read `references/detection.md` before deciding. Do not guess.

Once `platform` is set, resolve `subPlatform` with the phase-contract table, including its ask-fallback. This runs even when `--platform` was passed.

Still read-only, confirm the toolchain:

| Platform | Command |
|---|---|
| `ios` | `xcodebuild -version` |
| `android` | `./gradlew --version` |
| `react-native`, `expo` | `node --version` |
| `flutter` | `flutter --version` |
| `maui` | `dotnet --version`, **then `dotnet workload list`**, whose output must include `maui` (or at least `maui-android`) |

**What a missing toolchain costs depends on the mode, so the mode decides whether to ask.** In `verify`, Phase 7 is lost: warn the user and get explicit confirmation to continue; if they decline, stop (early-exit report). In `integrate`, no build was going to run: record it as the reason a later `--mode verify` will not work yet, and continue without asking. In `detect` and `report`, report it and never gate on it. In `doctor`, record it; it only matters if the user asks for the optional build at D4, so say so there.

**MAUI needs the workload check in `integrate` too**, because a missing workload breaks Phase 6, not only Phase 7. `dotnet --version` succeeds without workloads, and Phase 6's first action, `dotnet add package`, then fails with `error NETSDK1147` ("the following workloads must be installed") after the branch already exists. The remedy is `dotnet workload install maui` (with elevation where the SDK directory is not user-writable; on macOS with the official installer, `sudo $(which dotnet) workload install maui`). In `detect`, `doctor` and `report`, report that and nothing more (in `doctor`, it also means the optional build at D4 cannot run). In `integrate` and `verify`, warn and get explicit confirmation; if the user declines, stop (early-exit report). When warning, say plainly that on MAUI neither `dotnet restore` nor `dotnet build` can run: continuing means a text-only install, with the `PackageReference` added by hand per `references/maui.md`'s fallback and nothing compiled until the workload is installed. `NETSDK1147` may also name `maui-tizen` for a `net*.0`-only shared library; installing `maui` covers it.

## Phase 2: Confirm the platform reference exists

Read `references/<platform>.md` now, in full. This is the **only** read of it for the whole run: Phases 3 and 6 reuse it. Never read another platform's reference.

If it is missing, **stop** (early-exit report) and say this platform's reference is missing from this copy of the skill. Do not invent install steps from general knowledge of the SDK. Nothing has been created, so nothing needs cleaning up.

## Phase 3: Already-installed gate

Check the reference's **Existing Install Indicators** against the repo. If **any** matches: in `detect`, record it and continue to Phase 4, and render it in the normal detect report with the indicator list, not as an early exit ("is Pendo already installed?" is a question `detect` exists to answer). In `integrate` and `verify`, **stop** (early-exit report), change nothing, and report what was found and in which file.

**In `doctor` this gate is inverted.** An install is what doctor needs. If no indicator matched, go to Phase 8 and render the doctor "not installed" report, which points to `--mode integrate`. Otherwise classify the match (below), carry the state through Phase 4, then follow `references/doctor.md`. A partial install is doctor's main case, not a stop.

**In `report`, no install is not a stop.** Record the state (`complete`, `partial`, or not installed), carry it through Phase 4, then follow `references/report.md`. The report says Pendo is not installed and runs only doctor's `REQ` check.

Re-running `integrate` or `verify` on an instrumented repo must be a no-op: it must never duplicate a `setup()` call, overwrite a working configuration, or "fix" something that was not broken. **`setup()` is call-once-only on every platform**, so a second call in a partly instrumented repo is a real bug, not a harmless repeat.

**Classify the match into exactly one of two states, and carry the state into the report.** The test is whether the platform's own initialization call is present. Take its spelling from the reference, case-sensitively, and **never grep a bare `setup(`**: `PendoManager.shared().setup(` on iOS, `Pendo.setup(` on Android, `PendoSDK.setup(` on React Native, Expo and Flutter, and on **MAUI** the `.Setup(` call on the `IPendoService` that `PendoServiceFactory.CreatePendoService()` returns: **capital `S`**, the one platform that does not spell it lowercase. A lowercase search reports a fully wired MAUI app as partial. MAUI's indicator table names `PendoServiceFactory.CreatePendoService(`, not the init call: the factory call alone is not the marker.

**The init call can go through the app's own code.** An app may call it on a wrapper protocol the SDK type conforms to, on an injected instance, or through a type alias (Flutter's `PendoFlutterPlugin` is an alias of `PendoSDK`). That counts as the init call when the code shows the receiver is the SDK: the conformance (`extension PendoManager: PendoManagerWrapper`), the instance passed in (`PendoManager.shared()`), or the alias. Name the wrapper and the file that proves it in the report. A `setup(` on a receiver you cannot trace to the SDK does not count.

1. **Complete** — the initialization call is present. It is the marker: nothing else runs without it. Report the repo as instrumented, with nothing for this skill to add. If `startSession` or the deep-link scheme is missing, name that as remaining work for the developer; it does not make the repo installable here, because re-running would duplicate the initialization call.
2. **Partial** — something matched and **the initialization call exists nowhere**. Everything else counts: a dependency, Maven repository, plugin entry, URL scheme or manifest activity; an SDK `import`/`using`/`require` nothing calls; and a `startSession` call or deep-link handler with no initialization behind it, which is dead code. Pendo is in the build and not running, so **no analytics flow**. Name which pieces are present and which are missing, and give the ways forward: `--mode doctor` to finish the wiring through fixes the user picks, finish it by hand against Pendo's guide for this platform (https://github.com/pendo-io/pendo-mobile-sdk), or revert the partial install and re-run this skill on a clean tree.

**"Already instrumented — nothing to do" is true of `complete` only.** Said about a partial install, it guarantees nobody finishes the job.

**Identify an existing install of either generation, 2.x or 3.x, and stop. Never upgrade one.** The indicator tables are deliberately generation-agnostic: `references/android.md` carries the legacy `io.pendo:pendo-android-sdk` coordinate so a 2.x install trips this gate instead of getting 3.x installed on top. Where the generation is visible without extra work (a coordinate, a pinned version), name it in the report. `integrate` and `verify` have no upgrade path: do not offer one, write one, or route the user to one. `doctor` reports a 2.x install as a manual finding, offers no version bump on it, and offers minor bumps within 3.x only; it never crosses a major version.

## Phase 4: Requirements check (Global Constraints)

Compare the repo's versions against these router-level minimums. The platform reference may check more.

| Platform | Minimum |
|---|---|
| `ios` | `IPHONEOS_DEPLOYMENT_TARGET` ≥ **11.0** |
| `android` | `minSdkVersion` ≥ **21**, `compileSdkVersion` ≥ **35** (report-only), AGP ≥ **8.0** (hard stop), Kotlin ≥ **1.9.0**, Java ≥ **11** (report-only, read as `sourceCompatibility`) |
| `react-native` | `react-native` **0.66–0.84**, plus both native minimums above |
| `expo` | Expo SDK **41–56**, plus both native minimums above. **Expo Go cannot run Pendo; a development build is required.** |
| `flutter` | Flutter ≥ **3.16.0**, Dart ≥ **3.2.0**, plus the Android native minimum above |
| `maui` | **.NET 8–10**, read from the application head's `TargetFrameworks`. Kotlin ≥ 1.9.0 for the Android head: **outcome 4, not applicable** (below). |

**The MAUI application head** is the `.csproj` with both `<UseMaui>true</UseMaui>` **and** an executable `<OutputType>` (`Exe` or `WinExe`, possibly with a per-TFM `Condition`), the same markers `scripts/verify-build.sh`'s `find_maui_head_project()` uses, so this phase and Phase 7 read the same project. `UseMaui` alone is not enough: MAUI class libraries set it too. If no project has both, say the head could not be identified and treat the .NET row as indeterminate.

**MAUI's Kotlin floor is not applicable.** A MAUI repo has no Kotlin or Gradle files; the Android head builds against Pendo's prebuilt `pendo-maui-binding-android` AAR, whose Kotlin is fixed inside it. Report it as satisfied by the binding. Do not look for a `*.gradle` file, and do not treat its absence as a mismatch.

**Flutter's iOS floor** is not restated in Pendo's Flutter docs. The 11.0 minimum almost certainly applies (same native SDK), but it is inherited by implication, not sourced.

### The four outcomes of a constraint check

Every row resolves to exactly one of these. **"Assume it passes" is not one of them.**

1. **Pass** — read from the repo and meets the constraint.
2. **Mismatch** — read and does not meet it. Hard stop for AGP, report-only for `compileSdkVersion` and Java, report-and-ask for everything else (below).
3. **Indeterminate** — could not be read without writing to the repo, or is not declared anywhere. **Not a stop, and not a pass**: unknown is not unsupported. Continue, and report the constraint as **unverified** under "Requires your attention", with why it could not be read and where the developer can check it. In `verify`, Phase 7's build is the backstop: if a head fails, the unverified constraints are the first suspects, and the report says so. In `detect` and `integrate` there is no backstop: say so, and name `--mode verify` as the way to close it.
4. **Not applicable** — the value cannot exist in this repo shape (managed Expo's native minimums, MAUI's Kotlin floor). Report it as not applicable, never in silence.

### Which value each constraint reads

- **Java ≥ 11** → the Android module's `compileOptions { sourceCompatibility }` (with the `targetCompatibility` and `kotlinOptions.jvmTarget` that move with it). **Not the JDK running Gradle**; the two often disagree (a real Flutter app declares `VERSION_1_8` while building under JDK 17). No `compileOptions` in the app module means AGP's default applies: indeterminate, not a pass. Pendo documents only "JAVA version 11 or higher" (`android/pnddocs/native-android.md`); reading it as `sourceCompatibility` is this skill's choice, because that value is what Gradle compares against a published AAR.
- **iOS deployment target** → `IPHONEOS_DEPLOYMENT_TARGET` in the **app target's** build configurations in `project.pbxproj`: the app's own `.xcodeproj` on `ios`, the one under `ios/` on `react-native`, prebuilt `expo` and `flutter`. A target-level value overrides the project-level one. A value set in the `.xcconfig` that a configuration's `baseConfigurationReference` names is read from that file. When the configurations differ (Debug and Release), compare the **lowest**: the floor must hold for each. **Not the Podfile's `platform :ios`**: that sets the pods' target, not the app's. With XcodeGen or Tuist and no committed `.xcodeproj`, read `deploymentTarget` from `project.yml` (the app target's own value wins over the top-level `options.deploymentTarget`) or `deploymentTargets` from `Project.swift`. No committed `.xcodeproj` and no such manifest, or a value that stays unresolved (`$(inherited)` with nothing behind it, another build variable) → indeterminate; name a Podfile value only as a hint.
- **AGP ≥ 8.0** → the Android Gradle Plugin version the build resolves. Not the Gradle wrapper version, which is only a fallback inference (below).

### Where these values live, per framework

Pendo's docs point every framework at a raw `android { minSdkVersion 21; compileSdkVersion 35 }` in the root `android/build.gradle`, which is not where stock React Native or Flutter projects keep them. Resolve them here; anything you cannot reach is **indeterminate**.

| Framework | Value | Where it is |
|---|---|---|
| `react-native` | AGP | `android/build.gradle` usually declares `classpath("com.android.tools.build:gradle")` **with no version**. The version comes through `android/settings.gradle`'s `includeBuild('../node_modules/@react-native/gradle-plugin')`, pinned in `node_modules/@react-native/gradle-plugin/gradle/libs.versions.toml` as `agp = "…"`. |
| `flutter` | AGP | `android/settings.gradle`'s `plugins { id "com.android.application" version "…" apply false }`, or a legacy `classpath` in `android/build.gradle`. |
| `flutter` | `compileSdkVersion`, `minSdkVersion` | `android/app/build.gradle` reads `flutter.compileSdkVersion` / `flutter.minSdkVersion`; the numbers are defaults inside the installed Flutter SDK, not in the repo. |
| `expo` / `managed` | every Android value | Not applicable (below). |

**Read `node_modules/` or the Flutter SDK only if already present. Never install anything to resolve a Phase 4 value.** An install is not a neutral read: on a real React Native app it wrote about 1.1 GB, and a `postinstall` hook rewrote committed files (`ios/Podfile.lock`, `project.pbxproj`), dirtying the tree Phase 0 protects. A value you would have to write to obtain is indeterminate.

**Managed Expo: only the Expo SDK row applies.** AGP, Kotlin, Java, `minSdkVersion`, `compileSdkVersion` and `IPHONEOS_DEPLOYMENT_TARGET` do not exist in a managed repo (Expo derives them at prebuild), so do not look for them, and state in the report that they were not applicable. **The AGP hard stop does not fire on managed Expo.** On `prebuilt`, the values are in the committed native projects and every row is checked.

**AGP below 8.0 is a hard stop, not an ask**, on every platform whose AGP exists in the repo (`android`, `react-native`, `flutter`, prebuilt `expo`). Pendo requires AGP 8.0+, and AGP 8.0 requires Gradle ≥ 8.0. Below that, the install risks a Gradle file that fails to parse or a toolchain the SDK does not support, found only after this skill reported success. If AGP is **read** and is below 8.0, **stop** (early-exit report) without asking, and say the project's Android Gradle Plugin must be upgraded to 8.0+ first. **In `detect` this is the verdict, not a stop**: report **cannot install — AGP below 8.0** with the version and the file it came from, and keep the rest of the report.

**When AGP cannot be read, do not stop, and do not wave it through.** This is common on React Native. Fall back to the Gradle wrapper, `gradle/wrapper/gradle-wrapper.properties` under the Android directory (`android/` for `react-native`/`expo`/`flutter`, the repo root for `android`), which is always committed:

- **Wrapper Gradle below 8.0** → AGP is necessarily below 8.0. Treat it exactly as a read AGP below 8.0, in every mode, and say the stop (or `detect` verdict) was inferred from the wrapper because AGP was unreadable.
- **Wrapper Gradle 8.0 or above** → AGP stays **unverified** (Gradle 8 does not imply AGP 8), and the run continues. It does confirm the Gradle ≥ 6.2 that the `exclusiveContent` block in `references/android.md` §2 needs to parse.
- **Wrapper unreadable too** → both unverified; continue and report both. Name the risk: on Gradle below 6.2 the `exclusiveContent` block fails to parse, which a `verify` run surfaces as an Android head failure and an `integrate` run leaves for the developer to hit. Say which applies.

Pendo states no Gradle requirement anywhere; the Gradle floors above are Android/Gradle facts (AGP 8.0 needs Gradle 8.0; `exclusiveContent` arrived in Gradle 6.2).

**`compileSdkVersion` and Java `sourceCompatibility` are reported, never asked.** They are the app's own build settings, and `references/android.md` forbids this skill from changing them, so a prompt has no branch that behaves differently, while it would fire on nearly every React Native and Flutter app (RN 0.74's template ships `compileSdkVersion 34`; `flutter create` ships `VERSION_1_8`). When one falls short, list it under "Requires your attention" with the file and property to raise, and Pendo's floors (`compileSDKVersion 35`, `JAVA version 11`, `android/pnddocs/native-android.md`). Do not prompt, stop or omit it. In `verify`, Phase 7's build surfaces a real incompatibility concretely; in `integrate` the remedy line is all the developer gets, so write it carefully.

**Every other row is report-and-ask**: Kotlin, `minSdkVersion`, `IPHONEOS_DEPLOYMENT_TARGET`, and the bounded ranges (`react-native` 0.66–0.84, Expo SDK 41–56, the Flutter/Dart floors, .NET 8–10). A value below a floor, **above a bounded range's ceiling**, or below any sub-value of a multi-value row is a mismatch: **report it and ask whether to continue. Never skip silently.** If the user declines, **stop** (early-exit report). **In `detect`, report the mismatch and do not ask**: it goes in the requirements list and sets `Can install` to no, with the value read and the floor it missed. **`doctor` treats every row as `detect` does** and passes the outcomes to `references/doctor.md` as `REQ` findings. `report` does the same.

Whatever the outcome, every row reaches the user: a mismatch as a stop or an ask, report-only and indeterminate rows under "Requires your attention", a not-applicable row named as such. **A constraint that goes unmentioned is the one forbidden outcome**, including one never actually resolved.

## Phases 5–7: Install and build

**`detect`, `doctor` and `report` never enter these phases.** `detect` goes to Phase 8 and renders the detect report; `doctor` goes to `references/doctor.md`, which has its own branch step at D4; `report` goes to `references/report.md`. Do not ask for a key or scheme and do not create a branch. If `--api-key` or `--scheme` were passed, `detect` and `report` leave them unused and say so in the report; `doctor` keeps them for D4.

In `integrate` and `verify`, run Phases 5, 6 and 7 as `references/integrate.md` says: credentials and branch, the platform reference's install steps, and (in `verify`) the build. Phase 7 runs in `verify` only, plus `doctor` when the user asks for the build at D4.

## Phase 8: Report

Every report states its mode on its first line. Except in `report`, which renders `references/report.md`'s template, read `references/reports.md` now and render exactly one template: `## Detect report` in `detect`, `## Install report` on a completed `integrate` or `verify` run, `## Early-exit report` on any stop. In `doctor`, use the templates in `references/doctor.md` instead: D2 for the analysis and the "not installed" case, D4 for applied fixes. A doctor stop before D2 (Phase 2's missing reference) uses `## Early-exit report`. In `report`, use the template in `references/report.md` instead; only a stop before R2 (the same missing reference) uses `## Early-exit report` from `references/reports.md`.

## Constraints

- **Never write a placeholder visitor or account identifier. This one is absolute.** Not `"user123"`, not `"YOUR_VISITOR_ID"`, not a value invented to make the install look complete. `startSession("user123", ...)` compiles, runs, reports success, and sends made-up visitors into the customer's subscription forever; nothing downstream catches it and the data cannot be un-sent. With no real identifier, write `setup()` and **no `startSession` call at all** (not commented out, not with fake arguments), and report it. See `references/identity.md`. This is the most important rule in this skill.
- **Never invent an API key or URL scheme, and do not stop for a missing one.** A placeholder credential means no data flows and one string edit fixes it, a far smaller failure than the rule above. Phase 5 writes `YOUR_API_KEY_HERE` / `YOUR_SCHEME_ID_HERE` and the run completes. A *plausible* fake remains forbidden.
- **`doctor` only reads until the user picks fixes.** Its analysis never asks for a credential, never creates a branch and never writes. D4 writes only the picked fixes, only on a clean tree, only on a new `pendo-doctor-<platform>` branch.
- **A doctor fix never crosses a major SDK version and never invents a value.** Identity fixes follow `references/identity.md` exactly; with no real identifier, the fix removes the session call.
- **`report` never shows or saves anything that `scripts/redact_report.py` has not processed**, and it never contains an API key, a credential, or a real visitor or account value. It writes only `pendo-support-report.md` and `pendo-support-report.json`, only after the user says yes, and never stages or commits them.
- **`detect` never asks for a credential and never writes.** If a `detect` run finds itself wanting a key, a scheme, a branch or an edit, it has left its mode: stop and say so.
- In `integrate` and `verify`, never ask for credentials or create a branch before Phase 5; every earlier phase must stay read-only. In `doctor`, the same holds until D4. `report` never asks for a credential or creates a branch.
- Never read more than one `references/<platform>.md` in a run. (`integrate.md`, `doctor.md`, `report.md`, `identity.md`, `detection.md` and `reports.md` are not platform references.)
- Never guess a `subPlatform` when the signals are absent or contradict each other: ask.
- Never silently downgrade or skip a Phase 4 mismatch, below a floor or above a bounded ceiling: ask. **Except: AGP below 8.0 is a hard stop, and `compileSdkVersion` and Java `sourceCompatibility` are reported, not asked.** A value that cannot exist in this repo shape (managed Expo's native-head minimums, MAUI's Kotlin floor) is "not applicable", not "skipped", and is reported.
- **Never treat an unreadable Phase 4 value as passing.** It is indeterminate: report it as unverified and continue, unless a sound inference proves a violation (a Gradle wrapper below 8.0 proves AGP below 8.0). Never write to the repo, including installing dependencies, to resolve one.
