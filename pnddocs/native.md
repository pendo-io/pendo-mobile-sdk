
## Native IOS

### 1. Adding Pendo Dependecy
#### cocoapods:
In the _Podfile_ plase add:

`pod 'Pendo'`

#### swift package manger:
_File -> Add Packages_ in the search window paste:

`https://github.com/pendo-io/pendo-mobile-ios`

and select _Up to Next Major Version_

### 2. Integration
In the _AppDelegate_ file <br>
Swift:

```swift
import UIKit
import Pendo
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let key = "YOUR_KEY"
        //please note the following API will only setup initial configuration, to start collect analytics use start session
        PendoManager.shared().setup(key)
        return true
    }
    
    func application(_ app: UIApplication,open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme?.range(of: "pendo") != nil {
            PendoManager.shared().initWith(url)
            return true
        }
        // your code here...
        return true
    }
}
```
As soon as you have the  user to which you want to relate your guides and analytics please call:

```swift
PendoManager.shared().startSession("visitor1", accountId: "account1", visitorData:[], accountData: [])
```

Obj-C:
```objectivec
#import "AppDelegate.h"
@import Pendo;
@interface AppDelegate ()
@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString *key = @"YOUR_KEY";
    //note the following API will only setup initial configuration, to start collect analytics use start session
    [[PendoManager sharedManager] setup:key];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    if ([[url scheme] containsString:@"pendo"]) {
        [[PendoManager sharedManager] initWithUrl:url];
        return YES;
    }
    //your code
    return YES;
}
@end
```

As soon as you have the  user to which you want to relate your guides and analytics call:

```objc
[[PendoManager sharedManager] startSession:@"visitor1" accountId:@"account1" visitorData:@{} accountData:@{}];
```

### 3. Project Setup
To setup the Pendo pairing mode (tagging and test on device) select your project, navigate to the relevant target, select the info tab and create a URL Type using the Pendo url scheme (found in your subscription under the App Details tab)

<img src="https://user-images.githubusercontent.com/56674958/144723345-15c54098-28db-414c-90da-ef4a5256ae6a.png" width="500" height="300">

## Pivots
Please pay attention to the following api's ``` setup ``` and ```startSession``` the former *must* be called once per session and will create initial setup for the SDK, the later should be called whenever you have the visitor you would like to assign the analytics/guides to. In case you would like to have an anonymous visitor pass ```nil``` to the ```startSession``` and call it again as soon as you have the visitor. 


