# Flutter Android

>[!IMPORTANT]
>Flutter codeless solution is currently in OPEN BETA

>[!IMPORTANT]
>Requirements:
>- Flutter: ">=3.3.0"
>- SDK: ">=2.18.0 < 4.0.0" 

## Step 1. Install Pendo SDK

1. In the **application folder**, run the following command:

    ```shell
    flutter pub add pendo_sdk
    ```

2. In the application **android/build.gradle** file:  
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

## Step 2. Pendo SDK integration

>[!NOTE]
>The `API Key` can be found in your Pendo Subscription Settings in App Details.

1. Add the following code in the `initState` method:

    ```dart
    import 'package:pendo_sdk/pendo_sdk.dart';
    var pendoKey = 'YOUR_API_KEY_HERE';
    await PendoSDK.setup(pendoKey);
    ```

2. Initialize Pendo where your visitor is being identified (e.g. login, register, etc.).

    ```dart
    import 'package:pendo_sdk/pendo_sdk.dart';
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
    >To begin a session for an  <a href="https://support.pendo.io/hc/en-us/articles/360032202751" target="_blank">anonymous visitor</a>, pass ```null``` or an empty string ```''``` as the visitor id. You can call the `startSession` API more than once and transition from an anonymous session to an identified session (or even switch between multiple identified sessions). 


3. Add Navigation Observers <br>
Add PendoNavigationObserver for each app Navigator
    ```dart
    // For main Navigator in MaterialApp/CupertinoApp 
    return MaterialApp(
        ...
        navigatorObservers: [
            PendoNavigationObserver()
        ],); 

    // For Navigator widget
    return Navigator(
        ...
        observers: [
            PendoNavigationObserver()
        ],);
        
    // For Routes API with GoRouter 3d party
    final router = GoRouter(
        observers: [PendoNavigationObserver()],
        routes: [
        ...
    ]
    )

    ```
4. Add clicks listener<br>
At the root of the project, wrap the main widget with PendoActionListener:
    ```dart
    Widget build(BuildContext context) {
    return PendoActionListener( // Use PendoActionListener to track action clicks 
      child: MaterialApp(
        title: 'Title',
        home: Provider(
        create: (context) => MyHomePageStore()..initList(),
          child: MyHomePage(title: Strings.appName),
        ),
        navigatorObservers: [PendoNavigationObserver()], // Use Pendo Observer to track the Navigator stack transitions
        );
    )
    }

    ```

>[!TIP]
>In some cases you may find Track Events useful to capture specific analytics events.
 In the application files where you want to track an event, add the following code:
 ```dart
 import 'package:pendo_sdk/pendo_sdk.dart';
 await PendoSDK.track('name', { 'firstProperty': 'firstPropertyValue', 'secondProperty': 'secondPropertyValue'});
 ```

## Step 3. Mobile device connectivity for testing

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

## Step 4. Verify installation

1. Test using Android Studio:  
Run the app while attached to the Android Studio.  
Review the Android Studio logcat and look for the following message:  
`Pendo SDK was successfully integrated and connected to the server.`
2. In the Pendo UI, go to Settings>Subscription Settings.
3. Select the **Applications** tab and then your application.
4. Select the Install Settings tab and follow the instructions under Verify Your Installation to ensure you have successfully integrated the Pendo SDK.
5. Confirm that you can see your app as Integrated under <a href="https://app.pendo.io/admin" target="_blank">subscription settings</a>.

## Limitations
- [Notes, Known Issues & Limitations](/other/flutter-notes-known-issues-limitations.md).
- To support hybrid mode in Flutter, please open a ticket.

## Developer documentation

- API documentation available [here](/api-documentation/flutter-apis.md).
- Integration of native with Flutter components available [here](/other/native-with-flutter-components.md).


## Troubleshooting

- For technical issues, please [review open issues](https://github.com/pendo-io/pendo-mobile-sdk/issues) or [submit a new issue](https://github.com/pendo-io/pendo-mobile-sdk/issues).
- Release notes can be found [here](https://developers.pendo.io/category/mobile-sdk/).
- For additional documentation, visit our [Help Center Mobile Section](https://support.pendo.io/hc/en-us/categories/23324531103771-Mobile-implementation).
