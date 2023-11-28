# Flutter Android

>[!IMPORTANT]
>Flutter is supported by our track events only solution. The codeless solution is still in progress.

>[!IMPORTANT]
>Requirements:
>- Flutter 3.3 and above
>- Dart 2.18 and above 

## Step 1. Install Pendo SDK

1. In the **application folder**, run the following command:

    ```shell
    flutter pub add pendo_sdk
    ```

2. In the application **build.gradle** file:  
- Add the Pendo Repository to the repositories section:

    ```java
    repositories {
        maven {
            url "https://software.mobile.pendo.io/artifactory/androidx-release"
        }
    mavenCentral()
    }
    ```

- Minimum and compile SDK Version:  
If applicable, set your app to be compiled with **compileSdkVersion 33** or higher and **minSdkVersion 21** or higher:

    ```java
    android {
        minSdkVersion 21
        compileSdkVersion 33
    }
    ```



3. In the application **Android.manifest** file:  
If applicable, add the following `<uses-permission>` to the manifest in the `<manifest>` tag:

    ```xml
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
    ```

4. Using ProGuard / R8  
- If you are using **ProGuard**, the rules that need to be added to ProGuard are in this file: [pendo-proguard.cfg](/android/pnddocs/pendo-proguard.cfg)

- If you are using **ProGuard(D8/DX only)** to perform compile-time code optimization and have`proguard-android-optimize.txt`, add the following in the optimizations code line:
`!code/allocation/variable`  
Your optimizations line should look like this:  
`-optimizations *other optimizations*,!code/allocation/variable`

## Step 2. Pendo SDK integration

>[!NOTE]
>The `API Key` can be found in your Pendo Subscription Settings under the App Details Section.

In the application **main file (lib/main.dart)**, add the following code:  

```dart
import 'package:pendo_sdk/pendo_sdk.dart';
```

1. Add the following code in the `initState` method:

    ```dart
    var pendoKey = 'YOUR_API_KEY_HERE';
    await PendoSDK.setup(pendoKey);
    ```

2. Initialize Pendo where your visitor is being identified (e.g. login, register, etc.).

    ```dart
    final String visitorId = 'VISITOR-UNIQUE-ID';
    final String accountId = 'ACCOUNT-UNIQUE-ID';
    final Map<String, dynamic> visitorData = {'Age': '25', 'Country': 'USA'};
    final Map<String, dynamic> accountData = {'Tier': '1', 'Size': 'Enterprise'};

    await PendoSDK.startSession(visitorId, accountId, visitorData, accountData);
    ```

    **Notes:**

    **visitorId**: a user identifier (e.g. John Smith)  
    **visitorData**: the user metadata (e.g. email, phone, country, etc.)  
    **accountId**: an affiliation of the user to a specific company or group (e.g. Acme inc.)  
    **accountData**: the account metadata (e.g. tier, level, ARR, etc.)  

>[!TIP]
>Passing `null` or `""` or not setting the `visitorId` will generate an <a href="https://help.pendo.io/resources/support-library/analytics/anonymous-visitors.html" target="_blank">anonymous visitor id</a>.

3. Track events

    Configure Pendo Track Events to capture analytics to notify Pendo of analytics events.

    In the application files where you want to track an event, add the following code:

    ```dart
    import 'package:pendo_sdk/pendo_sdk.dart';
    ```

    ```dart
    await PendoSDK.track('name', { 'firstProperty': 'firstPropertyValue', 'secondProperty': 'secondPropertyValue'});
    ```

## Step 3. Mobile device connectivity for testing

>[!NOTE]
>The `Scheme ID` can be found in your Pendo Subscription Settings under the App Details Section.

These steps allow <a href="https://support.pendo.io/hc/en-us/articles/360033487792-Creating-a-Mobile-Guide#test-guide-on-device-0-6" target="_blank">guide testing capabilities</a>.

Add the following `<activity>` to the manifest in the `<application>` tag:

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

## Step 4. Verify installation

1. Test using Android Studio:  
Run the app while attached to the Android Studio.  
Review the device log and look for the following message:  
`Pendo SDK was successfully integrated and connected to the server.`
2. In the Pendo UI, go to Settings>Subscription Settings.
3. Hover over your app and select View app details.
4. Select the Install Settings tab and follow the instructions under Verify Your Installation to ensure you have successfully integrated the Pendo SDK.
5. Confirm that you can see your app as Integrated under <a href="https://app.pendo.io/admin" target="_blank">subscription settings</a>.

## Pivots
Pay attention to the following APIs ``` setup ``` and ```startSession```; the former *must* be called once per session and it creates initial setup for the SDK, the latter should be called when you have the visitor you would like to assign the analytics/guides to. If you want an anonymous visitor, pass ```nil``` to the ```startSession``` and call it again as soon as you have the visitor. 

## Limitations
- Flutter is currently only supported by our [Track-Events solution](https://support.pendo.io/hc/en-us/articles/360061487572-Pendo-for-Mobile-Track-Events-Solution).
- To support hybrid mode in Flutter, please open a ticket.

## Developer documentation

- API documentation available [here](/api-documentation/flutter-apis.md)

## Troubleshooting

- For technical issues please [review open issues](https://github.com/pendo-io/pendo-mobile-sdk/issues) or [submit a new issue](https://github.com/pendo-io/pendo-mobile-sdk/issues).
- Release notes can be found [here](https://developers.pendo.io/category/mobile-sdk/).
- For additional documentation visit our [Help Center Mobile Section](https://support.pendo.io/hc/en-us/categories/4403654621851-Mobile).