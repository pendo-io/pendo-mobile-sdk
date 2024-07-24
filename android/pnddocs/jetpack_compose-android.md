# Jetpack Compose (Beta)

>[!IMPORTANT]
>Starting from **SDK 3.3.0**, Pendo supports Jetpack Compose in the following areas:
>- Code-based tooltips. [Additional info](https://github.com/pendo-io/pendo-mobile-sdk/blob/master/android/pnddocs/jetpack_compose-android.md#step-3-add-the-pendotag)
>


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

## Step 2. Add Compose Navigation Support

If you are using a **Compose Navigation**, add the following as soon as possible, immediately after `rememberNavController` in your app.


- This step is required for the SDK to recognize Compose pages in your app.
- Navigation is limited to `androidx.navigation:navigation-compose` navigation. 


```kotlin
val navHostController = rememberNavController()
.... 
Pendo.setComposeNavigationController(navHostController.navController)

LifecycleResumeEffect(null) {
    Pendo.setComposeNavigationController(navHostController.navController)

    onPauseOrDispose {
        Pendo.setComposeNavigationController(null)
    }
}
```

>[!Tip]
>We strongly recommend calling the navigation with your navigation component before calling startSession to ensure the SDK uses the correct screen ID.

## Step 3. Add the pendoTag

In your application code, for each Composable component that you want to present a tooltip on, add the following snippet:

```kotlin
    someComposableObject(
        modifier = Modifier
            .pendoTag("UNIQUE_IDENTIFIER")
    )
```

>[!NOTE]
>pendoTags are case-sensitive. 

## Step 4. Mobile device connectivity for tagging and testing
Please follow the instructions as instructed for Android Native Apps [here](https://github.com/pendo-io/pendo-mobile-sdk/blob/master/android/pnddocs/native-android.md#step-3-mobile-device-connectivity-for-tagging-and-testing)


## Troubleshooting

- For technical issues, please [review open issues](https://github.com/pendo-io/pendo-mobile-sdk/issues) or [submit a new issue](https://github.com/pendo-io/pendo-mobile-sdk/issues).
- Release notes can be found [here](https://developers.pendo.io/category/mobile-sdk/).
- For additional documentation, visit our [Help Center Mobile Section](https://support.pendo.io/hc/en-us/categories/23324531103771-Mobile-implementation).