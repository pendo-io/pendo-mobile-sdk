# Flutter iOS

>[!IMPORTANT]
>Flutter is supported by our track events only solution. The codeless solution is still in progress.

>[!IMPORTANT]
>Requirements:
>- Flutter 3.3 and above
>- Dart 2.18 and above 

## Step 1. Add Pendo dependency 
In the root folder of your flutter app add the Pendo package: `flutter pub add pendo_sdk`.

## Step 2. Integration

>[!NOTE]
>The `API Key` can be found in your Pendo Subscription Settings in App Details.

Add the following code as soon as the app starts:
```dart
import 'package:pendo_sdk/pendo_sdk.dart';
var pendoKey = 'YOUR_API_KEY_HERE';
await PendoSDK.setup(pendoKey);
```

Initialize the Pendo Session where your visitor is being identified (e.g. login, register, etc.).
```dart
import 'package:pendo_sdk/pendo_sdk.dart';
final String visitorId = 'John Smith';
final String accountId = 'Acme Inc.';
final dynamic visitorData = {'Age': '25', 'Country': 'USA'};
final dynamic accountData = {'Tier': '1', 'Size': 'Enterprise'};

await PendoSDK.startSession(visitorId, accountId, visitorData, accountData);
```

>[!TIP]
>To begin a session for an  <a href="https://help.pendo.io/resources/support-library/analytics/anonymous-visitors.html" target="_blank">anonymous visitor</a>, pass ```null``` or an empty string ```''``` as the visitor id. You can call the `startSession` API more than once and transition from an anonymous session to an identified session (or even switch between multiple identified sessions). 

Configure Pendo Track Events to capture analytics to notify Pendo of analytics events.
In the application files where you want to track an event, add the following code:
```dart
import 'package:pendo_sdk/pendo_sdk.dart';
await PendoSDK.track('name', { 'firstProperty': 'firstPropertyValue', 'secondProperty': 'secondPropertyValue'});
```

## Step 3. Mobile device connectivity for tagging and testing

>[!NOTE]
>The `Scheme ID` can be found in your Pendo Subscription Settings in App Details.

These steps enable <a href="https://support.pendo.io/hc/en-us/articles/360033609651-Tagging-Mobile-Pages#HowtoTagaPage" target="_blank">page tagging</a>
and <a href="https://support.pendo.io/hc/en-us/articles/360033487792-Creating-a-Mobile-Guide#test-guide-on-device-0-6" target="_blank">guide testing</a> capabilities.

1. **Add Pendo URL scheme to **info.plist** file:**

   Under App Target > Info > URL Types, create a new URL by clicking the + button.  
   Set **Identifier** to pendo-pairing or any name of your choosing.  
   Set **URL Scheme** to `YOUR_SCHEME_ID_HERE`.

    <img src="https://user-images.githubusercontent.com/56674958/144723345-15c54098-28db-414c-90da-ef4a5256ae6a.png" width="500" height="300" alt="Mobile Tagging">

2. **To enable pairing from the device:**

    a. If using AppDelegate, add or modify the **openURL** function:

    <details open>
    <summary> <b>Swift Instructions</b><i> - Click to expand or collapse</i></summary>

    ```swift
    import Pendo

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
    </details>

    <details>
    <summary> <b>Objective-C Instructions</b><i> - Click to expand or collapse</i></summary>

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
    </details>

    </br>

    b. If using SceneDelegate, add or modify the **openURLContexts** function:

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

## Step 4. Verify installation

1. Test using Xcode:  
Run the app while attached to Xcode.  
Review the Xcode console and look for the following message:  
`Pendo Mobile SDK was successfully integrated and connected to the server.`
2. In the Pendo UI, go to Settings>Subscription Settings.
3. Select the **Applications** tab and then your application.
4. Select the Install Settings tab and follow the instructions under Verify Your Installation to ensure you have successfully integrated the Pendo SDK.
5. Confirm that you can see your app as Integrated under <a href="https://app.pendo.io/admin" target="_blank">subscription settings</a>.

## Limitations
- Flutter is currently only supported by our [Track-Events solution](https://support.pendo.io/hc/en-us/articles/360061487572-Pendo-for-Mobile-Track-Events-Solution).
- To support hybrid mode in Flutter, please open a ticket.

## Developer documentation

- API documentation available [here](/api-documentation/flutter-apis.md).

## Troubleshooting

- For technical issues, please [review open issues](https://github.com/pendo-io/pendo-mobile-sdk/issues) or [submit a new issue](https://github.com/pendo-io/pendo-mobile-sdk/issues).
- Release notes can be found [here](https://developers.pendo.io/category/mobile-sdk/).
- For additional documentation, visit our [Help Center Mobile Section](https://support.pendo.io/hc/en-us/categories/4403654621851-Mobile).

