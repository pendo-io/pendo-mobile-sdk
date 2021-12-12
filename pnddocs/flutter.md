
## Flutter
### Important: Pendo supports track events only in Flutter, the codeless solution is still in progress
### 1. Adding pendo dependence 
In the root folder of yout flutter app
`flutter pub add pendo_sdk`

### 2. Project setup (similar to Native IOS)
Pelase follow the instrction from the native part [2.Project Setup](#project-setup_anchor)
In the `AppDelegate.m` add the follwing:
```objectivec
#import "PendoManager.h";
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
### 3. Integration
Add the following code as soon as the app start:
```dart
import 'package:pendo_sdk/pendo_sdk.dart';
var initParams = {
    'visitorId': 'visitor1',
    'accountId': 'account1',
    'visitorData': {
        'age': 25,
        'country': 'USA'
    },
    'accountData': {
        'Tier': 1,
        'Size': 'Enterprise'
    }
};
var pendoKey = 'YOUR_KEY';
await PendoFlutterPlugin.initSDK(pendoKey,
        initParams);
await PendoFlutterPlugin.track('name', { 'firstProperty': 'firstPropertyValue', 'secondProperty': 'secondPropertyValue'});
```

### Limitations
* To suport hybrid mode in Flutter pelase open a ticket
