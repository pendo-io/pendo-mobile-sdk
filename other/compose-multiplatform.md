# Compose Multiplatform (Beta)

> [!IMPORTANT]
> Use this guide when your Android and iOS applications share UI with Compose Multiplatform. If your KMP project uses platform-native UI, follow the [Kotlin Multiplatform with native UI guide](/other/kotlin-multiplatform-native-ui.md).

> [!NOTE]
> Pendo Compose Multiplatform support is currently available as a beta. The following integration instructions are relevant for Pendo CMP SDK `3.14.x`.

> [!IMPORTANT]
> Requirements:
> - Kotlin `2.1.0` or higher
> - Compose Multiplatform `1.8.0` or higher
> - Supported Compose UI versions up to `1.12`
> - Pendo iOS SDK `3.14.x` (must match the CMP SDK minor version)
> - iOS deployment target `13.0` or higher
> - Android `minSdk 21` or higher
>
> Supported navigation libraries:
> - Jetpack Compose Navigation (Navigation 2)
> - Jetpack Navigation 3
> - Slack Circuit `0.20.0` or higher

## Step 1. Add the Pendo CMP SDK

### Add the Pendo repositories

Add the repositories for the CMP SDK and the native Android SDK to `settings.gradle.kts`:

```kotlin
dependencyResolutionManagement {
    repositories {
        // CMP SDK
        maven {
            url = uri("https://software.mobile.pendo.io/artifactory/cmp-beta/")
        }

        // Native Android SDK
        maven {
            url = uri("https://software.mobile.pendo.io/artifactory/androidx-release")
        }

        mavenCentral()
        google()
    }
}
```

The Pendo compatibility plugin is resolved separately. Add its repository to `pluginManagement` in `settings.gradle.kts`:

```kotlin
pluginManagement {
    repositories {
        maven {
            url = uri("https://software.mobile.pendo.io/artifactory/cmp-beta/")
        }
        gradlePluginPortal()
        mavenCentral()
    }
}
```

### Add Pendo to the shared module

Add the CMP SDK to `commonMain` in the shared KMP module's `build.gradle.kts`:

```kotlin
kotlin {
    sourceSets {
        commonMain.dependencies {
            api("com.pendo:pendo-cmp:3.14.1")
        }
    }
}
```

Apply the Pendo compatibility plugin to the same shared KMP module:

```kotlin
plugins {
    id("com.pendo.cmp.compat") version "3.14.1"
}
```

> [!IMPORTANT]
> The `com.pendo.cmp.compat` plugin version must exactly match the `com.pendo:pendo-cmp` version. The build fails when the versions don't match.

The compatibility plugin enables automatic capture of Compose overlays such as dialogs and popups on iOS across supported Compose UI versions.

### Export Pendo for iOS

Export the CMP SDK from each iOS framework target:

```kotlin
listOf(
    iosX64(),
    iosArm64(),
    iosSimulatorArm64(),
).forEach { target ->
    target.binaries.framework {
        baseName = "Shared" // Use your framework name
        isStatic = true
        export("com.pendo:pendo-cmp:3.14.1")
    }
}
```

### Add the native Pendo iOS SDK

The native Pendo iOS SDK must be installed separately.

#### CocoaPods

1. Open the `Podfile`.
2. Add `pod 'Pendo', '~> 3.14.1'`.

#### Swift Package Manager

1. In Xcode, select **File > Add Package Dependencies**.
2. Enter `https://github.com/pendo-io/pendo-mobile-sdk`.
3. Select **Up to Next Minor Version** and a `3.14.x` version.

No separate native SDK installation is required for Android.

## Step 2. Connect to Pendo

> [!NOTE]
> Find your API key in the Pendo UI under **Settings > Subscription settings > select an app > App Details**.

`Pendo.setup()` and `Pendo.setDebugMode()` are common CMP APIs and can be called from shared code. Call `setup()` once, as early as possible. Start a session whenever your app is ready to begin collecting activity:

```kotlin
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import com.pendo.cmp.Pendo

@Composable
fun App() {
    LaunchedEffect(Unit) {
        Pendo.setDebugMode(true) // Use only while debugging
        Pendo.setup("YOUR_API_KEY_HERE") // Call as early as possible

        // Start the session here, or whenever appropriate for your app
        Pendo.startSession(
            visitorId = "VISITOR-UNIQUE-ID",
            accountId = "ACCOUNT-UNIQUE-ID",
            visitorData = mapOf("age" to 27, "country" to "USA"),
            accountData = mapOf("Tier" to 1, "Size" to "Enterprise"),
        )
    }

    MyAppContent()
}
```

`Pendo.startSession()` ends any previous mobile session and starts a new session.

> [!TIP]
> To begin a session for an <a href="https://support.pendo.io/hc/en-us/articles/360032202751" target="_blank">anonymous visitor</a>, pass `null` as the visitor ID. You can call `startSession()` again to move from an anonymous session to an identified session or to switch visitors.

## Step 3. Add PendoTracker

Wrap your shared navigable content with [`PendoTracker`](/api-documentation/compose-multiplatform-apis.md#pendotracker) to enable Pendo tracking on both Android and iOS.

### Jetpack Compose Navigation

```kotlin
import com.pendo.cmp.PendoTracker
import com.pendo.cmp.nav.PendoNav2

@Composable
fun MyAppContent() {
    val navController = rememberNavController()

    PendoTracker(navigator = PendoNav2(navController)) {
        NavHost(navController, startDestination = "home") {
            composable("home") {
                HomeScreen()
            }
        }
    }
}
```

### Jetpack Navigation 3

```kotlin
import com.pendo.cmp.PendoTracker
import com.pendo.cmp.nav.PendoNav3

@Composable
fun MyAppContent() {
    val backStack = rememberNavBackStack(HomeKey)

    PendoTracker(navigator = PendoNav3(backStack)) {
        NavDisplay(
            backStack = backStack,
            entryProvider = entryProvider {
                entry<HomeKey> {
                    HomeScreen()
                }
            }
        )
    }
}
```

The screen is identified by the top back-stack key's class name (`HomeKey`), so key arguments
don't create separate screens: `DetailKey("42")` and `DetailKey("43")` are the same screen. Pass a
snapshot-backed back stack — `rememberNavBackStack(...)` or `mutableStateListOf(...)` — otherwise
only the initial screen is reported.

Pendo Android SDK `3.14.1` or higher reports the same key on Android, including for an adaptive
scene that displays two entries side by side. Earlier Android SDK versions identify such a scene by
every entry it displays, which doesn't match the screen reported on iOS.

### Slack Circuit

```kotlin
import com.pendo.cmp.PendoTracker
import com.pendo.cmp.nav.PendoCircuit

@Composable
fun MyCircuitContent(circuit: Circuit) {
    val backStack = rememberSaveableBackStack(root = HomeScreen)
    val navigator = rememberCircuitNavigator(backStack)

    PendoTracker(navigator = PendoCircuit(backStack)) {
        CircuitCompositionLocals(circuit) {
            NavigableCircuitContent(navigator, backStack)
        }
    }
}
```

## Step 4. Configure Pairing Mode

These steps enable page tagging and guide testing. Find your scheme ID in the Pendo UI under **Settings > Subscription settings > select an app > App Details**.

### iOS

In Xcode, go to **App Target > Info > URL Types** and add a URL type with:

- **Identifier:** `pendo-pairing`
- **URL Scheme:** your scheme ID from the Pendo UI

Then forward the pairing deep link to Pendo.

If your app uses the SwiftUI app lifecycle, add `onOpenURL` to its root content:

```swift
import Shared // Use your shared framework name

WindowGroup {
    ContentView()
        .onOpenURL { url in
            if url.scheme?.range(of: "pendo") != nil {
                Pendo.shared.handleDeepLink(url: url.absoluteString)
            }
        }
}
```

If your app uses `AppDelegate`, add or update the following method:

```swift
func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
) -> Bool {
    if url.scheme?.range(of: "pendo") != nil {
        Pendo.shared.handleDeepLink(url: url.absoluteString)
        return true
    }

    return false
}
```

If your app uses `SceneDelegate`, add or update the following method:

```swift
func scene(
    _ scene: UIScene,
    openURLContexts URLContexts: Set<UIOpenURLContext>
) {
    if let url = URLContexts.first?.url,
       url.scheme?.range(of: "pendo") != nil {
        Pendo.shared.handleDeepLink(url: url.absoluteString)
    }
}
```

### Android

Add the Pendo pairing activity to `AndroidManifest.xml`:

```xml
<activity
    android:name="sdk.pendo.io.activities.PendoGateActivity"
    android:launchMode="singleInstance"
    android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.VIEW"/>
        <category android:name="android.intent.category.DEFAULT"/>
        <category android:name="android.intent.category.BROWSABLE"/>
        <data android:scheme="YOUR_SCHEME_ID_HERE"/>
    </intent-filter>
</activity>
```

> [!NOTE]
> This activity is only used by Pendo's pairing mode (page tagging and on-device guide testing) and isn't required by your production app. If you prefer not to expose it in release builds, add it to a debug-only manifest (`src/debug/AndroidManifest.xml`) instead of the main manifest. Pairing will then be available only in debug builds.

## Step 5. Add drawer and bottom sheet support

To track a Compose drawer or bottom sheet, add [`Modifier.pendoStateModifier()`](/api-documentation/compose-multiplatform-apis.md#pendostatemodifier) with the component's state.

### Drawer

```kotlin
@Composable
fun AppDrawer() {
    val drawerState = rememberDrawerState(DrawerValue.Closed)

    ModalNavigationDrawer(
        drawerState = drawerState,
        modifier = Modifier.pendoStateModifier(drawerState),
        drawerContent = {
            // Drawer content
        },
    ) {
        // App content
    }
}
```

### Bottom sheet

```kotlin
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AppBottomSheet() {
    val sheetState = rememberModalBottomSheetState()
    val scope = rememberCoroutineScope()

    ModalBottomSheet(
        sheetState = sheetState,
        modifier = Modifier.pendoStateModifier(sheetState),
        onDismissRequest = {
            scope.launch {
                sheetState.hide()
            }
        },
    ) {
        // Sheet content
    }
}
```

Update the drawer or sheet state when the component is dismissed so Pendo stops detecting it as the current page.

## Step 6. Identify elements and custom screens

Use [`Modifier.pendoTag()`](/api-documentation/compose-multiplatform-apis.md#pendotag) to give an element a stable identifier that doesn't depend on its displayed text:

```kotlin
import com.pendo.cmp.pendoTag

Button(
    modifier = Modifier.pendoTag(
        tag = "checkout_button",
        mergeDescendants = true,
    ),
    onClick = ::checkout,
) {
    Text("Checkout")
}
```

Use [`Modifier.pendoScreenId()`](/api-documentation/compose-multiplatform-apis.md#pendoscreenid) for tabs or other state-driven content that doesn't have its own navigation route:

```kotlin
import com.pendo.cmp.pendoScreenId

Box(
    modifier = Modifier.pendoScreenId("ProfileTab"),
) {
    ProfileContent()
}
```

## Step 7. Verify the installation

1. Run the app.
2. Look for the log message: `Pendo Mobile SDK was successfully integrated and connected to the server.`
3. In the Pendo UI, go to **Settings > Subscription Settings** and select your app.
4. Open the **Install Settings** tab and complete **Verify Your Installation**.
5. Confirm that the app is shown as **Integrated**.

## Known limitations

- Automatic navigation tracking supports Jetpack Compose Navigation (Navigation 2), Jetpack Navigation 3, and Slack Circuit. Other navigation libraries, including Voyager and Decompose, aren't currently supported.
- Drawers and bottom sheets require `Modifier.pendoStateModifier()` for state tracking.
- Compose UI versions through `1.12` are supported. Future Pendo CMP releases will add support for newer Compose UI versions.
- The native Pendo iOS SDK must use the same major and minor version as the CMP SDK.

## Developer documentation

- [Compose Multiplatform API documentation](/api-documentation/compose-multiplatform-apis.md)

## Troubleshooting

- For technical issues, [review open issues](https://github.com/pendo-io/pendo-mobile-sdk/issues) or [submit a new issue](https://github.com/pendo-io/pendo-mobile-sdk/issues).
- See the [Pendo Mobile SDK release notes](https://developers.pendo.io/category/mobile-sdk/).
