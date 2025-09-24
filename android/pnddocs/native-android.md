# Native Android

>[!NOTE]
>The following integration instructions are relevant for SDK 3.0 or higher. <br> Follow our migration instructions to [upgrade from SDK 2.x to 3.0](/migration-docs/README.md) or refer to our [2.x integration instructions](https://github.com/pendo-io/pendo-mobile-sdk/blob/2.22.5/README.md).

>[!IMPORTANT]
>**Jetpack Compose GA** is now available (SDK 3.7.0+), offering:
>- Retroactive analytics
>- Self-serve tagging
>- Full guides support
>
> If your application already uses Pendo, please review and implement the additional steps outlined in [Step 3](#step-3-tracking-jetpack-compose) to enable Jetpack Compose support within your existing integration.

>[!IMPORTANT]
>Requirements:
>- Android Gradle Plugin `8.0` or higher
>- Kotlin version `1.9.0` or higher
>- JAVA version `11` or higher
>- minSdkVersion `21` or higher
>- compileSDKVersion `35` or higher
>
> If using Jetpack Compose:
>- androidx.compose.ui:ui `1.5.0` or higher

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
       implementation group:'sdk.pendo.io' , name:'pendoIO', version:'3.9.+', changing:true
    }
    ```

3. **Minimum and compile SDK versions**:

    If applicable, set your app to be compiled with **compileSdkVersion 35** or higher and **minSdkVersion 21** or higher:

    ```java
    android {
        minSdkVersion 21
        compileSdkVersion 35
    }
    ```
 
4. #### Using ProGuard

    If you are using **ProGuard(D8/DX only)** to perform compile-time code optimization, and have `{Android SDK Location}/tools/proguard/proguard-android-optimize.txt`, add `!code/allocation/variable` to the `-optimizations` line in your `app/proguard-rules.pro` file. The optimizations line should look like this:  
    `-optimizations *other optimizations*,!code/allocation/variable`

## Step 2. Integrate with the Pendo SDK

>[!NOTE]
>Find your API key in the Pendo UI under `Settings` > `Subscription settings` > select an app > `App Details`.

1. Set up Pendo in the **Application class**.

    The following code is required in the **onCreate** method:

    ```kotlin
    import sdk.pendo.io.*;

    val pendoApiKey = "YOUR_API_KEY_HERE"
    
    Pendo.setup(
       this,
       pendoApiKey,
       null, // PendoOptions (use only if instructed by Pendo support)
       null  // PendoPhasesCallbackInterface (Optional)
    )
    ```

2. Initialize Pendo in the **Activity/fragment** where your visitor is being identified.

    ```kotlin
    val visitorId = "VISITOR-UNIQUE-ID"
    val accountId = "ACCOUNT-UNIQUE-ID"
    val visitorData = mapOf("age" to 27, "country" to "USA")
    val accountData = mapOf("Tier" to 1, "Size" to "Enterprise")

    Pendo.startSession(
        visitorId,
        accountId,
        visitorData,
        accountData
   );
    ```

    **visitorId**: a user identifier (e.g., John Smith)  
    **visitorData**: the user metadata (e.g., email, phone, country, etc.)  
    **accountId**: an affiliation of the user to a specific company or group (e.g., Acme inc.)  
    **accountData** : the account metadata (e.g., tier, level, ARR, etc.)  
&nbsp;  
    This code ends the previous mobile session (if applicable), starts a new mobile session, and retrieves all guides based on the provided information.  
&nbsp;  

>[!TIP]
>To begin a session for an  <a href="https://support.pendo.io/hc/en-us/articles/360032202751" target="_blank">anonymous visitor</a>, pass ```null``` or an empty string ```""``` as the Visitor ID. You can call the `startSession` API more than once and transition from an anonymous session to an identified session (or even switch between multiple identified sessions). 

## Step 3. Tracking Jetpack Compose

1. **Add Compose Navigation Support**

    If you are using a **Compose Navigation**, add the following as soon as possible, immediately after `rememberNavController` in your app.


    - This step is required for the SDK to recognize Compose Pages in your app.
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

>[!TIP]
>We strongly recommend calling the navigation with your navigation component before calling startSession to ensure the SDK uses the correct screen ID.

2. **Drawer or ModalBottomSheetLayout Support (Add if applicable)**

    Automatic detection of Compose Drawer or ModalBottomSheetLayout in your app requires these steps:

    If you are using **Compose Navigation** add ``Modifier.pendoStateModifier(componentState)`` to your Drawer's or ModalBottomSheetLayout's modifier where componentState is the drawerState or sheetState.

    **Important:** To detect the dismissal of these components using this modifier, you must **specifically update the state** (bottomSheetState or drawerState) when you don’t want Pendo to detect the Page anymore.

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

3. **(Optional) Implement pendoTag in Jetpack Compose**

    PendoTags serve multiple purposes in identifying and tracking UI elements:

    - **Unique Feature identification:** It provides a unique identifier for Features during the tagging process.
    - **Manually enable click tracking:** For Composables you want to track as clicks that Pendo doesn't automatically detect, add pendoTag. You can also set mergeDescendants to true (default is false) to provide more attributes for better identification.
    - **Tooltip support:** Apply pendoTag to non-clickable Composable components to enable the presentation of tooltips.

    To implement pendoTag, add the following modifier to your relevant Composable components:

    ```kotlin
        someComposableObject(
            modifier = Modifier
                .pendoTag(UNIQUE_IDENTIFIER)
        )
    ```

>[!NOTE]
>pendoTags are case-sensitive. 

## Step 4. Connect mobile device for tagging and testing

>[!NOTE]
>Find your scheme ID in the Pendo UI under `Settings` > `Subscription settings` > select an app > `App Details`.

This step enables Page <a href="https://support.pendo.io/hc/en-us/articles/360033609651-Tagging-Mobile-Pages#HowtoTagaPage" target="_blank">tagging</a>
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

## Step 5. Verify installation

1. Test using Android Studio:  
Run the app while attached to the Android Studio.  
Review the Android Studio logcat and look for the following message:  
`Pendo SDK was successfully integrated and connected to the server.`
2. In the Pendo UI, go to `Settings` > `Subscription Settings`.
3. Select your application from the list.
4. Select the `Install Settings tab` and follow the instructions under `Verify Your Installation` to ensure you have successfully integrated the Pendo SDK.
5. Confirm that you can see your app as `Integrated` under <a href="https://app.pendo.io/admin" target="_blank">subscription settings</a>.

## Developer documentation

- View our [API documentation](/api-documentation/native-android-apis.md).
- See [Native application with Flutter components](/other/native-with-flutter-components.md) integration instructions.
- If you need to manually install the SDK, refer to the [manual installation page](/android/pnddocs/android_sdk_manual_installation.md).

## Troubleshooting

- For technical issues, please [review open issues](https://github.com/pendo-io/pendo-mobile-sdk/issues) or [submit a new issue](https://github.com/pendo-io/pendo-mobile-sdk/issues).
- See our [release notes](https://developers.pendo.io/category/mobile-sdk/).
- For additional documentation, visit our [Help Center](https://support.pendo.io/hc/en-us/categories/23324531103771-Mobile-implementation).
