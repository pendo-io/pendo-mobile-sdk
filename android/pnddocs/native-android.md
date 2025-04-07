# Native Android

>[!NOTE]
>The following integration instructions are relevant for SDK 3.0 or higher. <br> Follow our migration instructions to [upgrade from SDK 2.x to 3.0](/migration-docs/README.md) or refer to our [2.x integration instruction](https://github.com/pendo-io/pendo-mobile-sdk/blob/2.22.5/README.md).

>[!IMPORTANT]
>**Jetpack Compose (Beta)**, is available starting from SDK 3.3.0. Support includes:
>- Code-based tooltips
>
> Please see integration instructions [here](https://github.com/pendo-io/pendo-mobile-sdk/blob/master/android/pnddocs/jetpack_compose-android.md).
>
>


>[!IMPORTANT]
>Requirements:
>- Android Gradle Plugin `7.2` or higher
>- Kotlin version `1.9.0` or higher
>- JAVA version `11` or higher
>- minSdkVersion `21` or higher
>- compileSDKVersion `33` or higher
>- androidx.compose.ui:ui `1.5.0` or higher if the app contains Jetpack Compose

## Step 1. Install Pendo SDK

1. #### Add the Pendo repository to the app's build.gradle or to the settings.gradle if using dependencyResolutionManagement:

    ```java
    repositories {
        maven {
            url = uri("https://software.mobile.pendo.io/artifactory/androidx-release")
        }
        mavenCentral()
    }
    ```

2. #### Add Pendo as a dependency to **android/build.gradle** file:

    ```shell
    dependencies {
       implementation group:'sdk.pendo.io' , name:'pendoIO', version:'3.4+', changing:true
    }
    ```

3. **Minimum and compile SDK versions**:

    If applicable, set your app to be compiled with **compileSdkVersion 33** or higher and **minSdkVersion 21** or higher:

    ```java
    android {
        minSdkVersion 21
        compileSdkVersion 33
    }
    ```
 
4. #### Using ProGuard

    If you are using **ProGuard(D8/DX only)** to perform compile-time code optimization, and have `{Android SDK Location}/tools/proguard/proguard-android-optimize.txt`, add `!code/allocation/variable` to the `-optimizations` line in your `app/proguard-rules.pro` file. The optimizations line should look like this:  
    `-optimizations *other optimizations*,!code/allocation/variable`

## Step 2. Pendo SDK integration

>[!NOTE]
>The `API Key` can be found in your Pendo Subscription Settings in App Details.

1. Set up Pendo in the **Application class**.

    The following code is required in the **onCreate** method:

    ```java
    import sdk.pendo.io.*;

    String pendoApiKey = "YOUR_API_KEY_HERE";
    
    Pendo.setup(
       this,
       pendoApiKey,
       null, // PendoOptions (use only if instructed by Pendo support)
       null  // PendoPhasesCallbackInterface (Optional)
    );
    ```

2. Initialize Pendo in the **Activity/fragment** where your visitor is being identified.

    ```java
    String visitorId = "VISITOR-UNIQUE-ID";
    String accountId = "ACCOUNT-UNIQUE-ID";

    // send Visitor Level Data
    HashMap<String, Object> visitorData = new HashMap<>();
    visitorData.put("age", 27);
    visitorData.put("country", "USA");

    // send Account Level Data
    HashMap<String, Object> accountData = new HashMap<>();
    accountData.put("Tier", 1);
    accountData.put("Size", "Enterprise");

    Pendo.startSession(
        visitorId,
        accountId,
        visitorData,
        accountData
   );
    ```

    **visitorId**: a user identifier (e.g. John Smith)  
    **visitorData**: the user metadata (e.g. email, phone, country, etc.)  
    **accountId**: an affiliation of the user to a specific company or group (e.g. Acme inc.)  
    **accountData** : the account metadata (e.g. tier, level, ARR, etc.)  
&nbsp;  
    This code ends the previous mobile session (if applicable), starts a new mobile session and retrieves all guides based on the provided information.  
&nbsp;  

>[!TIP]
>To begin a session for an  <a href="https://support.pendo.io/hc/en-us/articles/360032202751" target="_blank">anonymous visitor</a>, pass ```null``` or an empty string ```""``` as the visitor id. You can call the `startSession` API more than once and transition from an anonymous session to an identified session (or even switch between multiple identified sessions). 

## Step 3. Mobile device connectivity for tagging and testing

>[!NOTE]
>The `Scheme ID` can be found in your Pendo Subscription Settings in App Details.

This step enables page <a href="https://support.pendo.io/hc/en-us/articles/360033609651-Tagging-Mobile-Pages#HowtoTagaPage" target="_blank">tagging</a>
and <a href="https://support.pendo.io/hc/en-us/articles/360033487792-Creating-a-Mobile-Guide#test-guide-on-device-0-6" target="_blank">guide</a> testing capabilities.

Add the following **activity** to the application **AndroidManifest.xml** in the `<Application>` tag:

    <activity android:name="sdk.pendo.io.activities.PendoGateActivity" android:launchMode="singleInstance" android:exported="true">
        <intent-filter>
            <action android:name="android.intent.action.VIEW"/>
            <category android:name="android.intent.category.DEFAULT"/>
            <category android:name="android.intent.category.BROWSABLE"/>
            <data android:scheme="YOUR_SCHEME_ID_HERE"/>
        </intent-filter>
    </activity>

## Step 4. (Optional - for Jetpack Compose Beta integration only)

 Continue to the beta integration instructions and complete the additional steps [here](https://github.com/pendo-io/pendo-mobile-sdk/blob/master/android/pnddocs/jetpack_compose-android.md)

## Step 5. Verify installation

1. Test using Android Studio:  
Run the app while attached to the Android Studio.  
Review the Android Studio logcat and look for the following message:  
`Pendo SDK was successfully integrated and connected to the server.`
2. In the Pendo UI, go to Settings>Subscription Settings.
3. Select the **Applications** tab and then your application.
4. Select the Install Settings tab and follow the instructions under Verify Your Installation to ensure you have successfully integrated the Pendo SDK.
5. Confirm that you can see your app as Integrated under <a href="https://app.pendo.io/admin" target="_blank">subscription settings</a>.

## Developer Documentation

- API documentation available [here](/api-documentation/native-android-apis.md).
- Integration of native with Flutter components available [here](/other/native-with-flutter-components.md).
- If for any reason you need to manually install the SDK - please refer to the [manual installation page](/android/pnddocs/android_sdk_manual_installation.md).

## Troubleshooting

- For technical issues, please [review open issues](https://github.com/pendo-io/pendo-mobile-sdk/issues) or [submit a new issue](https://github.com/pendo-io/pendo-mobile-sdk/issues).
- Release notes can be found [here](https://developers.pendo.io/category/mobile-sdk/).
- For additional documentation, visit our [Help Center Mobile Section](https://support.pendo.io/hc/en-us/categories/23324531103771-Mobile-implementation).
