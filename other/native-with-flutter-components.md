# Native application with Flutter components

>[!IMPORTANT]
>Flutter is supported by our track events only solution. The codeless solution is still in progress.

>[!IMPORTANT]
>Requirements:
>- Flutter 3.3 and above
>- Dart 2.18 and above 

>[!NOTE]
>These instructions assume prior knowledge of [Flutter integrated into your existing native app piecemeal, as a library or module](https://docs.flutter.dev/add-to-app).

## Table of contents:
- [Add the Pendo dependency](#add-the-pendo-dependency)
- [Android integration](#android-integration)
- [iOS integration](#ios-integration)
- [Sending a track event from the dart side](#sending-a-track-event-from-the-dart-side)
- [Limitations](#limitations)
- [Developer documentation](#developer-documentation)
- [Troubleshooting](#troubleshooting)


## Add the Pendo dependency

In the `pubspec.yaml` file, add the Pendo plugin under the dependencies section:
```shell
# make sure you are using the latest version. This is just an example:
pendo_sdk: ^3.2.0 
```

In the terminal, run: `flutter pub get`


## Android integration

### Step 1. Install the Pendo SDK

>[!NOTE]
>The `API Key` can be found in your Pendo Subscription Settings in App Details.


1. Add Pendo Repository to build.gradle:

    ```java
    repositories {
        maven {
            url "https://software.mobile.pendo.io/artifactory/androidx-release"
        }
        mavenCentral()
    }
    ```

2. Add Pendo as a dependency to 

    ```java
    dependencies {
        implementation group:'sdk.pendo.io' , name:'pendoIO', version:'3.2.+', changing:true
    }
    ```

3. In the application **AndroidManifest.xml** file:  
Add the following `<uses-permission>` to the manifest in the `<manifest>` tag:

    ```xml
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
    ```

4. Using ProGuard / R8  
- If you are using **ProGuard**, the rules that need to be added to ProGuard can be found here: [pendo-proguard.cfg](/android/pnddocs/pendo-proguard.cfg).


- If you are using **ProGuard(D8/DX only)** to perform compile-time code optimization, and have `{Android SDK Location}/tools/proguard/proguard-android-optimize.txt`, add `!code/allocation/variable` to the `-optimizations` line in your `app/proguard-rules.pro` file. 
The optimizations line should look like this:  
`-optimizations *other optimizations*,!code/allocation/variable`

### Step 2. Pendo SDK integration 

Init the SDK from the native and register the plugin:

```kotlin
package io.tsh.flutterloginembedding

import android.app.Application
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugins.GeneratedPluginRegistrant
import sdk.pendo.io.Pendo

class App : Application() {

    companion object {
        const val FLUTTER_ENGINE_ID = "newLoginEngine"
    }

    override fun onCreate() {

        super.onCreate()

        // Instantiate a FlutterEngine and 
        val flutterEngine = FlutterEngine(this)

        // Execute the Dart code to pre-warm the FlutterEngine
        flutterEngine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )

        // Cache the FlutterEngine to be used by FlutterActivity
        FlutterEngineCache
            .getInstance()
            .put(FLUTTER_ENGINE_ID, flutterEngine)

        // connect to Pendo's server
        Pendo.setup(
        this,
        "YOUR_API_KEY_HERE",
        null, // PendoOptions (use only if instructed by Pendo support)
        null  // PendoPhasesCallbackInterface (Optional)
        );

        // start a session
        val visitorId = "VISITOR-UNIQUE-ID"
        val accountId = "ACCOUNT-UNIQUE-ID"

        val visitorData = HashMap<String, Any>()
        visitorData.put("age", 27)
        visitorData.put("country", "USA")

        val accountData = HashMap<String, Any>() 
        accountData.put("Tier", 1)
        accountData.put("Size", "Enterprise")

        Pendo.startSession(
            visitorId,
            accountId,
            visitorData,
            accountData)

        // Connect the plugin 
        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }
}
```

>[!TIP]
>To begin a session for an  <a href="https://help.pendo.io/resources/support-library/analytics/anonymous-visitors.html" target="_blank">anonymous visitor</a>, pass ```null``` or an empty string ```''``` as the visitor id. You can call the `startSession` API more than once and transition from an anonymous session to an identified session (or even switch between multiple identified sessions). 



### Step 3. Mobile device connectivity for testing

>[!NOTE]
>The `Scheme ID` can be found in your Pendo Subscription Settings in App Details.

This step enables <a href="https://support.pendo.io/hc/en-us/articles/360033487792-Creating-a-Mobile-Guide#test-guide-on-device-0-6" target="_blank">guide testing capabilities</a>.

Add the following **activity** to the application **AndroidManifest.xml** in the `<Application>` tag:

```xml
<activity android:name="sdk.pendo.io.activities.PendoGateActivity" android:launchMode="singleInstance" android:exported="true">
<intent-filter>
        <action android:name="android.intent.action.VIEW"/>
        <category android:name="android.intent.category.DEFAULT"/>
        <category android:name="android.intent.category.BROWSABLE"/>
        <data android:scheme="YOUR_SCHEME_ID_HERE"/>
    </intent-filter>
</activity>
```

### Step 4. Verify installation

1. Test using Android Studio:  
Run the app while attached to the Android Studio.  
Review the Android Studio logcat and look for the following message:  
`Pendo SDK was successfully integrated and connected to the server.`
2. In the Pendo UI, go to Settings>Subscription Settings.
3. Select the **Applications** tab and then your application.
4. Select the Install Settings tab and follow the instructions under Verify Your Installation to ensure you have successfully integrated the Pendo SDK.
5. Confirm that you can see your app as Integrated under <a href="https://app.pendo.io/admin" target="_blank">subscription settings</a>.



## iOS integration

### Step 1. Install the Pendo SDK

In your native app folder, run: `pod install`

### Step 2. Pendo SDK Integration

>[!NOTE]
>The `API Key` can be found in your Pendo Subscription Settings in App Details.


<details open>
<summary> <b>Swift Instructions</b><i> - Click to expand or collapse</i></summary>

<br>

Using Swift, to access the PendoSDK.h, include it in the Bridging-Header.h of your app, adding: <br> `#import "PendoSDK.h"`

Setup the SDK in the native code and register the plugin as follows:

```swift
import UIKit
import Flutter
import FlutterPluginRegistrant
import Pendo

class AppDelegate: FlutterAppDelegate {

    lazy var flutterEngine = FlutterEngine(name: "my flutter engine")

    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // connect to Pendo's server
        PendoManager.shared().setup("YOUR_API_KEY_HERE")

        // start a session
        let visitorId = "John Doe"
        let accountId = "ACME"
        let visitorData: [String : any Hashable] = ["age": 27, "country": "USA"]
        let accountData: [String : any Hashable] = ["Tier": 1, "size": "Enterprise"]
        PendoManager.shared().startSession(visitorId, accountId:accountId, visitorData:visitorData, accountData:accountData)  
        
        // Run the default Dart entrypoint with a default Flutter route
        flutterEngine.run()

        // Connect the plugin to the iOS platform code
        GeneratedPluginRegistrant.register(with: self.flutterEngine)

        // Register the Pendo Plugin
        PendoSDK.registerWithRegistry(self.flutterEngine)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions);
    }
 } 
```
</details>

<details>
<summary> <b>Objective-C Instructions</b><i> - Click to expand or collapse</i></summary>

<br>

Setup the SDK in the native code in your `AppDelegate` file and register the plugin as follows:

```objectivec
@import Flutter;
@import Pendo;
#import "PendoSDK.h"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // connect to Pendo's server
    [[PendoManager sharedManager] setup:@"YOUR_API_KEY_HERE"];

    // start a session
    [[PendoManager sharedManager] startSession:@"John Doe" accountId:@"ACME" visitorData:@{@"age": @27, @"country": @"USA"} accountData:@{@"Tier": @1, @"size": @"Enterprise"}];

    // Run the default Dart entrypoint with a default Flutter route
    FlutterEngine *flutterEngine = [[FlutterEngine alloc] initWithName:@"my flutter engine"];
    [flutterEngine run];

    // Connect the plugin to the iOS platform code
    [GeneratedPluginRegistrant registerWithRegistry:flutterEngine];

    // Register the Pendo Plugin
    [PendoFlutterPlugin registerWithRegistry:flutterEngine];

    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
   if ([[url scheme] containsString:@"pendo"]) {
      [[PendoManager sharedManager] initWithUrl:url];
      return YES;
   }

   return YES;
}
```
</details>

>[!TIP]
>To begin a session for an  <a href="https://help.pendo.io/resources/support-library/analytics/anonymous-visitors.html" target="_blank">anonymous visitor</a>, pass ```null``` or an empty string ```''``` as the visitor id. You can call the `startSession` API more than once and transition from an anonymous session to an identified session (or even switch between multiple identified sessions). 

### Step 3. Mobile device connectivity and testing

>[!NOTE]
>The `Scheme ID` can be found in your Pendo Subscription Settings in App Details.

These steps enable  <a href="https://support.pendo.io/hc/en-us/articles/360033487792-Creating-a-Mobile-Guide#test-guide-on-device-0-6" target="_blank">guide testing capabilities</a>.

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

### Step 4. Verify installation

1. Test using Xcode:  
Run the app while attached to Xcode.  
Review the Xcode console and look for the following message:  
`Pendo Mobile SDK was successfully integrated and connected to the server.`
2. In the Pendo UI, go to Settings>Subscription Settings.
3. Select the **Applications** tab and then your application.
4. Select the Install Settings tab and follow the instructions under Verify Your Installation to ensure you have successfully integrated the Pendo SDK.
5. Confirm that you can see your app as Integrated under <a href="https://app.pendo.io/admin" target="_blank">subscription settings</a>.

## Sending a track event from the dart side

Configure Pendo Track Events to capture analytics to notify Pendo of analytics events. In the application files where you want to track an event, add the following code:

```dart
import 'package:pendo_sdk/pendo_sdk.dart';

await PendoFlutterPlugin.track('name', { 'firstProperty': 'firstPropertyValue', 'secondProperty': 'secondPropertyValue'});
```

## Limitations
- Flutter is currently only supported by our [Track Events solution](https://support.pendo.io/hc/en-us/articles/360061487572-Codeless-tracking-vs-Track-Events).

## Developer documentation

- Android native API documentation available [here](/api-documentation/native-android-apis.md).
- iOS native API documentation available [here](/api-documentation/native-ios-apis.md).
- Flutter plugin API documentation available [here](/api-documentation/flutter-apis.md).


## Troubleshooting

- For technical issues, please [review open issues](https://github.com/pendo-io/pendo-mobile-sdk/issues) or [submit a new issue](https://github.com/pendo-io/pendo-mobile-sdk/issues).
- Release notes can be found [here](https://developers.pendo.io/category/mobile-sdk/).
- For additional documentation, visit our [Help Center Mobile Section](https://support.pendo.io/hc/en-us/categories/23324531103771-Mobile-implementation).

