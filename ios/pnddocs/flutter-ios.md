# Flutter iOS

>[!IMPORTANT]
>[Flutter Obfuscation issue](https://github.com/pendo-io/pendo-mobile-sdk/issues/196#issue-2605284796)<br><br>
>Migration from the track-event solution to the low-code solution:
> 1. Refer to [Step 2](#step-2-pendo-sdk-integration) in the installation guide, and verify the addition of the navigationObserver and clickListener.
> 2. The migration process will take up to 24 hours to complete and be reflected in Pendo, during the processing time, you will not be able to tag Pages and Features.

>[!IMPORTANT]
>Requirements:
>- Flutter: ">=3.16.0"
>- SDK: ">=3.2.0 < 4.0.0"
>
>Supported Navigation Libraries:
>
>- GoRouter 13.0 or higher
>- AutoRoute 7.0 or higher

## Step 1. Add Pendo dependency 
In the root folder of your flutter app add the Pendo package: `flutter pub add pendo_sdk`.

## Step 2. Integrate with the Pendo SDK

>[!NOTE]
>Find your API key in the Pendo UI under `Settings` > `Subscription settings` > select an app > `App Details`.

1. For optimal integration place the following code at the beginning of your app's execution:
    ```dart
    import 'package:pendo_sdk/pendo_sdk.dart';
    var pendoKey = 'YOUR_API_KEY_HERE';
    await PendoSDK.setup(pendoKey);
    ```

2. Initialize the Pendo Session where your visitor is being identified (e.g.,. login, register, etc.).
    ```dart
    import 'package:pendo_sdk/pendo_sdk.dart';
    final String visitorId = 'John Smith';
    final String accountId = 'Acme Inc.';
    final dynamic visitorData = {'Age': '25', 'Country': 'USA'};
    final dynamic accountData = {'Tier': '1', 'Size': 'Enterprise'};

    await PendoSDK.startSession(visitorId, accountId, visitorData, accountData);
    ```

>[!TIP]
>To begin a session for an  <a href="https://support.pendo.io/hc/en-us/articles/360032202751" target="_blank">anonymous visitor</a>, pass ```null``` or an empty string ```''``` as the Visitor ID. You can call the `startSession` API more than once and transition from an anonymous session to an identified session (or even switch between multiple identified sessions). 

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
> [!TIP]
> The Pendo SDK uses the `Route` name to uniquely identify each `Route`. Pendo highly recommends that you give a unique name to each route in the `RouteSettings`. The unique names must also be applied to the `showModalBottomSheet` api.

<ins>**Navigation Types:**<ins><br>

* **_GoRouter_**

    When using `GoRouter`, change the `setup` API call to include the correct navigation library, like so:
    ```dart
    PendoSDK.setup(pendoKey, navigationLibrary: NavigationLibrary.GoRouter);
    ```
    When using `GoRouter`, apply the `addPendoListenerToDelegate()` to your `GoRouter` instance.
    Make sure to add it once (e.g., adding it in the build method will be less desired)
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

> [!TIP]
> Pendo SDK uses routerDelegate listener to track route change analytics, make sure your route is included in the GoRouter routes     

* **_AutoRoute_**

    When using `AutoRoute`, change the `setup` API call to include the correct navigation library, like so:
    ```dart
    PendoSDK.setup(pendoKey, navigationLibrary: NavigationLibrary.AutoRoute);
    ```

    When using `AutoRoute`, apply the `addPendoListenerToDelegate()` to your `AutoRoute.config()` instance. <br>
    Make sure to add it once (e.g., adding it in the build method will be less desired)<br>

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
> [!TIP]
> Pendo SDK uses routerDelegate listener to track route change analytics, make sure your route is included in the AutoRoute routes.

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

## Step 3. Mobile device connectivity and testing

>[!NOTE]
>Find your scheme ID in the Pendo UI under `Settings` > `Subscription settings` > select an app > `App Details`.

These steps enable  <a href="https://support.pendo.io/hc/en-us/articles/360033487792-Creating-a-Mobile-Guide#test-guide-on-device-0-6" target="_blank">guide testing capabilities</a>.

1. **Add Pendo URL scheme to **info.plist** file:**

   Under App Target > Info > URL Types, create a new URL by clicking the + button.  
   Set **Identifier** to pendo-pairing or any name of your choosing.  
   Set **URL Scheme** to `YOUR_SCHEME_ID_HERE`.

    <img src="https://user-images.githubusercontent.com/56674958/144723345-15c54098-28db-414c-90da-ef4a5256ae6a.png" width="500" height="300" alt="Mobile Tagging">

2. **To enable pairing from the device:**

    In the AppDelegate file add or modify the **openURL** function:

    <details open>
    <summary> <b>Swift Instructions</b><i> - Click to expand or collapse</i></summary>

    ```swift
    import Pendo

    @UIApplicationMain
    class AppDelegate:  FlutterAppDelegate {
        override func application(_ app: UIApplication,open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
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

## Step 4. Verify installation

1. Test using Xcode:  
Run the app while attached to Xcode.  
Review the Xcode console and look for the following message:  
`Pendo Mobile SDK was successfully integrated and connected to the server.`
2. In the Pendo UI, go to `Settings` > `Subscription Settings`.
3. Select your application from the list.
4. Select the `Install Settings tab` and follow the instructions under `Verify Your Installation` to ensure you have successfully integrated the Pendo SDK.
5. Confirm that you can see your app as `Integrated` under <a href="https://app.pendo.io/admin" target="_blank">subscription settings</a>.

## Limitations
- [Notes, Known Issues & Limitations](/other/flutter-notes-known-issues-limitations.md).
- To support hybrid mode in Flutter, please open a ticket.

## Developer documentation

- API documentation available [here](/api-documentation/flutter-apis.md).
- See [Native application with Flutter components](/other/native-with-flutter-components.md) integration instructions.


## Troubleshooting

- For technical issues, please [review open issues](https://github.com/pendo-io/pendo-mobile-sdk/issues) or [submit a new issue](https://github.com/pendo-io/pendo-mobile-sdk/issues).
- See our [release notes](https://developers.pendo.io/category/mobile-sdk/).
- For additional documentation, visit our [Help Center](https://support.pendo.io/hc/en-us/categories/23324531103771-Mobile-implementation).

