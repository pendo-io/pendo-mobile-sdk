
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

## Pivots
Please pay attention to the follwowing APIs ``` setup ``` and ```startSession``` the former *must* be called once per session and will create initial setup for the SDK, the later should be called whenever you have the visitor you would like to assign the analytics/guides to. In case you would like to have an anonymous visitor pass ```nil``` to the ```startSession``` and call it again as soon as you have the vistor. 

## Limitations
* Flutter is currently only supported by our [Track-Events solution](https://support.pendo.io/hc/en-us/articles/360061487572-Pendo-for-Mobile-Track-Events-Solution)
* To suport hybrid mode in Flutter pelase open a ticket


