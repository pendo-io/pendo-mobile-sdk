# React Native Android using React Native Navigation

>[!NOTE]
>**Expo SDK** 41-49 using React Native Navigation 6+ is supported. See dedicated [Expo integration instructions](/android/pnddocs/expo_rnn-android.md).

>[!IMPORTANT]
>We support a codeless solution for React Native 0.6-0.72 using react-native-navigation 6+.

## Step 1. Install the Pendo SDK

1. In the **root folder of your project**, add Pendo using one of your package managers: 

    ```shell
    #example with npm
    npm install --save rn-pendo-sdk

    #example with yarn
    yarn add rn-pendo-sdk
    ```

2. In the application **android/build.gradle** file.  
- **add the Pendo Repository to the repositories section under the allprojects section**:

    ```java
    allprojects { 
        repositories {
            maven {
                url "https://software.mobile.pendo.io/artifactory/androidx-release"
            }
            mavenCentral()
        }
    }
    ```

- **Minimum and compile Sdk versions**:  
If applicable, set your app to be compiled with **compileSdkVersion 33** or higher and **minSdkVersion 21** or higher:

    ```java
    android {
        minSdkVersion 21
        compileSdkVersion 33
    }
    ```
 
3. In the application **AndroidManifest.xml** file.  
Add the following `<uses-permission>` to the manifest in the `<manifest>` tag:

    ```xml
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
    ```

4. Modify Javascript minification

    When bundling for production, React Native minifies class and function names to reduce the size of the bundle.
This means there is no access to the original component names that are used for the codeless solution.

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

5.  #### Using ProGuard 
  
    If you are using **ProGuard(D8/DX only)** to perform compile-time code optimization, and have `{Android SDK Location}/tools/proguard/proguard-android-optimize.txt`, add `!code/allocation/variable` to the `-optimizations` line in your `app/proguard-rules.pro` file. The optimizations line should look like this:  
    `-optimizations *other optimizations*,!code/allocation/variable`

## Step 2. Pendo SDK integration

>[!NOTE]
>The `API Key` can be found in your Pendo Subscription Settings in App Details.

1. In the application **main file (App.js/.ts/.tsx)**, add the following code:

    ```javascript
    import { PendoSDK, NavigationLibraryType } from 'rn-pendo-sdk';
    import { Navigation } from "react-native-navigation";

    function initPendo() {
        const navigationOptions = {library: NavigationLibraryType.ReactNativeNavigation, navigation: Navigation};
        const pendoKey = 'YOUR_API_KEY_HERE';
        //note the following API will only setup initial configuration, to start collect analytics use startSession
        PendoSDK.setup(pendoKey, navigationOptions);
    }   
    initPendo();
    ```

2. Initialize Pendo where your visitor is being identified (e.g. login, register, etc.).

    ```javascript
    const visitorId = 'VISITOR-UNIQUE-ID';
    const accountId = 'ACCOUNT-UNIQUE-ID';
    const visitorData = {'Age': '25', 'Country': 'USA'};
    const accountData = {'Tier': '1', 'Size': 'Enterprise'};

    PendoSDK.startSession(visitorId, accountId, visitorData, accountData);
    ```

    **Notes:**  

    **visitorId**: a user identifier (e.g. John Smith)  
    **visitorData**: the user metadata (e.g. email, phone, country, etc.)  
    **accountId**: an affiliation of the user to a specific company or group (e.g. Acme inc.)  
    **accountData**: the account metadata (e.g. tier, level, ARR, etc.)  

>[!TIP]
>To begin a session for an  <a href="https://help.pendo.io/resources/support-library/analytics/anonymous-visitors.html" target="_blank">anonymous visitor</a>, pass ```null``` or an empty string ```''``` as the visitor id. You can call the `startSession` API more than once and transition from an anonymous session to an identified session (or even switch between multiple identified sessions). 


## Step 3. Mobile device connectivity for tagging and testing

>[!NOTE]
>The `Scheme ID` can be found in your Pendo Subscription Settings in App Details.

This step enables page <a href="https://support.pendo.io/hc/en-us/articles/360033609651-Tagging-Mobile-Pages#HowtoTagaPage" target="_blank">tagging</a>
and <a href="https://support.pendo.io/hc/en-us/articles/360033487792-Creating-a-Mobile-Guide#test-guide-on-device-0-6" target="_blank">guide</a> testing capabilities.

Add the following **activity** to the application **AndroidManifest.xml** in the **<Application>** tag:

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

## Developer documentation

- API documentation available [here](/api-documentation/rn-apis.md).
- Sample app with Pendo SDK integrated available <a href="https://github.com/pendo-io/RN-demo-app-React-Native-Navigation" target="_blank">here</a>.

## Troubleshooting

- For technical issues, please [review open issues](https://github.com/pendo-io/pendo-mobile-sdk/issues) or [submit a new issue](https://github.com/pendo-io/pendo-mobile-sdk/issues).
- Release notes can be found [here](https://developers.pendo.io/category/mobile-sdk/).
- For additional documentation, visit our [Help Center Mobile Section](https://support.pendo.io/hc/en-us/categories/4403654621851-Mobile).