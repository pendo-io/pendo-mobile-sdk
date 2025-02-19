# React Native iOS using React Navigation

>[!NOTE]
>**Expo SDK** 41-49 using React Navigation 5+ is supported. See dedicated [Expo integration instructions](/ios/pnddocs/expo_rn-ios.md).

>[!IMPORTANT]
>We support a codeless solution for React Native 0.6-0.74 using react-navigation 5+.

>[!IMPORTANT]
>Requirements:
>- Deployment target of `iOS 11` or higher 
>- Swift Compatibility `5.7` or higher
>- Xcode `14` or higher

## Step 1. Install the Pendo SDK

1. In the **root folder of your project**, add Pendo using one of your package managers: 

    ```shell
    #example with npm
    npm install --save rn-pendo-sdk

    #example with yarn
    yarn add rn-pendo-sdk
    ```

2. In the **iOS folder**, run the following command:

    ```shell script 
    pod install
    ```

3. **Modify Javascript minification**

    When bundling for production, React Native minifies class and function names to reduce the size of the bundle.  This means there is no access to the original component names that are used for the codeless solution.

    In the application **metro.config.js**, add the following statements in the transformer:  

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

## Step 2. Integrate with the Pendo SDK

>[!NOTE]
>Find your API key in the Pendo UI under `Settings` > `Subscription settings` > select an app > `App Details`.
1. In the application **main file (App.js/.ts/.tsx)**, add the following code:  

    ```typescript
    import { PendoSDK, NavigationLibraryType } from 'rn-pendo-sdk';

    function initPendo() {
        const navigationOptions = {library: NavigationLibraryType.ReactNavigation};
        const pendoKey = 'YOUR_API_KEY_HERE';
        //note the following API will only setup initial configuration, to start collect analytics use startSession
        PendoSDK.setup(pendoKey, navigationOptions);
    }   
    initPendo();
    ```
2. Initialize Pendo where your visitor is being identified (e.g., login, register, etc.).

    ```typescript
    const visitorId = 'VISITOR-UNIQUE-ID';
    const accountId = 'ACCOUNT-UNIQUE-ID';
    const visitorData = {'Age': '25', 'Country': 'USA'};
    const accountData = {'Tier': '1', 'Size': 'Enterprise'};

    PendoSDK.startSession(visitorId, accountId, visitorData, accountData);
    ```

3. In the file where the `NavigationContainer` is created.

   Import `WithPendoReactNavigation`:

    ```typescript
    import {WithPendoReactNavigation} from 'rn-pendo-sdk'    
    ```

   Wrap `NavigationContainer` with  `WithPendoReactNavigation` HOC

    ```typescript
    const PendoNavigationContainer = WithPendoReactNavigation(NavigationContainer);    
    ```

   replace `NavigationContainer` tag with `PendoNavigationContainer` tag

    ```typescript
    <PendoNavigationContainer>
    {/* Rest of your app code */}
    </PendoNavigationContainer>
    ```

    **Notes:**  
    **visitorId**: a user identifier (e.g., John Smith)  
    **visitorData**: the user metadata (e.g., email, phone, country, etc.)  
    **accountId**: an affiliation of the user to a specific company or group (e.g., Acme inc.)  
    **accountData**: the account metadata (e.g., tier, level, ARR, etc.)  

>[!TIP]
>To begin a session for an  <a href="https://support.pendo.io/hc/en-us/articles/360032202751" target="_blank">anonymous visitor</a>, pass ```null``` or an empty string ```''``` as the Visitor ID. You can call the `startSession` API more than once and transition from an anonymous session to an identified session (or even switch between multiple identified sessions). 


## Step 3. Connect mobile device for tagging and testing

>[!NOTE]
>Find your scheme ID in the Pendo UI under `Settings` > `Subscription settings` > select an app > `App Details`.

These steps enable <a href="https://support.pendo.io/hc/en-us/articles/360033609651-Tagging-Mobile-Pages#HowtoTagaPage" target="_blank">page tagging</a>
and <a href="https://support.pendo.io/hc/en-us/articles/360033487792-Creating-a-Mobile-Guide#test-guide-on-device-0-6" target="_blank">guide testing</a> capabilities.

1. Add Pendo URL scheme to **info.plist** file:
  
      Under App Target > Info > URL Types, create a new URL by clicking the + button.  
      Set **Identifier** to pendo-pairing or any name of your choosing.  
      Set **URL Scheme** to `YOUR_SCHEME_ID`.

    <img src="https://user-images.githubusercontent.com/56674958/144723345-15c54098-28db-414c-90da-ef4a5256ae6a.png" width="500" height="300" alt="Mobile Tagging"/> <br>

2. To enable pairing from the device:
    
    a. If using AppDelegate, add or modify the **openURL** function:

    <details open>
    <summary> <b>Swift Instructions</b><i> - Click to expand or collapse</i></summary>

    ```swift
    import Pendo

    ...

    func application(_ app: UIApplication,open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme?.range(of: "pendo") != nil {
            PendoManager.shared().initWith(url)
            return true
        }
        // your code here...
        return true
    }
    ```
    </details>

    <details>
    <summary> <b>Objective-C Instructions</b><i> - Click to expand or collapse</i></summary>

    ```objective-c
    #import <Pendo/Pendo.h>

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

    <br>

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
2. In the Pendo UI, go to `Settings` > `Subscription Settings`.
3. Select your application from the list.
4. Select the `Install Settings tab` and follow the instructions under `Verify Your Installation` to ensure you have successfully integrated the Pendo SDK.
5. Confirm that you can see your app as `Integrated` under <a href="https://app.pendo.io/admin" target="_blank">subscription settings</a>.


## Developer documentation

- API documentation available [here](/api-documentation/rn-apis.md).
- Sample app with Pendo SDK integrated available <a href="https://github.com/pendo-io/RN-demo-app-React-Navigation" target="_blank">here</a>.

## Troubleshooting

- For technical issues, please [review open issues](https://github.com/pendo-io/pendo-mobile-sdk/issues) or [submit a new issue](https://github.com/pendo-io/pendo-mobile-sdk/issues).
- See our [release notes](https://developers.pendo.io/category/mobile-sdk/).
- For additional documentation, visit our [Help Center](https://support.pendo.io/hc/en-us/categories/23324531103771-Mobile-implementation).
