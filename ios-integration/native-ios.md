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





### Step 1. Add Pendo Dependency
#### cocoapods:
In the _Podfile_ , add:

`pod 'Pendo'`

#### Swift package manager:
_File -> Add Packages_ in the search window paste:

`https://github.com/pendo-io/pendo-mobile-sdk`

and select Up to Next Major Version_

### Step 2. Integration

**Both Scheme ID and API Key can be found in your Pendo Subscription under App Details**

In the _AppDelegate_ file <br>
**Swift**

```swift
    import UIKit
    import Pendo
    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {
        var window: UIWindow?
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            let key = "YOUR_API_KEY_HERE"
            //please note the following API will only setup initial configuration, to start collect analytics use start session
            PendoManager.shared().setup(key)
            return true
        }
    }
```

As soon as you have the user you want your guides and analytics to relate to, call:

```swift
    PendoManager.shared().startSession("visitor1", accountId: "account1", visitorData:[], accountData: [])
```

**ObjectiveC**
```objectivec
    #import "AppDelegate.h"
    @import Pendo;    
    
    @implementation AppDelegate
    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        NSString *key = @"YOUR_API_KEY_HERE";
        //note the following API will only setup initial configuration, to start collect analytics use start session
        [[PendoManager sharedManager] setup:key];
        return YES;
    }
    @end
```

As soon as you have the user you want to relate your guides and analytics to relate to, call:

```objectivec
    [[PendoManager sharedManager] startSession:@"visitor1" accountId:@"account1" visitorData:@{} accountData:@{}];
```

In case using _SceneDelegate_ file <b>
**Swift**
```swift
func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    let key = "YOUR_API_KEY_HERE"
    //// the following API is required to initialize the SDK. To begin the collection of analytics and the usage of guides a call to the startSession method is required as well
    PendoManager.shared().setup(key)
}
```

As soon as you have the user you want your guides and analytics to relate to, call:

```swift
    PendoManager.shared().startSession("visitor1", accountId: "account1", visitorData:[], accountData: [])
```

**ObjectiveC**
```objectivec
- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {}
    NSString *key = @"YOUR_API_KEY_HERE";
    //note the following API will only setup initial configuration, to start collect analytics use start session
    [[PendoManager sharedManager] setup:key];
    //  your code here ...
}
```
As soon as you have the user you want to relate your guides and analytics to relate to, call:


```objectivec
    [[PendoManager sharedManager] startSession:@"visitor1" accountId:@"account1" visitorData:@{} accountData:@{}];
```

### 3. Mobile device connectivity for tagging and testing
These steps allow <a href="https://support.pendo.io/hc/en-us/articles/360033609651-Tagging-Mobile-Pages#HowtoTagaPage" target="_blank">page tagging</a>
and <a href="https://support.pendo.io/hc/en-us/articles/360033487792-Creating-a-Mobile-Guide#test-guide-on-device-0-6" target="_blank">guide testing</a> capabilities.

#### Add Pendo URL Scheme to **info.plist** file:

   Under App Target > Info > URL Types, create a new URL by clicking the + button.  
   Set **Identifier** to pendo-pairing or any name of your choosing.  
   Set **URL Scheme** to `YOUR_SCHEME_ID_HERE`.

<img src="https://user-images.githubusercontent.com/56674958/144723345-15c54098-28db-414c-90da-ef4a5256ae6a.png" width="500" height="300" alt="Mobile Tagging">

#### To allow pairing from the device
a. If using AppDelegate, add or modify the **openURL** function:
**Swift**
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
**ObjectiveC**
```objectivec
    - (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
        if ([[url scheme] containsString:@"pendo"]) {
            [[PendoManager sharedManager] initWithUrl:url];
            return YES;
        }
        //your code
        return YES;
    }
```

b. If using SceneDelegate, add or modify the **openURLContexts** function:
**Swift**
```swift
func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    if let url = URLContexts.first?.url, url.scheme?.range(of: "pendo") != nil {
        PendoManager.shared().initWith(url)
    }
}
```

**ObjectiveC**
```objectivec
- (void)scene:(UIScene *)scene openURLContexts:(nonnull NSSet<UIOpenURLContext *> *)URLContexts {
    NSURL *url = [[URLContexts allObjects] firstObject].URL;
    if ([[url scheme] containsString:@"pendo"]) {
        [[PendoManager sharedManager] initWithUrl:url];
    }
    //  your code here ...
}
```
### Step 4. Verify Installation

1. Test using Xcode:  
Run the app while attached to Xcode.  
Review the device log and look for the following message:  
`Pendo Mobile SDK was successfully integrated and connected to the server.`
2. In the Pendo UI, go to Settings>Subscription Settings.
3. Hover over your app and select View app details.
4. Select the Install Settings tab and follow the instructions under Verify Your Installation to ensure you have successfully integrated the Pendo SDK.
5. Confirm that you can see your app as Integrated under <a href="https://app.pendo.io/admin" target="_blank">subscription settings</a>.


## Pivots
Pay attention to the following apis ``` setup ``` and ```startSession```; the former *must* be called once per session and it creates initial setup for the SDK, the latter should be called when you have the visitor you would like to assign the analytics/guides to. If you want an anonymous visitor, pass ```nil``` to the ```startSession``` and call it again as soon as you have the visitor. 

## Developer Documentation

- API documentation available [here](TODO:missing-link)

## Troubleshooting

- For technical issues please [review open issues](https://github.com/pendo-io/pendo-mobile-sdk/issues) or [submit a new issue](https://github.com/pendo-io/pendo-mobile-sdk/issues).
- Release notes can be found [here](https://developers.pendo.io/category/mobile-sdk/).
- For additional documentation visit our [Help Center Mobile Section](https://support.pendo.io/hc/en-us/categories/4403654621851-Mobile).
