# React Native (bare) — Pendo Mobile SDK Install

**Entry context** (per `SKILL.md`'s phase contract): `platform = react-native`, `subPlatform = bare` — always constant, since Expo is its own `platform` value and is never dispatched here. If the repo has the `expo` package itself in its own `package.json` dependencies, the router should have dispatched to `references/expo.md` instead — do not proceed if that's the case. Only the repo's **own** dependencies count, and only that exact package: an `expo-*` module without `expo` (`expo-secure-store` on its own, say) and an `expo` resolved transitively through some other dependency both belong here, in bare React Native — neither is grounds to refuse the run.

**Scope check**: this file assumes the repo's `react-native` version already passed `SKILL.md` Phase 4's **bounded range 0.66–0.84** (a floor *and* a ceiling — a repo above 0.84 should already have been flagged, not silently accepted). Nothing below re-derives that check.

If you are holding this file open alongside `references/expo.md` for comparison, stop — `SKILL.md`'s phase contract forbids reading more than one platform reference in a single run. Everything below applies to bare React Native only.

---

## Existing Install Indicators

Any of the following found anywhere in the repo means Pendo is already wired here — stop per Phase 3, change nothing:

- `rn-pendo-sdk` in `package.json` `dependencies` or `devDependencies`
- `import { PendoSDK }` or `import { WithPendoReactNavigation }` (or any other `WithPendo*` symbol) from `rn-pendo-sdk`
- `require('rn-pendo-sdk')`
- A `PendoSDK.setup(` call anywhere in the source
- A `PendoSDK.startSession(` call anywhere in the source
- `PendoGateActivity` in `android/app/src/main/AndroidManifest.xml`
- A URL type in `ios/<App>/Info.plist` whose identifier is `pendo-pairing` or whose scheme starts with `pendo-`

---

## Dependency

### JS package

Add `rn-pendo-sdk` to `dependencies` (not `devDependencies` — it ships native code that must build into the release binary), then install:

```shell
yarn add rn-pendo-sdk
```

(`npm install --save rn-pendo-sdk` is the corpus-documented equivalent if the repo is npm-based; match whichever lockfile the repo already uses.)

Source: `ios/pnddocs/rn-ios.md`, `android/pnddocs/rn-android.md`. No version number is pinned anywhere in the upstream docs for `rn-pendo-sdk` — do not invent one; let the package manager resolve latest.

### iOS native head — CocoaPods autolinking only

**The iOS native SDK arrives via CocoaPods autolinking. Do not add SPM, and do not edit `project.pbxproj` by hand.** After the JS install, run:

```shell
cd ios && pod install
```

That's the entire iOS-native step for a default install — no Xcode project surgery. This is the sharpest contrast with `references/ios.md` (native iOS), which walks through SPM package resolution inside Xcode directly.

*Aside, not part of the default install*: the upstream docs also document an **opt-in** SPM path for RN **≥0.75** (still CocoaPods by default otherwise) — setting `$RNPendoEnableSPM = true` plus `require_relative '../node_modules/rn-pendo-sdk/scripts/pendo_spm_fix'` in the `Podfile`, and calling `pendo_fix_spm_signing(installer)` in `post_install` (skipping the signing fix causes a `dyld: Library not loaded` crash, since `Pendo.framework` is a pre-compiled dynamic binary Xcode won't auto-embed-and-sign when resolved via SPM inside the `Pods.xcodeproj` subproject). Source: `ios/pnddocs/rn-ios.md`. This install does not enable that flag — it stays on the CocoaPods default. Do not turn it on unless the user explicitly asks for SPM.

### Android native head

Needs the same Pendo Maven repository block as native Android. See **Native sides → Android** below for the exact block and where it goes — do not duplicate it here.

---

## Navigation setup

**Setup is navigation-library-dependent.** `PendoSDK.setup(appKey, navigationOptions, pendoOptions?)` takes a `NavigationOptions(library: NavigationLibraryType, navigation?: any)`, and `NavigationLibraryType` is a 5-value enum: `ReactNativeNavigation`, `ReactNavigation`, `ExpoRouter`, `Paper`, `Other`. Source: `api-documentation/rn-apis.md`.

> **[!IMPORTANT]** "The `setup` API must be called before the `startSession`, `WithPendoReactNavigation`, `WithPendoExpoRouter`, `WithPendoPaper` and `WithPendoModal` APIs. All other APIs must be called after both the `setup` and `startSession` APIs, otherwise they will be ignored." Source: `api-documentation/rn-apis.md`.

| Library | `setup()` call | Wrapper |
|---|---|---|
| React Navigation | `PendoSDK.setup(apiKey, {library: NavigationLibraryType.ReactNavigation})` | `const PendoNavigationContainer = WithPendoReactNavigation(NavigationContainer);` then replace `<NavigationContainer>` in JSX with `<PendoNavigationContainer>` |
| React Native Navigation (Wix) | `PendoSDK.setup(apiKey, {library: NavigationLibraryType.ReactNativeNavigation, navigation: Navigation})` | none — RNN has no wrapper component; the library's own `Navigation` object is passed into `setup()` instead |
| Expo Router | `PendoSDK.setup(apiKey, {library: NavigationLibraryType.ExpoRouter})` | `WithPendoExpoRouter(RootLayout)` — documented here for completeness because the enum/HOC pair is part of the one shared `rn-pendo-sdk` JS API (`api-documentation/rn-apis.md`); not reachable from an actual bare-RN dispatch, since Expo Router requires the `expo-router` package, which requires Expo — an app with that dependency is classified `platform = expo` at Phase 1, before this file is ever read |
| React Native Paper (`BottomNavigation` only) | Reuse whichever stack library's `setup()` call above is already configured — Paper is **additive**, not a `library` choice of its own | `const PendoBottomNavigation = WithPendoPaper(BottomNavigation);` |
| Other / unknown | `PendoSDK.setup(apiKey, {library: NavigationLibraryType.Other})` | none — codeless screen tracking is not guaranteed for this app |

`apiKey` above is the Pendo integration key resolved in Phase 5 — write that resolved value as a literal, never one of your own invention. If Phase 5 resolved it to the declared placeholder `YOUR_API_KEY_HERE` because the user did not have a key to hand, write that verbatim and complete every step as normal; the router reports it as a placeholder install.

Note on Paper: the enum does list a `Paper` value, but the upstream guide's actual usage pattern treats `WithPendoPaper` as additive on top of whichever screen-stack library (React Navigation, RNN, etc.) is also present, since `BottomNavigation` is a nav *component*, not a full router — it is not documented as its own standalone `library:` choice for `setup()`. Source: `api-documentation/rn-apis.md`; corroborated by `references/detection.md` §6.

Expo Router's Root Layout wrapper (shape only — the exact API contract this implements is corpus-confirmed via `usePathname()`/`useGlobalSearchParams()` → `props.onExpoRouterStateChange(pathname, params)`; the literal code below is one correct way to wire it, not a verbatim upstream sample):

```typescript
function RootLayout(props: any): ReactNode {
    let pathname = usePathname();
    const params = useGlobalSearchParams();

    useEffect(() => {
        props.onExpoRouterStateChange(pathname, params);
    }, [pathname, params, props]);
}
export default WithPendoExpoRouter(RootLayout);
```

### Placement

**`setup()` is call-once-only for the application lifecycle.** Pendo's API reference states this explicitly: "`setup` can only be called once during the application lifecycle." (`api-documentation/rn-apis.md`). This matters concretely here: `index.js` typically just calls `AppRegistry.registerComponent` and renders `App.tsx` — if both files (or `App.tsx` plus some other root-level component) each end up with their own `setup()` call, that's two real calls in one app lifecycle, not two harmless duplicates. Wire `setup()` in exactly one place — the app's actual main entry file — and confirm no other file in the repo already calls it (this is also Phase 3's Existing Install Indicators gate, which should already have caught an existing call before this file is ever reached).

`setup()` goes in the app's main entry file (`App.js`/`.ts`/`.tsx` — `ios/pnddocs/rn-ios.md`, `android/pnddocs/rn-android.md`), at **module level**, before any navigation container renders — **never inside `useEffect`**. This isn't a separate upstream rule; it's the direct consequence of the ordering requirement quoted above: the `WithPendoReactNavigation`/`WithPendoExpoRouter`/`WithPendoPaper` wrapper calls typically run at module-evaluation time (e.g. `const PendoNavigationContainer = WithPendoReactNavigation(NavigationContainer)` executes as soon as the module loads, before any component renders), and `setup()` must run before every one of them or they're silently ignored per the `[!IMPORTANT]` note above. Deferring `setup()` into a `useEffect` runs it after the first render — after those wrapper calls have already executed — which is exactly the ordering violation the API warns against.

`startSession` is called wherever the visitor is actually identified (e.g. after login) — see **Visitor identity and `startSession`** below.

---

## Metro configuration (mandatory)

**This is not optional.** React Native's production minifier strips component names by default, and Pendo's codeless tagging identifies UI elements by those names — mangled output breaks codeless tagging entirely. Source: `ios/pnddocs/rn-ios.md`, `android/pnddocs/rn-android.md` (identical snippet in both).

**Merge into the existing config — never replace it.** A repo's `metro.config.js` almost always has other transformer/resolver settings already; blowing those away to drop in Pendo's block is a regression, not an install.

The corpus-confirmed block, to be merged under `transformer.minifierConfig`:

```javascript
module.exports = {
    transformer: {
        // ...existing transformer config (DO NOT remove existing settings)
        minifierConfig: {
            keep_classnames: true,
            keep_fnames: true,
            mangle: {
                keep_classnames: true,
                keep_fnames: true,
            }
        }
    }
}
```

**Search order**: `metro.config.ts` → `metro.config.js`; create `metro.config.js` if neither exists (Metro's own CLI resolves `metro.config.js` by default — a `.ts` variant only works if the repo already has its own loader for it; this file-search-order detail is standard Metro/RN tooling convention, not a Pendo-specific fact, unlike the `keep_classnames`/`keep_fnames` block itself, which is upstream-sourced).

Merge patterns for the two common base configs (also generic Metro/Expo tooling, not Pendo-specific — shown so the merge is additive rather than a blind overwrite):

**`@react-native/metro-config`** (bare RN's default template):

```javascript
const { getDefaultConfig, mergeConfig } = require('@react-native/metro-config');

const defaultConfig = getDefaultConfig(__dirname);

const pendoConfig = {
    transformer: {
        minifierConfig: {
            keep_classnames: true,
            keep_fnames: true,
            mangle: {
                keep_classnames: true,
                keep_fnames: true,
            },
        },
    },
};

module.exports = mergeConfig(defaultConfig, pendoConfig);
```

**`expo/metro-config`** (relevant only if this bare-RN repo happens to still depend on the Expo metro config package without being an Expo app — rare, but `mergeConfig` isn't exported from this package, so merge by spreading instead):

```javascript
const { getDefaultConfig } = require('expo/metro-config');

const defaultConfig = getDefaultConfig(__dirname);

defaultConfig.transformer.minifierConfig = {
    ...defaultConfig.transformer.minifierConfig,
    keep_classnames: true,
    keep_fnames: true,
    mangle: {
        ...defaultConfig.transformer.minifierConfig?.mangle,
        keep_classnames: true,
        keep_fnames: true,
    },
};

module.exports = defaultConfig;
```

---

## Modal HOCs (optional — and scope-bounded)

**Unlike the Metro configuration above, this step is not required for a correct install.** Upstream describes `WithPendoModal` as what lets the SDK "detect its visibility changes and track the modal content" (`api-documentation/rn-apis.md`); it is never stated as a mandatory install step, and nothing else degrades when a modal is left unwrapped — an unwrapped modal is simply not tracked. An install that wraps no modals at all is complete and working.

**Decide the scope before editing, by counting the render sites first:**

```shell
grep -rnE "<(Modal|BottomSheetModal|Modalize|ReactNativeModal)([[:space:]>/]|$)" \
  --include='*.tsx' --include='*.jsx' --include='*.js' --include='*.ts' . | grep -v node_modules
```

(Quote the `--include` globs — unquoted they are expanded by zsh before `grep` sees them, and the command reports nothing. The trailing character class keeps `<ModalBox`-style component names out of the count.)

- **Never wrap anything outside the app's own source** — no `node_modules`, no generated or vendored files.
- **3 render sites or fewer** → wrap them as part of the install.
- **More than 3** → do **not** rewrite them. A production app commonly renders modals at 10–20 sites across a dozen files; a sweep that size dwarfs the handful of files the rest of this install touches and buries the SDK wiring in a diff the developer never asked for. Instead, list the count and the files under Phase 8's "Requires your attention" and let the app owner decide — or wrap them if the user explicitly asks for modal coverage.

Whatever you do wrap, the Rules subsection below is binding for it.

```typescript
import {Modal} from 'react-native';
import {WithPendoModal} from 'rn-pendo-sdk';

const PendoModal = WithPendoModal(Modal);
```

`WithPendoModal` is the one corpus-confirmed wrapper (source: `api-documentation/rn-apis.md`) — apply it to whichever modal component the app actually renders. Covered libraries, per `api-documentation/rn-apis.md`'s `WithPendoModal` usage list (also corroborated by `references/detection.md` §6):

- React Native built-in `Modal`
- `@gorhom/bottom-sheet` v4/v5 `BottomSheetModal`
- `react-native-modalize`
- `react-native-modal`
- `react-native-modals`

The upstream docs confirm `WithPendoModal` as the wrapper name for every one of these libraries, but do not hand out a distinct per-library wrapper *name* — `PendoBottomSheetModal`, `PendoModalize`, `PendoReactNativeModal`, `PendoRNModal`, etc. are illustrative variable names following the same pattern as the `PendoModal` sample above (`const <Descriptive Name> = WithPendoModal(<actual imported modal component>)`), not additional exported symbols from `rn-pendo-sdk`. Name the constant for whatever's being wrapped; the function being called is always `WithPendoModal`.

### Rules

- **Only wrap modals actually rendered in JSX.** A `package.json` dependency on `@gorhom/bottom-sheet` alone is not evidence the app renders one — check for the JSX usage before wrapping.
- **Replace both the opening and closing tags**, including self-closing forms (`<Modal ... />` → `<PendoModal ... />`).
- **Never double-wrap** an already-wrapped component.
- **Never change props or children** while wrapping — the wrap is purely a rename of the tag.
- `setup()` must run before any `WithPendoModal` use, per the `[!IMPORTANT]` ordering note above.

---

## Native sides (both edited by hand)

Unlike Expo — which generates this configuration through a config plugin instead — bare React Native has no config plugin layer. These native files are edited directly here, the same way `references/ios.md` and `references/android.md` edit them for a fully native app.

### iOS

`Info.plist` → the app target's URL Types → identifier `pendo-pairing`, URL Scheme = the resolved `urlScheme` value (e.g. `pendo-xxxx`) — same mechanism as native iOS; bare RN has no separate JS-level deep-link API. Source: `ios/pnddocs/rn-ios.md`, `ios/pnddocs/native-ios.md`.

**Check the `AppDelegate`'s language before writing a line of it.** Look in `ios/<App>/`: the file is `AppDelegate.swift`, `AppDelegate.m`, or `AppDelegate.mm`. React Native's own template shipped an Objective-C++ `AppDelegate.mm` across most of the supported 0.66–0.84 range and only moved to Swift late in it, so an in-range app is at least as likely to be Objective-C as Swift — and Swift pasted into a `.m`/`.mm` is a compile error (`unknown type name 'import'`, then `missing context for method declaration` for every method that follows), not a style mismatch. Pendo documents **both** languages for this step — `ios/pnddocs/rn-ios.md` carries a Swift block and an Objective-C block for the same instruction — so use the one matching the file in front of you. Both forms below are upstream's, transcribed.

The upstream `AppDelegate` handler, exactly as documented (native iOS's own sample, reused verbatim for RN per the upstream RN doc's "the native iOS hook is unchanged"):

**Swift** (`AppDelegate.swift`):

```swift
import Pendo

func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    if url.scheme?.range(of: "pendo") != nil {
        PendoManager.shared().initWith(url)
        return true
    }
    return true
}
```

**Objective-C** (`AppDelegate.m` / `AppDelegate.mm`):

```objectivec
@import Pendo;

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
        if ([[url scheme] containsString:@"pendo"]) {
            [[PendoManager sharedManager] initWithUrl:url];
            return YES;
        }
        //  your code here ...
        return YES;
}
```

Note the two languages are not transliterations of each other in upstream's own text: Swift matches the scheme with `range(of:)` and Objective-C with `containsString:`. Keep whichever the sample for your language uses. Source for both: `ios/pnddocs/rn-ios.md`.

`@import Pendo;` is upstream's Objective-C import and works wherever the target has Clang modules enabled (`CLANG_ENABLE_MODULES = YES`, the default for RN's template). If the target has modules disabled, `#import <Pendo/Pendo.h>` is the equivalent — the CocoaPods-installed `Pendo.xcframework` ships both a `Modules/module.modulemap` and a `Headers/Pendo.h` umbrella header, so either import resolves the same `PendoManager` interface. `+ (instancetype)sharedManager` and `- (void)initWithUrl:(NSURL *_Nonnull)url` are declared in that framework's own `Headers/PendoManager.h`; do not guess at other Objective-C spellings of the API.

**Now check whether the method is already there**, because that decides which of the two cases below you are in. Upstream's own instruction is "add **or modify** the `openURL` function", and the `//  your code here ...` line inside both samples is exactly where an app's existing handling belongs:

```shell
grep -rn "openURL\|open url" --include='AppDelegate.*' ios/
```

#### Case 1 — no `openURL` handler exists yet: add the method, falling through to `super`

**Read this before pasting it in.** The upstream sample above returns `true` unconditionally on both branches — including the non-matching-scheme case. That's fine for a from-scratch native iOS `AppDelegate` with no other `openURL` consumer, but **it is not corpus-sourced guidance for React Native specifically, and it is a real risk in an RN app**: an RN `AppDelegate` typically subclasses `RCTAppDelegate` (React Native's own base class, generated by the community template since RN 0.71+), which implements its own `application(_:open:options:)` for RN's `Linking` module and any other autolinked library that hooks the same callback (Google/Facebook sign-in SDKs, universal-links handling, etc.). Returning `true` unconditionally — or `false` — on the non-matching branch silently swallows whatever `super` would otherwise have done for those other consumers. Fall through to `super` instead:

```swift
import Pendo

func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    if url.scheme?.range(of: "pendo") != nil {
        PendoManager.shared().initWith(url)
        return true
    }
    return super.application(app, open: url, options: options)
}
```

Objective-C, same shape:

```objectivec
@import Pendo;

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([[url scheme] containsString:@"pendo"]) {
        [[PendoManager sharedManager] initWithUrl:url];
        return YES;
    }
    return [super application:app openURL:url options:options];
}
```

This `super` fallthrough is **not upstream-sourced** — it is general React Native architecture guidance layered on top of the corpus-confirmed `PendoManager` call, included here because pasting Pendo's own sample verbatim into an RN `AppDelegate` risks breaking other URL handling. It is only valid if the superclass actually implements the method: `RCTAppDelegate` does, but an `AppDelegate` declared `@interface AppDelegate : UIResponder <RCTBridgeDelegate>` (the shape older and heavily customized RN apps use) inherits no such method, and the `super` call fails to compile with `no visible @interface for 'UIResponder' declares the selector 'application:openURL:options:'`. Confirm the declared superclass in `AppDelegate.h`/`.swift` before assuming this shape is safe, and ask rather than guessing if it's unclear.

#### Case 2 — a handler already exists: modify it, never add a second one

This is the **common** case in a real app, not an edge case: React Native's own `Linking` documentation tells app authors to forward `application:openURL:options:` to `RCTLinkingManager`, so essentially every RN app that supports deep links already implements this method — often routing a long list of the app's own URL schemes through it.

Declaring the method a second time in the same class is a hard compile error — Objective-C rejects it with `error: duplicate declaration of method 'application:openURL:options:'`, and Swift as an invalid redeclaration — and deleting the existing body to make room silently breaks every deep link the app already handles.

**Insert the Pendo branch at the top of the existing method and leave the existing body as the fall-through**, exactly where upstream's `//  your code here ...` sits:

```objectivec
@import Pendo;

- (BOOL)application:(UIApplication *)application
   openURL:(NSURL *)url
   options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
  if ([[url scheme] containsString:@"pendo"]) {
    [[PendoManager sharedManager] initWithUrl:url];
    return YES;
  }
  return [RCTLinkingManager application:application openURL:url options:options];  // pre-existing body, unchanged
}
```

Swift is the same shape: Pendo branch first, then the method's existing body verbatim as the final statement.

Two rules for this case:

- **Do not add a `super` call the method did not already have.** In Case 1 `super` is the fall-through; here the existing body is, and appending a `super` call after it changes behavior the app already relies on.
- **The superclass question does not arise.** Whatever the existing body does is by definition what this app's non-Pendo URLs already do, so there is nothing to confirm about the superclass and nothing to ask about.

### Android

**Maven repository** — the same block native Android requires, added to `android/build.gradle`'s `allprojects.repositories` if that structure is present, or to `android/settings.gradle`'s `dependencyResolutionManagement.repositories` if the project uses the newer centralized-repositories Gradle layout (this search-order choice is standard Android/Gradle project structure, not Pendo-specific — check whichever file the repo actually uses for repository declarations).

Pendo's docs show exactly one repository form — `exclusiveContent`/`filter`, never a bare `maven {}` block (see `references/android.md` §2 for the full rationale on why there's no fallback — same rule, repeated here because this file is read standalone):
```groovy
repositories {
    exclusiveContent {
        forRepository {
            maven { url = uri("https://software.mobile.pendo.io/artifactory/androidx-release") }
        }
        filter {
            includeGroup "sdk.pendo.io"
        }
    }
    mavenCentral()
}
```

Source: `android/pnddocs/native-android.md`, reused for RN per `android/pnddocs/rn-android.md` ("Android's native head only needs the `PendoGateActivity` manifest block (same XML as native Android)").

**`PendoGateActivity`** — inside `<application>` in `AndroidManifest.xml`, with the resolved `urlScheme` value substituted for the scheme:

```xml
<activity android:name="sdk.pendo.io.activities.PendoGateActivity" android:launchMode="singleInstance" android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.VIEW"/>
        <category android:name="android.intent.category.DEFAULT"/>
        <category android:name="android.intent.category.BROWSABLE"/>
        <data android:scheme="<urlScheme>"/>
    </intent-filter>
</activity>
```

Source: `android/pnddocs/native-android.md`, reused verbatim for RN.

**Permissions** — verify `android.permission.INTERNET` and `android.permission.ACCESS_NETWORK_STATE` are present in `AndroidManifest.xml`; add them if missing. **Flag:** neither permission is stated anywhere in the fetched upstream corpus for any platform — this is a general requirement for any SDK that makes network calls, not a claim traceable to Pendo's docs. Included because Pendo's SDK plainly needs network access to function, but treat it as an engineering inference, not an upstream fact.

**ProGuard — only when minification is enabled.** Check the app module's `build.gradle[.kts]` release `buildTypes` block for `minifyEnabled true` (Groovy) or `isMinifyEnabled = true` (Kotlin DSL). If **absent**, skip this step entirely — do not touch `proguard-rules.pro`.

If **present**, append Pendo's full ProGuard/R8 configuration below to `proguard-rules.pro` — the complete, verbatim contents of `android/pnddocs/pendo-proguard.cfg`, not just the `-optimizations` line. Skipping any of the `-keep`/`-keepattributes` rules risks R8 stripping or obfuscating Pendo's own SDK classes in the release build specifically: the app still builds and runs fine in debug, so the breakage only surfaces in production.

```
# Keep all non obfuscated classes under Pendo SDK core code in .aar
-keep class sdk.pendo.io.** { *; }

# Keep all non obfuscated classes under external libs in .aar
-keep class external.sdk.pendo.io.** { *; }

# Keep all views - names and listed methods for
# dynamic views initialisation, predicate rules...
-keep public class * extends android.view.View {
    public <init>(android.content.Context);
    public <init>(android.content.Context, android.util.AttributeSet);
    public <init>(android.content.Context, android.util.AttributeSet, int);
    public void set*(...);
}

# Keep Fragments for their names we use in page identification screenId
-keepnames public class * extends android.support.v4.app.Fragment
-keepnames public class * extends android.app.Fragment
-keepnames public class * extends androidx.fragment.**
-dontwarn external.sdk.pendo.io.glide.R$id
-dontwarn external.sdk.pendo.io.org.codehaus.mojo.animal_sniffer.IgnoreJRERequirement
-dontwarn external.sdk.pendo.io.org.conscrypt.Conscrypt$Version
-dontwarn external.sdk.pendo.io.org.conscrypt.Conscrypt
-dontwarn external.sdk.pendo.io.org.conscrypt.ConscryptHostnameVerifier
-dontwarn external.sdk.pendo.io.org.jetbrains.annotations.NotNull
-dontwarn external.sdk.pendo.io.org.jetbrains.annotations.Nullable
-dontwarn external.sdk.pendo.io.org.openjsse.javax.net.ssl.SSLParameters
-dontwarn external.sdk.pendo.io.org.openjsse.javax.net.ssl.SSLSocket
-dontwarn external.sdk.pendo.io.org.openjsse.net.ssl.OpenJSSE
-dontwarn external.sdk.pendo.io.slf4j.impl.StaticLoggerBinder
-dontwarn java.security.interfaces.EdECPrivateKey
-dontwarn java.security.interfaces.EdECPublicKey
-dontwarn java.security.interfaces.XECPrivateKey
-dontwarn java.security.interfaces.XECPublicKey
-dontwarn java.security.spec.EdECPoint
-dontwarn java.security.spec.EdECPrivateKeySpec
-dontwarn java.security.spec.EdECPublicKeySpec
-dontwarn java.security.spec.NamedParameterSpec
-dontwarn java.security.spec.XECPrivateKeySpec
-dontwarn java.security.spec.XECPublicKeySpec
-dontwarn javax.swing.**
-dontwarn java.awt.**
-dontwarn org.codehaus.mojo.animal_sniffer.IgnoreJRERequirement
-dontwarn androidx.window.**
-dontwarn com.google.api.client.http.**
-dontwarn edu.umd.cs.findbugs.annotations.SuppressFBWarnings
-dontwarn java.lang.invoke.StringConcatFactory

#ParametrizedType ClassCastException error fix
 -keep,allowobfuscation,allowshrinking interface retrofit2.Call
 -keep,allowobfuscation,allowshrinking class retrofit2.Response
 -keep,allowobfuscation,allowshrinking class kotlin.coroutines.Continuation

# Gson uses generic type information stored in a class file when working with fields. Proguard
# removes such information by default, so configure it to keep all of it.
-keepattributes Signature

# For using GSON @Expose annotation
-keepattributes *Annotation*

# Gson specific classes
-dontwarn sun.misc.**

# Application classes that will be serialized/deserialized over Gson
-keep class external.sdk.pendo.io.gson.examples.android.model.** { <fields>; }

# Prevent proguard from stripping interface information from TypeAdapter, TypeAdapterFactory,
# JsonSerializer, JsonDeserializer instances (so they can be used in @JsonAdapter)
-keep class * extends external.sdk.pendo.io.gson.TypeAdapter
-keep class * implements external.sdk.pendo.io.gson.TypeAdapterFactory
-keep class * implements external.sdk.pendo.io.gson.JsonSerializer
-keep class * implements external.sdk.pendo.io.gson.JsonDeserializer
```

**Addendum — a separate D8/DX-time optimization flag, not part of the keep-rule set above.** Add this to the same `proguard-rules.pro` (D8/DX-time code optimization otherwise breaks the SDK):
```
-optimizations !code/allocation/variable
```
If a `-optimizations` line already exists in the file, append `!code/allocation/variable` to its existing flag list rather than adding a second, competing `-optimizations` line.

Source: `android/pnddocs/native-android.md`, `android/pnddocs/pendo-proguard.cfg`. The upstream RN doc does not separately restate this for RN — it's inherited here because RN's Android native head embeds the same native Android SDK the rule was written for, same as the Maven repo and `PendoGateActivity` blocks above; flag this inheritance if it ever needs re-verifying directly against an RN-specific doc. This gate mirrors `references/android.md` §7 verbatim — restated here (not just cross-referenced) because this file's own header says only one platform reference is read per run, so it cannot rely on the reader having also seen android.md.

---

## Visitor identity and `startSession`

```typescript
static startSession(visitorId?: string, accountId?: string, visitorData?: object, accountData?: object): void
```

Source: `api-documentation/rn-apis.md`. Full guidance on finding a real `visitorId`/`accountId` and choosing where to place this call lives in `references/identity.md` — read it before wiring this call; do not invent an identifier here.

If the app has no account/organization/tenant concept at all (visitor-only), the React Native / Expo empty-account convention from `references/identity.md` §4 is `accountId: ''`, `accountData: {}` — matching this signature's own declared `string?`/`object?` parameter types. **This convention is not itself upstream-sourced as a Pendo mandate** — it is simply the empty value of the type the signature already requires, not a documented Pendo requirement to always pass one.
