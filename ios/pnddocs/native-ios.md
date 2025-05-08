# Native iOS

<!-- ![Cocoapods platforms](https://img.shields.io/cocoapods/p/Pendo)  -->
![Cocoapods](https://img.shields.io/cocoapods/l/Pendo)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fpendo-io%2Fpendo-mobile-sdk%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/pendo-io/pendo-mobile-sdk)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fpendo-io%2Fpendo-mobile-sdk%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/pendo-io/pendo-mobile-sdk)\
![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/pendo-io/pendo-mobile-sdk?color=brightgreen&label=version&sort=semver)
![Cocoapods](https://img.shields.io/badge/cocoapods-compatibale-brightgreen)
![Cocoapods](https://img.shields.io/badge/xcframework-compatibale-brightgreen)
![Cocoapods](https://img.shields.io/badge/manual%20integration-compatibale-brightgreen)

<!-- ![Cocoapods](https://img.shields.io/cocoapods/v/Pendo) -->

>[!NOTE]
>The following integration instructions are relevant for SDK 3.0 or higher. <br/> Follow our migration instructions to [upgrade from SDK 2.x to 3.0](/migration-docs/README.md) or refer to our [2.x integration instruction](https://github.com/pendo-io/pendo-mobile-sdk/blob/2.22.5/README.md).

>[!IMPORTANT]
><b>SwiftUI</b> codeless solution is fully supported from `iOS 15`. <br/> <b>SwiftUI</b> screen navigation tracking is available from `iOS 13`.

>[!IMPORTANT]
>Requirements:
>- Deployment target of `iOS 11` or higher 
>- Swift Compatibility `5.7` or higher
>- Xcode `14` or higher

## Step 1. Add the Pendo SDK
### Cocoapods:

1. Open the _Podfile_.  
2. Add: `pod 'Pendo'`.

### Swift Package Manager:

1. Open _File -> Add Packages_.
2. Search for: `https://github.com/pendo-io/pendo-mobile-sdk`.
3. Select _Up to Next Major Version_.

## Step 2. Establish a connection to Pendo's server on app launch

>[!NOTE]
>Find your API key in the Pendo UI under `Settings` > `Subscription settings` > select an app > `App Details`.

Identify if your app project contains an `AppDelegate` file or a `SceneDelegate` file. Pure SwiftUI projects do not include either of these files. To use Pendo in your app, you will need to create one of them.  


1. If using the `AppDelegate` file, implement the following: <br/>

    <details open>
    <summary> <b>Swift Instructions</b><i> - Click to expand or collapse</i></summary>

    ```swift
    import UIKit
    import Pendo
    
    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {
        var window: UIWindow?
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            PendoManager.shared().setup("YOUR_API_KEY_HERE")
            //  your code here ...
            return true
        }
    }
    ```
    </details>

    <details>
    <summary> <b>Objective-C Instructions</b><i> - Click to expand or collapse</i></summary>

    ```objectivec
    #import "AppDelegate.h"
    #import @Pendo;    
    
    @implementation AppDelegate
    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        [[PendoManager sharedManager] setup:@"YOUR_API_KEY_HERE"];
        //  your code here ...
        return YES;
    }
    @end
    ```
    </details>

<br/>

2. If using the `SceneDelegate` file, implement the following:

    <details open>
    <summary> <b>Swift Instructions</b><i> - Click to expand or collapse</i></summary>

    ```swift
    import Pendo

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        PendoManager.shared().setup("YOUR_API_KEY_HERE")
        //  your code here ...
    }
    ```
    </details>
    <details>
    <summary> <b>Objective-C Instructions</b><i> - Click to expand or collapse</i></summary>

    ```objectivec
    #import @Pendo;    

    - (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {}
        [[PendoManager sharedManager] setup:@"YOUR_API_KEY_HERE"];
        //  your code here ...
    }
    ```
    </details>


## Step 3. Start a new session to track a visitor and to display guides

To begin tracking a visitor's analytics and to display guides, call the `startSession` API. The call to the `startSession` API can be conducted immediately after calling the `setup` API or anywhere else in the code, such as completing the login process of your app. 

<details open>
<summary> <b>Swift Instructions</b><i> - Click to expand or collapse</i></summary>


```swift
var visitorId = "John Doe"
var accountId = "ACME"
var visitorData: [String : any Hashable] = ["age": 27, "country": "USA"]
var accountData: [String : any Hashable] = ["Tier": 1, "size": "Enterprise"]
PendoManager.shared().startSession(visitorId, accountId:accountId, visitorData:visitorData, accountData:accountData)  
```
</details>

<details>
<summary> <b>Objective-C Instructions</b><i> - Click to expand or collapse</i></summary>

```objectivec
[[PendoManager sharedManager] startSession:@"someVisitor" accountId:@"someAccount" visitorData:@{@"age": @27, @"country": @"USA"} accountData:@{@"Tier": @1, @"size": @"Enterprise"}];
```
</details>

>[!TIP]
>To begin a session for an  <a href="https://support.pendo.io/hc/en-us/articles/360032202751" target="_blank">anonymous visitor</a>, pass ```nil``` or an empty string ```""``` as the Visitor ID. You can call the `startSession` API more than once and transition from an anonymous session to an identified session (or even switch between multiple identified sessions). 

### Supporting SwiftUI with older SDK (below 3.1) additional step 

If using SDK below 3.1 the `pendoEnableSwiftUI()` modifier must be applied to the application rootView. If there are multiple rootViews (ex. usage of multiple UIHostingControllers), apply the modifier to each main rootView. See example below:
```swift
struct YourView: View {
    var body: some View {
        Text("RootView")
            .pendoEnableSwiftUI()
    }
}
```

## Step 4. Configure Pairing Mode for tagging and testing

>[!NOTE]
>Find your scheme ID in the Pendo UI under `Settings` > `Subscription settings` > select an app > `App Details`.

For additional information, see <a href="https://support.pendo.io/hc/en-us/articles/360033609651-Tagging-Mobile-Pages#HowtoTagaPage" target="_blank">page tagging</a>
and <a href="https://support.pendo.io/hc/en-us/articles/360033487792-Creating-a-Mobile-Guide#test-guide-on-device-0-6" target="_blank">guide testing</a>.

### Add the Pendo URL scheme to the **info.plist** file

Navigate to your **App Target > Info > URL Types** and create a new URL by clicking the plus (+) button.

Set the **Identifier** to `pendo-pairing` or an identifiable name of your choosing.  
Set **URL Scheme** to `YOUR_SCHEME_ID_HERE`.

<img src="https://user-images.githubusercontent.com/56674958/144723345-15c54098-28db-414c-90da-ef4a5256ae6a.png" width="500" height="300" alt="Mobile Tagging">

### Configure the app to connect to Pairing Mode

1. If using `AppDelegate`, add or modify the `openURL` function:
    <details open>
    <summary> <b>Swift Instructions</b><i> - Click to expand or collapse</i></summary>

    ```swift
    import Pendo

    ...

    func application(_ app: UIApplication,open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme?.range(of: "pendo") != nil {
            PendoManager.shared().initWith(url)
            return true
        }
        // your code here...
        return true
    }
    ```
   
    </details>

    <details>
    <summary> <b>Objective-C Instructions</b><i> - Click to expand or collapse</i></summary>

   ```objectivec
   
        - (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
            if ([[url scheme] containsString:@"pendo"]) {
                [[PendoManager sharedManager] initWithUrl:url];
                return YES;
            }
            //your code here...
            return YES;
        }                
    ```
    </details>

<br/>

2. If using `SceneDelegate`, add or modify the `openURLContexts` function:

    <details open>
    <summary> <b>Swift Instructions</b><i> - Click to expand or collapse</i></summary>

    ```swift
    import Pendo

    ...

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url, url.scheme?.range(of: "pendo") != nil {
            PendoManager.shared().initWith(url)
        }
    }
    ```
    </details>

    <details>
    <summary> <b>Objective-C Instructions</b><i> - Click to expand or collapse</i></summary>

    ```objectivec
    - (void)scene:(UIScene *)scene openURLContexts:(nonnull NSSet<UIOpenURLContext *> *)URLContexts {
        NSURL *url = [[URLContexts allObjects] firstObject].URL;
        if ([[url scheme] containsString:@"pendo"]) {
            [[PendoManager sharedManager] initWithUrl:url];
        }
        //  your code here ...
    }
    ```
    </details>

### An additional required Step to configure Pairing Mode for SwiftUI

If the entry point to your app is a `struct` attributed with `@main`, your SwiftUI application will not respond to the method `application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool`.<br/>
To handle URL schemes in your SwiftUI app, add the `.onOpenURL()` modifier to your main view.<br/>
```swift
import Pendo

@main
struct YourApp: App {
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        return WindowGroup {
            TabView {
                YourView().tabItem {
                    Image("Icon")
                    Text("Text")
                }
            }
            .pendoEnableSwiftUI()
            .onOpenURL(perform: handleURL)
        }
    }
    
    func handleURL(_ url: URL) {
        _ = appDelegate.application(UIApplication.shared, open: url, options: [:])

    }
}
``` 

## Step 5. Verify installation

1. Test using Xcode:  
Run the app while attached to Xcode.  
Review the Xcode console and look for the following message:  
`Pendo Mobile SDK was successfully integrated and connected to the server.`
2. In the Pendo UI, go to Settings > Subscription Settings.
3. Select your application from the list.
4. Select the **Install Settings** tab and follow the instructions under Verify Your Installation to ensure you have successfully integrated the Pendo SDK.
5. Confirm that you can see your app as `Integrated` under <a href="https://app.pendo.io/admin" target="_blank">subscription settings</a>.


## SwiftUI limitations 

SwiftUI tracking of page changes is based on the application events emitted by the following navigation components: `NavigationView`,`NavigationStack`,
`NavigationSplitView`,`TabView`,`NavigationLink`,`ActionSheet`,`Sheets`,`.alert`,`.confirmationDialog` and `PopOvers`, under the hood SwiftUI still uses UIKit navigation and as such Pendo will track those changes automatically by identifying those pages with unique identifier we extract from the declarative definition of the page or from the underline structure of your app. Rendering new views on the page will not be tracked by our SDK automatically.

**Specific Limitations**

1. **Page Changes**:<br>
 a. If your application renders new views conditionally or dynamically (e.g `ZStack` views that you treat as distinct pages) *without* using standard navigation containers mentioned above, Pendo might not automatically recognize this as a distinct page change. To ensure these views are tracked as separate pages in Pendo analytics, you can manually designate them using the [`.trackPage(pageId: "page_id")`](/api-documentation/native-ios-apis.md#viewtrackpage) modifier on the relevant view. Ensure the `pageId` provided is unique across your application.<br>
b. If the tagged page identifier such as `retroactiveScreenId` or `swiftUIIdentifier` are not unique enough you can enhance it by selecting unique Page Identifier in Pendo Web designer OR apply your own page id via [`.trackPage(pageId: "page_id")`](/api-documentation/native-ios-apis.md#viewtrackpage)

2. **Tagging**:<br>
 Pendo's feature tagging relies heavily on iOS accessibility services to gather information like accessibilityHint, accessibilityIdentifier, accessibilityLabel, and user interactions. While iOS typically provides these accessibility elements by default, there might be instances where UI elements are not automatically tagged as expected by the Pendo SDK. In such cases, you can use the pendoRecognizeClickAnalytics() modifier. This API helps by creating an accessibility element, combining its children, and marking it as userInteractionEnabled. This allows Pendo to correctly identify the element as taggable and record click analytics for it.

3. **List Elements**:<br> 
SwiftUI offers List and ForEach for creating dynamic lists. Because List is built upon UICollectionView internally, the Pendo SDK utilizes its existing support for UICollectionView. Consequently, individual elements within a List will appear as taggable in Pendo. However, analytics (such as click events) will only be recorded if these elements are clickable.

4. **Container Views**: <br>
Container views that do not generate underlying UIKit elements may cause the Pendo SDK to fail in tagging and collecting analytics. This is because such views are purely declarative and serve as instructions for their child elements.<br> 
Examples of these views include `VStack`, `HStack`, `ZStack`, `LazyHStack`, `LazyVStack`, `LazyVGrid`, and `LazyHGrid`. In most cases, applying a modifier (e.g., a background modifier) will create an underlying `UIView`, enabling the Pendo SDK to tag and collect analytics seamlessly. However, if tagging issues persist, we recommend using the `pendoRecognizeClickAnalytics()` API on the specific element to ensure interactions are properly recorded. 

5. **UIContextMenu,Menu,.contextMenu**: <br>
 The UIContextMenu control is not supported in both Swift and SwiftUI. As a result, any interactions with context menus created using this control will not be tracked by the SDK.<br/>

## Developer documentation

- API documentation available [here](/api-documentation/native-ios-apis.md).
- See [Native application with Flutter components](/other/native-with-flutter-components.md) integration instructions.


- Sample apps with examples of feature tagging and how Pendo analytics work.<br/>
(pay attention to comments with _PENDO CHANGE_. In some cases these require minor changes of integration code or adding a background color)
    - [ACHNBrowserUI](https://github.com/pendo-io/ACHNBrowserUI)
    - [TeslaApp](https://github.com/pendo-io/Tesla_Clone_Swiftui)

## SwiftUI Troubleshooting
_Why aren't some elements being tagged correctly in SwiftUI?_

* **Missing Accessibility Traits**: Ensure that interactive elements, like buttons, have appropriate accessibility traits (e.g.,, .button). Adding these traits helps our SDK recognize and tag them correctly.

* **Embedding SwiftUI in UIKit**: If you are using SwiftUI elements inside UIKit, enable `pendoOptions.enableSwiftUIInsideUIKitScan`. This option will help our SDK to recognize SwiftUI components within UIKit containers.

* **Allow deeply nested SwiftUI layouts**: Enable `pendoOptions.scanFromRootViewController` flag to allow the SDK to scan elements starting from the main window root view controller, rather than limiting the scan to the top-most controller. This feature is designed to enhance element detection in SwiftUI-based layouts, particularly for complex view hierarchies (like `Overlays` that are triggered from deeper views)  where traditional scanning methods might fail. This scanning approach performs a deeper traversal of the entire view hierarchy, which may affect performance in large or deeply nested layouts. Use this flag only when necessary, as it introduces a heavier processing load compared to the default scanning method.

* **Using Our API** : <br>
`pendoRecognizeClickAnalytics()` - Even with codeless solutions, sometimes it’s necessary to use our tagging API to manually recognize clickable views. Applying this API to the specific view can resolve tagging issues effectively.<br>
`trackPage(pageId: "your_page_name")` - If the Pendo SDK fails to uniquely identify your page, use this API to manually designate the view as a page with a unique page name.


_Why do some of my SwiftUI screens have generic or irrelevant keywords in their screenId, and how can this be improved?_

* While we continue to refine screen identification for SwiftUI, make sure that your SwiftUI views are properly structured and identifiable. For now, this may require some manual adjustments to ensure each screen is tracked correctly.

_I have noticed performance issues in my app after integrating Pendo SDK. What should I do?_
  
* **Disable Unnecessary Information Collection** - To improve performance, particularly on iPads, consider disabling some of the things Pendo collects while scanning your page:
    *  **Texts Collection** - Set enableTextCollectionSwiftUI to false in pendoOptions:
    ```
    let options = PendoOptions()
    options.configs = ["enableTextCollectionSwiftUI": false]
    PendoManager.shared().setup(prodAppKey, with: options)
    ```
    * **Pruning** - To save time during scanning, set pendoOptions.enablePruning = false. This may help reduce the overhead.

* **Optimizing Scanning Depth** - If performance issues persist, adjust the scan depth settings. Consult our support team to configure this setting for optimal performance.
  
## General Troubleshooting

- For technical issues, please [review open issues](https://github.com/pendo-io/pendo-mobile-sdk/issues) or [submit a new issue](https://github.com/pendo-io/pendo-mobile-sdk/issues).
- See our [release notes](https://developers.pendo.io/category/mobile-sdk/).
- For additional documentation, visit our [Help Center](https://support.pendo.io/hc/en-us/categories/23324531103771-Mobile-implementation).
