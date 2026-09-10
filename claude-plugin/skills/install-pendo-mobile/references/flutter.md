# Flutter — Pendo Mobile SDK Install Reference

Entered at Phase 6 with `apiKey`, `urlScheme`, `platform=flutter`, `subPlatform=null`, `branchName` already resolved (`SKILL.md`, phase contract) — do not re-ask for them or re-run detection here.

If this repo embeds Flutter as a module inside a native host app (hybrid mode) rather than being a Flutter-owned app, stop: Pendo's docs say hybrid mode is not self-serve ("To support hybrid mode in Flutter, please open a ticket" — `ios/pnddocs/flutter-ios.md`). This should already have been caught by `references/detection.md` §1 before dispatch; if it wasn't, stop now instead of proceeding.

## Existing Install Indicators

Any one of these found anywhere in the repo means Pendo is already installed — stop per Phase 3, change nothing:

- `pendo_sdk:` under `dependencies:` in `pubspec.yaml`
- `import 'package:pendo_sdk/pendo_sdk.dart'` in any `.dart` file
- `PendoSDK.setup(` call anywhere (normally an entry point under `lib/` — `main.dart`, or a per-flavor `main_<flavor>.dart`)
- `PendoSDK.startSession(` call anywhere
- `PendoNavigationObserver` referenced anywhere
- `PendoActionListener` referenced anywhere
- `addPendoListenerToDelegate` referenced anywhere
- `sdk.pendo.io.activities.PendoGateActivity` in `android/app/src/main/AndroidManifest.xml`
- A URL Type whose identifier/scheme starts with `pendo` in `ios/Runner/Info.plist`

## Dependency (`pubspec.yaml`)

```bash
flutter pub add pendo_sdk
```

This edits `pubspec.yaml` and fetches the package in one step (no separate `flutter pub get` needed). **Pendo's docs never show a version constraint** — the getting-started guides only ever show the bare `flutter pub add pendo_sdk` command, with no version anywhere in the example. Running that command still writes a caret-pinned version into `pubspec.yaml` (e.g. `pendo_sdk: ^3.13.5`) — that's `pub add`'s own normal behavior, and the pin it produces is correct and expected, not something to "fix" back to unpinned afterward. What the docs not showing a version constraint actually rules out is picking one yourself: never hand-write a version constraint into `pubspec.yaml` (e.g. typing in `^3.5.0`) — none is sourced, and inventing one would misrepresent what Pendo's docs actually say. Let `pub add` choose the version; never type one yourself. Source: `ios/pnddocs/flutter-ios.md`, `android/pnddocs/flutter-android.md`.

Android additionally needs the Maven repository block (same as native Android) in the **project-level** Android build file — `android/build.gradle` (Groovy) or `android/build.gradle.kts` (Kotlin DSL); a Flutter app's Android head may use either. Add it wherever the project already declares its repositories (that build file, or `android/settings.gradle[.kts]`'s `dependencyResolutionManagement` block on newer templates) — match the existing project's pattern, don't invent a new one. **Both candidates are under `android/`.** A Flutter app's Gradle root is `android/`, not the repo root: `android/settings.gradle[.kts]` is the settings file Gradle actually evaluates for the Android head, while a repo-root `settings.gradle` either does not exist or belongs to something else entirely (an enclosing monorepo, a melos/pub workspace). Editing a repo-root file here changes nothing about the Android build and leaves the real one untouched.

Pendo's docs show exactly one repository form — `exclusiveContent`/`filter`, never a bare `maven {}` block (see `references/android.md` §2 for the full rationale on why there's no fallback — same rule, repeated here because this file is read standalone). Only the `repositories { }` block is needed here — Pendo's Flutter docs never show a separate `dependencies { implementation ... }` line for the Android head the way the native-Android install does; do not add one.

**The blocks below are the target state of the declaration site, not text to paste blindly.** Every app scaffolded by `flutter create` already ships `allprojects { repositories { google(); mavenCentral() } }` in `android/build.gradle`, so pasting a whole `repositories { }` block into it produces either a nested `repositories { repositories { … } }` — a Gradle configuration error — or a redundant second `mavenCentral()`. Read them as: this is what the site must contain when you are finished.

**Groovy** (`build.gradle`):
```groovy
repositories {
    exclusiveContent {
        forRepository {
            maven { url 'https://software.mobile.pendo.io/artifactory/androidx-release' }
        }
        filter {
            includeGroup "sdk.pendo.io"
        }
    }
    mavenCentral()
}
```

**Kotlin DSL** (`build.gradle.kts`):
```kotlin
repositories {
    exclusiveContent {
        forRepository {
            maven { url = uri("https://software.mobile.pendo.io/artifactory/androidx-release") }
        }
        filter {
            includeGroup("sdk.pendo.io")
        }
    }
    mavenCentral()
}
```
Both forms copied verbatim from `references/android.md` §2 so the two files can't drift. Source: `android/pnddocs/flutter-android.md` (repository form and rationale).

**So, concretely — when a `repositories { }` block already exists** at the declaration site (the common case), add **only** the `exclusiveContent { … }` chunk inside it and leave everything already there — `google()`, `mavenCentral()`, any custom repos — untouched:

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

(Kotlin DSL: the same chunk in the `url = uri("…")` / `includeGroup("sdk.pendo.io")` spelling shown in the full block above.) Only when the declaration site has no `repositories { }` block at all do you add one, in the complete form above. Either way the end state matches the target blocks, and `mavenCentral()` appears exactly once.

## Setup (the app's entry point(s))

Call exactly one of these three forms — after `WidgetsFlutterBinding.ensureInitialized()`, before `runApp()`:

```dart
await PendoSDK.setup('<API_KEY>');                                                 // default Navigator
await PendoSDK.setup('<API_KEY>', navigationLibrary: NavigationLibrary.GoRouter);   // GoRouter
await PendoSDK.setup('<API_KEY>', navigationLibrary: NavigationLibrary.AutoRoute);  // AutoRoute
```

Pick the form matching whichever navigation library `pubspec.yaml` already depends on: `go_router` → the GoRouter form, `auto_route` → the AutoRoute form, neither → the default form. `<API_KEY>` is the Pendo integration key resolved in Phase 5 — write that resolved value as the string content, never one of your own invention. If Phase 5 resolved it to the declared placeholder `YOUR_API_KEY_HERE` because the user did not have a key to hand, write that verbatim and complete every step as normal; the router reports it as a placeholder install.

Full placement — in each entry point that needs it, per the enumeration below:

```dart
import 'package:flutter/material.dart';
import 'package:pendo_sdk/pendo_sdk.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PendoSDK.setup('<API_KEY>');

  runApp(const MyApp());
}
```

Note the entry point's own signature usually has to change with it: a synchronous `void main() {` becomes `Future<void> main() async {` so the `await` is legal.

### Find every entry point first — `lib/main.dart` is the default, not the only one

`flutter run` and `flutter build` both take `--target <file>`, and flavored apps ship one entry point per environment (`lib/main_development.dart`, `lib/main_staging.dart`, `lib/main_production.dart`, …), each launched with its own `--target`. **A launch through `--target lib/main_staging.dart` never executes `lib/main.dart` at all**, so an install that only touched `lib/main.dart` leaves the SDK uninitialized on every flavored launch — while `PendoActionListener` and the navigation listener still run against it.

Enumerate the entry points before editing anything:

```bash
grep -rnE "^(void|Future<void>) main\(" lib/
```

(loosen the pattern if the app declares `main` some other way — the point is to find every top-level `main`, not to trust one regex), and check how the app is actually launched — its `README`, `.vscode/launch.json`, `*.iml` run configs, `Makefile`, and CI workflow files, for `--target` arguments.

Then classify each one you found:

- **Terminal entry point** — its `main()` calls `runApp()` itself. **Each of these gets its own `setup()` call**, in the same shape as the sample above.
- **Delegating entry point** — its `main()` only forwards to another entry point's `main()` (e.g. `lib/main.dart` whose whole body is `development.main();`). **Do not add `setup()` here.** The entry point it forwards to already carries the call; adding it in both means two `setup()` calls on one launch.
- **Shared bootstrap** — if every entry point routes through one common async bootstrap helper before `runApp()`, put a single `setup()` call in that helper and none in the entry points.

**`setup()` is call-once-only for the application lifecycle, Flutter included** — Pendo's iOS, Android, Flutter, React Native, and MAUI docs each separately state the setup call can only be made once. The rule that enforces this is about execution paths, not files: **every way the app can launch must reach exactly one `setup()` call — never zero, never two.** Several `setup()` calls across several entry points are correct as long as no single launch runs two of them (each `--target` starts its own process, so each executes exactly one entry point's `main()`); two calls on one launch path — the delegating-entry-point trap above — is the violation. When you are done, walk the list you enumerated and confirm each entry point reaches the call exactly once.

**No build can catch a missed entry point.** Phase 7 builds the default target only, so an app whose developers always launch with `--target` will build green with the SDK never initializing. This enumeration is the only check there is.

**Documented discrepancy — do not "fix" this against the API reference.** `api-documentation/flutter-apis.md`, Pendo's formal API reference page, declares the signature as `static Future<void> setup(String appKey, {Map<String, dynamic>? pendoOptions}) async` — no `navigationLibrary` parameter at all — and it never mentions `NavigationLibrary`, `addPendoListenerToDelegate`, `PendoNavigationObserver`, or `PendoActionListener` anywhere. The `navigationLibrary` parameter shown above, and Flutter's entire navigation-instrumentation surface below, exist only in the two platform guides (`ios/pnddocs/flutter-ios.md`, `android/pnddocs/flutter-android.md`). This is a real, upstream-confirmed gap in Pendo's own documentation, not a transcription error in this file — follow the guides' form above.

## Navigation instrumentation (mutually exclusive by library)

Which of these applies is determined by the `navigationLibrary` argument passed to `setup()` above. **Never wire more than one of the three** — Pendo's docs present them as alternative paths selected via that single parameter, never combined in any example (the docs don't use the literal phrase "mutually exclusive," but no example ever mixes them).

**Default `Navigator`** (no `navigationLibrary` argument) — add `PendoNavigationObserver()` to `navigatorObservers` on **every** `Navigator` in the app, root and nested:
```dart
MaterialApp(
  navigatorObservers: [PendoNavigationObserver()],
  home: const HomePage(),
)
```

**GoRouter** ≥ 13.0 (`navigationLibrary: NavigationLibrary.GoRouter`) — call `addPendoListenerToDelegate()` on the router instance, **exactly once per instance, at that instance's construction site**. Whatever shape the app uses, the cascade goes on the `GoRouter(...)` expression itself.

*Single long-lived router (top-level `final`, or a `late final` field):*
```dart
final GoRouter _router = GoRouter(
  routes: [ /* existing routes unchanged */ ],
)..addPendoListenerToDelegate();
```

*Router produced by a factory function — including one that takes injected dependencies and is called from `build()`:*
```dart
GoRouter router(AuthRepository authRepository) => GoRouter(
  refreshListenable: authRepository,
  routes: [ /* existing routes unchanged */ ],
)..addPendoListenerToDelegate();
```
The cascade sits inside the factory, on the constructor call, so every router it produces is attached to exactly once. **Do not hoist the router to a top-level `final` to avoid a `build()`-time call** — that rewrites the app's dependency injection and breaks constructor arguments like `refreshListenable`, which need the scoped instance. Leave the app's router lifetime exactly as you found it; if the app rebuilds its router on every rebuild, that is pre-existing app behavior and not this install's to change.

**AutoRoute** ≥ 7.0 (`navigationLibrary: NavigationLibrary.AutoRoute`) — call `addPendoListenerToDelegate()` on the router config, exactly once:
```dart
final AppRouter _router = AppRouter()..config().addPendoListenerToDelegate();
```

For both GoRouter and AutoRoute, Pendo's guides say: "Make sure to add it once (e.g., adding it in the build method will be less desired)". What that rules out is **re-attaching to an already-constructed router** — `_router..addPendoListenerToDelegate();` written inside a `build()`, `didChangeDependencies()`, or any other method that re-runs on rebuild, which re-attaches to one long-lived instance every time it runs. Attaching at the construction site is always correct, including when that construction site is a factory `build()` calls: each call constructs a new router and attaches to it once. If the only construction site in the app is inside a factory, that is where the cascade goes — there is no shape here that requires refactoring the app to satisfy the rule.

*Provenance:* "exactly once per instance" is this file's reading of that upstream sentence, not upstream wording. It is consistent with the shipped package — `pendo_sdk` 3.13.5's `addPendoListenerToDelegate()` (`lib/src/nested_branches_observer.dart`) removes its own listener before adding it, commented "avoid potential issue of double listeners" — but treat that as corroboration, not as licence to call it repeatedly.

**Additive, regardless of which form above applies:**
- Custom navigation widgets (`TabBar`, `BottomNavigationBar`, `PageView`) need `PendoCustomNavigationWidget`/`PendoNavigationState`/`getPendoCustomNavigationInfo()` (SDK ≥ 3.6.2).
- Give every `Route` a unique `name` in its `RouteSettings` — Pendo identifies routes by name — including routes opened via `showModalBottomSheet`.

Source for this section: `ios/pnddocs/flutter-ios.md`, `android/pnddocs/flutter-android.md`.

## `PendoActionListener` (mandatory, Flutter-only — no equivalent on any other platform)

Wrap the **root widget returned from `build()`** — `MaterialApp`, `MaterialApp.router`, or `CupertinoApp` — **not** the argument passed to `runApp()`. The string `runApp` appears nowhere in Pendo's docs; the wrap happens one level down, inside whichever widget's `build()` method constructs the app's root:

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return PendoActionListener(
      child: MaterialApp(
        // existing app config unchanged
      ),
    );
  }
}
```

For GoRouter/AutoRoute apps using `MaterialApp.router`, wrap that instead:
```dart
    return PendoActionListener(
      child: MaterialApp.router(
        routerConfig: _router,
      ),
    );
```

`runApp(const MyApp());` itself is left untouched. This wrap is required for click tracking on every navigation flavor above and is independent of which `navigationLibrary` was selected.

## Native sides (hand-edited — no Dart API covers these)

### Android
Same wiring as native Android, on top of the Maven repo block already added under Dependency. In `android/app/src/main/AndroidManifest.xml`, inside `<application>`:
```xml
<activity android:name="sdk.pendo.io.activities.PendoGateActivity" android:launchMode="singleInstance" android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.VIEW"/>
        <category android:name="android.intent.category.DEFAULT"/>
        <category android:name="android.intent.category.BROWSABLE"/>
        <data android:scheme="<URL_SCHEME>"/>
    </intent-filter>
</activity>
```
Replace `<URL_SCHEME>` with the resolved `urlScheme`. Source: `android/pnddocs/flutter-android.md` (identical XML to native Android's own block).

**ProGuard/R8 — only when minification is enabled.** Check the Android head's app-module `build.gradle[.kts]` release `buildTypes` block for `minifyEnabled true` (Groovy) or `isMinifyEnabled = true` (Kotlin DSL). If **absent**, skip this step entirely — do not touch `android/app/proguard-rules.pro`.

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

**Addendum — a separate D8/DX-time optimization flag, not part of the keep-rule set above.** Add this to the same `proguard-rules.pro`:
```
-optimizations !code/allocation/variable
```
Without it, D8/DX-time code optimization breaks the SDK. If a `-optimizations` line already exists in the file, append `!code/allocation/variable` to its existing flag list rather than adding a second, competing `-optimizations` line.

Source: `android/pnddocs/flutter-android.md`, `android/pnddocs/pendo-proguard.cfg` — the same rule file native Android uses; Flutter's Android head embeds the same native SDK the rules were written for.

No manifest permission (e.g. `INTERNET`, `ACCESS_NETWORK_STATE`) is stated anywhere in the fetched native-Android or Flutter-Android docs — do not add either on the assumption it's required; it is not sourced.

### iOS
`ios/Runner/Info.plist` — same URL Types entry as native iOS. Add inside the root `<dict>`:
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>pendo-pairing</string>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string><URL_SCHEME></string>
        </array>
    </dict>
</array>
```
`CFBundleURLName` value `pendo-pairing` and `CFBundleTypeRole` value `Editor` come from Pendo's own guide, identical to native iOS's own block (`references/ios.md`). Replace `<URL_SCHEME>` with the resolved `urlScheme` — never leave the literal token. Source: `ios/pnddocs/flutter-ios.md`.

`ios/Runner/AppDelegate.swift` — the Flutter-generated `AppDelegate` already subclasses `FlutterAppDelegate`, so the override needs both `override` and a `super` fallback (unlike native iOS's own non-Flutter sample, which falls through to a bare `return true`):
```swift
import Pendo

class AppDelegate: FlutterAppDelegate {
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme?.range(of: "pendo") != nil {
            PendoManager.shared().initWith(url)
            return true
        }
        return super.application(app, open: url, options: options)
    }
}
```
Source: `ios/pnddocs/flutter-ios.md`. Calling `super` matters here specifically because `FlutterAppDelegate` has its own `open url:` handling — not falling back to it (as the plain native-iOS sample does) would break Flutter's own URL handling for any other URL scheme the app uses.

**Do not edit the iOS `Podfile`.** The `pendo_sdk` plugin's own podspec pulls in the native Pendo iOS SDK as a transitive dependency; a manual `pod 'Pendo'` line is the native-iOS install path, not Flutter's plugin-mediated one, and adding it risks a duplicate-symbol conflict. This constrains what **you** write. The Flutter tool rewrites the `Podfile` itself during the build — see "Files the build changes on its own" below — and that churn is not a breach of this rule and must not be reverted.

## Minimums

| Requirement | Floor |
|---|---|
| Flutter | ≥ 3.16.0 |
| Dart | ≥ 3.2.0 (`>=3.2.0 <4.0.0`) |
| GoRouter (if used) | ≥ 13.0 |
| AutoRoute (if used) | ≥ 7.0 |
| Android head — AGP | ≥ 8.0 |
| Android head — Kotlin | ≥ 1.9.0 |
| Android head — Java | ≥ 11 |
| Android head — minSdkVersion | ≥ 21 |
| Android head — compileSdkVersion | ≥ 35 |

Verbatim source for Flutter/Dart: `Flutter: ">=3.16.0"`, `SDK (Dart): ">=3.2.0 < 4.0.0"` (`ios/pnddocs/flutter-ios.md`, `android/pnddocs/flutter-android.md`). Android floors are restated in the same two files, identical to native Android's own minimums.

**iOS deployment target is not directly sourced for Flutter.** Pendo's Flutter docs restate the Android native floor explicitly but never separately restate an iOS deployment-target floor for Flutter. Native iOS's own documented floor (`iOS 11`, confirmed independently by the SDK's `Package.swift`: `platforms: [.iOS(.v11)]`) almost certainly still applies underneath, since Flutter's iOS plugin wraps the same native SDK — but treat that as inherited by implication, not a directly-sourced Flutter-specific claim. This matches `SKILL.md` Phase 4's note on this exact point; do not restate it there as if newly confirmed.

iOS dependency manager: CocoaPods by default. Swift Package Manager is available as an opt-in but requires Flutter ≥ 3.24 on the host app — a separately higher floor than the plugin's own 3.16.0 minimum, relevant only if opting into SPM.

Superseded, do not use: `migration-docs/flutter-2.x-to-3.x-migration.md` states an older Flutter `3.3.0`/Dart `2.18` floor — that was the 2.x→3.0 baseline and is superseded by the `3.16.0`/`3.2.0` floors above.

## Session (`startSession`)

```dart
static Future<void> startSession(String? visitorId, String? accountId, Map<String, dynamic>? visitorData, Map<String, dynamic>? accountData) async
```
Source: `api-documentation/flutter-apis.md`. Parameters are positional, not named: call as `PendoSDK.startSession(visitorId, accountId, visitorData, accountData)`.

For finding the app's real `visitorId`/`accountId` and choosing where in the app this call belongs, see `references/identity.md` — do not re-derive that search/placement logic here. Its per-platform empty-account convention table gives the Flutter-specific `accountId`/`accountData` values to pass when the app has no account/organization concept at all; those two values are conventions matched to this signature's `String?`/`Map<String, dynamic>?` parameter types, not something Pendo's docs themselves specify — identity.md states that plainly, and this file does not repeat or re-assert it as a Pendo mandate.

## Files this typically touches

- `pubspec.yaml` — add the `pendo_sdk` dependency
- every terminal entry point under `lib/` (`main.dart` and/or `main_<flavor>.dart` — see "Find every entry point first") — the `setup()` call
- wherever the root widget's `build()` and the router live (often `lib/main.dart`) — navigation-observer/listener wiring, `PendoActionListener` wrap
- `android/build.gradle` or `android/build.gradle.kts` — Maven repository block
- `android/app/src/main/AndroidManifest.xml` — `PendoGateActivity` entry
- `ios/Runner/Info.plist` — URL Types entry
- `ios/Runner/AppDelegate.swift` — deep-link `open url:` override
- wherever the real `visitorId`/`accountId` is resolved (per `references/identity.md`) — the `startSession()` call, or left unwired with that fact reported under "Requires your attention" if no real identifier exists

## Files the build changes on its own

Phase 7's build is not read-only. `flutter build ios` runs the Flutter tool's own project migrations first, so the working tree ends up dirtier than the install made it — through no action of yours. **When you report the diff, separate this churn from your own edits instead of claiming or omitting it.** The tool announces each migration on stdout (`Upgrading Podfile`, `Upgrading project.pbxproj`, `… uses the deprecated @UIApplicationMain attribute, updating`, `Adding Swift Package Manager integration`), so the build log tells you which changes were the tool's.

Observed on a Flutter 3.44 build of an app scaffolded by an older Flutter — modified:

- `ios/Podfile` (deployment target raised)
- `ios/Flutter/AppFrameworkInfo.plist`
- `ios/Flutter/Generated.xcconfig`, `ios/Flutter/flutter_export_environment.sh`
- `ios/Runner.xcodeproj/project.pbxproj`
- `ios/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme`
- `ios/Runner.xcworkspace/contents.xcworkspacedata`
- `ios/Runner/AppDelegate.swift` (`@UIApplicationMain` → `@main`, on top of your own edit to this file)

and added: `ios/Podfile.lock`, `ios/Flutter/Flutter.podspec`, and two `xcshareddata/swiftpm/Package.resolved` files.

The exact set depends on the Flutter version and how old the project's scaffolding is — an app generated by the same Flutter version needs no migrations and shows none of this. Treat the list as what to expect, not as exhaustive: check the build's own output for `Upgrading`/`updating` lines, and never revert a file the tool rewrote in order to make the diff look smaller.
