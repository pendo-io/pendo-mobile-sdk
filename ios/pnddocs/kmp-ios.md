# Kotlin Multiplatform (KMP) — iOS

>[!IMPORTANT]
> These instructions cover the **iOS target of a Kotlin Multiplatform (KMP) app that uses native UI** (SwiftUI/UIKit on iOS, Jetpack Compose/Views on Android) — **not** Compose Multiplatform. For the Android side of the same project, see [Kotlin Multiplatform (KMP) — Android](/android/pnddocs/kmp-android.md).

>[!WARNING]
>**CocoaPods Deprecation Notice:** CocoaPods has announced that their registry will become read-only in December 2026. Pendo will stop publishing new SDK versions to CocoaPods. Existing CocoaPods versions will remain available and installations will remain functional. We highly recommend migrating to Swift Package Manager (SPM) as soon as possible. See our [CocoaPods to SPM Migration Guide](/migration-docs/cocoapods-to-spm-migration.md) for more details.

>[!IMPORTANT]
><b>SwiftUI</b> codeless solution is fully supported from `iOS 15`. <br/> <b>SwiftUI</b> screen navigation tracking is available from `iOS 13`.

>[!IMPORTANT]
>Requirements:
>- Deployment target of `iOS 11` or higher 
>- Swift Compatibility `5.7` or higher
>- Xcode `14` or higher

The Pendo SDK is a native platform SDK: it hooks into the `UIApplication` lifecycle and the UIKit/SwiftUI view hierarchy. In a KMP project you therefore add Pendo to your **iOS app (the Xcode project, e.g. `iosApp`)** exactly as you would in any native iOS app — KMP does not change how the SDK is integrated, and it is independent of how your shared Kotlin framework is linked. Your shared (`commonMain`) module stays Pendo-agnostic. If you want to emit analytics *from* shared code, see [Step 6](#step-6-optional-emit-analytics-from-shared-code).

## Step 1. Add the Pendo SDK

Add Pendo to your **iOS app (Xcode project)**.

### Swift Package Manager (recommended):

1. Open _File -> Add Packages_.
2. Search for: `https://github.com/pendo-io/pendo-mobile-sdk`.
3. Select _Up to Next Major Version_.

### Cocoapods:

1. Open the _Podfile_.  
2. Add: `pod 'Pendo'`.

## Step 2. Establish a connection to Pendo's server on app launch

>[!NOTE]
>Find your API key in the Pendo UI under `Settings` > `Subscription settings` > select an app > `App Details`.

A KMP iOS app is typically a pure **SwiftUI** app whose entry point is a `struct` attributed with `@main`, which has no `AppDelegate` or `SceneDelegate` by default. Create an `AppDelegate` and attach it with `@UIApplicationDelegateAdaptor`, then call `setup` from `didFinishLaunchingWithOptions`.

1. Create the `AppDelegate` and call `setup`:

    ```swift
    import UIKit
    import Pendo

    class AppDelegate: NSObject, UIApplicationDelegate {
        func application(_ application: UIApplication,
                         didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
            PendoManager.shared().setup("YOUR_API_KEY_HERE")
            //  your code here ...
            return true
        }
    }
    ```

2. Attach the `AppDelegate` to your SwiftUI `@main` app:

    ```swift
    import SwiftUI

    @main
    struct iOSApp: App {
        @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
        var body: some Scene {
            WindowGroup {
                ContentView()
            }
        }
    }
    ```

> [!NOTE]
> If your SwiftUI `@main` `App` already has an `init()` (for example to bootstrap dependency injection), keep it — just add the `@UIApplicationDelegateAdaptor` property and the `AppDelegate`. They coexist: the `App`'s `init()` runs first, then the `AppDelegate`'s `didFinishLaunchingWithOptions`.

> [!NOTE]
> If your iOS app instead uses a classic `AppDelegate` or `SceneDelegate` (UIKit lifecycle), call `PendoManager.shared().setup("YOUR_API_KEY_HERE")` from `didFinishLaunchingWithOptions` or `scene(_:willConnectTo:options:)` respectively.

## Step 3. Start a new session to track a visitor and to display guides

To begin tracking a visitor's analytics and to display guides, call the `startSession` API. It can be called immediately after `setup` or anywhere else in your code, such as after completing the login process of your app.

```swift
let visitorId = "John Doe"
let accountId = "ACME"
let visitorData: [String : any Hashable] = ["age": 27, "country": "USA"]
let accountData: [String : any Hashable] = ["Tier": 1, "size": "Enterprise"]
PendoManager.shared().startSession(visitorId, accountId:accountId, visitorData:visitorData, accountData:accountData)
```

**visitorId**: a user identifier (e.g., John Smith)  
**visitorData**: the user metadata (e.g., email, phone, country, etc.)  
**accountId**: an affiliation of the user to a specific company or group (e.g., Acme inc.)  
**accountData**: the account metadata (e.g., tier, level, ARR, etc.)

>[!TIP]
>To begin a session for an  <a href="https://support.pendo.io/hc/en-us/articles/360032202751" target="_blank">anonymous visitor</a>, pass ```nil``` or an empty string ```""``` as the Visitor ID. You can call the `startSession` API more than once and transition from an anonymous session to an identified session (or even switch between multiple identified sessions).

## Step 4. Tag and track your SwiftUI UI

In a native-UI KMP project the iOS app's UI is **SwiftUI**. Pendo tracks most navigation automatically; this step covers what it can't detect on its own and how to tag it.

SwiftUI Page-change tracking is based on the events emitted by these navigation components: `NavigationView`, `NavigationStack`, `NavigationSplitView`, `TabView`, `NavigationLink`, `ActionSheet`, `Sheets`, `.alert`, `.confirmationDialog` and `PopOvers`. Under the hood SwiftUI still uses UIKit navigation, so Pendo tracks those changes automatically by identifying each Page with a unique identifier extracted from the declarative definition of the Page or the underlying structure of your app. Rendering new views on the same Page is **not** tracked automatically.

### Specific limitations

1. **Page changes**
   - If your app renders new views conditionally or dynamically (e.g. `ZStack` views you treat as distinct Pages) *without* using the standard navigation containers above, Pendo might not recognize this as a distinct Page change. To track these as separate Pages, designate them with the [`.trackPage(pageId: "page_id")`](/api-documentation/native-ios-apis.md#viewtrackpage) modifier. Ensure the `pageId` is unique across your application.
   - If a tagged Page identifier such as `retroactiveScreenId` or `swiftUIIdentifier` is not unique enough, enhance it by selecting a unique Page Identifier in the Pendo web designer, or apply your own via [`.trackPage(pageId: "page_id")`](/api-documentation/native-ios-apis.md#viewtrackpage).

2. **Tagging** — Pendo's Feature tagging relies on iOS accessibility services (accessibilityHint, accessibilityIdentifier, accessibilityLabel, and user interactions). While iOS usually provides these by default, some UI elements may not be tagged as expected. In such cases use the `pendoRecognizeClickAnalytics()` modifier, which creates an accessibility element, combines its children, and marks it as userInteractionEnabled so Pendo can identify it as taggable.

3. **Container views** — container views with `TapGesture` modifiers don't always generate underlying accessibility elements and may fail to be tagged as clickable (they are purely declarative). Examples: `VStack`, `HStack`, `ZStack`, `LazyHStack`, `LazyVStack`, `LazyVGrid`, `GeometryReader`, `LazyHGrid`. Apply the [`.pendoTag("your-tag")`](/api-documentation/native-ios-apis.md#viewpendotag) modifier on the specific element for a stable, uniquely-identified click event.

4. **`Menu` / `.contextMenu`** — SwiftUI's `Menu` and `.contextMenu` (and the UIKit `UIContextMenuInteraction` they're backed by) are not auto-tagged; their items live in a system-owned presentation outside the app view hierarchy. Wrap the trigger view with [`.pendoTag("your-tag")`](/api-documentation/native-ios-apis.md#viewpendotag); clicks on the menu trigger are then reported under the supplied tag.

### Tagging modifiers

- [`pendoTag("your-tag")`](/api-documentation/native-ios-apis.md#viewpendotag) — attaches a unique, stable identifier to a View so Pendo reports clicks under the supplied tag:
  ```swift
  Button("Submit") { submit() }
      .pendoTag("checkout-submit-button")
  ```
- [`trackPage(pageId: "page_id")`](/api-documentation/native-ios-apis.md#viewtrackpage) — manually designate a view as a Page with a unique name when the SDK can't uniquely identify it.
- `pendoRecognizeClickAnalytics()` — helps recognize clickable views that aren't automatically tagged; it applies Apple's accessibility APIs to combine child elements and mark them as a button. If you prefer not to use a Pendo API, apply the native modifiers yourself:
  ```swift
  .accessibilityElement(children: .combine)
  .accessibilityAddTraits([.isButton])
  ```
- [`pendoSkipAccessibilityScan()`](/api-documentation/native-ios-apis.md#viewpendoskipaccessibilityscan) — bypasses Pendo's accessibility scan for a view's hosting controller. Use it to prevent main-thread layout-invalidation hangs on iOS 26 when rendering complex, nested lazy containers (`LazyVStack`, `LazyHStack`) that load or mutate state on appear:
  ```swift
  ScrollView {
      LazyVStack {
          ForEach(items) { item in
              ItemRow(item: item)
                  .onAppear { loadMore(item) }
          }
      }
  }
  .pendoSkipAccessibilityScan()
  ```

### Troubleshooting SwiftUI tagging

- **Missing accessibility traits** — container views with an `.onTapGesture` modifier might not be tagged automatically. Add accessibility traits so the SDK identifies them as interactive:
  ```swift
  .accessibilityElement(children: .combine)
  .accessibilityAddTraits([.isButton])
  ```
- **Elements inside overlays** — Pendo detects elements within most SwiftUI `Overlays`. If elements inside an overlay are not taggable (the overlay isn't part of the top-most view controller's hierarchy), enable `pendoOptions.scanFromRootViewController`. This performs a deeper scan of the view hierarchy and may impact performance, so use it only when necessary.
- **Performance (especially on iPads)** — to improve performance, disable some of what Pendo collects while scanning a Page by setting `enableTextCollectionSwiftUI` to false:
  ```swift
  let options = PendoOptions()
  options.configs = ["enableTextCollectionSwiftUI": false]
  PendoManager.shared().setup("YOUR_API_KEY_HERE", with: options)
  ```
  Feature analytics will then be based only on accessibility data.
- **Main-thread hangs on lazy containers (Apple bug FB21851974)** — on iOS 26, screens with nested `LazyVStack`/`LazyHStack` that load or mutate state on `.onAppear` can hang due to a SwiftUI accessibility-layout bug triggered by any accessibility client (VoiceOver, Accessibility Inspector, or the Pendo scanner). Apply [`.pendoSkipAccessibilityScan()`](/api-documentation/native-ios-apis.md#viewpendoskipaccessibilityscan) on the view to bypass the scan while keeping the screen discoverable and trackable.

## Step 5. Configure Pairing Mode for tagging and testing

>[!NOTE]
>Find your scheme ID in the Pendo UI under `Settings` > `Subscription settings` > select an app > `App Details`.

For additional information, see <a href="https://support.pendo.io/hc/en-us/articles/360033609651-Tagging-Mobile-Pages#HowtoTagaPage" target="_blank">page tagging</a>
and <a href="https://support.pendo.io/hc/en-us/articles/360033487792-Creating-a-Mobile-Guide#test-guide-on-device-0-6" target="_blank">guide testing</a>.

### Add the Pendo URL scheme to the **info.plist** file

Navigate to your **App Target > Info > URL Types** and create a new URL by clicking the plus (+) button.

Set the **Identifier** to `pendo-pairing` or an identifiable name of your choosing.  
Set **URL Scheme** to `YOUR_SCHEME_ID_HERE`.

### Configure the SwiftUI app to connect to Pairing Mode

Because the SwiftUI `@main` app does not respond to `application(_:open:options:)`, forward pairing deep links using the `.onOpenURL()` modifier on your main view, and handle the URL in the `AppDelegate`.

1. Handle the URL in the `AppDelegate`:

    ```swift
    import Pendo

    // in AppDelegate
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        if url.scheme?.range(of: "pendo") != nil {
            PendoManager.shared().initWith(url)
            return true
        }
        return false
    }
    ```

2. Forward deep links from the SwiftUI app:

    ```swift
    import SwiftUI

    @main
    struct iOSApp: App {
        @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
        var body: some Scene {
            WindowGroup {
                ContentView()
                    .onOpenURL(perform: handleURL)
            }
        }

        func handleURL(_ url: URL) {
            _ = appDelegate.application(UIApplication.shared, open: url, options: [:])
        }
    }
    ```

## Step 6. (Optional) Emit analytics from shared code

Initialization stays in the native iOS layer (Step 2). If you also want to emit track events from your **shared** business logic, define a Pendo-agnostic interface in `commonMain` and implement it **in Swift**, then inject it at startup.

> [!IMPORTANT]
> Unlike Android, the iOS implementation must be written in **Swift**, not in `iosMain`. Kotlin/Native cannot call the Swift/Objective-C Pendo SDK directly (no C-interop bindings are shipped), so `iosMain` stays Pendo-free and the Swift app provides the implementation.

> [!IMPORTANT]
> To use types from your shared Kotlin module in Swift, import it by its **framework name** — the `baseName` set in `shared/build.gradle.kts` (commonly `Shared`; e.g. it is `RssReader` in JetBrains' RSS Reader sample). It is **not** literally `import shared` unless your `baseName` is `shared`. Replace `Shared` below with your framework's name.

1. In `commonMain`, declare the abstraction (shared with Android):

    ```kotlin
    // commonMain
    interface PendoAnalytics {
        fun track(event: String, properties: Map<String, Any>)
    }

    object SharedAnalytics {
        private var analytics: PendoAnalytics? = null
        fun setImplementation(impl: PendoAnalytics) { analytics = impl }
        fun trackSharedEvent(action: String) {
            analytics?.track("shared_$action", mapOf("origin" to "commonMain"))
        }
    }
    ```

2. In your iOS app, implement it in Swift and inject it from the `AppDelegate` (after `setup`):

    ```swift
    // iosApp — import your shared Kotlin framework by its baseName (see note above).
    // `Shared` is the common default; use your project's actual framework name.
    import Shared
    import Pendo

    class IOSPendoAnalytics: PendoAnalytics {
        func track(event: String, properties: [String: Any]) {
            PendoManager.shared().track(event, properties: properties as [AnyHashable: Any])
        }
    }

    // in AppDelegate.didFinishLaunchingWithOptions, after PendoManager.shared().setup(...)
    SharedAnalytics.shared.setImplementation(impl: IOSPendoAnalytics())
    ```

    Your shared Kotlin code can now call `SharedAnalytics.trackSharedEvent("...")` and the event is routed to Pendo through the native SDK.

## Step 7. Verify installation

1. Test using Xcode:  
Run the app while attached to Xcode.  
Review the Xcode console and look for the following message:  
`Pendo Mobile SDK was successfully integrated and connected to the server.`
2. In the Pendo UI, go to Settings > Subscription Settings.
3. Select your application from the list.
4. Select the **Install Settings** tab and follow the instructions under Verify Your Installation to ensure you have successfully integrated the Pendo SDK.
5. Confirm that you can see your app as `Integrated` under <a href="https://app.pendo.io/admin" target="_blank">subscription settings</a>.

## Developer documentation

- API documentation available [here](/api-documentation/native-ios-apis.md).
- For the Android side of your KMP project, see [Kotlin Multiplatform (KMP) — Android](/android/pnddocs/kmp-android.md).

## Troubleshooting

- For technical issues, please [review open issues](https://github.com/pendo-io/pendo-mobile-sdk/issues) or [submit a new issue](https://github.com/pendo-io/pendo-mobile-sdk/issues).
- See our [release notes](https://developers.pendo.io/category/mobile-sdk/).
- For additional documentation, visit our [Help Center](https://support.pendo.io/hc/en-us/categories/23324531103771-Mobile-implementation).
