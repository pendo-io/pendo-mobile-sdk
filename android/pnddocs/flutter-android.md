# Flutter Android

>[!IMPORTANT]
>Flutter low-code solution is currently in Beta.<br><br>
>Migration from the track-event solution to the low-code solution:
> 1. Refer to [Step 2](#step-2-pendo-sdk-integration) in the installation guide, and verify the addition of the navigationObserver and clickListener.
> 2. The migration process will take up to 24 hours to complete and be reflected in Pendo, during the processing time, you will not be able to tag Pages and Features.

>[!IMPORTANT]
>Requirements:
>- Flutter: ">=3.16.0"
>- SDK: ">=3.2.0 < 4.0.0" 
>- Android Gradle Plugin `7.2` or higher
>- Kotlin version `1.9.0` or higher
>- JAVA version `11` or higher
>- minSdkVersion `21` or higher
>- compileSDKVersion `33` or higher

## Step 1. Install Pendo SDK

1. In the **application folder**, run the following command:

    ```shell
    flutter pub add pendo_sdk
    ```

2. In the application **android/build.gradle** file:  
- **Add the Pendo Repository to the repositories section under the allprojects section**

    ```java
    allprojects { 
        repositories {
            maven {
                url "https://software.mobile.pendo.io/artifactory/androidx-release"
            }
            mavenCentral()
        }
    ```

- Minimum SDK Version:  
If applicable, set your app to be **minSdkVersion 21** or higher:

    ```java
    android {
        minSdkVersion 21
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

1. For optimal integration place the following code at the beginning of your app's execution:

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
    When using `Flutter Navigator API` add PendoNavigationObserver for each app Navigator:
    ```dart
    import 'package:pendo_sdk/pendo_sdk.dart';
    // Observes the MaterialApp/CupertinoApp main Navigator
    return MaterialApp(
        ...
        navigatorObservers: [
            PendoNavigationObserver()
        ],); 

    // Observes the nested widget Navigator
    return Navigator(
        ...
        observers: [
            PendoNavigationObserver()
        ],);
    ```

    >[!NOTE]
    >The Pendo SDK uses the `Route` name to uniquely identify each `Route`. For the best practice please make sure to provide each route with unique name in the `RouteSettings`.<br>

    When using `GoRouter`, apply the `addPendoListenerToDelegate` to your `GoRouter` instance. <br>
    Make sure to add it once (e.g adding it in the build method will be less desired)<br>
    `GoRouter` is supported from version 13.0 <br>
    ```dart
    import 'package:pendo_sdk/pendo_sdk.dart';

    final GoRouter _router = GoRouter()..addPendoListenerToDelegate()
    
    class _AppState extends State<App> {
        @override
        Widget build(BuildContext context) {
            return PendoActionListener(
                child: MaterialApp.router(
                routerConfig: _router,
                ),
            );
        }
    }
    ```

    <br>

    When using `AutoRoute`, apply the `addPendoListenerToDelegate()` to your `AutoRoute.config()` instance. <br>
    Make sure to add it once (e.g adding it in the build method will be less desired)<br>
    `AutoRoute` is supported from version 7.0 <br>
    ```dart
    import 'package:pendo_sdk/pendo_sdk.dart';

    @AutoRouterConfig()
    class AppRouter extends RootStackRouter {
        @override
        List<AutoRoute> get routes => [];
    }

    final AppRouter _router = AppRouter()..config().addPendoListenerToDelegate();

    class _AppState extends State<App> {
        @override
        Widget build(BuildContext context) {
            return PendoActionListener(
                child: MaterialApp.router(
                routerConfig: _router.config(),
                ),
            );
        }
    }
    ```

4. Add a click listener<br>
Wrap the main widget with a PendoActionListener in the root of the project:
    ```dart
    import 'package:pendo_sdk/pendo_sdk.dart';
    Widget build(BuildContext context) {
    return PendoActionListener( // Use the PendoActionListener to track action clicks 
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
>You can use track events to programmatically notify Pendo of custom events of interest:
> ```dart
> import 'package:pendo_sdk/pendo_sdk.dart';
> await PendoSDK.track('name', { 'firstProperty': 'firstPropertyValue', 'secondProperty': 'secondPropertyValue'});
> ```

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
