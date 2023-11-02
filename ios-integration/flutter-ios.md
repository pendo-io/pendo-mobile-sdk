# Flutter

### Important: Pendo supports track events only in Flutter, the codeless solution is still in progress
### Step 1. Add Pendo dependency 
In the root folder of your flutter app add the Pendo package:
    `flutter pub add pendo_sdk`

### Step 2. Integration

**Both Scheme ID and API Key can be found in your Pendo Subscription under App Details**

Add the following code as soon as the app starts:
```dart
    import 'package:pendo_sdk/pendo_sdk.dart';
    var pendoKey = 'YOUR_API_KEY_HERE';
    await PendoFlutterPlugin.setup(pendoKey);
```

Initialize the Pendo Session where your visitor is being identified (e.g. login, register, etc.).
```dart
    import 'package:pendo_sdk/pendo_sdk.dart';
    final String visitorId = 'John Smith';
    final String accountId = 'Acme Inc.';
    final dynamic visitorData = {'Age': '25', 'Country': 'USA'};
    final dynamic accountData = {'Tier': '1', 'Size': 'Enterprise'};
    
    await PendoFlutterPlugin.startSession(visitorId, accountId, visitorData, accountData);
```

Configure Pendo Track Events to capture analytics to notify Pendo of analytics events.
In the application files where you want to track an event, add the following code:
```dart
    import 'package:pendo_sdk/pendo_sdk.dart';
    await PendoFlutterPlugin.track('name', { 'firstProperty': 'firstPropertyValue', 'secondProperty': 'secondPropertyValue'});
```

### Step 3. Mobile device connectivity for tagging and testing
These steps allow <a href="https://support.pendo.io/hc/en-us/articles/360033609651-Tagging-Mobile-Pages#HowtoTagaPage" target="_blank">page tagging</a>
and <a href="https://support.pendo.io/hc/en-us/articles/360033487792-Creating-a-Mobile-Guide#test-guide-on-device-0-6" target="_blank">guide testing</a> capabilities.

1. #### Add Pendo URL Scheme to **info.plist** file:

   Under App Target > Info > URL Types, create a new URL by clicking the + button.  
   Set **Identifier** to pendo-pairing or any name of your choosing.  
   Set **URL Scheme** to `YOUR_SCHEME_ID_HERE`.

<img src="https://user-images.githubusercontent.com/56674958/144723345-15c54098-28db-414c-90da-ef4a5256ae6a.png" width="500" height="300" alt="Mobile Tagging">

2. #### To allow pairing from the device
a. If using AppDelegate, add or modify the **openURL** function:

**Swift**
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
**ObjectiveC**
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
Pay attention to the following APIs ``` setup ``` and ```startSession```; the former *must* be called once per session and it creates initial setup for the SDK, the latter should be called when you have the visitor you would like to assign the analytics/guides to. If you want an anonymous visitor, pass ```nil``` to the ```startSession``` and call it again as soon as you have the visitor. 

## Limitations
* Flutter is currently only supported by our [Track-Events solution](https://support.pendo.io/hc/en-us/articles/360061487572-Pendo-for-Mobile-Track-Events-Solution).
* To support hybrid mode in Flutter, please open a ticket.

## Developer Documentation

- API documentation available [here](TODO:missing-link)

## Troubleshooting

- For technical issues please [review open issues](https://github.com/pendo-io/pendo-mobile-sdk/issues) or [submit a new issue](https://github.com/pendo-io/pendo-mobile-sdk/issues).
- Release notes can be found [here](https://developers.pendo.io/category/mobile-sdk/).
- For additional documentation visit our [Help Center Mobile Section](https://support.pendo.io/hc/en-us/categories/4403654621851-Mobile).

