# Platform & Framework Detection — Evidence Reference

Consulted by two different callers, for two different jobs:

1. **The router (`SKILL.md` Phase 1)** — only when its six-row fast-path table matches ambiguously or not at all. Most repos never reach this file.
2. **Platform reference files** (`references/ios.md`, `android.md`, `react-native.md`, `expo.md` — built in later tasks) — for sub-framework, lifecycle, and navigation-library detail that the router's `subPlatform` table (`SKILL.md`, "The phase contract") does not resolve on its own.

Never guess past what a section below can confirm. If signals are genuinely absent or contradictory, ask the user — do not default to the more common case.

---

## 1. True cross-platform ambiguity (e.g. a Flutter module embedded in a native host)

Different from §2 below — that one is a false ambiguity the router's fast-path table already resolves instantly (Expo wins over React Native). This section is for a repo that genuinely shows two independent platforms at once: a `pubspec.yaml` with a Flutter SDK dependency *and* a bare `android/` or iOS project that is not Flutter's own generated shell (i.e. a native host embedding a Flutter module, not a Flutter app's own `android/`/`ios/` scaffolding).

**Do not pick one and proceed.** Pendo's docs state hybrid mode (native host + Flutter module) is **not self-serve**: "To support hybrid mode in Flutter, please open a ticket." Source: `ios/pnddocs/flutter-ios.md`, `other/native-with-flutter-components`. Stop, tell the user this repo shape requires a Pendo support ticket, and do not dispatch to any platform reference.

---

## 2. React Native vs. Expo

Router rule (`SKILL.md` Phase 1): `expo` in `package.json` dependencies wins over `react-native` when both are present, because every RN and Expo repo ships native `ios/`/`android/` shells alongside `react-native` in `package.json` — that combination alone is not evidence of a native app.

### Confirming indicators — Expo
- `expo` (or any `expo-*` package, e.g. `expo-router`, `expo-modules-core`) in the **app's own** `package.json` dependencies — not just a hoisted root in a monorepo/workspace, since a workspace root's dependency list can mask what an individual app actually depends on.
- `app.json` or `app.config.js`/`app.config.ts` with a top-level `"expo": {...}` key.
- `.expo/` directory present (local Expo dev-client cache).
- `package.json` `"main"` set to `"expo-router/entry"` or `"expo/AppEntry.js"`, or a `"scripts"` entry invoking `expo start` / `expo prebuild` / `expo run:ios` / `expo run:android`.
- Root component registered via `registerRootComponent` (from the `expo` package) rather than `AppRegistry.registerComponent`.

### Confirming indicators — bare React Native
- `react-native` in dependencies, **no** `expo` package anywhere in the app's own `package.json` and no `"expo"` key in any `app.json`/`app.config.*`.
- `react-native.config.js` present.
- Root component registered via `AppRegistry.registerComponent` in `index.js`.
- `ios/Podfile` / `android/app/build.gradle` reference `react-native`/`com.facebook.react` directly with no Expo autolinking config-plugin block.

If signals conflict (e.g. `expo-router` present but no `"expo"` key anywhere and no `.expo/` dir — an unusual partial migration), ask the user rather than picking a side.

---

## 3. iOS — sub-framework (UIKit vs. SwiftUI vs. hybrid)

Router `subPlatform` heuristic (`SKILL.md`, "The phase contract" — restated, not redefined here): a type conforming to `App` with `@main` in a `.swift` file → `swiftui`; otherwise an `AppDelegate.swift` conforming to `UIApplicationDelegate` → `uikit`. That heuristic is binary; this section covers the hybrid case it doesn't name.

### Pure SwiftUI
- `@main struct <Name>App: App { var body: some Scene { ... } }` exists.
- No `AppDelegate.swift`, or one exists only as a thin bridge pulled in via `@UIApplicationDelegateAdaptor` for callbacks the `App` protocol doesn't cover (push notifications, etc.) — it does not itself define `application(_:didFinishLaunchingWithOptions:)` as the app's real entry point.

### Pure UIKit
- `AppDelegate.swift` conforms to `UIApplicationDelegate` and implements `application(_:didFinishLaunchingWithOptions:)`.
- No `@main`-annotated `App`-conforming type anywhere in the target.
- Root UI built via `UIWindow`/`UINavigationController`/storyboards, not `WindowGroup`.

### Hybrid (both present)
Common shapes: SwiftUI `View`s hosted inside a UIKit stack via `UIHostingController`, or a SwiftUI `App` that uses `@UIApplicationDelegateAdaptor(AppDelegate.self)` to keep a legacy `AppDelegate` alive for other integrations.

**Classification rule** — whichever type owns the actual startup callback governs `subPlatform`:
- `AppDelegate.application(_:didFinishLaunchingWithOptions:)` is where the app cold-starts (with or without a `@UIApplicationDelegateAdaptor` bridge) → classify `uikit`.
- No `AppDelegate` at all, or one that exists solely as a delegate-adaptor shim with no `didFinishLaunchingWithOptions` logic of its own → classify `swiftui`.

If neither condition clearly holds (e.g. an Objective-C-only app with no `@main` and no `AppDelegate.swift` file at all), this is the no-clean-match case the router's phase contract already tells you to ask about — do so.

---

## 4. iOS — lifecycle split (AppDelegate-only vs. AppDelegate+SceneDelegate)

**Independent from §3.** A UIKit app can run single-window with no scenes, or multi/single-scene with a `SceneDelegate`; a SwiftUI app's `WindowGroup`/`Scene` model replaces both. This axis is not part of the router's `subPlatform` value set — it changes *where inside the chosen sub-framework* the Pendo calls go:

- `setup()` goes in `AppDelegate.application(_:didFinishLaunchingWithOptions:)` **or** `SceneDelegate.scene(_:willConnectTo:options:)`.
- The deep-link handler goes in `AppDelegate.application(_:open:options:)` **or** `SceneDelegate.scene(_:openURLContexts:)` **or**, for pure SwiftUI, `.onOpenURL(perform:)` on the root scene.

Source: `ios/pnddocs/native-ios.md` — setup placement ("`AppDelegate.application(_:didFinishLaunchingWithOptions:)`" or "`SceneDelegate.scene(_:willConnectTo:options:)`"); deep-link code shown for both delegate types plus the SwiftUI `.onOpenURL` case.

### Signals — AppDelegate+SceneDelegate present
- `SceneDelegate.swift` file exists.
- A type implements `scene(_:willConnectTo:options:)` (the `UIWindowSceneDelegate` connection callback).
- `Info.plist` contains a `UIApplicationSceneManifest` key (commonly nesting `UIApplicationSupportsMultipleScenes` and `UISceneConfigurations`).

### Signals — AppDelegate-only (no scenes)
- None of the three signals above are present.
- `application(_:didFinishLaunchingWithOptions:)` and `application(_:open:options:)` are the only relevant lifecycle entry points found.

### SwiftUI-native equivalent
Pure-SwiftUI apps (per §3) have neither file — the root `Scene`'s `.onOpenURL(perform:)` is the SwiftUI-idiomatic replacement for both `SceneDelegate` methods, and is where the deep-link handler goes regardless of whether an `Info.plist` `UIApplicationSceneManifest` key happens to be present (SwiftUI apps still carry one by default). Source: `ios/pnddocs/native-ios.md` — "Pure-SwiftUI apps with an `@main App` struct additionally need `.onOpenURL(perform: handleURL)` on the root scene, since there is no `AppDelegate.application(open:)` callback to receive it."

A single project can show more than one of these signals if it supports multiple scenes for iPad multitasking while still carrying an `AppDelegate` — if `scene(_:willConnectTo:options:)` exists, prefer wiring the SceneDelegate over the AppDelegate for both calls, since that's the callback that actually fires for scene-based apps.

---

## 5. Android — sub-framework (Views vs. Compose vs. hybrid)

Determines which of Pendo's two wiring paths applies. Source: `android/pnddocs/native-android.md` — tracking is "Automatic for standard Views. For Jetpack Compose ...: add `Modifier.pendoTag(...)` ... and `Modifier.pendoStateModifier(...)`."

### Views-only
- `res/layout/*.xml` layout files present for the app's screens.
- `setContentView(R.layout....)` calls in `Activity`/`Fragment` classes.
- No `androidx.compose.ui:ui` (or other `androidx.compose.*`) dependency in any module's `build.gradle[.kts]`.

### Compose-only
- `setContent { ... }` calls (Compose's activity entry point) instead of `setContentView`.
- `androidx.compose.ui:ui` (or `androidx.compose.material3`, etc.) present in `build.gradle[.kts]` dependencies.
- `@Composable`-annotated functions define the UI; little or no `res/layout/*.xml` for app screens (system/library-provided layouts don't count).

### Hybrid
- Both `setContentView` and `setContent` calls exist in the same app, **or**
- A `ComposeView` (`androidx.compose.ui.platform.ComposeView`) is embedded inside a Views-based `Fragment`/`Activity`, **or**
- An `AndroidView` composable wraps a legacy `View` inside a Compose screen.

Common in apps mid-migration to Compose. When hybrid, both wiring paths apply — instrument the Views portions (automatic) and add `Modifier.pendoTag`/`Modifier.pendoStateModifier` to the Compose portions.

---

## 6. React Native / Expo — navigation-library detection

Pendo's RN/Expo `NavigationOptions` takes a `NavigationLibraryType` enum with exactly five values: `ReactNativeNavigation`, `ReactNavigation`, `ExpoRouter`, `Paper`, `Other`. Source: `api-documentation/rn-apis.md`.

| Library | Confirming indicators | Pendo wrapper |
|---|---|---|
| React Navigation | `@react-navigation/native` in dependencies; `NavigationContainer` imported from `@react-navigation/native` in the app root | Wrap `NavigationContainer` with `WithPendoReactNavigation` |
| React Native Navigation (Wix) | `react-native-navigation` in dependencies; `Navigation.registerComponent`/`Navigation.events()` calls; imports from `react-native-navigation` | No wrapper component — pass `navigation: Navigation` inside `NavigationOptions` to `setup` |
| Expo Router | `expo-router` in dependencies; an `app/` directory with `_layout.tsx`/`index.tsx` file-based routes; `package.json` `"main": "expo-router/entry"` | Wrap the Root Layout with `WithPendoExpoRouter`, wiring `usePathname()`/`useGlobalSearchParams()` (from `expo-router`) into `props.onExpoRouterStateChange(pathname, params)` |
| React Native Paper (`BottomNavigation` only) | `react-native-paper` in dependencies; `BottomNavigation` imported from `react-native-paper` | Wrap with `WithPendoPaper` — additive to whichever screen-stack library above is also present, since Paper's `BottomNavigation` is a nav *component*, not a full router |
| Other | None of the above match — a custom or unsupported navigation solution | Pass `Other` to `NavigationLibraryType`; codeless screen tracking for this app is not guaranteed |

Source for all five wrapper names/enum values: `api-documentation/rn-apis.md`. Per-flavor Expo detail (which `NavigationLibraryType` value pairs with which Expo variant) from `ios/pnddocs/expo_rn-ios.md`, `expo_rnn-ios.md`, `expo_router-ios.md`.

### Modal detection (additive, independent of the above)
Any of `Modal`, `@gorhom/bottom-sheet` (v4/v5), `react-native-modalize`, `react-native-modal`, `react-native-modals` in dependencies → wrap with `WithPendoModal`, regardless of which navigation library is also in use. Source: `api-documentation/rn-apis.md` (`WithPendoModal` usage list).

Multiple libraries can be true at once (e.g. React Navigation for the screen stack + Paper for a bottom bar + `react-native-modal` for a sheet) — detect and report all matches, not just the first.
