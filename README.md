# Pendo SDK for IOS 
![Cocoapods platforms](https://img.shields.io/cocoapods/p/Pendo)
![Cocoapods](https://img.shields.io/cocoapods/v/Pendo)
![Cocoapods](https://img.shields.io/badge/cocoapods-compatibale-brightgreen)
![Cocoapods](https://img.shields.io/badge/xcframework-compatibale-brightgreen)
![Cocoapods](https://img.shields.io/badge/manual%20integration-compatibale-brightgreen)
![Cocoapods](https://img.shields.io/cocoapods/l/Pendo)

TODO: (Naor) Some description aboout the SDK

## Installation Instruction 
- [Native IOS](#native-ios_anchor)
- [React Native](#react-native_anchor)
- [React Native Navigation](#react-native-navigation_anchor)
- [Xamarin](#xamarin_anchor)
- [Flutter](#flutter_anchor)
- [Benchmarks](#benchmarks_anchor)
- [Pivots](#pivots_anchor)
- [Limitations](#limitations_anchor)

<a name="native-ios_anchor"></a>
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
Swift:

```swift
import UIKit
import Pendo
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let key = "YOUR_KEY"
        //please note the following API will only setup initial configuartion, to start collect analytics use start session
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
    //note the following API will only setup initial configuartion, to start collect analytics use start session
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

```swift
[[PendoManager sharedManager] startSession:@"visitor1" accountId:@"acount1" visitorData:@{} accountData:@{}];
```

<a name="project-setup_anchor"></a> 
### 2. Project Setup
In order to enable Pendo pairing mode (taging and testing) select your project select the info tab and add Url Type with pendo url scheme 

<img src="https://user-images.githubusercontent.com/56674958/144723345-15c54098-28db-414c-90da-ef4a5256ae6a.png" width="500" height="300">

<a name="react-native_anchor"></a>
## React Native

### 1. Adding Pendo dependency
#### Requirements: 
We support codeless solution for _react-native 0.6 and above and react-navigation 5 and above_
Please note in order for the codeless solution to work all the elements *MUST be wrapped in react-native ui components*<br>
As any other anlytics tool we are dependent on react-navigation [screen change callbacks](https://reactnavigation.org/docs/screen-tracking/)


In the root folder of your react app run the folowing:
```
npm i rn-pendo-sdk  
```

or 

```
yarn add rn-pendo-sdk
```
after that `cd ios` and run:
`pod install `

### 2. Project setup (similar to Native IOS)
Pelase follow the instrction from the native part [2.Project Setup](#project-setup_anchor)

### 3. Production Bundle - Modify Javascript Obfuscation
In the `metro.config.js` file add the following:
```javascript
module.exports = {
  transformer: {
    // ...
    minifierConfig: {
        keep_classnames: true, // Preserve class names
        keep_fnames: true, // Preserve function names
        mangle: {
          keep_classnames: true, // Preserve class names
          keep_fnames: true, // Preserve function names
        }
    }
  }
}
```
### 4.Integration

```typescript
import {withPendoRN, PendoSDK, NavigationLibraryType} from "rn-pendo-sdk";
import { useRef } from 'react';

const initParams = {
  visitorId: 'visitor1',
  accountId: 'account1',
};
const navigationOptions = { 'library': NavigationLibraryType.ReactNavigation };
const key = 'YOUR_CODE'; 

//note the following API will only setup initial configuartion, to start collect analytics use start session
PendoSDK.setup(key,navigationOptions,null);

//your code 

function YOUR_MAIN_FUNCTION(props) {
  const navigationRef = useRef();
  return (
    <NavigationContainer 
    ref={navigationRef}
    onStateChange={()=> {
      const state = navigationRef.current.getRootState()
      props.onStateChange(state);
    }}
    onReady ={()=>{
        const state = navigationRef.current.getRootState()
        props.onStateChange(state);
    }} >
      {MainStackScreen()}
    </NavigationContainer >
  )
};
export default withPendoRN(YOUR_MAIN_FUNCTION);
```
As soon as you have the user to which you want to relate your guides and analytics please call:
```PendoSDK.startSession("visitor1","acoount1", null, null);```

<a name="react-native-navigation_anchor"></a>
## React Native Navigation
### Requirements
We support  _react native navigation 6 or above_

Initial steps 1,2,3 are identical to *React Native*

### 4. Integration

```typescipt
const initParams = {
        visitorId: 'visitor1',
        accountId: 'account1',
    };

    const navigationOptions = {library: NavigationLibraryType.ReactNativeNavigation, navigation: Navigation};
    const pendoKey = 'YOUR_KEY';
    PendoSDK.setup(pendoKey, initParams,navigationOptions); // initParams is optional.
```
As soon as you have the user to which you want to relate your guides and analytics please call:
```PendoSDK.startSession("visitor1","acoount1", null, null);```


<a name="xamarin_anchor"></a>
## Xamarin
### 1. Adding Pendo dependecy 
In Visual Studio `Project->Manage Nuget Packages` search for _pendo_ and add the **pendo-sdk-IOS**

### 2. Integration
```csharp
using Pendo;
[Register("AppDelegate")]
public partial class AppDelegate : FormsApplicationDelegate {
        public override bool FinishedLaunching(UIApplication app, NSDictionary options) {
            string appKey = "YOUR_KEY";
            //please note the following API will only setup initial configuartion, to start collect analytics use start session
            PendoManager.SharedManager().setup(appKey);
            return base.FinishedLaunching(app, options);
        }
        //This step is done to alllow capture mode (taging/testing)
        public override bool OpenUrl(UIApplication application, NSUrl url, string sourceApplication, NSObject annotation) {
            if (url.Scheme.Contains("pendo")) {
                Pendo.PendoManager.SharedManager().InitWithUrl(url);
                return true;
            }
            //Your code here...
            return true;
        }
 }
 
```
As soon as you have the user to which you want to relate your guides and analytics call:
```
Pendo.PendoManager.SharedManager().StartSession("visitor1", "account1", null, null);
```

### 3. Project setup
Add Pendo URL Scheme to info.plist file

<img alt="Screen Shot 2021-12-08 at 16 39 20" src="https://user-images.githubusercontent.com/56674958/145228026-f7a5af6c-33c9-4174-afc9-a0295dd6844e.png" width="500" height="300">


<a name="flutter_anchor"></a>
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

<a name="benchmarks_anchor"></a>
## Benchmarks
SDK size in production is about _2.3MB_<br>
The init process which includes  `setup`, `startSession` and downloading amount of 3 guides with 3 step each (_~80KB overall_ ) will take around _3sec_ for all of the guides.<br>
 The network load is executed in paraller so the the guides with highest priority will be downloaded faster and will be availble before the totall download time.

<a name="pivots_anchor"></a>
## Pivots
Please pay attention to the follwowing api's ``` setup ``` and ```startSession``` the former *must* be called once per session and will create initial setup for the SDK, the later should be called whenever you have the visitor you would like to assign the analytics/guides to. In case you would like to have an anonymous visitor pass ```nil``` to the ```statSession``` and call it again as son as u have the vistor. 

<a name="limitations_anchor"></a>
## Limitations 
We dont support _SwiftUI_ yet <br>
To suport hybrid mode in Flutter/ React native pelase open a ticket


