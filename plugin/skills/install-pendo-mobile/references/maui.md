# .NET MAUI — Pendo SDK Install Reference

Read in full once, at `SKILL.md` Phase 2 (that single read is reused by Phase 3's already-installed gate and Phase 6's dispatch — see the phase contract in `SKILL.md`). `subPlatform` is always `null` for `maui` — the wiring point is identical across MVVM and code-behind, so nothing here branches on it.

Entered with `apiKey`, `urlScheme`, `platform` (`maui`), `subPlatform` (`null`), and `branchName` already resolved — do not re-ask for them. Below, `apiKey` and `urlScheme` name those resolved values: wherever they appear in code, write the resolved string as a literal — never leave the identifier in place, and never substitute a value of your own (`"YOUR_API_KEY"`, a made-up scheme, etc.). Phase 5 may legitimately have resolved either to a declared placeholder (`YOUR_API_KEY_HERE` / `YOUR_SCHEME_ID_HERE`) when the user did not have one; if so, write that verbatim like any other resolved value and complete every step as normal — the router reports it. Do not skip the deep-link step, and do not improvise a different value, because what you were handed looks like a placeholder.

## Existing Install Indicators

Check all four before touching anything. If **any** is found, stop per Phase 3 — this repo is already instrumented.

- `pendo-maui` in a `PackageReference` inside any `*.csproj`
- `PendoServiceFactory.CreatePendoService(` anywhere in the app's C# source
- `using PendoMAUIPlugin` anywhere in the app's C# source
- `PendoGateActivity` in `Platforms/Android/AndroidManifest.xml`

## Dependency

Pendo pins no version — its own docs say only "search for `pendo-maui` with latest version", and no file in the source repo states a specific number. **Do not invent one.** Note what that does *not* license: resolving a version is a different act from inventing one, and both routes below leave the resolving to NuGet.

**Preferred — let the tooling write the version:**
```bash
dotnet add package pendo-maui
```
This queries NuGet, resolves the current latest, and writes the concrete `Version` into the `.csproj` itself.

**If that command cannot run**, add the item by hand with a floating version, which still leaves the resolving to NuGet:
```xml
<ItemGroup>
  <PackageReference Include="pendo-maui" Version="*" />
</ItemGroup>
```
Then `dotnet restore`, and pin what it picked: `dotnet list package` prints the resolved version, and replacing `*` with that literal keeps later builds reproducible. (`dotnet add package` builds the project's dependency graph before it writes anything, so it fails outright when the workload for a declared platform is missing — `error NETSDK1147`. That is the case this fallback exists for; `SKILL.md` Phase 1 checks for it up front.)

**Never write the reference with no `Version` attribute at all** — `<PackageReference Include="pendo-maui" />` on its own is `error NU1015` ("the following PackageReference item(s) do not have a version specified") and the project does not restore, so nothing further down this reference is reachable. The one shape where a bare `Include` is valid is a project using Central Package Management, where a `Directory.Packages.props` supplies the version via `<PackageVersion>`; if the repo has that file, add the `PackageVersion` entry there and match the surrounding style. **"Pendo documents no version" is not "write no version"** — the two are unrelated, and conflating them is how this section previously shipped a snippet that could not restore.

- `pendo-maui-binding-android` and `pendo-maui-binding-ios` are transitive dependencies of `pendo-maui` — never add either directly to the `.csproj`.
- `pendo-xamarin-forms` is a different product (Xamarin.Forms, not MAUI) — documented in a separate doc set (`xamarin_forms-ios.md`/`xamarin_forms-android.md`/`xamarin-forms-apis.md`, distinct from the `xamarin_maui-*` files this reference is built from). Out of scope; do not confuse the two packages.
- If the app enables R8/ProGuard for Android release builds, see **ProGuard/R8** below — do not skip it; the same keep rules native Android needs apply here too, MAUI's Android head embeds the same native SDK.

## Initialization

**Factory, not a singleton.** `PendoServiceFactory.CreatePendoService()` returns `IPendoService` — or `null` if the app targets a platform besides iOS/Android (MAUI can target Windows/macOS, where Pendo has no implementation). **The null check is required.**

Goes in `App.xaml.cs`. Add the override if `App : Application` doesn't already have one:

```csharp
using PendoMAUIPlugin;   // service namespace — NOT PendoMaui, see Two Traps below

protected override void OnStart()
{
    IPendoService pendo = PendoServiceFactory.CreatePendoService();
    if (pendo != null)
    {
        pendo.Setup(apiKey);   // apiKey = the resolved value, written as a literal string
    }
}
```

Signatures (`api-documentation/xamarin-maui-apis.md`):
```csharp
interface IPendoService
void Setup(string appKey)
void StartSession(string visitorId, string accountId, Dictionary<string, object> visitorData, Dictionary<string, object> accountData)
```

**Ordering:** `Setup` can only be called once during the application lifecycle (Pendo's API reference states this for every platform, MAUI included), and it must complete before `StartSession` runs. `StartSession` goes wherever the visitor is identified — see `references/identity.md` to locate a real `visitorId`/`accountId` and choose that call site. Whichever method holds that call needs its own `PendoServiceFactory.CreatePendoService()` + null check — this reference does not assume the `OnStart` call site and the `StartSession` call site share a method or a cached instance.

Pendo's own `IPendoService` API-reference sample has a case-mismatch bug: it declares `IPendoService Pendo = PendoServiceFactory.CreatePendoService();` (capital `Pendo`) then checks `if (pendo != null)` (lowercase) — copied verbatim, that does not compile. Keep the variable name consistently cased, as in the sample above.

## Two Traps

1. **Two different namespaces.** The service is `PendoMAUIPlugin` (used above for `Setup`/`StartSession`). The deep-link handler is `PendoMaui` (used below for `InitWithUrl`). Using the wrong one fails to compile.
2. **`InitWithUrl` takes a `string`, not a `URL`.** Call it with `url.AbsoluteString` — an `NSUrl` property that is itself a C# `string` — not the `NSUrl` object. This diverges from native iOS, where `initWith(url)` takes the `URL` directly; do not port that call shape over. `InitWithUrl` also has no formal entry in Pendo's MAUI API reference (`api-documentation/xamarin-maui-apis.md`) — only the single code sample used below, so there's no independently-declared signature to check the call against.

## Deep Links

Split per head — iOS needs an `Info.plist` entry plus a code override; Android needs manifest only.

### iOS

`Platforms/iOS/Info.plist`, edited as raw XML — a .NET MAUI repo contains no `.xcodeproj` or `.xcworkspace`, so there is no Xcode Info tab to do this through. Add inside the root `<dict>`, keeping any `CFBundleURLTypes` entry that is already there:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>pendo-scheme-d</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string><urlScheme></string>
        </array>
    </dict>
</array>
```

Substitute `<urlScheme>` with the real, already-resolved `urlScheme` value — never leave the literal token, never invent a scheme. Verify with `plutil -lint Platforms/iOS/Info.plist` before moving on.

Pendo's MAUI iOS guide gives this step only as Xcode's display labels — a `URL types` array holding a dictionary with a `URL identifier` string beginning with `pendo` (its own example is `pendo-scheme-d`, used above) and a `URL Schemes` array. Those labels correspond to the `CFBundleURLTypes` / `CFBundleURLName` / `CFBundleURLSchemes` keys written above; that mapping is Apple's documented property-list vocabulary, not a Pendo statement.

`AppDelegate.cs`:
```csharp
using PendoMaui;   // deep-link namespace — NOT PendoMAUIPlugin, see Two Traps above

public override bool OpenUrl(UIApplication app, NSUrl url, NSDictionary options)
{
    if (url.Scheme.Contains("pendo"))
    {
        PendoManager.InitWithUrl(url.AbsoluteString);
        return true;
    }
    return base.OpenUrl(app, url, options);
}
```

### Android

Manifest only — **no code**. Inside `<application>` in `Platforms/Android/AndroidManifest.xml`:

```xml
<activity android:name="sdk.pendo.io.activities.PendoGateActivity"
          android:launchMode="singleInstance" android:exported="true">
  <intent-filter>
    <action android:name="android.intent.action.VIEW"/>
    <category android:name="android.intent.category.DEFAULT"/>
    <category android:name="android.intent.category.BROWSABLE"/>
    <data android:scheme="<urlScheme>"/>
  </intent-filter>
</activity>
```

Substitute `<urlScheme>` with the real, already-resolved `urlScheme` value — never leave the literal token, never invent a scheme. Pasted unsubstituted this block is not valid XML, which is deliberate: a scheme that merely *looks* like a value (`android:scheme="urlScheme"`) compiles, ships, and then silently never pairs with Pendo Designer, whereas an unsubstituted token here fails the manifest loudly and immediately.

## ProGuard/R8 — Android head, release builds only

Check the Android head's `.csproj` for `<AndroidLinkTool>r8</AndroidLinkTool>` or `<AndroidLinkTool>proguard</AndroidLinkTool>` (optionally scoped to Release via a `Condition`), or `<AndroidEnableProguard>true</AndroidEnableProguard>` — MAUI's equivalent of Gradle's `minifyEnabled`/`isMinifyEnabled`; `.NET for Android Build Properties` documents both as opt-in, disabled by default. If **none** of these appear, skip this section entirely — do not add a ProGuard config file.

If **present**, the Android head needs Pendo's full ProGuard/R8 configuration — the complete, verbatim contents of `android/pnddocs/pendo-proguard.cfg`, the same rule file native Android uses (MAUI's Android head embeds the same native SDK).

**Check for an existing config first, and append to it rather than replacing it.** Look for any file already listed in a `ProguardConfiguration` item (and, failing that, an existing `Platforms/Android/proguard.cfg`). If one exists, **append** Pendo's rules to it, exactly as `references/android.md` appends to a native project's `proguard-rules.pro` — overwriting it would silently drop the app's own keep rules, and because minification only runs in release builds the loss surfaces as a production-only crash, not a failed build. Only when no config exists at all should a new file be created. Either way place it under `Platforms/Android/` (e.g. `Platforms/Android/proguard.cfg`, alongside `AndroidManifest.xml`) and, if it is not already wired in, wire it up with a `ProguardConfiguration` MSBuild item — `.NET for Android` only applies `@(ProguardConfiguration)` files it's explicitly told about, unlike Gradle's convention-based `proguardFiles` lookup used by the other platforms:
```xml
<ItemGroup>
  <ProguardConfiguration Include="Platforms/Android/proguard.cfg" />
</ItemGroup>
```

`Platforms/Android/proguard.cfg` contents — skipping any of the `-keep`/`-keepattributes` rules below risks R8 stripping or obfuscating Pendo's own SDK classes in the release build specifically: the app still builds and runs fine in debug, so the breakage only surfaces in production:

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

**Addendum — a separate D8/DX-time optimization flag, not part of the keep-rule set above.** Add this to the same config file:
```
-optimizations !code/allocation/variable
```
Without it, D8/DX-time code optimization breaks the SDK. If a `-optimizations` line already exists in the file, append `!code/allocation/variable` to its existing flag list rather than adding a second, competing `-optimizations` line.

Source: `android/pnddocs/pendo-proguard.cfg` (rule content, shared with native Android — MAUI's own docs point at this same file rather than restating the rules). The `AndroidLinkTool`/`AndroidEnableProguard`/`ProguardConfiguration` MSBuild mechanics are general `.NET for Android` tooling knowledge (Microsoft's own build-properties/build-items docs), not Pendo-specific — included here so this step is self-sufficient without a separate lookup.

## No Navigation Instrumentation

Screen tracking on MAUI is fully codeless. There is no observer, HOC, delegate, or navigation-controller equivalent anywhere in Pendo's MAUI docs (guides or API reference) — **do not look for one, and do not invent one** by analogy with Flutter's `PendoNavigationObserver` or React Native's `WithPendoReactNavigation`.

One optional, unrelated extra — document it, do not emit it by default:

- **Gestures** (requires SDK ≥ 3.1), registered once in `MauiProgram.cs`:
  ```csharp
  builder.ConfigureEffects(effects =>
  {
      effects.Add<PendoRoutingEffect, PendoPlatformEffect>();
  });
  ```
  This is for Pendo's Gestures feature, not navigation. Only add it if the app is confirmed to use Pendo Gestures and the installed SDK is 3.1+.

## Minimum Requirements

- `.NET 8 – .NET 10` (stated verbatim, identically, in both the iOS-head and Android-head MAUI guides). Read it from the head project's `TargetFrameworks`.
- Android head: Kotlin `1.9.0` or higher (stated in the MAUI Android guide's requirements block, and nowhere else).
  **There is nothing in a MAUI repo to read this from — do not go looking, and do not report it as unverified.** A MAUI app has no Kotlin sources and no Gradle files at all; its Android head is built by .NET for Android against Pendo's published `pendo-maui-binding-android` AAR, and whichever Kotlin compiled that AAR is sealed inside it, upstream of anything the developer can see or change. So this row is Phase 4's **outcome 4, not applicable** — the value cannot exist in this repo shape — and not outcome 3, indeterminate, which would otherwise park the same line under "Requires your attention" on every MAUI install forever without any action a developer could take to clear it. Report it as satisfied by the binding, not as a gap. (That the floor lives in the AAR is this reference's reading: Pendo states the version and never says where to read it.)
- Nothing else is stated for MAUI in Pendo's docs — no `compileSdk`, `minSdk`, or `Microsoft.Maui.Controls` version appears anywhere in the source repo. Do not assert one.

## Session

For finding a real `visitorId`/`accountId` and choosing the `StartSession` call site (including MAUI's empty-account convention when the app has no account/org concept), see `references/identity.md` — do not restate that logic here.
