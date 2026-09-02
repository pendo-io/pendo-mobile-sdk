# Expo — Pendo Mobile SDK Install

Entered from `SKILL.md` Phase 2 (read once, in full) and executed from Phase 6, with `apiKey`, `urlScheme`, `platform="expo"`, `subPlatform` (`managed` | `prebuilt`), and `branchName` already resolved and in scope — never re-ask for them, never re-run detection.

Wherever a snippet below shows `<apiKey>` or `<urlScheme>`, that is a template slot: write the real, already-resolved value in its place; never write the literal angle-bracket token into a file.

This file is self-contained. `SKILL.md`'s phase contract permits reading exactly **one** `references/<platform>.md` per run, so nothing below ever tells you to open `references/react-native.md`, `references/android.md`, or `references/ios.md` — everything those files would contribute is restated here. `references/identity.md` is the one exception, and it is not a platform reference: it is shared, and the **Visitor identity** section below directs you to it.

---

## 0. `managed` vs `prebuilt` — read this before anything else

Almost every difference in this file follows from this one axis. Find your row and stay in it; the other row's instructions are wrong for you.

| | `subPlatform = managed` | `subPlatform = prebuilt` |
|---|---|---|
| `ios/` and `android/` on disk | absent | present **and tracked by git** |
| Who owns native config | `npx expo prebuild` regenerates it from the app config | the developer, by hand |
| Does this install edit native files? | **No — never** | **Yes — required, or the Android build breaks** |
| Steps to run | 1 – 5 | 1 – 6 |
| What makes Pendo's native side real | the next `npx expo prebuild` / `expo run:*` / EAS build | steps 6a – 6c, right now |

**Sanity-check the value you were handed.** `ios/`/`android/` present but **untracked or gitignored** means they are leftover `expo prebuild` output, not developer-maintained sources — that repo is really `managed`, and treating it as `prebuilt` makes you hand-edit throwaway directories and read a prior run's plugin output as evidence of an install. Confirm with `git ls-files ios android | head -1`: empty output on directories that exist ⇒ managed, and say so in the Phase 8 report. If the check contradicts the `subPlatform` you were given, stop and ask rather than guessing.

### `managed`: do NOT edit native files

There are no native files to edit — `ios/` and `android/` do not exist. If a prebuild ever generates them, everything in them is derived from the app config, so a hand edit made outside the config plugin is discarded or collides at the next prebuild. On `managed`, this install touches only:

- `package.json` (+ its lockfile)
- the app config file (`app.config.ts` / `app.config.js` / `app.json`)
- `metro.config.js`
- JS/TS source files

Do not run `npx expo prebuild` as part of a `managed` install, and do not treat it as an implicit part of one. Generating `ios/`/`android/` changes the repo's on-disk shape — and because managed templates gitignore both directories, `git checkout` and `git reset --hard` will not remove them again, so the next run of this skill sees a `prebuilt` repo that no `prebuild` of the developer's ever created.

### `prebuilt`: you MUST edit native files

The prohibition above does **not** apply here, and applying it is what produces a broken install. In a `prebuilt` repo the native directories are committed and the developer maintains them by hand — that is the entire reason the repo left `managed`. Editing them is the normal workflow for this project shape, exactly as a bare React Native or a native Android/iOS repo is edited.

Concretely, on `prebuilt` the config plugin has **not run** against the committed native projects and will not run during this install, so the native configuration it would have produced is simply absent. One piece of that is not cosmetic:

> React Native's autolinking wires `rn-pendo-sdk` into the Gradle build **the moment step 1 installs the package** — no prebuild involved. `node_modules/rn-pendo-sdk/android/build.gradle` declares `implementation 'sdk.pendo.io:pendoIO:3.13.+'`, and that coordinate is served only by Pendo's own Maven repository. Nothing else in the project declares that repository, so `./gradlew assembleDebug` fails at dependency resolution:
>
> ```
> Could not find any matches for sdk.pendo.io:pendoIO:3.13.+ as no versions of sdk.pendo.io:pendoIO are available.
> Required by:
>     project :app > project :rn-pendo-sdk
> ```
>
> The module's own `repositories { }` block does list Pendo's Artifactory, and it does not help: autolinking includes `rn-pendo-sdk` as a **project** dependency of `:app`, and a project dependency's external coordinates resolve against the **consumer's** repositories (`:app:debugRuntimeClasspath`), not the producer's. The root project's `allprojects { repositories { … } }` — or `settings.gradle`'s `dependencyResolutionManagement`, whichever this repo uses — is the only place that fixes it. (Reproduced on a real prebuilt Expo SDK 51 app: identical trees, with and without step 6a; without it the build fails with the error above, with it `BUILD SUCCESSFUL`.)

So on `prebuilt`, **step 6 is not optional and not a follow-up** — it is part of the install.

The line this file draws: hand-edit native **text configuration** (`android/build.gradle`, `AndroidManifest.xml`, `Info.plist`) the same way a native repo does; do **not** hand-mutate the Xcode project structure (`project.pbxproj`) to add source files. Step 6d covers the one thing that falls on the far side of that line.

Phase 7's `scripts/verify-build.sh` runs `pod install` on a `prebuilt` repo's `ios/` directory, which rewrites `ios/Podfile.lock` and `ios/<App>.xcodeproj/project.pbxproj`. On `prebuilt` that is expected and permitted — same rule as above — and both files must reach the developer in the Phase 8 report so they are not surprised by them in `git status`. They belong under **`### Files the build touched`**, not `### Files changed`: this reference never edits them, Phase 7's `pod install` does, and `SKILL.md`'s phase contract reserves the handback list for this file's *own* edits. Do not add them to the handback.

### Expo Go cannot run Pendo — on **both** sub-platforms

Verbatim: *"Expo Go is not supported. Pendo SDK has a native plugin that is not part of the Expo Go app. Pendo can only be used in development builds."* Source: `ios/pnddocs/expo_rn-ios.md`, `android/pnddocs/expo_rn-android.md`, `ios/pnddocs/expo_router-ios.md` (identical wording in all three navigation-flavor docs).

This is a workflow-ending fact for exactly the developers most likely to be on `managed`, so it is a **mandatory** entry in Phase 8's "Requires your attention" section for **every** Expo dispatch, `managed` and `prebuilt` alike — never optional, never omitted. Emit it verbatim:

> **Expo Go can no longer run this app.** Pendo ships native code that the Expo Go client does not bundle, so Expo Go is not supported at all. Use a development build instead — `npx expo run:ios` / `npx expo run:android`, or an EAS development build.

**Scope check**: this file assumes the repo's Expo SDK version already passed `SKILL.md` Phase 4's **bounded range 41–56** (a floor *and* a ceiling). Nothing below re-derives that check.

---

## Existing Install Indicators

Phase 3 stops the whole run if **any** of these is found. Every one of them is evidence that a *complete* install already happened — not merely that someone once started one.

- `PendoSDK.setup(` anywhere in the source
- `PendoSDK.startSession(` anywhere in the source
- `import { PendoSDK }`, `import { WithPendoExpoRouter }`, `import { WithPendoReactNavigation }`, or any other `WithPendo*` symbol from `rn-pendo-sdk`, in a JS/TS source file
- `require('rn-pendo-sdk')` in a JS/TS source file
- An **array-form** plugin entry — `["rn-pendo-sdk", { … }]` carrying `ios-scheme` / `android-scheme` — in the `plugins` array of `app.config.ts` / `app.config.js` / `app.json`
- **`prebuilt` only**, in the *committed* native directories: the Pendo Maven URL `https://software.mobile.pendo.io/artifactory/androidx-release` in `android/build.gradle` or `android/settings.gradle`; `PendoGateActivity` in `android/app/src/main/AndroidManifest.xml`; or a `CFBundleURLName` of `pendo-pairing` in the app target's `Info.plist`

### What is NOT an indicator

`npx expo install rn-pendo-sdk` — step 1 below — produces **both** of the following on its own, before a single line of this install's real work has happened:

1. `rn-pendo-sdk` in `package.json` `dependencies`
2. a **bare-string** `"rn-pendo-sdk"` entry in the `plugins` array (on static configs — see step 1)

A repo in that state has no `setup()`, no scheme, no Metro config, no native wiring, and — on a static config — cannot even resolve its own app config (see step 2). Treating either as "already instrumented" reports a no-op over a half-finished, non-building install, which is the opposite of what Phase 3's gate is for.

So: **neither of those two is an indicator.** If you find them and find none of the real indicators above, this is an interrupted run. Do not stop; say so plainly in the report, skip the parts of step 1 that already happened, and continue from step 2.

---

## Step 1 — Dependency (`managed` and `prebuilt`)

```shell
npx expo install rn-pendo-sdk
```

Same npm package as bare React Native (`rn-pendo-sdk`) — there is no separate Expo-specific package. Source: `ios/pnddocs/expo_rn-ios.md` (and the `expo_rnn-*` / `expo_router-*` and Android equivalents). `expo install` rather than a plain `yarn add`/`npm install` is the Expo-idiomatic command: it resolves a version compatible with the project's installed Expo SDK and uses whichever package manager the project already uses.

**No version number is pinned anywhere in the upstream docs for `rn-pendo-sdk` — do not invent one.** Record whatever version the command resolved, and report that.

Two behaviours of this command are not obvious and both have bitten real installs:

**It also writes a config-plugin entry, by itself.** `expo install` runs Expo CLI's auto-plugin step, which appends a **bare-string** `"rn-pendo-sdk"` to the `plugins` array:

```
› Added config plugin: rn-pendo-sdk
```
```json
"plugins": ["expo-router", "rn-pendo-sdk"]
```

That entry is **not a valid Pendo configuration** — Pendo's plugin throws without props — so from this moment until step 2 finishes, the project's app config does not resolve at all. Step 2 fixes it. Do not stop here, and do not leave the run half-done at this point.

**On a dynamic config it exits 1 while fully succeeding.** With `app.config.ts` / `app.config.js`, Expo CLI cannot write the entry, so it prints instructions and exits **1** — after the package has been installed correctly:

```
dependencies:
+ rn-pendo-sdk ^3.13.3

Cannot automatically write to dynamic config at: app.config.ts
Add the following to your Expo config
{ "plugins": ["rn-pendo-sdk"] }
```

**Do not treat that exit code as a failure.** Confirm `rn-pendo-sdk` is present in `package.json` `dependencies`; if it is, the step succeeded — continue to step 2. (The `{ "plugins": ["rn-pendo-sdk"] }` snippet Expo prints is the bare-string form, not the form Pendo requires; ignore it and use step 2's.)

---

## Step 2 — Config plugin entry (`managed` and `prebuilt`)

Expo declares the SDK's native configuration through a config plugin entry. The required form carries both scheme properties:

```json
["rn-pendo-sdk", { "ios-scheme": "<urlScheme>", "android-scheme": "<urlScheme>" }]
```

Source: `ios/pnddocs/expo_rn-ios.md`. Substitute the `urlScheme` resolved in Phase 5 into both properties (the same value for both, unless the user separately specified distinct iOS/Android schemes) — never a value of your own invention, and never the bare `urlScheme` token. Where Phase 5 resolved the declared placeholder `YOUR_SCHEME_ID_HERE` (the user had no scheme to hand), write that into both properties like any other value: the config must still be structurally complete, and the router is what reports the install as needing the scheme replaced.

### Upgrade the existing entry in place — never append a second one

Step 1 has, on a static config, **already put an `rn-pendo-sdk` entry in the `plugins` array**. The rule is therefore:

1. Search `plugins` for any entry naming `rn-pendo-sdk` — either the bare string `"rn-pendo-sdk"` or an array whose first element is `"rn-pendo-sdk"`.
2. If one exists, **replace it in place** with the array form above.
3. Only if none exists, append the array form.
4. Never end up with two `rn-pendo-sdk` entries. Both entries are evaluated, the bare one still has no props, and the config still throws — appending alongside the auto-added entry fixes nothing.

**Merge, don't replace**, as everywhere else in this install: keep every other entry in `plugins`, and every other top-level key in the config, untouched.

**File search order** — edit the first of these that exists; create `app.json` if none do:

1. `app.config.ts`
2. `app.config.js`
3. `app.json` — the array lives under the top-level `"expo"` key, i.e. `expo.plugins`

The upstream docs show the plugin entry landing in `app.config.js` / `app.json`; `app.config.ts` is the standard modern variant of the same file and is listed first for that reason, not as a separately upstream-confirmed location.

On a **dynamic** config (`app.config.ts` / `.js`) step 1 wrote nothing, so there is usually no entry to upgrade — but check anyway before appending, because the developer may have added one by hand.

### Verify before moving on

```shell
npx expo config --type prebuild
```

This must exit **0**, and the resolved `plugins` array must show the array-form entry carrying **both scheme props, holding whatever value Phase 5 resolved** — the real scheme, or the declared placeholder `YOUR_SCHEME_ID_HERE` when the user had none. What this check is for is the *shape* of the entry: the plugin throws on a bare-string entry or a missing prop, and a placeholder satisfies neither of those failure conditions. **A placeholder scheme is not a verification failure here** — do not treat it as one, and do not block on it; the router reports it as an install needing the scheme replaced. If it exits 1 with

```
Error: Pendo plugin props are required
```

then a bare-string entry is still present somewhere in `plugins` — go back to rule 1. (Pendo's plugin also throws `Pendo plugin requires "ios-scheme" prop` / `… "android-scheme" prop` if one of the two is missing.) Until this command exits 0, `expo prebuild`, `expo run:ios`, `expo run:android` and every EAS build are broken, so do not proceed past this point with a failing config.

*Optional, not part of the default install*: the same block accepts `"ios-use-spm": true` to opt the iOS head into Swift Package Manager instead of Expo's CocoaPods default. Source: `ios/pnddocs/expo_rn-ios.md`. Do not add it unless the user explicitly asks for SPM.

---

## Step 3 — Metro configuration, mandatory (`managed` and `prebuilt`)

**This is not optional.** React Native's production minifier strips component names by default, and Pendo's codeless tagging identifies UI elements by those names — mangled output breaks codeless tagging entirely. The requirement is identical for Expo apps, applied in the app's own Metro config. Source: `ios/pnddocs/expo_rn-ios.md` ("Same Metro `keep_classnames`/`keep_fnames` requirement as bare RN, applied in the Expo app's `metro.config.js`").

The corpus-confirmed settings, to end up under `transformer.minifierConfig`:

```javascript
minifierConfig: {
    keep_classnames: true,
    keep_fnames: true,
    mangle: {
        keep_classnames: true,
        keep_fnames: true,
    }
}
```

**Search order**: `metro.config.ts` → `metro.config.js`; create `metro.config.js` if neither exists (standard Metro/Expo tooling convention, not a Pendo fact — unlike the block above, which is upstream-sourced).

### Merge rule — mutate the config object, never re-assign `module.exports`

An Expo `metro.config.js` almost always ends by exporting the result of a **wrapper**: NativeWind, uniwind, Sentry, Reanimated and Expo Router templates all do this. Overwriting the export drops the wrapper and silently breaks whatever it provided (styling, source maps, …) while the build still succeeds — the worst kind of regression.

So: find where the config object is created (`getDefaultConfig(__dirname)`), set `minifierConfig` on it, and **leave the file's existing `module.exports` line exactly as it is**.

Plain config (no wrapper):

```javascript
const { getDefaultConfig } = require('expo/metro-config');

const config = getDefaultConfig(__dirname);

config.transformer.minifierConfig = {
    ...config.transformer.minifierConfig,
    keep_classnames: true,
    keep_fnames: true,
    mangle: {
        ...config.transformer.minifierConfig?.mangle,
        keep_classnames: true,
        keep_fnames: true,
    },
};

module.exports = config;      // ← unchanged from what was already there
```

Wrapped config — the common case. Only the middle block is added; the wrapper call is untouched:

```javascript
const { getDefaultConfig } = require('expo/metro-config');
const { withSomeWrapper } = require('some-package/metro');

const config = getDefaultConfig(__dirname);

config.transformer.minifierConfig = {
    ...config.transformer.minifierConfig,
    keep_classnames: true,
    keep_fnames: true,
    mangle: {
        ...config.transformer.minifierConfig?.mangle,
        keep_classnames: true,
        keep_fnames: true,
    },
};

module.exports = withSomeWrapper(config, { /* existing options, unchanged */ });
```

(`expo/metro-config` does not export `mergeConfig`, which is why this merges by spreading rather than by a merge helper.)

---

## Step 4 — `setup()` and navigation (`managed` and `prebuilt`)

**Setup is navigation-library-dependent.** `PendoSDK.setup(appKey, navigationOptions, pendoOptions?)` takes a `NavigationOptions(library: NavigationLibraryType, navigation?: any)`. Source: `api-documentation/rn-apis.md`.

**`NavigationLibraryType` ships six members, of which five are choices you may pass.** The API reference documents exactly five options — `ReactNativeNavigation`, `ReactNavigation`, `ExpoRouter`, `Paper`, `Other` (`api-documentation/rn-apis.md`) — while the enum shipped in `rn-pendo-sdk`'s own `index.d.ts` has a sixth member, `NoPluginDetected = 0`, which the docs do not list and which is not a value to pass to `setup()`. Two consequences: never select `NoPluginDetected`, and never rely on ordinal position — the declared values are not sequential (`ReactNativeNavigation = 1`, `ReactNavigation = 2`, `Other = 3`, `ExpoRouter = 5`, `Paper = 6`). Always refer to members by name.

Of the five documented choices, Expo's own guides use three: `ReactNavigation`, `ReactNativeNavigation` (with `navigation: Navigation`), and `ExpoRouter` (source: `ios/pnddocs/expo_rn-ios.md`, `expo_rnn-ios.md`, `expo_router-ios.md`). `Paper` and `Other` appear only in the shared API reference, but the enum and the wrappers are the same either way.

> **[!IMPORTANT]** "The `setup` API must be called before the `startSession`, `WithPendoReactNavigation`, `WithPendoExpoRouter`, `WithPendoPaper` and `WithPendoModal` APIs. All other APIs must be called after both the `setup` and `startSession` APIs, otherwise they will be ignored." Source: `api-documentation/rn-apis.md`.

| Library | `setup()` call | Wrapper |
|---|---|---|
| Expo Router | `PendoSDK.setup('<apiKey>', {library: NavigationLibraryType.ExpoRouter})` | `WithPendoExpoRouter(RootLayout)` — see below |
| React Navigation | `PendoSDK.setup('<apiKey>', {library: NavigationLibraryType.ReactNavigation})` | `const PendoNavigationContainer = WithPendoReactNavigation(NavigationContainer);` then replace `<NavigationContainer>` in JSX with `<PendoNavigationContainer>` |
| React Native Navigation (Wix) | `PendoSDK.setup('<apiKey>', {library: NavigationLibraryType.ReactNativeNavigation, navigation: Navigation})` | none — RNN has no wrapper component; its own `Navigation` object goes into `setup()` instead |
| React Native Paper (`BottomNavigation` only) | reuse whichever stack library's `setup()` call above is already configured — Paper is **additive**, not a `library` choice of its own | `const PendoBottomNavigation = WithPendoPaper(BottomNavigation);` |
| Other / unknown | `PendoSDK.setup('<apiKey>', {library: NavigationLibraryType.Other})` | none — codeless screen tracking is not guaranteed for this app |

`<apiKey>` is the Pendo integration key resolved in Phase 5 — write that resolved value as the string content, never one of your own invention and never the bare angle-bracket token. If Phase 5 resolved it to the declared placeholder `YOUR_API_KEY_HERE` because the user did not have a key to hand, write that verbatim and complete every step as normal; the router reports it as a placeholder install.

### Placement

**`setup()` is call-once-only for the application lifecycle** — "`setup` can only be called once during the application lifecycle" (`api-documentation/rn-apis.md`). For an Expo Router app, a root `app/_layout.tsx` plus nested `_layout.tsx` files are all plausible-looking homes for Pendo wiring; `setup()` belongs in exactly one of them — the **root** layout. For a React Navigation app it goes in the app's main entry file (`App.tsx`/`App.js`).

It goes at **module level**, before any navigation container renders — **never inside `useEffect`**. That follows directly from the ordering requirement quoted above: the `WithPendo*` wrapper calls run at module-evaluation time, before any component renders, and `setup()` must run before every one of them or they are silently ignored.

`startSession` is called wherever the visitor is actually identified — see **Visitor identity** below.

### Expo Router: wrapping the root layout

The contract is corpus-confirmed (`ios/pnddocs/expo_router-ios.md`): the wrapped component receives an `onExpoRouterStateChange` prop and must call it with the current `usePathname()` / `useGlobalSearchParams()` values whenever they change. The code below is one correct way to implement that contract, not a verbatim upstream sample.

**Merge rule — this section edits the app's root layout, the single most destructive file in the repo to get wrong. Follow all five:**

1. **Keep the existing component body and its `return` exactly as they are.** The wrapped component still renders the entire app; a root layout that returns nothing renders a blank app. TypeScript will not catch this — `ReactNode` admits `undefined`.
2. Add only three things inside the component: the `usePathname()` call, the `useGlobalSearchParams()` call, and the `useEffect` that forwards them. Put them above the existing body.
3. If the file currently reads `export default function RootLayout() {`, convert it to a plain `function RootLayout(props: { onExpoRouterStateChange: … }) {` and move the export to the bottom.
4. Export the wrapped component through a **named** constant. `export default WithPendoExpoRouter(RootLayout)` exports an anonymous component, which trips the common `react-refresh/only-export-components` lint rule; the named form does not.
5. Change nothing else in the file — no reordering of providers, no touching `unstable_settings` or `ErrorBoundary` re-exports.

Applied to a root layout that already renders something:

```typescript
import { Stack, useGlobalSearchParams, usePathname } from 'expo-router';
import * as React from 'react';
import {
    NavigationLibraryType,
    PendoSDK,
    WithPendoExpoRouter,
} from 'rn-pendo-sdk';

PendoSDK.setup('<apiKey>', { library: NavigationLibraryType.ExpoRouter });

function RootLayout(props: {
    onExpoRouterStateChange: (pathname: string, params: unknown) => void;
}) {
    const pathname = usePathname();
    const params = useGlobalSearchParams();

    React.useEffect(() => {
        props.onExpoRouterStateChange(pathname, params);
    }, [pathname, params, props]);

    // ↓ everything below this line is the layout's ORIGINAL body, unchanged
    return (
        <Stack>
            <Stack.Screen name="(app)" options={{ headerShown: false }} />
        </Stack>
    );
}

const PendoRootLayout = WithPendoExpoRouter(RootLayout);
export default PendoRootLayout;
```

Custom RN components that are not auto-tagged: add a `nativeID` prop, then pass `{nativeIDs:["myProp"]}` as the second argument to `WithPendoExpoRouter` / `WithPendoReactNavigation`. Source: `ios/pnddocs/expo_rn-ios.md`.

---

## Step 5 — Modal HOCs (`managed` and `prebuilt`)

```typescript
import { Modal } from 'react-native';
import { WithPendoModal } from 'rn-pendo-sdk';

const PendoModal = WithPendoModal(Modal);
```

`WithPendoModal` is the one corpus-confirmed wrapper (source: `api-documentation/rn-apis.md`) — apply it to whichever modal component the app actually renders:

- React Native's built-in `Modal`
- `@gorhom/bottom-sheet` v4/v5 `BottomSheetModal`
- `react-native-modalize`
- `react-native-modal`
- `react-native-modals`

The upstream docs confirm `WithPendoModal` as the wrapper for every one of these, but do not define per-library wrapper *names* — e.g. `PendoBottomSheetModal` is just a variable name following the sample's pattern, not an additional export from `rn-pendo-sdk`.

**Rules**:

- **Only wrap modals actually rendered in JSX.** A `package.json` dependency alone is not evidence the app renders one.
- **Replace both the opening and closing tags**, including self-closing forms (`<Modal ... />` → `<PendoModal ... />`).
- **Put the wrapper constant below the file's import block**, not among the imports — most RN lint configs fail the build on an import that follows a statement.
- **Never double-wrap** an already-wrapped component.
- **Never change props or children** while wrapping.
- `setup()` must run before any `WithPendoModal` use, per the `[!IMPORTANT]` ordering note in step 4.
- **"For the codeless solution to work, all the elements *MUST be wrapped in react-native ui components*"** — codeless tracking covers screen components and depends on the navigation library's own screen-change callbacks. Source: `ios/pnddocs/expo_rn-ios.md`.

---

## Step 6 — Native wiring (**`prebuilt` only — skip entirely on `managed`**)

Stop here if `subPlatform = managed`: these files do not exist in that repo, and creating them is not part of a managed install.

On `prebuilt`, these edits go into the committed native directories, by hand, exactly as a native repo would make them. Substitute the real `urlScheme` where shown.

### 6a. Pendo's Maven repository — required for the Android build

Without this, `./gradlew assembleDebug` fails at dependency resolution (see §0 for the mechanism and the exact error).

Add the repository where **this project already declares its repositories**, matching its existing layout — do not introduce a new one:

- `android/build.gradle`, inside the existing `allprojects { repositories { … } }` block — the shape React Native and Expo templates ship; **or**
- `android/settings.gradle`, inside `dependencyResolutionManagement { repositories { … } }`, if the project centralizes repositories there instead.

Pendo's docs show exactly one repository form — `exclusiveContent` with a `filter`, never a bare `maven {}` block — which scopes the credentialed Artifactory to Pendo's own group so no other dependency is ever resolved through it:

```groovy
exclusiveContent {
    forRepository {
        maven { url 'https://software.mobile.pendo.io/artifactory/androidx-release' }
    }
    filter {
        includeGroup "sdk.pendo.io"
    }
}
```

Source: `android/pnddocs/native-android.md`. Kotlin-DSL (`build.gradle.kts`) form, if that is what the repo uses:

```kotlin
exclusiveContent {
    forRepository {
        maven { url = uri("https://software.mobile.pendo.io/artifactory/androidx-release") }
    }
    filter {
        includeGroup("sdk.pendo.io")
    }
}
```

Add the repository block only. **Do not add a `sdk.pendo.io:pendoIO` dependency line** — unlike a native Android install, the Expo/React Native app module must not declare it: `node_modules/rn-pendo-sdk/android/build.gradle` already does, and autolinking already puts that module on `:app`'s classpath. Declaring it a second time pins a version the JS package did not choose.

`exclusiveContent` needs Gradle ≥ 6.2, which is never a concern here: `SKILL.md` Phase 4 hard-stops below AGP 8.0, and AGP 8.0 itself requires Gradle ≥ 8.0.

**Exactly one such block may exist — two break the build.** `exclusiveContent` declares that `sdk.pendo.io` is served *only* by the repository inside it. Two blocks claiming the same group leave Gradle with no repository it will search, and resolution fails with the same message as having none at all — except the error carries **no `Searched in:` list**, which is how you tell the two cases apart:

```
Could not find any matches for sdk.pendo.io:pendoIO:3.13.+ as no versions of sdk.pendo.io:pendoIO are available.
Required by:
    project :app > project :rn-pendo-sdk
```

That matters because Pendo's config plugin appends its own copy of this block whenever a full `npx expo prebuild` runs, bracketed by `// @generated begin rn-pendo-sdk-import` / `// @generated end rn-pendo-sdk-import`. It does not recognize a hand-written block, so a prebuild after this install produces two. So: before writing, check whether a Pendo repository block is already in the file (a generated one counts, and Phase 3's indicators would already have caught it) and add nothing if so — and put this in the Phase 8 report:

> If you later run a full `npx expo prebuild`, Pendo's config plugin appends a second copy of the Maven repository block to `android/build.gradle`. Two of them break dependency resolution. Keep exactly one — delete either the hand-written block or the `@generated`-bracketed one.

(The `-p ios` prebuild that step 6d asks for does not touch `android/build.gradle`, so it does not trigger this.) All three states above were verified against a real prebuilt Expo SDK 51 app: hand-written block only → `BUILD SUCCESSFUL`; generated block only → `BUILD SUCCESSFUL`, resolving `sdk.pendo.io:pendoIO:3.13.+ -> 3.13.9.10193`; both → the failure above, and it persists through `--refresh-dependencies`.

**Do not modify `compileSdkVersion` or `minSdkVersion`** — those are the app's own settings, already checked in Phase 4. If either falls short, report it under "Requires your attention"; never bump it yourself.

### 6b. `PendoGateActivity` and permissions — Android Designer pairing

Inside `<application>` in `android/app/src/main/AndroidManifest.xml`:

```xml
<activity
    android:name="sdk.pendo.io.activities.PendoGateActivity"
    android:launchMode="singleInstance"
    android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.VIEW"/>
        <category android:name="android.intent.category.DEFAULT"/>
        <category android:name="android.intent.category.BROWSABLE"/>
        <data android:scheme="<urlScheme>"/>
    </intent-filter>
</activity>
```

Source: `android/pnddocs/native-android.md`.

Also confirm `android.permission.INTERNET` and `android.permission.ACCESS_NETWORK_STATE` are declared in the same manifest, and add whichever is missing. **Flag:** these two permissions are not stated in the fetched upstream corpus for any platform — they are what Pendo's own Expo config plugin requests when it runs, and what any SDK making network calls needs. Treat that as the source, not a doc citation.

### 6c. iOS URL scheme — `Info.plist`

Add a URL type identified as `pendo-pairing` to the **app target's** `Info.plist` (`ios/<App>/Info.plist`), keeping any `CFBundleURLTypes` entries that are already there:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>pendo-pairing</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string><urlScheme></string>
        </array>
    </dict>
</array>
```

Source: `ios/pnddocs/native-ios.md`, reused for the Expo/React Native iOS head. Verify with `plutil -lint ios/<App>/Info.plist` before moving on. `pendo-pairing` is exactly the `CFBundleURLName` Pendo's own config plugin writes, so a later `expo prebuild` recognizes this entry and leaves it alone rather than adding a second one.

### 6d. iOS URL-open hook — **not wired here; mandatory report entry**

The iOS side needs one more piece that this install deliberately does not write: something must receive the opened URL and hand it to `PendoManager`. Pendo delivers that as two Objective-C files (`PendoAppDelegate.h` / `.m`) that its config plugin **copies into the Xcode project and registers in `project.pbxproj`** when `expo prebuild` runs. They ship inside `node_modules/rn-pendo-sdk/plugin/ios/` and are not compiled until they are part of the Xcode project.

Adding source files to an Xcode project is a project-structure mutation, not a text-config edit, and this skill does not perform one. So on `prebuilt`, emit this **mandatory** entry in Phase 8's "Requires your attention" section, verbatim:

> **iOS Designer pairing needs one more step.** Android is fully wired. On iOS, the URL scheme is registered in `Info.plist`, but the handler that forwards an opened `<urlScheme>://` URL to Pendo ships as two files (`PendoAppDelegate.h`/`.m`) that Pendo's config plugin adds to the Xcode project — and a config plugin only runs at `npx expo prebuild`. Run `npx expo prebuild -p ios` (review the diff first against any manual customizations in `ios/`), then re-run `pod install` and rebuild. Until then the iOS build is fine and analytics work; only Designer pairing on iOS does not.

Do not soften it, and do not bury it under lower-severity notes.

---

## Visitor identity and `startSession`

```typescript
static startSession(visitorId?: string, accountId?: string, visitorData?: object, accountData?: object): void
```

Source: `api-documentation/rn-apis.md` — identical to bare React Native, since it is the same JS package.

Full guidance on finding a real `visitorId`/`accountId` and choosing where to place this call lives in `references/identity.md` — a shared, non-platform reference, not subject to the single-platform-file rule. Read it before wiring this call, and **do not invent an identifier**: an install that calls `startSession("user123", …)` compiles, runs, reports success, and produces garbage analytics forever. If the app has no real identity source, wire `setup()` only, write no `startSession` call at all, and report it per `references/identity.md` §5.

If the app has no account/organization/tenant concept (visitor-only), the React Native / Expo empty-account convention from `references/identity.md` §4 is `accountId: ''`, `accountData: {}` — the empty value of the types this signature already declares. **This is not itself an upstream Pendo mandate.**

---

## Handback for Phase 8

Return, for the router's report:

- **Every file touched**, with a one-line reason each. On `prebuilt` that includes the native files from step 6 — plus `ios/Podfile.lock` and `ios/<App>.xcodeproj/project.pbxproj` if Phase 7's `pod install` rewrote them.
- **The resolved `rn-pendo-sdk` version**, noting that upstream pins none.
- **The Expo Go entry** (§0) — mandatory on both `managed` and `prebuilt`.
- **On `managed`**: that the config plugin's native output only materializes at the next `npx expo prebuild` / `expo run:*` / EAS build, and that no native file was created or edited by this install.
- **On `prebuilt`**: the step 6d iOS entry, verbatim.
- **If this run resumed an interrupted install** (see *What is NOT an indicator*): which parts were already present and which this run completed.
- **Whether `startSession` was wired**, and if not, `references/identity.md` §5's exact unwired-report format — verbatim, not paraphrased.

## Minimum requirements recap

**Expo Go cannot run this SDK at all**, regardless of version — see §0; that is a hard blocker, not a version floor.

Beyond that, Phase 4 has already confirmed Expo SDK 41–56. The Android/iOS native-head minimums in `SKILL.md`'s Global Constraints table (iOS 11+/Swift 5.7+/Xcode 14+; AGP 8.0+/Kotlin 1.9.0+/Java 11+/minSdk 21+/compileSdk 35+) apply as written on `prebuilt`, where those values exist in the committed `android/`/`ios/` projects. On `managed` they are not present in the repo at all — Expo derives them from the SDK version at prebuild — and `SKILL.md` Phase 4 says explicitly what to do in that case. Nothing is re-derived here.
