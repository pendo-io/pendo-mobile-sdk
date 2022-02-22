
## Flutter
### Important: Pendo supports track events only in Flutter, the codeless solution is still in progress
### 1. Adding pendo dependence 
In the root folder of yout flutter app
`flutter pub add pendo_sdk`

### 2. Project setup (similar to Native IOS)
In the _AppDelegate_ file <br>
Swift:

```swift
import Pendo
//your code
@UIApplicationMain
class AppDelegate:  FlutterAppDelegate {
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
Obj-C:
```objectivec
@import Pendo;
//your code
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([[url scheme] containsString:@"pendo"]) {
        [[PendoManager sharedManager] initWithUrl:url];
        return YES;
    }
    //  your code here ...
    return YES;
}
```

In order to enable Pendo pairing mode (tagging and testing) select your project select the info tab and add Url Type with pendo url scheme 

<img src="https://user-images.githubusercontent.com/56674958/144723345-15c54098-28db-414c-90da-ef4a5256ae6a.png" width="500" height="300">

### 3. Integration
Add the following code as soon as the app start:
```dart
import 'package:pendo_sdk/pendo_sdk.dart';
var pendoKey = 'YOUR_KEY';
await PendoFlutterPlugin.setup(pendoKey);
```

Initialize Pendo Session where your visitor is being identified (e.g. login, register, etc.).
```dart
import 'package:pendo_sdk/pendo_sdk.dart';
final String visitorId = 'John Smith';
final String accountId = 'Acme Inc.';
final dynamic visitorData = {'Age': '25', 'Country': 'USA'};
final dynamic accountData = {'Tier': '1', 'Size': 'Enterprise'};

PendoFlutterPlugin.startSession(visitorId, accountId, visitorData, accountData);
```

Configure Pendo Track Events to capture analytics to notify Pendo of analytics events.
In the application files where you want to track an event, add the following code:
```dart
import 'package:pendo_sdk/pendo_sdk.dart';
await PendoFlutterPlugin.track('name', { 'firstProperty': 'firstPropertyValue', 'secondProperty': 'secondPropertyValue'});
```

Flutter Codeless POC can be found here:
[Flutter Codeless POC video](https://user-images.githubusercontent.com/56674958/153876161-c1017a0d-ad5e-4837-9746-4317d1183f18.mov)

## Pivots
Please pay attention to the following APIs ``` setup ``` and ```startSession``` the former *must* be called once per session and will create initial setup for the SDK, the later should be called whenever you have the visitor you would like to assign the analytics/guides to. In case you would like to have an anonymous visitor pass ```nil``` to the ```startSession``` and call it again as soon as you have the visitor. 

## Limitations
* Flutter is currently only supported by our [Track-Events solution](https://support.pendo.io/hc/en-us/articles/360061487572-Pendo-for-Mobile-Track-Events-Solution)
* To support hybrid mode in Flutter please open a ticket


