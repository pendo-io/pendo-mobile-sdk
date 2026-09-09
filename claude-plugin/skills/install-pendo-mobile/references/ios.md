# Native iOS — Install Reference

Dispatched by `SKILL.md` Phase 6 for `platform = ios`. Entered with `apiKey`, `urlScheme`, and `subPlatform` (`uikit` | `swiftui`) already resolved per the phase contract — never re-ask, never re-detect. Read once in Phase 2 and reused for Phase 3's gate and Phase 6's execution.

Code blocks below use `<API_KEY>`, `<SCHEME>`, and `<CURRENT_VERSION>` as substitution markers. Replace each with the real resolved value before writing the file — never write the literal bracket text into the app, and never invent a value for any of them (Constraints, `SKILL.md`).

`startSession`'s visitor/account identifier and its placement point are resolved by `references/identity.md` — this file only gives the call's signature and type shapes; do not restate identity.md's search/placement logic here.

## Existing Install Indicators

| Indicator | Where to look | Kind |
|---|---|---|
| `import Pendo` or `import PendoSDK` | any `.swift` file | code |
| `PendoManager.shared().setup(` | any `.swift` file | code |
| `PendoManager.shared().startSession(` | any `.swift` file | code |
| `CFBundleURLSchemes` containing a `pendo-` prefixed value | the app target's resolved `Info.plist` — a checked-in file, or the partial plist referenced by `INFOPLIST_FILE` when `GENERATE_INFOPLIST_FILE = YES` (see "Before writing to `Info.plist`" below) | code |
| `XCRemoteSwiftPackageReference "pendo-mobile-sdk"` | `project.pbxproj` | dependency |
| `XCSwiftPackageProductDependency` with `productName = Pendo` | `project.pbxproj` | dependency |
| `/* Pendo in Frameworks */`, `/* Pendo.framework in Frameworks */`, or `/* Pendo.xcframework in Frameworks */` | `project.pbxproj` | dependency |
| `pod 'Pendo'` | `Podfile` | dependency |
| A `Pendo.framework` or `Pendo.xcframework` bundle vendored anywhere in the repo — present on disk rather than resolved by SPM or CocoaPods | filesystem — `find . \( -path '*/Pods' -o -path '*/build' -o -path '*/.build' -o -path '*/DerivedData' -o -path '*/Carthage' -o -path '*/.git' \) -prune -o \( -iname "Pendo.framework" -o -iname "Pendo.xcframework" \) -print` — or a `PBXFileReference` in `project.pbxproj` whose `path` ends in `Pendo.framework`/`Pendo.xcframework`. **The prunes are load-bearing:** CocoaPods materialises `Pendo.framework` under `Pods/`, and build outputs leave copies under `build/`/`DerivedData/`, so an unpruned `find` matches a CocoaPods or already-built install and reports it as vendored — precisely what this row's own wording ("rather than resolved by SPM or CocoaPods") excludes. | dependency |
| `FRAMEWORK_SEARCH_PATHS` value naming Pendo as a path segment (e.g. ending in `.../Pendo.framework`, `.../Pendo.xcframework`, or a vendor directory such as `.../PendoSDK/...`) | any `XCBuildConfiguration`'s `buildSettings` in `project.pbxproj`, or an `.xcconfig` file | dependency |
| `OTHER_LDFLAGS` containing a Pendo linker flag (e.g. `-framework Pendo`) | any `XCBuildConfiguration`'s `buildSettings` in `project.pbxproj`, or an `.xcconfig` file | dependency |

The last three rows exist because manually vendoring a compiled framework is a real install path Xcode has always supported natively, independent of any package manager, predating both CocoaPods and SPM — not a hypothetical. A real app was found with `Pendo.framework` linked exactly this way, via `FRAMEWORK_SEARCH_PATHS`, with no SPM or CocoaPods entry anywhere; none of this file's other dependency-declaration rows matched it. Unlike every other row in this table, these three are not traceable to a Pendo upstream doc describing vendoring as a supported method (the corpus never documents one) — they exist purely because the pattern was directly observed in a real repo, the same basis `references/android.md` already uses for its own not-upstream-confirmed legacy-coordinate row. All three are scoped to the literal token `Pendo`, not a generic pattern: a `FRAMEWORK_SEARCH_PATHS` or `OTHER_LDFLAGS` entry that merely contains the word "framework" is not a match and must not be treated as one — it must name Pendo specifically, the same way every other row here is scoped to Pendo's own literal API/product names rather than a shape any unrelated SDK could coincidentally match.

If **any** row matches, this is Phase 3's stop condition — do not proceed into this file's install steps, regardless of which row matched or which `Kind` it is. Installing Pendo through a second dependency mechanism on top of one already present — SPM alongside a vendored framework, a second CocoaPods entry, or anything else that stacks rather than replaces — is a worse outcome than stopping, so a `dependency`-only match is still a stop, never a signal to proceed because "the code isn't wired yet."

### Reporting the match — name which state this actually is

The rows above cover two different situations, and Phase 8's stop report must say which one was found rather than collapsing both into "already instrumented":

- **A `code` row matched that is an actual SDK call site** — `PendoManager.shared().setup(`, `startSession(`, or the deep-link handler. The SDK is genuinely being invoked. This is a completed install; report it as such: already instrumented, nothing to do.
- **Only the `CFBundleURLSchemes` row matched, with no call site and no `import Pendo`.** A `pendo-` URL scheme in `Info.plist` is *configuration*, not a call: it is what Designer pairing needs, and it can sit in a plist while `setup()` was never written — or be left behind by an install that was reverted in code but not in config. Treat this exactly like the dependency-only case below: a **partial install**, reported as such, naming the scheme found and stating that no SDK call site exists. Never report "already instrumented, nothing to do" on a plist entry alone; analytics do not work in that state, and saying the work is done is the one outcome that guarantees nobody finishes it.
- **Only `dependency` rows matched — no `code` row did.** The dependency is present (via SPM, CocoaPods, or a vendored `Pendo.framework`/`Pendo.xcframework`), but nothing in the app calls the SDK yet. This is a **partial install**, and the report must say so explicitly: name the dependency mechanism found, state plainly that `setup()`/`startSession()`/the deep-link handler are still unwired, and say that this run is stopping rather than layering a second dependency mechanism on top of the one already there. Never emit "this repo is already instrumented — nothing to do" for this case — that line is false here, and tells a developer mid-migration that a half-finished install is complete when it isn't.

This split matters most for the vendored-framework rows specifically: a `Pendo.framework` linked via `FRAMEWORK_SEARCH_PATHS` with no `setup()`/`startSession()` call anywhere is a real, plausible state — mid-migration, or a framework added ahead of writing the init code — not a hypothetical edge case invented for this section.

## API building blocks

From `api-documentation/native-ios-apis.md`:

```swift
func setup(_ appKey: String, with options: PendoOptions?)
func initWith(_ url: URL)
func startSession(_ visitorId: String?, accountId: String?, visitorData: [AnyHashable : Any]?, accountData: [AnyHashable : Any]?)
```

The 2-arg `setup(_:with:)` is the only signature formally documented in the API reference. Every getting-started guide calls the single-arg form instead — `PendoManager.shared().setup("YOUR_API_KEY_HERE")` — which is an (undocumented-in-the-reference) convenience overload, not a separate API. Either is correct; the variants below use the 1-arg form to match upstream's own guide usage.

**`setup` is call-once-only.** The API reference states: "Setup API can only be called once during the application lifecycle." It also warns: "If setup was called while the device is offline, the setup call will fail." Do not add a second `setup` call anywhere, including inside the deep-link handler.

For `startSession`'s real `visitorId`/`accountId` values, where to place the call, and the (not-upstream-sourced) empty-account convention for apps with no account concept, see `references/identity.md`.

## Dependency — pick the first tier that applies, optimising for a durable install verified immediately, not for edit-safety

Do not order these tiers by which edit feels safest to perform. `project.pbxproj` surgery (Tier 2) is the most fragile *edit* in this file, and that fragility is real — but a malformed edit fails loudly, immediately, at the `xcodebuild -resolvePackageDependencies` check this file mandates right after it. A CocoaPods install of Pendo fails silently, later, on someone else's machine, once CocoaPods' registry goes read-only and Pendo stops publishing new SDK versions there (see Tier 3). Prefer the failure that surfaces now over the rot that surfaces later. Concretely: **the presence of a `Podfile` is not, by itself, a reason to install Pendo via CocoaPods.** Plenty of real projects run CocoaPods for legacy dependencies and SPM for newer ones — a `Podfile` says nothing about which package manager *Pendo* should go through. Only reach for Tier 3 when SPM genuinely isn't viable for this project, or the developer explicitly asks for CocoaPods.

**Mixed case — SPM setup *and* a `Podfile` both present (common, and not a special case to hesitate over):** install Pendo via SPM (Tier 1 or Tier 2). The existing `Podfile` keeps serving whatever else it manages; it is simply not Pendo's path in. Also don't conflate a `Podfile.lock` with a `Podfile`: a `Podfile.lock` with no corresponding live `Podfile`/pod usage is a leftover from a prior install, not evidence the project uses CocoaPods — it is not a signal to route Pendo through CocoaPods either.

**The identical mistake runs in the other direction for SPM: a `Package.resolved` is not evidence the project uses SPM.** `Package.resolved` is a lockfile — it records what a *previous* SPM resolution pinned, not whether anything in the project still asks for it. Before treating "SPM setup" as real, confirm there's a **live** reference driving it: a `packageReferences` entry under `PBXProject` in `project.pbxproj` (with a corresponding `XCRemoteSwiftPackageReference`), or a declarative manifest per Tier 1 (`Package.swift`, Tuist, XcodeGen). A `Package.resolved` sitting next to an empty `packageReferences = ( );` is an orphaned artifact from a dependency that was removed without deleting its lockfile — reading it as "this project uses SPM" is the same error as reading a stray `Podfile.lock` as "this project uses CocoaPods," just for the other package manager. Treat Tier 1/Tier 2 as applicable only once you've confirmed a live reference, never from `Package.resolved`'s mere presence.

### Tier 1 — declarative manifest

If the app (or an internal package it depends on) is configured through one of these, edit it directly — the Xcode project file is generated from it, so editing `project.pbxproj` instead would be immediately overwritten on next generation.

**`Package.swift`** (app or internal Swift package):
```swift
dependencies: [
    .package(url: "https://github.com/pendo-io/pendo-mobile-sdk", .upToNextMajor(from: "<CURRENT_VERSION>"))
],
targets: [
    .target(
        name: "YourApp",
        dependencies: [
            .product(name: "Pendo", package: "pendo-mobile-sdk")
        ]
    )
]
```

**Tuist** — check which manifest exists first; syntax differs by Tuist version. If an existing external dependency is already declared somewhere in the repo, copy its exact pattern instead of the templates below.

`Tuist/Package.swift` (Tuist ≥ 4, external packages manifest):
```swift
let package = Package(
    name: "YourApp",
    dependencies: [
        .package(url: "https://github.com/pendo-io/pendo-mobile-sdk", .upToNextMajor(from: "<CURRENT_VERSION>"))
    ]
)
```
and in `Project.swift`, add to the target's dependencies:
```swift
.target(
    name: "YourApp",
    dependencies: [
        .external(name: "Pendo")
    ]
)
```

`Dependencies.swift` (older Tuist):
```swift
let dependencies = Dependencies(
    swiftPackageManager: .init([
        .remote(url: "https://github.com/pendo-io/pendo-mobile-sdk", requirement: .upToNextMajor(from: "<CURRENT_VERSION>"))
    ]),
    platforms: [.iOS]
)
```

**XcodeGen** (`project.yml`):
```yaml
packages:
  Pendo:
    url: https://github.com/pendo-io/pendo-mobile-sdk
    from: <CURRENT_VERSION>
targets:
  YourApp:
    dependencies:
      - package: Pendo
        product: Pendo
```

**Version note — do not skip:** no file in Pendo's SDK repo states a minimum/floor SDK version for iOS (an earlier version of this skill twice shipped an invented floor — do not repeat that). Use SPM's "Up to Next Major Version" rule. For `<CURRENT_VERSION>`, the sourced reference point is `3.13.9` — the root `Package.swift` of `pendo-io/pendo-mobile-sdk` currently pins its `binaryTarget` to `3.13.9.12418` — but confirm the actual latest tag against the live repo (e.g. `git ls-remote --tags https://github.com/pendo-io/pendo-mobile-sdk`) before writing it in, since this will drift as Pendo ships releases and this doc will not be updated in lockstep.

**URL trap:** the canonical SPM URL, used by Pendo's own current getting-started guide (`ios/pnddocs/native-ios.md`), is `https://github.com/pendo-io/pendo-mobile-sdk`. Pendo's own `migration-docs/cocoapods-to-spm-migration.md` tells readers to search for a *different* URL, `https://github.com/pendo-io/pendo-mobile-ios` — that is the repository's pre-rename name; GitHub's redirect makes it still resolve, but it is not the name to use. If you consult Pendo's upstream docs directly while doing this install, use the `pendo-mobile-sdk` URL only.

### Tier 2 — SPM via `project.pbxproj` surgery (the normal path when there's no declarative manifest)

**This is the most fragile edit in the whole skill — handle it carefully and verify immediately, don't avoid it at the cost of a rotting install.** `project.pbxproj` is a hand-editable but not hand-*friendly* plist-like format; a single malformed brace or duplicate UUID can make the project fail to open in Xcode with no useful diagnostic. That's a real cost, but it's a cost paid once, up front, and caught immediately by the `xcodebuild -resolvePackageDependencies` check below — not a reason to fall back to Tier 3 just because a `Podfile` happens to exist. Use this tier whenever Tier 1's declarative manifest doesn't apply, and verify with `xcodebuild -resolvePackageDependencies` immediately after — do not defer that check to Phase 7.

Generate three unique 24-character uppercase hex UUIDs (Xcode's own object-ID format — 12 random bytes, hex-encoded, uppercased):
```bash
openssl rand -hex 12 | tr '[:lower:]' '[:upper:]'
```
Run it three times for `[BuildFile UUID]`, `[PackageRef UUID]`, `[ProductDep UUID]`. Before using each, `grep` the target `project.pbxproj` for the value to confirm it doesn't already exist (collision is astronomically unlikely with 12 random bytes, but free to check).

**Insertion point 1 — new `PBXBuildFile` entry.** Find the block delimited by `/* Begin PBXBuildFile section */` … `/* End PBXBuildFile section */` and add a line inside it:
```
[BuildFile UUID] /* Pendo in Frameworks */ = {isa = PBXBuildFile; productRef = [ProductDep UUID] /* Pendo */; };
```

**Insertion point 2 — new `XCRemoteSwiftPackageReference` + `XCSwiftPackageProductDependency` entries.** These sections may not exist yet if this is the app's first SPM dependency — if either `/* Begin XCRemoteSwiftPackageReference section */` or `/* Begin XCSwiftPackageProductDependency section */` is absent, create it (conventionally placed near the end of the file, just before `/* Begin PBXProject section */`):
```
[PackageRef UUID] /* XCRemoteSwiftPackageReference "pendo-mobile-sdk" */ = {
    isa = XCRemoteSwiftPackageReference;
    repositoryURL = "https://github.com/pendo-io/pendo-mobile-sdk";
    requirement = {
        kind = upToNextMajorVersion;
        minimumVersion = <CURRENT_VERSION>;
    };
};
[ProductDep UUID] /* Pendo */ = {
    isa = XCSwiftPackageProductDependency;
    package = [PackageRef UUID] /* XCRemoteSwiftPackageReference "pendo-mobile-sdk" */;
    productName = Pendo;
};
```
Use the same `<CURRENT_VERSION>` resolved in Tier 1's version note — do not hardcode a different number here.

**Insertion point 3 — append to `PBXFrameworksBuildPhase.files`.** Inside `/* Begin PBXFrameworksBuildPhase section */` … `/* End PBXFrameworksBuildPhase section */`, the app target's phase object has a `files = ( ... );` array — append:
```
[BuildFile UUID] /* Pendo in Frameworks */,
```

**Insertion point 4 — append to `PBXProject.packageReferences`.** Inside `/* Begin PBXProject section */` … `/* End PBXProject section */`, the single `PBXProject` object may not yet have a `packageReferences = ( ... );` field — add it (as a sibling of `mainGroup`/`targets`) if absent, then append:
```
[PackageRef UUID] /* XCRemoteSwiftPackageReference "pendo-mobile-sdk" */,
```

**Always run afterward, to prove the file still parses:**
```bash
xcodebuild -resolvePackageDependencies
```
If this fails, the edit was malformed — do not proceed to Phase 6's remaining steps or Phase 7 with a broken project file.

### Tier 3 — CocoaPods (only when SPM genuinely isn't viable, or the developer explicitly asks for CocoaPods)

```ruby
pod 'Pendo'
```
then `pod install`.

Reach for this tier only when Tier 1 and Tier 2 are both genuinely unworkable for this project (or the developer explicitly requests CocoaPods) — **not merely because a `Podfile` already exists.** A `Podfile` in the repo is not evidence that Pendo belongs there: CocoaPods and SPM routinely coexist in the same app (legacy pods alongside newer SPM packages), and a leftover `Podfile.lock` with no live pod usage isn't even evidence the project uses CocoaPods at all.

**Never introduce CocoaPods to a repo that doesn't already use it.** CocoaPods' registry goes read-only in December 2026, and Pendo will stop publishing new SDK versions to it (`ios/pnddocs/native-ios.md`, `migration-docs/cocoapods-to-spm-migration.md`). If there's no existing `Podfile`, use Tier 1 or Tier 2 instead — do not create one. This is exactly why this tier is a last resort rather than the default whenever a `Podfile` is present: an app installed this way builds fine today and simply stops receiving Pendo SDK updates once the registry goes read-only, with nothing in the build to flag it.

## Init variants — pick by `subPlatform` and lifecycle

`subPlatform = swiftui` → Variant C, always.
`subPlatform = uikit` → Variant A or B, chosen by the lifecycle signals in `references/detection.md` §4: `SceneDelegate.swift` exists **and** implements `scene(_:willConnectTo:options:)` → Variant B. Neither present → Variant A.

### Variant A — UIKit, AppDelegate-only

All Pendo code lives in `AppDelegate.swift`.

```swift
import Pendo

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    PendoManager.shared().setup("<API_KEY>")
    // startSession: see references/identity.md for the real visitor/account identifier and placement tier.
    return true
}

func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    if url.scheme?.range(of: "pendo") != nil {
        PendoManager.shared().initWith(url)
        return true
    }
    return false
}
```

Note: Pendo's own `native-ios.md` sample returns `true` unconditionally from this handler, including the non-matching branch — that reads as a copy/paste artifact in their doc, since returning `true` for a URL the app didn't actually handle violates `UIApplicationDelegate`'s own contract (the OS won't try any other handler). This reference returns `false` in the non-matching branch instead.

### Variant B — UIKit with SceneDelegate

**All Pendo code goes in `SceneDelegate.swift`. None in `AppDelegate.swift`.** Wiring `setup`/`startSession`/the URL handler into `AppDelegate` here compiles and runs, but `scene(_:willConnectTo:options:)` is the callback that actually fires for scene-based apps — an install split across both files produces a build that reports success and never pairs.

```swift
import Pendo

func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    PendoManager.shared().setup("<API_KEY>")
    // startSession: see references/identity.md for the real visitor/account identifier and placement tier.
}

func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    if let url = URLContexts.first?.url, url.scheme?.range(of: "pendo") != nil {
        PendoManager.shared().initWith(url)
    }
}
```

### Variant C — SwiftUI

Both the `@UIApplicationDelegateAdaptor` bridge and `.onOpenURL` are required — SwiftUI's `App` protocol has no `application(_:open:options:)`-equivalent callback of its own, so without `.onOpenURL` the deep link is never received.

```swift
import Foundation
import UIKit
import Pendo

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        PendoManager.shared().setup("<API_KEY>")
        // startSession: see references/identity.md for the real visitor/account identifier and placement tier.
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme?.range(of: "pendo") != nil {
            PendoManager.shared().initWith(url)
            return true
        }
        return false
    }
}
```

```swift
@main
struct YourApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    _ = appDelegate.application(UIApplication.shared, open: url, options: [:])
                }
        }
    }
}
```

**Guardrail — do not add `.pendoEnableSwiftUI()`.** It is deprecated from SDK 3.1: "The SDK automatically performs the logic, removing the need to use this API. Calling it will be ignored." (`api-documentation/native-ios-apis.md`, `ios/pnddocs/native-ios.md`). Pendo's own `native-ios.md` still shows this call in one pairing-mode snippet elsewhere in that doc — if you consult it directly, do not carry that call into this install; it is a no-op on any current SDK version and adding it is dead code, not a fix for anything.

## Before writing to `Info.plist` — confirm Xcode will actually read it

**Do this before writing anything in the "Deep link — `Info.plist`" section below.** A standalone `Info.plist` file only affects the built app if a build setting actually points at it. Any target created on Xcode 13+ with no checked-in `Info.plist` — the default for a fresh target, and common on greenfield SwiftUI apps — instead has `GENERATE_INFOPLIST_FILE = YES`: Xcode synthesizes the plist at build time from build settings, and there is no checked-in file for a hand-written edit to land in. Create a standalone `Info.plist` on such a target anyway, and nothing will reference it: the build still passes, `setup()` still runs, and Designer pairing silently never works because the URL scheme never reached the built app.

**Determine which mechanism the app target actually uses, authoritatively, before editing anything:**

```bash
xcodebuild -showBuildSettings -project <YourApp>.xcodeproj -target <AppTargetName> | grep -E 'INFOPLIST_FILE|GENERATE_INFOPLIST_FILE'
```

Prefer this over grepping `project.pbxproj` text directly — resolved build settings can come from an `.xcconfig` file or a scheme/configuration-specific override that a raw text scan of the pbxproj won't reflect, and this is the actual value Xcode builds with.

**Read both lines of that output together.** `GENERATE_INFOPLIST_FILE` alone does not determine which case applies — the two settings combine into four states, and branching on `GENERATE_INFOPLIST_FILE` alone (ignoring what `INFOPLIST_FILE` also resolves to) is exactly how a real, already-effective plist gets silently orphaned. This has happened on a real app: `GENERATE_INFOPLIST_FILE = YES` **and** `INFOPLIST_FILE` resolving to a real, substantial, already-shipping file at the same time — a third combination a two-way `YES`/`NO` branch has no room for.

| `GENERATE_INFOPLIST_FILE` | `INFOPLIST_FILE` resolves to an existing file? | State | Go to |
|---|---|---|---|
| `NO` / absent | Yes | **Checked-in only** | "Checked-in `Info.plist`" |
| `NO` / absent | No path set at all | **Neither / ambiguous** | Stop — see below |
| `YES` | No (absent, or a path with nothing there yet) | **Generated only** | "Generated `Info.plist`" |
| `YES` | Yes | **Both — the real file wins** | "Checked-in `Info.plist`" |

- **Checked-in only.** Xcode reads that file, full stop. Proceed to "Checked-in `Info.plist`" below and edit it directly.
- **Generated only.** Xcode is synthesizing the plist from build settings and there is no existing file to land an edit in. **Do not create a standalone `Info.plist` in this case, and do not flip `GENERATE_INFOPLIST_FILE` to `NO`** — both reproduce or cause a silent-failure mode. This is also not a case for setting `INFOPLIST_KEY_CFBundleURLTypes`: `INFOPLIST_KEY_*` build settings only carry scalar values, and `CFBundleURLTypes` is an array of dictionaries — Xcode silently drops an unrecognized `INFOPLIST_KEY_*` setting with no error and no warning (Apple, "Managing your app's information property list values": "Xcode doesn't use values from user-defined build settings when it generates the information property list, even if you create settings with the `INFOPLIST_KEY_` prefix"). Proceed to "Generated `Info.plist`" below instead — Apple documents a merge mechanism for exactly this case, and it does not require disabling generation.
- **Both — the real file wins.** `GENERATE_INFOPLIST_FILE = YES` does not mean there is no file to edit. If `INFOPLIST_FILE` already resolves to a real, existing file, that file is already Xcode's merge target — this is the identical mechanism the "Generated `Info.plist`" section's own partial-plist technique relies on below, just already set up by something else already present in the project (a prior manual step, another SDK's integration, etc.), commonly with real, working keys already in it. **Edit that file directly, exactly like "Checked-in `Info.plist`" below, preserving every key already in it.** Do **not** create a second, separate partial plist and repoint `INFOPLIST_FILE` at it — `INFOPLIST_FILE` resolves to exactly one file, so doing so does not add a second source, it silently replaces the first: every key already in the real file (including anything having nothing to do with Pendo) drops out of the build the moment the setting moves, with no error anywhere. Leave `GENERATE_INFOPLIST_FILE` untouched either way, same as Constraint (a) below.
- **Neither / ambiguous.** `GENERATE_INFOPLIST_FILE` is `NO`/absent and `INFOPLIST_FILE` has no path at all (not merely a declared path whose file hasn't been created yet — that's still "Checked-in only," see the create-it-there note below). Nothing here matches either documented mechanism: no file is being read, and Xcode is not generating one either. Do not guess which one this is "supposed to be" and do not create a file speculatively. **Stop and hand off**: report the app target's name and the literal values found for both settings under "Requires your attention," and ask the developer to confirm how this target's `Info.plist` is actually produced (a custom build phase, a misconfigured `.xcconfig`, or a genuinely broken target are all possible) before any deep-link configuration is attempted.

**Multi-target repos:** the same repo commonly has several targets — the app, unit tests, UI tests, extensions, widgets — each with its own independent `INFOPLIST_FILE`/`GENERATE_INFOPLIST_FILE` value. Run the `-showBuildSettings` check above against the **app target specifically** (the one with an application product type, matching the scheme a user actually builds and runs) — not a test target or extension. Editing whichever plist a test target or extension resolves to, instead of the app target's, silently fixes nothing: the app itself still ships with no URL scheme.

## Deep link — `Info.plist`

Which of the two subsections below applies was already decided by the check in "Before writing to `Info.plist`" above — do not re-derive it here. Two of the four states from that check land here; "Neither / ambiguous" already stopped before reaching this section and has no subsection of its own.

### Checked-in `Info.plist`

Applies to two of the four states above: **Checked-in only** (`GENERATE_INFOPLIST_FILE` `NO`/absent, `INFOPLIST_FILE` resolving to a real, existing path), and **Both** (`GENERATE_INFOPLIST_FILE = YES` *with* `INFOPLIST_FILE` also resolving to a real, existing path — the real file wins; see the state table above for why this is not routed to "Generated `Info.plist`" instead). The edit is identical in both cases: edit that exact file directly, and leave `GENERATE_INFOPLIST_FILE` exactly as found — untouched in the first case because it's already `NO`/absent, and deliberately left `YES` in the second per the "Both" note above.

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
            <string><SCHEME></string>
        </array>
    </dict>
</array>
```
`CFBundleURLName` value `pendo-pairing` and `CFBundleTypeRole` value `Editor` come from Pendo's own guide ("Identifier `pendo-pairing`", App Target > Info > URL Types). `<SCHEME>` is the resolved `urlScheme`.

**If `INFOPLIST_FILE` pointed at a path with no file there yet and it had to be created**, also set `CFBundleIdentifier` to `$(PRODUCT_BUNDLE_IDENTIFIER)` and `CFBundleExecutable` to `$(EXECUTABLE_NAME)` — without these two keys the app will not launch at all. (This is a general Xcode/`Info.plist` requirement, not a Pendo-specific fact.)

### Generated `Info.plist` (`GENERATE_INFOPLIST_FILE = YES`, no existing file)

Applies only to the **Generated only** state above: `GENERATE_INFOPLIST_FILE = YES` **and** `INFOPLIST_FILE` does not already resolve to an existing file. If `INFOPLIST_FILE` *does* already resolve to a real file, that's the **Both** state — go to "Checked-in `Info.plist`" above instead, and do not create the new partial plist described below; it would silently orphan the file already in use. **Automate this — it is not a case for stopping.** Apple documents a merge mechanism for adding a key `INFOPLIST_KEY_*` can't carry (see above) onto a generated plist: a small partial `Info.plist` containing only the extra key(s), referenced via the target's `INFOPLIST_FILE` build setting, with `GENERATE_INFOPLIST_FILE` left `YES`. Xcode then merges the partial file's keys with everything it synthesizes — nothing generated is lost. This is Apple-documented behavior (see the Sources section at the end of this file), additionally confirmed by reproducing it end-to-end in a real Xcode build — not merely read from docs.

Three steps. Each of the three constraints below is a documented, silent (or, per the third, community-reported) failure mode if skipped — do not treat any of them as optional.

**Step 1 — write the partial plist, containing `CFBundleURLTypes` and nothing else.** Place it alongside the app target's other source files (e.g. next to `AppDelegate.swift`), named `PendoURLTypes.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleURLName</key>
            <string>pendo-pairing</string>
            <key>CFBundleTypeRole</key>
            <string>Editor</string>
            <key>CFBundleURLSchemes</key>
            <array>
                <string><SCHEME></string>
            </array>
        </dict>
    </array>
</dict>
</plist>
```
Same `CFBundleURLName`/`CFBundleTypeRole`/`<SCHEME>` values as the checked-in case above. **Do not add any other key to this file** — `CFBundleIdentifier`, `CFBundleExecutable`, and everything else are already synthesized by Xcode from build settings; duplicating them here only risks a conflicting value for no benefit.

**Step 2 — constraint (a) and (b): point `INFOPLIST_FILE` at it on *every* `XCBuildConfiguration` of the app target, and never touch `GENERATE_INFOPLIST_FILE`.** In `project.pbxproj`:
1. Find the app target's `PBXNativeTarget` entry (the one with `productType = "com.apple.product-type.application"`, matching the app target confirmed above — not a test target or extension) and read its `buildConfigurationList` UUID.
2. Find the `XCConfigurationList` with that UUID; its `buildConfigurations` array lists one UUID per configuration — typically Debug and Release, but include every one listed, including any custom configurations.
3. For **each** of those `XCBuildConfiguration` blocks (inside `/* Begin XCBuildConfiguration section */` … `/* End XCBuildConfiguration section */`), add one line to that block's `buildSettings = { ... };`:
   ```
   INFOPLIST_FILE = "<AppTargetDir>/PendoURLTypes.plist";
   ```
   using a path relative to the project directory, in the same style as this target's other file-valued build settings (or, if the project routes this target's settings through an `.xcconfig` file instead of literal `buildSettings` in `project.pbxproj`, add the line there instead, matching that file's existing convention).

   **Constraint (a) — do not add, remove, or edit a `GENERATE_INFOPLIST_FILE` line anywhere in this edit.** Leaving it `YES`, untouched, is what makes this a merge instead of a replace; flipping it to `NO` (the intuitive-looking fix) discards every key Xcode was synthesizing — `CFBundleExecutable`, `CFBundleIdentifier` from `$(PRODUCT_BUNDLE_IDENTIFIER)`, and every other `INFOPLIST_KEY_*`-driven key already in use (e.g. `NSCameraUsageDescription`) — unless every one of them is hand-reproduced in the new file, which step 1 explicitly says not to do.

   **Constraint (b) — every configuration, not just one.** Setting `INFOPLIST_FILE` on Debug but not Release (or vice versa) is the classic half-fix: the build works in whichever configuration got the edit and silently ships with no URL scheme in the others. Verify each configuration was actually touched before moving on — do not assume the first edit "took" for all of them.

**Step 3 — constraint (c): give the new plist no build-phase membership.** Do not add `PendoURLTypes.plist` to the app target's Copy Bundle Resources build phase — no `PBXBuildFile` entry for it, and no entry in any `PBXResourcesBuildPhase.files` array. (A bare `PBXFileReference`, for Xcode Navigator visibility only, is fine and optional — the build-phase membership is the part that must not exist.) Apple's docs state the reason directly: "Don't add the property list file to your target. If you do, Xcode copies it into the Resources folder of your bundle, which isn't the correct location for the file. Additionally, Xcode copies the file without processing its values." On iOS's flat bundle layout specifically, this reportedly escalates further, from a warning into a hard `"Multiple commands produce '.../Info.plist'"` build failure — **this escalation is community-reported (multiple independent Apple Developer Forum threads), not Apple-documented or independently verified against a real iOS target**, unlike everything else in this subsection.

If whatever tool or method is editing `project.pbxproj` cannot guarantee this file is added without build-phase membership (e.g. a generic "add file to Xcode project" script that defaults to Copy Bundle Resources for any newly-referenced file) — **that specific limitation, not the mechanism itself, is the right reason to stop and surface it under "Requires your attention"** instead of risking a broken build: report that the app target uses a generated `Info.plist`, that the URL scheme needs the partial-plist merge above, and that the developer should add `PendoURLTypes.plist` with `INFOPLIST_FILE` pointed at it on every configuration and confirm it has no Copy Bundle Resources membership before building.

**Verify before moving on — do not assume the merge worked:**
```bash
xcodebuild -showBuildSettings -project <YourApp>.xcodeproj -target <AppTargetName> | grep -E 'INFOPLIST_FILE|GENERATE_INFOPLIST_FILE'
```
Confirm `INFOPLIST_FILE` now resolves to the new partial plist's path and `GENERATE_INFOPLIST_FILE` is still `YES`. This is cheap and catches a malformed edit immediately, rather than waiting for Phase 7's full build verification at the end of the whole install.

## Minimum requirements (informational — `SKILL.md` Phase 4 already gates the floor)

- Deployment target `iOS 11` or higher (`Package.swift` hard-codes `platforms: [.iOS(.v11)]`; Phase 4 checks `IPHONEOS_DEPLOYMENT_TARGET`).
- Swift `5.7`+, Xcode `14`+.
- No SDK package version floor is documented anywhere — see Tier 1's version note. Do not assert one.

Source: `ios/pnddocs/native-ios.md`.

## Sources

- `ios/pnddocs/native-ios.md` — https://raw.githubusercontent.com/pendo-io/pendo-mobile-sdk/master/ios/pnddocs/native-ios.md
- `api-documentation/native-ios-apis.md` — https://raw.githubusercontent.com/pendo-io/pendo-mobile-sdk/master/api-documentation/native-ios-apis.md
- `migration-docs/cocoapods-to-spm-migration.md` — https://raw.githubusercontent.com/pendo-io/pendo-mobile-sdk/master/migration-docs/cocoapods-to-spm-migration.md
- `migration-docs/ios-2.x-to-3.x-migration.md` — https://raw.githubusercontent.com/pendo-io/pendo-mobile-sdk/master/migration-docs/ios-2.x-to-3.x-migration.md
- Root `Package.swift` — https://raw.githubusercontent.com/pendo-io/pendo-mobile-sdk/master/Package.swift

The generated-`Info.plist` merge mechanism above is sourced from Apple, not the Pendo corpus, and was additionally confirmed against a real Xcode build (not just read from docs):
- Apple, "Managing your app's information property list values" — https://developer.apple.com/documentation/bundleresources/managing-your-app-s-information-property-list
- Apple, "CFBundleURLTypes" reference — https://developer.apple.com/documentation/bundleresources/information-property-list/cfbundleurltypes
- Apple, "Defining a custom URL scheme for your app" — https://developer.apple.com/documentation/xcode/defining-a-custom-url-scheme-for-your-app
