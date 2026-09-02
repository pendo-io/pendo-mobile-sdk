# Android Native — Install Reference

Entered from `SKILL.md` Phase 2 (read once, in full) and executed from Phase 6, with `apiKey`, `urlScheme`, `platform="android"`, `subPlatform` (`kotlin` | `java`), and `branchName` already resolved and in scope — never re-ask for them, never re-run detection. Wherever code below shows `"<apiKey>"` or `"<urlScheme>"` (quoted, angle-bracket), that is a string-literal template slot: write the real, already-resolved value as the literal string content; never write the literal angle-bracket token into a file.

All SDK facts below are sourced from `pendo-io/pendo-mobile-sdk` (`android/pnddocs/native-android.md`, `api-documentation/native-android-apis.md`, `android/pnddocs/pendo-proguard.cfg`), cited inline. Do not add facts from any other source.

## Existing Install Indicators

Phase 3 stops the whole run if **any** of these are found — check all of them:

- Maven repo `https://software.mobile.pendo.io/artifactory/androidx-release` in any `build.gradle`/`build.gradle.kts`
- Dependency group `sdk.pendo.io`, artifact `pendoIO` (current SDK coordinate)
- Legacy dependency coordinate `io.pendo:pendo-android-sdk` (older Pendo Android package name, per this skill's detection requirements — not independently confirmed in the upstream corpus extract; treat a match the same as the current coordinate)
- `import sdk.pendo.io.Pendo` (or any `sdk.pendo.io.*` import) in a `.kt`/`.java` file
- `Pendo.setup(` anywhere in the app module
- `Pendo.startSession(` anywhere in the app module
- `Pendo.setComposeNavigationController(` anywhere in the app module (legacy Compose wiring — still counts as installed even though current SDKs ignore it)
- `PendoGateActivity` in `AndroidManifest.xml`

## 1. Sub-platform and UI framework — two independent axes

- **`subPlatform` (`kotlin`/`java`)** — resolved by `SKILL.md`'s phase contract, governs which language the code samples below use. If an Application subclass **already exists**, write into it in *its own* language regardless of `subPlatform` (don't introduce a second-language file just to match the repo's dominant language). Only use `subPlatform` to choose the language when **creating** a new Application class.
- **UI framework (Views / Compose / hybrid)** — a separate axis, not part of `subPlatform`. Resolve with `references/detection.md` §5 when not obvious from a quick scan (`setContentView` vs `setContent`, `androidx.compose.*` in `build.gradle[.kts]`). Screen/navigation tracking is **automatic for both** Views and Compose — this axis only changes whether the optional manual-tagging note in §5 below applies, and whether the legacy §6 Compose-navigation step is even relevant.

## 2. Dependency

Dependency line in **map form**, not the `"group:name:version"` shorthand string — the corpus explicitly notes Pendo's own docs use the map form.

Pendo's docs show exactly one repository form — `exclusiveContent`/`filter`, never a bare `maven {}` block. `exclusiveContent` is a Gradle DSL feature that requires Gradle ≥ 6.2 (Gradle's own 6.2 release notes). That floor is never a concern here: `SKILL.md` Phase 4 already hard-stops before this reference is ever read if the project's AGP is below **8.0**, and AGP 8.0 itself requires Gradle ≥ 8.0 (an Android/Gradle compatibility fact, not a Pendo one) — well above what `exclusiveContent` needs. So by the time this file is reached, the project's Gradle version is always well above 6.2, and there is nothing to branch on:

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

dependencies {
    implementation group: 'sdk.pendo.io', name: 'pendoIO', version: '3.13.+', changing: true
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

dependencies {
    implementation(group = "sdk.pendo.io", name = "pendoIO", version = "3.13.+") {
        isChanging = true
    }
}
```

`3.13.+` and `changing`/`isChanging: true` are exactly what the docs pin, in both forms — don't substitute a different version. `changing: true` tells Gradle this coordinate's content can mutate even though the version string (`3.13.+`) looks fixed, so Gradle revalidates it against the remote repo on each build instead of caching it forever as immutable — without it, a real `3.13.x` patch release could silently never reach the build.

If the app module has its own `build.gradle[.kts]` distinct from the root, add the `dependencies { }` block there and the `repositories { }` block wherever the project already declares repositories (root `settings.gradle[.kts]` `dependencyResolutionManagement`, or the root/app build file — match the existing project's pattern, don't invent a new one).

**Do not modify `compileSdkVersion` or `minSdkVersion`.** These are the target app's own settings and were already checked against the Global Constraints in Phase 4 (`minSdkVersion ≥ 21`, `compileSdkVersion ≥ 35`) before this reference was ever reached. If you notice either value falls short while editing this file, that should already have surfaced in Phase 4 — report it under "Requires your attention" in the Phase 8 report; never bump the value yourself.

**Additional version note, only if relevant:** SDK 3.13.0+ pulls in a `androidx.room` dependency internally (2.6.0+). If the app already depends on Room directly, confirm its version is ≥2.6.0 to avoid a resolution conflict; otherwise this is transitive and needs no action.

## 3. Initialize — Application class + `setup()`

Signature (`api-documentation/native-android-apis.md`):
```java
static synchronized void setup(Context context, String appKey, PendoOptions options, PendoPhasesCallbackInterface pendoPhasesCallback)
```
Guide usage passes `null` for both `options` and `pendoPhasesCallback` — that's the documented baseline call shape, not a placeholder:
```kotlin
Pendo.setup(this, "<apiKey>", null, null)
```

**Must be called from the Application class's `onCreate()`, after `super.onCreate()`.** Per the corpus's cross-platform finding, Android's API reference states setup is call-once-only for the app's lifetime — this is also why Phase 3's indicator gate above must catch an existing `Pendo.setup(` call before this step ever runs.

**Find or create the Application class:**
1. Check `AndroidManifest.xml`'s `<application>` tag for an `android:name` attribute. If present, that's the existing Application subclass — open it, add `import sdk.pendo.io.Pendo` (Kotlin: no trailing `;`; Java: with it), add an `onCreate()` override if none exists, and insert the `Pendo.setup(...)` call as the first line after `super.onCreate()`.
2. If `android:name` is absent, no custom Application class exists — create one:
   - **Derive the class name from the app itself**, never a generic name like `MyApplication`/`YourAppNameApplication`: read `android:label` from the `<application>` tag (resolving a `@string/xxx` reference against `res/values/strings.xml` if needed), strip non-alphanumeric characters, PascalCase the words, append `Application` — e.g. "Acme Shop" → `AcmeShopApplication`. If `android:label` doesn't resolve to a usable name, fall back to the last segment of the applicationId, PascalCased, plus `Application` — e.g. `com.acme.shop` → `ShopApplication`.
   - Place the new file in the same package as the app's launcher Activity (the one whose `<intent-filter>` has `action.MAIN` + `category.LAUNCHER`).
   - Register it: `android:name=".AcmeShopApplication"` (or the fully qualified name if it lives outside that package) on the manifest's `<application>` element.

Kotlin:
```kotlin
class AcmeShopApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        Pendo.setup(this, "<apiKey>", null, null)
    }
}
```

Java:
```java
public class AcmeShopApplication extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        Pendo.setup(this, "<apiKey>", null, null);
    }
}
```

(`AcmeShopApplication` above is illustrative only — always derive the real name per the rule above; never write this literal name into the repo.)

## 4. Session — `startSession`

Signature, shown only for cross-reference (`api-documentation/native-android-apis.md`):
```java
static void startSession(final String visitorId, final String accountId, final Map<String, Object> visitorData, final Map<String, Object> accountData)
```
Everything about *where* this call goes, *which* visitor/account identifier to use, and the per-platform empty-account convention when the app has no account concept is governed entirely by `references/identity.md` — read it in full and follow it; do not re-derive or restate any of that logic here.

## 5. Compose navigation — legacy path, SDK < 3.12 only (omit by default)

`Pendo.setComposeNavigationController(...)` is **not** merely unnecessary on current SDKs — per the API reference it is **"Deprecated from SDK 3.12.+. The SDK automatically performs the logic, removing the need to use this API. Calling it will be ignored."** Since this skill installs `3.13.+`, this whole step is **skipped by default** — do not emit it as a normal install step.

Only surface it if this specific repo is pinning a Pendo Android SDK version below 3.12 (e.g. an existing `sdk.pendo.io:pendoIO` dependency already present at a pre-3.12 version that the install is deliberately not upgrading). In that case: this corpus extract confirms the method name and its version gate, but does not carry a verified call-site code sample for it — don't fabricate one. State the constraint to the user (method name, deprecation boundary, and Pendo's own recommendation to wire it *before* the `startSession` call so the SDK captures the correct initial screen: "set up Compose navigation before calling startSession") and point them to Pendo's current docs for the exact call shape rather than emitting unverified code.

Compose baseline tracking needs none of this: navigation is auto-detected, and `Modifier.pendoTag(UNIQUE_IDENTIFIER)` (manual click-tracking/tooltip anchors) plus `Modifier.pendoStateModifier(componentState)` (Drawer/`ModalBottomSheetLayout` detection) are optional gap-fillers, not required for a baseline install, on GA since SDK 3.7.0+.

## 6. Deep link — `PendoGateActivity` manifest block

Verbatim, inside `<application>` in `AndroidManifest.xml`:
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
Substitute `<urlScheme>` with the real, already-resolved `urlScheme` value — never leave the literal token, never invent a scheme.

## 7. ProGuard — only when minification is enabled

Check the app module's `build.gradle[.kts]` release `buildTypes` block for `minifyEnabled true` (Groovy) or `isMinifyEnabled = true` (Kotlin DSL). If **absent**, skip this step entirely — do not touch `proguard-rules.pro`.

If **present**, append Pendo's full ProGuard/R8 configuration below to the app module's `proguard-rules.pro` (the file referenced by that same `buildTypes` block's `proguardFiles`) — this is the complete, verbatim contents of `android/pnddocs/pendo-proguard.cfg`, not a partial excerpt. Skipping any of the `-keep`/`-keepattributes` rules below risks R8 stripping or obfuscating Pendo's own SDK classes in the release build specifically: the app still builds and runs fine in debug, so the breakage only surfaces in production.

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

**Addendum — a separate D8/DX-time optimization flag, not part of the keep-rule set above.** Pendo documents this one on its own, distinct from `pendo-proguard.cfg`'s keep rules; add it to the same `proguard-rules.pro`:
```
-optimizations !code/allocation/variable
```
Without it, D8/DX-time code optimization breaks the SDK. If a `-optimizations` line already exists in the file, append `!code/allocation/variable` to its existing flag list rather than adding a second, competing `-optimizations` line.

## Handback for Phase 8

Return, for the router's report:
- Every file touched (`build.gradle[.kts]`, the Application class — created or edited — `AndroidManifest.xml`, `proguard-rules.pro` if touched) with a one-line reason each.
- Whether the Compose-navigation legacy step (§5) was surfaced and why, if applicable.
- Whether `startSession` was wired, and if not, `references/identity.md` §5's exact unwired-report format (tiers searched, what's missing, what the developer must supply) — verbatim, don't paraphrase it into something vaguer.
