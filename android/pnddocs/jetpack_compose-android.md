# Jetpack Compose (Beta)

>[!IMPORTANT]
>Starting **SDK 3.3**, Pendo support for Jetpack Compose includes the following:
>- Retroactive Page View analytics and page view activated guides. 
>- Code-based tooltips. [see here](https://github.com/pendo-io/pendo-mobile-sdk/blob/APP-99856_install_instructions_jpc/android/pnddocs/jetpack_compose-android.md#step-2-add-the-pendotag)
>
>**Non-track event support is in beta**



>[!IMPORTANT]
>Requirements:
>- Android Gradle Plugin `7.2` or higher
>- Kotlin version `1.9.0` or higher
>- JAVA version `11` or higher
>- minSdkVersion `21` or higher
>- compileSDKVersion `33` or higher

## Step 1. Install Pendo SDK as instructed for Android Native Apps 

[Android Native Integration Instructions](https://github.com/pendo-io/pendo-mobile-sdk/blob/master/android/pnddocs/native-android.md)

## Step 2. Add the JetpackComposeBeta flag
    
Add the following PendoOptions object to the Pendo Setup API call from Step 1:

```kotlin
Pendo.PendoOptions options =
    new Pendo.PendoOptions.Builder().setJetpackComposeBeta(true).build();

Pendo.setup(
    this,
    pendoApiKey,
    options,
    null    // PendoPhasesCallbackInterface (Optional)
); 
```

## Step 2. Add the pendoTag

In your application code, for each Composable component that you would like to present a tooltip on, add the following snippet:

```kotlin
    someComposableObject(
        modifier = Modifier
            .pendoTag("UNIQUE_IDENTIFIER")
    )
```

>[!NOTE]
>pendoTags are case-sensitive. 

## Step 3. Add Compose Navigation Support

If you are using a **Compose Navigation**, please add the following as soon as possible, right after `rememberNavController` in your app.


- Without this step, Pendo will not be able to recognize Compose pages in your app.
- Navigation is limited to `androidx.navigation:navigation-compose` navigation. 


```kotlin
val navHostController = rememberNavController()
.... 
Pendo.setComposeNavigationController(navHostController.navController)

LifecycleResumeEffect {
    Pendo.setComposeNavigationController(navHostController.navController)

    onPauseOrDispose {
        Pendo.setComposeNavigationController(null)
    }
}
```

>[!Tip]
>We strongly recommend calling the navigation with your navigation component before calling startSession to ensure the SDK uses the correct screen ID.

## Step 4. Mobile device connectivity for tagging and testing
Please follow the instructions as instructed for Android Native Apps [here](https://github.com/pendo-io/pendo-mobile-sdk/blob/master/android/pnddocs/native-android.md#step-3-mobile-device-connectivity-for-tagging-and-testing)


## Troubleshooting

- For technical issues, please [review open issues](https://github.com/pendo-io/pendo-mobile-sdk/issues) or [submit a new issue](https://github.com/pendo-io/pendo-mobile-sdk/issues).
- Release notes can be found [here](https://developers.pendo.io/category/mobile-sdk/).
- For Dex issues with Android applications refer to this [resource](https://developer.android.com/studio/build/multidex).
- For additional documentation, visit our [Help Center Mobile Section](https://support.pendo.io/hc/en-us/categories/23324531103771-Mobile-implementation).