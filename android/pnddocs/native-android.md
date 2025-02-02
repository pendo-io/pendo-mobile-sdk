# Native Android

>[!NOTE]
>The following integration instructions are relevant for SDK 3.0 or higher. <br> Follow our migration instructions to [upgrade from SDK 2.x to 3.0](/migration-docs/README.md) or refer to our [2.x integration instruction](https://github.com/pendo-io/pendo-mobile-sdk/blob/2.22.5/README.md).

>[!IMPORTANT]
>**Jetpack Compose (Beta)**, is available starting from SDK 3.6.0. Support includes:
>- Retroactive analytics
>- Self-serve tagging
>- Full guides support
>
> Please see integration instructions below.
>
>


>[!IMPORTANT]
>Requirements:
>- Android Gradle Plugin `7.2` or higher
>- Kotlin version `1.9.0` or higher
>- JAVA version `11` or higher
>- minSdkVersion `21` or higher
>- compileSDKVersion `33` or higher

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
       implementation group:'sdk.pendo.io' , name:'pendoIO', version:'3.6+', changing:true
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

    **When using Jetpack Compose** - Add the JetpackComposeBeta flag
        
    Add the following PendoOptions object to the Pendo Setup API call:

    ```kotlin
    Pendo.PendoOptions options =
        Pendo.PendoOptions.Builder().setJetpackComposeBeta(true).build();

    Pendo.setup(
        this,
        pendoApiKey,
        options,
        null  // PendoPhasesCallbackInterface (Optional)
    ); 
    ```

 2.  **When using Jetpack Compose** - Add Compose Navigation Support

        If you are using a **Compose Navigation**, add the following as soon as possible, immediately after `rememberNavController` in your app.


        - This step is required for the SDK to recognize Compose pages in your app.
        - Navigation is limited to `androidx.navigation:navigation-compose` navigation. 


        ```kotlin
        val navHostController = rememberNavController()
        .... 

        LifecycleResumeEffect(null) {
            Pendo.setComposeNavigationController(navHostController.navController)

            onPauseOrDispose {
                Pendo.setComposeNavigationController(null)
            }
        }
        ```

    >[!Tip]
    >We strongly recommend calling the navigation with your navigation component before calling startSession to ensure the SDK uses the correct screen ID.

3. Initialize Pendo in the **Activity/fragment** where your visitor is being identified.

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

## Step 3. When using Jetpack Compose - Add Drawer / ModalBottomSheetLayout support - optional

If you’re using either Compose Drawer/ModalBottomSheetLayout in your app, please add the following for automatic detection - including page analytics, feature detection & guides.

Add ``Modifier.pendoStateModifier(componentState)`` to your Drawer's and or ModalBottomSheetLayout's modifier where componentState is the drawerState / sheetState.

**Please note !** When using this modifier, you must **specifically update the state** (bottomSheetState / drawerState) when you don’t want Pendo to detect the page anymore.
```kotlin
    ModalBottomSheetLayout(
        sheetState = sheetState,
        sheetContent = {
            // Content of the bottom sheet
            modifier = Modifier.pendoStateModifier(sheetState),
        }
    ) 
    ...
```


## Step 4. When using Jetpack Compose - Add the pendoTag - optional

In your application code, for each non-clickable Composable component that you want to present a tooltip on, add the following snippet:

```kotlin
    someComposableObject(
        modifier = Modifier
            .pendoTag("UNIQUE_IDENTIFIER")
    )
```

>[!NOTE]
>pendoTags are case-sensitive. You may add the pendoTag to clickable Composable components as well, as it will strengthen Pendo’s feature identification logic.


## Step 5. Mobile device connectivity for tagging and testing

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

## Step 6. Verify installation

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
