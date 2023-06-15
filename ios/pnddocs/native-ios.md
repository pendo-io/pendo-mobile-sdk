## Native iOS

### Step 1. Add Pendo Dependency
#### cocoapods:
In the _Podfile_ , add:

`pod 'Pendo'`

#### Swift package manager:
_File -> Add Packages_ in the search window paste:

`https://github.com/pendo-io/pendo-mobile-sdk/ios`

and select Up to Next Major Version_

### Step 2. Integration
In the _AppDelegate_ file <br>
Swift:

```swift
    import UIKit
    import Pendo
    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {
        var window: UIWindow?
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            let key = "YOUR_APPKEY_HERE"
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

Obj-C:
```objectivec
    #import "AppDelegate.h"
    @import Pendo;    
    
    @implementation AppDelegate
    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        NSString *key = @"YOUR_APPKEY_HERE";
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

### 3. Mobile device connectivity for tagging and testing
These steps allow <a href="https://support.pendo.io/hc/en-us/articles/360033609651-Tagging-Mobile-Pages#HowtoTagaPage" target="_blank">page tagging</a>
and <a href="https://support.pendo.io/hc/en-us/articles/360033487792-Creating-a-Mobile-Guide#test-guide-on-device-0-6" target="_blank">guide testing</a> capabilities.

#### Add Pendo URL Scheme to **info.plist** file:

   Under App Target > Info > URL Types, create a new URL by clicking the + button.  
   Set **Identifier** to pendo-pairing or any name of your choosing.  
   Set **URL Scheme** to `YOUR_SCHEME_HERE`.

<img src="https://user-images.githubusercontent.com/56674958/144723345-15c54098-28db-414c-90da-ef4a5256ae6a.png" width="500" height="300" alt="Mobile Tagging">

#### In AppDelegate file add or modify the **openURL** function:
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
### Step 4. Verify Installation

* Test using Xcode:  
  Run the app while attached to Xcode.  
  Review the device log and look for the following message:  
  `Pendo Mobile SDK was successfully integrated and connected to the server.`
* In the Pendo UI, under your app's subscription settings, click the Install Settings tab, and look for the Start Verification button. Follow instructions there to make sure you have integrated correctly.  
* Test using the Pendo UI:  
  Confirm that you can see your app as Integrated under <a href="https://app.pendo.io/admin" target="_blank">subscription settings</a>.

-------------

## Pivots
Pay attention to the following apis ``` setup ``` and ```startSession```; the former *must* be called once per session and it creates initial setup for the SDK, the latter should be called when you have the visitor you would like to assign the analytics/guides to. If you want an anonymous visitor, pass ```nil``` to the ```startSession``` and call it again as soon as you have the visitor. 


