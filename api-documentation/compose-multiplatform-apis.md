# Compose Multiplatform public developer API documentation

> [!IMPORTANT]
> Call `Pendo.setup()` before `Pendo.startSession()`. Except for `setDebugMode()` and `endSession()`, call the remaining APIs after both `setup()` and `startSession()`. Calls that require an active session are ignored when Pendo is inactive. `Pendo.setDebugMode()` may be called before setup.

Core APIs and modifiers are available from `com.pendo.cmp`. Navigation adapters are available from `com.pendo.cmp.nav`.

## Pendo APIs

- [`setup`](#setup)
- [`startSession`](#startsession)
- [`endSession`](#endsession)
- [`track`](#track)
- [`setVisitorData`](#setvisitordata)
- [`setAccountData`](#setaccountdata)
- [`setDebugMode`](#setdebugmode)
- [`getDeviceId`](#getdeviceid)
- [`pauseGuides`](#pauseguides)
- [`resumeGuides`](#resumeguides)
- [`dismissVisibleGuides`](#dismissvisibleguides)
- [`initWithUrl`](#initwithurl)
- [`screenContentChanged`](#screencontentchanged)

## Configuration APIs

- [`PendoOptions`](#pendooptions)
- [`PendoInitCallback`](#pendoinitcallback)

## Compose tracking APIs

- [`PendoTracker`](#pendotracker)
- [`PendoNavigator`](#pendonavigator)
- [`PendoNav2`](#pendonav2)
- [`PendoCircuit`](#pendocircuit)
- [`pendoTag`](#pendotag)
- [`pendoScreenId`](#pendoscreenid)
- [`pendoStateModifier`](#pendostatemodifier)
- [`applyPendoSRPrivacy`](#applypendosrprivacy)
- [`clearPendoSRPrivacy`](#clearpendosrprivacy)
- [`PrivacyAction`](#privacyaction)

## Pendo APIs

### `setup`

```kotlin
fun setup(
    appKey: String,
    options: PendoOptions? = null,
    callback: PendoInitCallback? = null,
)
```

Establishes the connection to Pendo. Call this once, as early as possible during application startup.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `appKey` | `String` | The app key shown in the Pendo UI under the application’s settings. |
| `options` | `PendoOptions?` | Optional SDK configuration. |
| `callback` | `PendoInitCallback?` | Optional initialization callback. |

```kotlin
Pendo.setup(
    appKey = "YOUR_APP_KEY",
    options = PendoOptions(environmentName = "production"),
    callback = object : PendoInitCallback {
        override fun onInitComplete() {
            // Pendo initialization completed
        }

        override fun onInitFailed() {
            // Pendo initialization failed
        }
    },
)
```

### `startSession`

```kotlin
fun startSession(
    visitorId: String?,
    accountId: String?,
    visitorData: Map<String, Any>? = null,
    accountData: Map<String, Any>? = null,
)
```

Starts a session with the provided visitor and account information. Starting a session ends any previously active session. Pass `null` for `visitorId` to start an anonymous session.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `visitorId` | `String?` | Unique visitor ID, or `null` for an anonymous visitor. |
| `accountId` | `String?` | Unique account ID, or `null`. |
| `visitorData` | `Map<String, Any>?` | Optional visitor metadata. |
| `accountData` | `Map<String, Any>?` | Optional account metadata. |

```kotlin
Pendo.startSession(
    visitorId = "VISITOR-UNIQUE-ID",
    accountId = "ACCOUNT-UNIQUE-ID",
    visitorData = mapOf("country" to "USA"),
    accountData = mapOf("tier" to "Enterprise"),
)
```

### `endSession`

```kotlin
fun endSession()
```

Ends the current session and stops collecting analytics. Call this API when the user logs out. Start a new session when another visitor logs in.

```kotlin
Pendo.endSession()
```

### `track`

```kotlin
fun track(
    event: String,
    properties: Map<String, Any>? = null,
)
```

Sends a Track Event for the active session.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `event` | `String` | Name describing the event. |
| `properties` | `Map<String, Any>?` | Optional event properties. Use interoperable values such as strings, numbers, and booleans. |

```kotlin
Pendo.track(
    event = "Checkout Completed",
    properties = mapOf("itemCount" to 3, "total" to 42.50),
)
```

### `setVisitorData`

```kotlin
fun setVisitorData(data: Map<String, Any>)
```

Updates visitor metadata for the active session.

```kotlin
Pendo.setVisitorData(
    mapOf("plan" to "Pro", "isAdmin" to true),
)
```

### `setAccountData`

```kotlin
fun setAccountData(data: Map<String, Any>)
```

Updates account metadata for the active session.

```kotlin
Pendo.setAccountData(
    mapOf("region" to "EMEA", "employeeCount" to 250),
)
```

### `setDebugMode`

```kotlin
fun setDebugMode(enabled: Boolean)
```

Enables or disables detailed SDK logging. Enable debug mode only during development. This API may be called before `setup()`.

```kotlin
Pendo.setDebugMode(true)
```

### `getDeviceId`

```kotlin
fun getDeviceId(): String
```

Returns the device identifier used by Pendo. Returns an empty string when Pendo is not active.

```kotlin
val deviceId = Pendo.getDeviceId()
```

### `pauseGuides`

```kotlin
fun pauseGuides(dismissGuides: Boolean = false)
```

Pauses guide presentation for the active session.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `dismissGuides` | `Boolean` | When `true`, also dismisses any currently visible guide. |

```kotlin
Pendo.pauseGuides(dismissGuides = true)
```

### `resumeGuides`

```kotlin
fun resumeGuides()
```

Resumes guide presentation after `pauseGuides()`.

```kotlin
Pendo.resumeGuides()
```

### `dismissVisibleGuides`

```kotlin
fun dismissVisibleGuides()
```

Dismisses any currently visible guides.

```kotlin
Pendo.dismissVisibleGuides()
```

### `initWithUrl`

```kotlin
fun initWithUrl(url: String)
```

Processes a Pendo Pairing Mode URL on iOS. Configure Android Pairing Mode in `AndroidManifest.xml` as described in the [Compose Multiplatform integration guide](/other/compose-multiplatform.md#android).

```kotlin
Pendo.initWithUrl(pairingUrl)
```

When called from Swift, this API is exported as:

```swift
Pendo.shared.handleDeepLink(url: url.absoluteString)
```

### `screenContentChanged`

```kotlin
fun screenContentChanged()
```

Notifies Pendo that dynamic content changed and requests a new scan of the current screen.

```kotlin
Pendo.screenContentChanged()
```

## Configuration APIs

### `PendoOptions`

```kotlin
data class PendoOptions(
    val environmentName: String? = null,
    val disableAnalytics: Boolean = false,
    val includeAllGuideContent: Boolean = false,
)
```

| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `environmentName` | `String?` | `null` | Optional environment name, such as `staging` or `production`. |
| `disableAnalytics` | `Boolean` | `false` | Disables analytics collection when `true`. |
| `includeAllGuideContent` | `Boolean` | `false` | Includes all guide content in the initialization model when `true`. |

Pass an instance to `Pendo.setup()`:

```kotlin
Pendo.setup(
    appKey = "YOUR_APP_KEY",
    options = PendoOptions(
        environmentName = "production",
        disableAnalytics = false,
    ),
)
```

### `PendoInitCallback`

```kotlin
interface PendoInitCallback {
    fun onInitComplete()
    fun onInitFailed()
}
```

Receives SDK initialization results. Both methods are invoked on the main thread.

## Compose tracking APIs

### `PendoTracker`

```kotlin
@Composable
fun PendoTracker(
    navigator: PendoNavigator? = null,
    content: @Composable () -> Unit,
)
```

Wraps shared Compose content for Pendo tracking. Pass a supported navigator to enable automatic screen detection, or omit it when the content does not use a supported navigation library.

```kotlin
PendoTracker(navigator = PendoNav2(navController)) {
    NavHost(navController, startDestination = "home") {
        // Destinations
    }
}
```

`PendoTracker` can be nested when an application has multiple navigation levels.

### `PendoNavigator`

```kotlin
sealed interface PendoNavigator
```

Represents a supported navigation adapter for `PendoTracker`. Use `PendoNav2` for Jetpack Compose Navigation 2 or `PendoCircuit` for Slack Circuit.

### `PendoNav2`

```kotlin
class PendoNav2(
    val navController: Any,
) : PendoNavigator
```

Adapts a Jetpack Compose Navigation 2 `NavController` for `PendoTracker`.

```kotlin
PendoTracker(navigator = PendoNav2(navController)) {
    NavHost(navController, startDestination = "home") {
        // Destinations
    }
}
```

### `PendoCircuit`

```kotlin
class PendoCircuit(
    val backStack: Any,
) : PendoNavigator
```

Adapts a Slack Circuit `SaveableBackStack` for `PendoTracker`.

```kotlin
PendoTracker(navigator = PendoCircuit(backStack)) {
    NavigableCircuitContent(navigator, backStack)
}
```

### `pendoTag`

```kotlin
fun Modifier.pendoTag(
    tag: String,
    mergeDescendants: Boolean = false,
): Modifier
```

Adds a stable, localization-independent identifier to a Compose element. Tagged elements can be identified in analytics and targeted by guides.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `tag` | `String` | Unique identifier for the element. |
| `mergeDescendants` | `Boolean` | Merges descendant semantics into this element when `true`. |

```kotlin
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

### `pendoScreenId`

```kotlin
fun Modifier.pendoScreenId(screenId: String): Modifier
```

Marks a composable as a distinct screen. Use it for screens such as tabs or state-driven content that do not have their own navigation route.

The screen ID must:

- not be blank
- contain no more than 100 characters
- contain only letters, numbers, underscores, hyphens, and periods

```kotlin
Box(
    modifier = Modifier.pendoScreenId("ProfileTab"),
) {
    ProfileContent()
}
```

### `pendoStateModifier`

```kotlin
fun Modifier.pendoStateModifier(state: DrawerState): Modifier

@OptIn(ExperimentalMaterial3Api::class)
fun Modifier.pendoStateModifier(state: SheetState): Modifier
```

Tracks Material 3 drawer and bottom-sheet visibility for Pendo.

```kotlin
ModalNavigationDrawer(
    drawerState = drawerState,
    modifier = Modifier.pendoStateModifier(drawerState),
    drawerContent = {
        // Drawer content
    },
) {
    // Screen content
}
```

```kotlin
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
```

### `applyPendoSRPrivacy`

```kotlin
fun Modifier.applyPendoSRPrivacy(
    action: PrivacyAction,
): Modifier
```

Applies a Session Replay privacy action to a composable. Privacy actions cascade to descendants. An ancestor using `PrivacyAction.BLOCK` cannot be overridden by a descendant.

Apply only one Session Replay privacy modifier to an element.

```kotlin
TextField(
    modifier = Modifier.applyPendoSRPrivacy(PrivacyAction.MASK),
    value = value,
    onValueChange = onValueChange,
)
```

### `clearPendoSRPrivacy`

```kotlin
fun Modifier.clearPendoSRPrivacy(): Modifier
```

Clears the privacy action on an element so it uses inherited or configured Session Replay behavior.

Use this modifier by itself. Do not chain it after `applyPendoSRPrivacy()` on the same element.

```kotlin
Text(
    modifier = Modifier.clearPendoSRPrivacy(),
    text = "Public content",
)
```

### `PrivacyAction`

```kotlin
enum class PrivacyAction {
    MASK,
    UNMASK,
    BLOCK,
}
```

| Value | Description |
| :--- | :--- |
| `MASK` | Redacts text. It does not affect images or other non-text content. |
| `UNMASK` | Reveals non-sensitive text that would otherwise be masked. Password fields remain masked. |
| `BLOCK` | Replaces the element and its descendants with a placeholder and excludes interactions within its bounds. |

Compose cannot automatically identify email and phone fields as sensitive. Avoid `UNMASK` on those fields, or protect them with password semantics.
