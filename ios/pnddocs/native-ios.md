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
>The `API Key` can be found in your Pendo Subscription Settings in App Details.

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
    #import "Pendo.h";    
    
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
    #import "Pendo.h";    

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
var visitorData = ["age": 27, "country": "USA"]      
var accountData = ["Tier": 1, "size": "Enterprise"]  
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
>To begin a session for an  <a href="https://help.pendo.io/resources/support-library/analytics/anonymous-visitors.html" target="_blank">anonymous visitor</a>, pass ```nil``` or an empty string ```""``` as the visitor id. You can call the `startSession` API more than once and transition from an anonymous session to an identified session (or even switch between multiple identified sessions). 

### Supporting SwiftUI

To support SwiftUI, the `pendoEnableSwiftUI()` modifier must be applied to the application rootView. If there are multiple rootViews (ex. usage of multiple UIHostingControllers), apply the modifier to each main rootView. See example below:
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
>The `Scheme ID` can be found in your Pendo Subscription Settings in App Details.

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
3. Select the **Applications** tab and then your application.
4. Select the **Install Settings** tab and follow the instructions under Verify Your Installation to ensure you have successfully integrated the Pendo SDK.
5. Confirm that you can see your app as Integrated under <a href="https://app.pendo.io/admin" target="_blank">subscription settings</a>.


## SwiftUI limitations 

- SwiftUI tracking of page changes is based on the application events emitted by the following navigation components: `NavigationView`, `TabView`, `NavigationLink`, `ActionSheet`, `Sheets` or `PopOvers`. Rendering new views on the page will no be tracked by our SDK.

- When encountering tagging issues of clickable elements try calling the `pendoRecognizeClickAnalytics()` API on the `View` of clickable element.

- The `iOS 16 Navigation APIs` are not supported at the moment.

- The `Menu` Control is not supported at the moment.

## Accessibility support
The OS assigns default accessibility values to UI elements in the app if you do not set accessibility values yourself. The accessibility identifiers, accessibility labels, and accessibility hints are all collected by Pendo and can be utilized for unique identification of features and pages.<br/>

## Developer documentation

- API documentation available [here](/api-documentation/native-ios-apis.md).

- Sample apps with examples of feature tagging and how Pendo analytics work.<br/>
(pay attention to comments with _PENDO CHANGE_. In some cases these require minor changes of integration code or adding a background color)
    - [ACHNBrowserUI](https://github.com/pendo-io/ACHNBrowserUI)
    - [TeslaApp](https://github.com/pendo-io/Tesla_Clone_Swiftui)

## Troubleshooting

- For technical issues, please [review open issues](https://github.com/pendo-io/pendo-mobile-sdk/issues) or [submit a new issue](https://github.com/pendo-io/pendo-mobile-sdk/issues).
- Release notes can be found [here](https://developers.pendo.io/category/mobile-sdk/).
- For additional documentation, visit our [Help Center Mobile Section](https://support.pendo.io/hc/en-us/categories/4403654621851-Mobile).
