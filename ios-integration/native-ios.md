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

### Important Note:

<b> SwiftUI</b> full support full codeless solution is supported from `iOS 15`. <br> <b>SwiftUI</b> screen navigation tracking is available from `iOS 13`.

## Step 1. Add the Pendo SDK
### Cocoapods:

1. Open the _Podfile_  
2. Add: `pod 'Pendo'`

### Swift Package Manager:

1. Open _File -> Add Packages_ 
2. Search for: `https://github.com/pendo-io/pendo-mobile-sdk`
3. Select _Up to Next Major Version_

## Step 2. Establish a Connection to Pendo's Server on App Launch

<b>Note:</b> Both the `API Key` and the `Scheme ID` can be found in your Pendo Subscription under the App Details section.

Identify if your app project contains an `AppDelegate` file or a `SceneDelegate` file. Pure SwiftUI projects do not include either of these files. To use Pendo in your app you will need to create one of them.  


1. If using the `AppDelegate` file, implement the following: <br>

    <details open>
    <summary> <b>Swift Instructions</b><i> - Click to Expand / Collapse</i></summary>

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
    <summary> <b>Objective-C Instructions</b><i> - Click to Expand / Collapse</i></summary>

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

<br>

2. If using the `SceneDelegate` file, implement the following:

    <details open>
    <summary> <b>Swift Instructions</b><i> - Click to Expand / Collapse</i></summary>

    ```swift
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        PendoManager.shared().setup("YOUR_API_KEY_HERE")
        //  your code here ...
    }
    ```
    </details>
    <details>
    <summary> <b>Objective-C Instructions</b><i> - Click to Expand / Collapse</i></summary>

    ```objectivec
    - (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {}
        [[PendoManager sharedManager] setup:@"YOUR_API_KEY_HERE"];
        //  your code here ...
    }
    ```
    </details>


## Step 3. Start a New Session to Track a Visitor and to Display Guides

To begin tracking a visitor's analytics and display guides call the `startSession` API. The call to the `startSession` API can be conducted immediately after calling the `setup` API or anywhere else in the code, such as completing the log in process of your app. To begin a session for an anonymous visitor, pass ```nil``` as the visitor id. You can call the `startSession` API more than once and transition from an anonymous session to an identified session (or even switch between multiple identified sessions). 

<details open>
<summary> <b>Swift Instructions</b><i> - Click to Expand / Collapse</i></summary>


```swift
PendoManager.shared().startSession("someVisitor", accountId: "someAccount", visitorData:[], accountData: [])
```
</details>

<details>
<summary> <b>Objective-C Instructions</b><i> - Click to Expand / Collapse</i></summary>

```objectivec
[[PendoManager sharedManager] startSession:@"someVisitor" accountId:@"someAccount" visitorData:@{} accountData:@{}];
```
</details>

### Supporting SwiftUI

To support SwiftUI, the `pendoEnableSwiftUI()` modifier must be called on each of the `rootViews` in your app. See example below:
```swift
struct YourView: View {
    var body: some View {
        Text("RootView")
            .pendoEnableSwiftUI()
    }
}
```

## Step 4. Configure Pairing Mode for Tagging and Testing

For additional information see: <a href="https://support.pendo.io/hc/en-us/articles/360033609651-Tagging-Mobile-Pages#HowtoTagaPage" target="_blank">page tagging</a>
and <a href="https://support.pendo.io/hc/en-us/articles/360033487792-Creating-a-Mobile-Guide#test-guide-on-device-0-6" target="_blank">guide testing</a>.

### Add the Pendo URL Scheme to the **info.plist** File


Navigate to your **App Target > Info > URL Types** and create a new URL by clicking the plus (+) button.

Set the **Identifier** to `pendo-pairing` or an identifiable name of your choosing.  
Set **URL Scheme** to `YOUR_SCHEME_ID_HERE`.

<b>Note:</b> The `Scheme ID` can be found in your Pendo Subscription under the App Details section.

<img src="https://user-images.githubusercontent.com/56674958/144723345-15c54098-28db-414c-90da-ef4a5256ae6a.png" width="500" height="300" alt="Mobile Tagging">

### Configure the App to Connect to Pairing Mode
1. If using `AppDelegate`, add or modify the `openURL` function:
    <details open>
    <summary> <b>Swift Instructions</b><i> - Click to Expand / Collapse</i></summary>

    ```swift
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
    <summary> <b>Objective-C Instructions</b><i> - Click to Expand / Collapse</i></summary>```objectivec
        - (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
            if ([[url scheme] containsString:@"pendo"]) {
                [[PendoManager sharedManager] initWithUrl:url];
                return YES;
            }
            //your code
            return YES;
        }
    ```
    </details>

<br>

2. If using `SceneDelegate`, add or modify the `openURLContexts` function:

    <details open>
    <summary> <b>Swift Instructions</b><i> - Click to Expand / Collapse</i></summary>

    ```swift
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url, url.scheme?.range(of: "pendo") != nil {
            PendoManager.shared().initWith(url)
        }
    }
    ```
    </details>

    <details>
    <summary> <b>Objective-C Instructions</b><i> - Click to Expand / Collapse</i></summary>

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

### An Additional Required Step to Configure Pairing Mode for SwiftUI

In case the entry point to your app is a `struct` attributed with `@main`, your SwiftUI application will not respond to the method `application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool`.<br>
To handle URL schemes in your SwiftUI app, add the `.onOpenURL()` modifier to your main view.<br>
```swift
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

## Step 5. Verify Installation

1. Test using Xcode:  
Run the app while attached to Xcode.  
Review the device log and look for the following message:  
`Pendo Mobile SDK was successfully integrated and connected to the server.`
2. In the Pendo UI, go to Settings > Subscription Settings.
3. Hover over your app and select View app details.
4. Select the Install Settings tab and follow the instructions under Verify Your Installation to ensure you have successfully integrated the Pendo SDK.
5. Confirm that you can see your app as Integrated under <a href="https://app.pendo.io/admin" target="_blank">subscription settings</a>.


## Limitations 

### SwiftUI 
- Clickable elements (e.x. Buttons / TapGestures) have a transparent background color  or that are created without a set background color (e.x. VStack or HStack) may encounter issues with identification by our SDK. To resolve this issue invoke the `pendoRecognizeClickAnalytics()` API on the `View` of this element.

- The `iOS 16 Navigation APIs` are not supported at the moment.

- The `PresentationContainer` is not supported at the moment.

- The `Menu` Control is not supported at the moment.

### Other Limitations

- Codeless support for dynamic content on a page (see **) does not exist. To remedy such scenarios invoke the `screenContentChanged()` API after the dynamic content has been rendered on the screen.
    <br><br><i>\*\* 
    Content that is rendered on the screen after the screen's initial load. <br>(e.x. delayed loading of elements or elements/text that update on the screen as a result of a button tapped or a network response) </i>

## Accessibility Support
The OS assigns default accessibility values to UI elements in the app if you do not set accessibility values yourself. The accessibility identifiers, accessibility labels, and accessibility hints are all collected by Pendo and can be utilized for unique identification of features and pages.<br>

## Developer Documentation

- API documentation available [here](TODO:missing-link)

- Sample apps with examples of feature tagging and how Pendo analytics work.<br>
(Please pay attention to comments with _PENDO CHANGE_ which in some places require minor changes like integration code or adding a background color)<br>

    ACHNBrowserUI - https://github.com/pendo-io/ACHNBrowserUI <br>
TeslaApp      - https://github.com/pendo-io/Tesla_Clone_Swiftui <br>

## Troubleshooting

- For technical issues please [review open issues](https://github.com/pendo-io/pendo-mobile-sdk/issues) or [submit a new issue](https://github.com/pendo-io/pendo-mobile-sdk/issues).
- Release notes can be found [here](https://developers.pendo.io/category/mobile-sdk/).
- For additional documentation visit our [Help Center Mobile Section](https://support.pendo.io/hc/en-us/categories/4403654621851-Mobile).