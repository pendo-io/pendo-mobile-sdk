# Native Android public developer API documentation

> [!IMPORTANT]
>The `setup` API must be called before the `startSession` API. <br> 
> All other APIs must be called after both the `setup` and `startSession` APIs, otherwise they will be ignored. <br>
>The `setDebugMode` API is the exception to that rule and may be called anywhere in the code.

### Pendo APIs
[setup](#setup) ⇒ `void` <br>
[startSession](#startsession) ⇒ `void` <br>
[setVisitorData](#setvisitordata) ⇒ `void` <br>
[setAccountData](#setaccountdata) ⇒ `void` <br>
[endSession](#endsession) ⇒ `void` <br>
[track](#track) ⇒ `void` <br>
[screenContentChanged](#screencontentchanged) ⇒ `void` <br>
[sendClickAnalytic](#sendclickanalytic) ⇒ `void` <br>
[pauseGuides](#pauseguides) ⇒ `void` <br>
[resumeGuides](#resumeguides) ⇒ `void` <br>
[dismissVisibleGuides](#dismissvisibleguides) ⇒ `void` <br>
[getDeviceId](#getdeviceid) ⇒ `String` <br>
[getVisitorId](#getvisitorid) ⇒ `String` <br>
[getAccountId](#getaccountid) ⇒ `String` <br>
[jwt](#jwt) ⇒ `JWT`<br>
[setDebugMode](#setdebugmode) ⇒ `void`<br>

### Pendo Compose APIs
[setComposeNavigationController](#setcomposenavigationcontroller) ⇒ `void` (deprecated) <br>
[pendoStateModifier](#pendostatemodifier) ⇒ `Modifier` <br>
[pendoTag](#pendotag) ⇒ `Modifier` <br>
[pendoScreenId](#pendoscreenid) ⇒ `Modifier` <br>

### PendoPhasesCallbackInterface Callbacks
[onInitComplete](#oninitcomplete) ⇒ `void` <br>
[onInitFailed](#oninitfailed) ⇒ `void` <br>


### JWT APIs
[jwt.startSession](#jwtstartsession) ⇒ `void` <br>
[jwt.setVisitorData](#jwtsetvisitordata) ⇒ `void` <br>
[jwt.setAccountData](#jwtsetaccountdata) ⇒ `void` <br>

### Session Replay — Privacy Configuration
[PrivacyAction](#privacyaction) ⇒ `enum` <br>
[View.applyPendoSRPrivacy](#applypendosrprivacy) ⇒ `void` <br>
[View.clearPendoSRPrivacy](#clearpendosrprivacy) ⇒ `void` <br>
[XML privacy tag](#xml-privacy-tag) <br>
[Modifier.applyPendoSRPrivacy](#modifierapplypendosrprivacy) ⇒ `Modifier` <br>
[Modifier.clearPendoSRPrivacy](#modifierclearpendosrprivacy) ⇒ `Modifier` <br>
[Actions & behavior](#actions--behavior) <br>
[Cascade & inheritance](#cascade--inheritance) <br>
[Safety rails](#safety-rails) <br>
[RecyclerView clear-in-bind](#recyclerview-clear-in-bind) <br>

## Pendo APIs

### `setup`

```java 
static synchronized void setup(Context context, String appKey, PendoOptions options, PendoPhasesCallbackInterface pendoPhasesCallback)
```

> Establishes a connection with Pendo’s server. Call this API in your application’s onCreate() method. The setup method can only be called once during the application lifecycle. Calling this API is required before tracking sessions or invoking session-related APIs. 

> If the setup API is called while the device is offline, the SDK begins observing the network state, so that after it's back online, it continues with the setup network calls process. If the setup network call fails, PendoPhasesCallbackInterface "onInitFailed" callback is called. 

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Class</b>: Pendo
<br><b>Kind</b>: static method
<br>
<b>Returns</b>: void
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| context | Context | The hosting application Context (Activity / Service / Application) |
| appKey | String | The App Key is listed in your Pendo Subscription Settings in App Details |
| pendoOptions | PendoOptions | PendoOptions should be null unless instructed otherwise by Pendo Support |
| pendoPhasesCallback | PendoPhasesCallbackInterface | See the PendoPhasesCallbackInterface method table below for more details. Using these callbacks is optional |


<b>Example</b>:
    
```java
Pendo.setup(appContext, "your.app.key", null, null)    
```
</details>


### `startSession`

```java 
static void startSession(final String visitorId, final String accountId, final Map<String, Object> visitorData, final Map<String, Object> accountData)
```

> Starts a mobile session with the provided visitor and account information. If a session is already in progress, the current session will terminate and a new session will begin. The termination of the app will also terminate the session.

> To generate an anonymous visitor, pass `null` as the visitorId. Visitor data and Account data are optional.

> No action will be taken if the visitor and account IDs do not change when calling the startSession API during an ongoing session.

> If the startSession API is called while the device is offline, the SDK begins observing the network state, so that after it's back online, it continues with the start session network calls process. After the startSession network calls succeed, the PendoPhasesCallbackInterface "onInitComplete" callback is called. If the startSession network call fails, "onInitFailed" callback is called.
 
<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>


<b>Class</b>: Pendo
<br><b>Kind</b>: static method
<br>
<b>Returns</b>: void
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| visitorId | String | The session visitor ID. For an anonymous visitor set to `null` |
| accountId | String | The session account ID |
| visitorData | Map<String, Object> | Additional visitor metadata |
| accountData | Map<String, Object> | Additional account metadata |


<b>Example</b>:
    
```java
HashMap visitorData = new HashMap<>();
visitorData.put("age", 21);
visitorData.put("country", "USA");

HashMap accountData = new HashMap<>();
accountData.put("Tier", 1);
accountData.put("size", "Enterprise");

Pendo.startSession("John Doe", "ACME", visitorData, accountData)    
```

</details>

### `setVisitorData`

```java 
static void setVisitorData(Map<String, Object> visitorData)
```

>Updates the visitor metadata of the ongoing session.
  
<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>


<b>Class</b>: Pendo
<br><b>Kind</b>: static method
<br>
<b>Returns</b>: void
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| visitorData | Map<String, Object> | The visitor metadata to be updated |


<b>Example</b>:
    
```java
HashMap visitorData = new HashMap<>();
visitorData.put("age", 25);
visitorData.put("country", "UK");
visitorData.put("birthday", "01-01-1990");

Pendo.setVisitorData(visitorData)    
```

</details>

### `setAccountData`

```java 
static void setAccountData(Map<String, Object> accountData)
```

>Updates the account metadata of the ongoing session.
  
<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>


<b>Class</b>: Pendo
<br><b>Kind</b>: static method
<br>
<b>Returns</b>: void
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| accountData | Map<String, Object> | The account metadata to be updated |


<b>Example</b>:
    
```java
HashMap accountData = new HashMap<>();
accountData.put("Tier", 2);
accountData.put("size", "Mid-Market");
accountData.put("signing-date", "01-01-2020");

Pendo.setAccountData(accountData)    
```

</details>

### `endSession`

```java 
static void endSession()
```

>Ends the active session and stops collecting analytics or showing guides to the user. A new session can be started by calling the startSession API.

>This API is commonly used when the user logs out of your application.


  
<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>


<b>Class</b>: Pendo
<br><b>Kind</b>: static method
<br>
<b>Returns</b>: void
<br>

<b>Example</b>:
    
```java
Pendo.endSession(); 
```

</details>

### `track`

```java
static void track(String eventName, @Nullable Map<String, Object> properties)
```

>Sends a track event with the specified properties.

<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Class</b>: Pendo<br>
<b>Kind</b>: static method<br>
<b>Returns</b>: void<br>
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| eventName | String | The track event name |
| properties | Map<String, Object> | Additional metadata to be sent as part of the track event |

<b>Example:</b>

```java
HashMap trackEventProperties = new HashMap<>();
trackEventProperties.put("Theme", "Dark Mode");
Pendo.track("App Opened", trackEventProperties);
```
</details>


### `screenContentChanged`

```java
static void screenContentChanged()
```

>Manually triggers a rescan of the current screen layout hierarchy by the SDK. This API should be called on rare occasions where the delayed appearance of some elements on the screen is not recognized by the SDK (e.g.,, changes to a View’s 'visibility' or 'alpha' properties after the initial loading of a screen).

>The following cases are handled by our SDK and do not require the usage of the `screenContentChanged` API:
>- The View’s 'visibility' attribute was updated from 'gone' to 'visible'.
>- The View was added dynamically to the View Hierarchy.
>- The screen content was scrolled.

>If multiple Page captures were used to tag all Features on the Page (where some Features exist only in some state of the Page), verify that all of the Page captures of the screen are configured with identical Page rules and Page identifiers for correct analytics and guide behavior.

<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Class</b>: Pendo<br>
<b>Kind</b>: static method<br>
<b>Returns</b>: void<br>

<br>
Example:

```java
Pendo.screenContentChanged();
```
</details>


### `sendClickAnalytic`

```java
static boolean sendClickAnalytic(View view)
```

>Manually sends an RAClick analytic event for the view during the ongoing session. Use the API only when Pendo does not automatically recognize the view as a clickable feature or to resolve issues of displaying a guide that is activated by tapping this view.

>The View's clickable attribute must be set as `true` in the xml / activity. Call the API in your code as part of the action implementation (e.g.,, onTouchListener, onClickListener, etc).

<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Class</b>: Pendo<br>
<b>Kind</b>: static method<br>
<b>Returns</b>: boolean<br>
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| view | View | The clickable view to be used by the manual triggered RAClick analytic event |

<b>Example:</b>

```java
Pendo.sendClickAnalytic(myButton);
```
</details>

### `pauseGuides`

```java 
static synchronized void pauseGuides(boolean dismissGuides)
```

>Pauses any guides from appearing during an active session. If the `dismissGuides` value is set to `true`, then any visible guide will be dismissed. Calling this API affects the current session. Starting a new session reverts this logic, enabling guides to be presented.

<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Class:</b> Pendo<br>
<b>Kind:</b> static method<br>
<b>Returns:</b> void<br>
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| dismissGuides | boolean | Determines whether the displayed guide, if one is visible, is dismissed when pausing the display of the further guides |

<b>Example:</b>

```java
Pendo.pauseGuides(false);
```
</details>


### `resumeGuides`

```java 
static synchronized void resumeGuides()
```

>Resumes displaying guides during the ongoing session. This API reverses the logic of the `pauseGuides` API.

<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Class:</b> Pendo<br>
<b>Kind:</b> static method<br>
<b>Returns:</b> void<br>
<br>
<b>Example:</b>

```java
Pendo.resumeGuides();
```
</details>

### `dismissVisibleGuides`

```java 
static synchronized void dismissVisibleGuides()
```

>Dismisses any visible guide.

<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Class:</b> Pendo<br>
<b>Kind:</b> static method<br>
<b>Returns:</b> void<br>
<br>
<b>Example:</b>

```java
Pendo.dismissVisibleGuides();
```
</details>

### `getDeviceId`

```java 
static String getDeviceId()
```

>Returns the device's unique Pendo-generated ID. 

<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Class:</b> Pendo<br>
<b>Kind:</b> static method<br>
<b>Returns:</b> String<br>
<br>
<b>Example:</b>

```java
Pendo.getDeviceId();
```
</details>

### `getVisitorId`

```java 
static String getVisitorId()
```

>Returns the ID of the visitor in the active session.

<details>
    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Class:</b> Pendo<br>
<b>Kind:</b> static method<br>
<b>Returns:</b> String<br>
<br>
<b>Example:</b>

```java
Pendo.getVisitorId();
```
</details>

### `getAccountId`

```java 
static String getAccountId()
```

>Returns the ID of the account in the active session.

<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Class:</b> Pendo<br>
<b>Kind:</b> static method<br>
<b>Returns:</b> String<br>
<br>
<b>Example:</b>

```java
Pendo.getAccountId();
```
</details>

### `jwt`

```java 
static final JWT jwt
```

>Returns the JWT instance for handling secure metadata sessions. 

>To use secure metadata sessions, contact Pendo support to enable this feature.


<details>
    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Class:</b> Pendo<br>
<b>Kind:</b> static property getter<br>
<b>Returns:</b> JWT<br>
<br>
<b>Example:</b>

```java
Pendo.jwt;
```
</details>

### `setDebugMode`

```java 
static synchronized void setDebugMode(boolean enableDebugMode)
```

>Enable/disable debug logs from Pendo SDK. To debug the Pendo SDK we recommend calling this API before calling the setup API.

>Debug logs are turned off by default. Releasing your production app with the debug logs enabled is not recommended and may have performance repercussions on your app.

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Class</b>: Pendo
<br><b>Kind</b>: static method
<br>
<b>Returns</b>: void
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| enableDebugMode | boolean | Set to `true` to enable debug logs, `false` to disable |


<b>Example</b>:

```java
Pendo.setDebugMode(true);
Pendo.setup(appContext, "your.app.key", null, null);
```
</details>

<br>


## Pendo Compose APIs
### `setComposeNavigationController`

> [!NOTE]
>Deprecated from SDK 3.12.+ The SDK automatically performs the logic, removing the need to use this API. Calling it will be ignored.

```java 
static synchronized void setComposeNavigationController(NavHostController navHostController)
```
>This API allows the SDK to recognize Compose Pages in your app.

>If you are using **Compose Navigation** add the following as soon as possible, immediately after `rememberNavController` in your app.

>Navigation is limited to `androidx.navigation:navigation-compose` navigation. 

>We strongly recommend calling the navigation with your navigation component before calling startSession to ensure the SDK uses the correct screen ID.

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Class</b>: Pendo
<br><b>Kind</b>: static method
<br>
<b>Returns</b>: void
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| navHostController | NavHostController | The Compose Navigation used in your app |


<b>Example</b>:


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
</details>

### `pendoStateModifier`

```kotlin 
fun Modifier.pendoStateModifier(state: Any? = null): Modifier
```
>This modifier allows the SDK to automatically detect the Compose Drawer or ModalBottomSheetLayout in your app if using **Compose Navigation**.

>Add ``Modifier.pendoStateModifier(componentState)`` to your Drawer's or ModalBottomSheetLayout's modifier where componentState is the drawerState or sheetState.

>To detect the dismissal of these components using this modifier, you must **specifically update the state** (bottomSheetState or drawerState) when you don’t want Pendo to detect the Page anymore.

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Class</b>: Pendo
<br><b>Kind</b>: Jetpack Compose Modifier
<br>
<b>Returns</b>: Modifier
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| state | Any? | The Composable's state you'd want Pendo to listen to |


<b>Example</b>:


```kotlin
ModalBottomSheetLayout(
    sheetState = sheetState,
    sheetContent = {
        // Content of the bottom sheet
        modifier = Modifier.pendoStateModifier(sheetState),
    }
) 
```
</details>

### `pendoTag`

```kotlin 
fun Modifier.pendoTag(pendoTagKey: String, mergeDescendants: Boolean  = false): Modifier
```
>PendoTags serve multiple purposes in identifying and tracking Jetpack Compose elements:
> - **Unique feature identification:** It provides a unique identifier for features during the tagging process.
> - **Manually enable click tracking:** For Composables you want to track as clicks that Pendo doesn't automatically detect, add pendoTag.
> - **Tooltip support:** Apply pendoTag to non-clickable Composable components to enable the presentation of tooltips.

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Class</b>: Pendo
<br><b>Kind</b>: Jetpack Compose Modifier
<br>
<b>Returns</b>: Modifier
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| pendoTagKey | String | A unique identifier for the specific composable |
| mergeDescendants | Boolean | By setting mergeDescendants to true, additional attributes may be available to uniquely tag the element (default is false) |

<b>Example</b>:


```kotlin
someComposableObject(
    modifier = Modifier
        .pendoTag(UNIQUE_IDENTIFIER)
)
```
</details>

<br>

### `pendoScreenId`

```kotlin
fun Modifier.pendoScreenId(screenId: String): Modifier
```

> Extension to Jetpack Compose's Modifier class that marks a composable as a screen for analytics.
>
> Use this modifier when you want to track a composable (such as tab content) as a separate screen in Pendo analytics, instead of relying solely on Compose navigation routes or XML Fragment names.

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Class</b>: Pendo
<br><b>Kind</b>: Jetpack Compose Modifier
<br>
<b>Returns</b>: Modifier
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| screenId | String | Unique identifier for this screen in Pendo analytics. Must not be blank. |

<b>Example</b>:

```kotlin
TabRow(selectedTabIndex = selectedTab) {
    tabs.forEachIndexed { index, tab ->
        Tab(selected = selectedTab == index, onClick = { selectedTab = index })
    }
}
when (selectedTab) {
    0 -> HomeContent(Modifier.pendoScreenId("HomeTab"))
    1 -> ProfileContent(Modifier.pendoScreenId("ProfileTab"))
    2 -> SettingsContent(Modifier.pendoScreenId("SettingsTab"))
}
```
</details>

<br>


## PendoPhasesCallbackInterface Callbacks

### `onInitComplete`

```java 
void onInitComplete()
```

> This callback is triggered once per session after each successful call to the StartSession API. The callback is triggered as soon as the analytics recording for the session has begun and the session guides are ready to be displayed.

> Guides that are not triggered on app launch may take a few additional moments after this callback to be ready for display.


<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Interface</b>: PendoPhasesCallbackInterface
<br><b>Kind</b>: class method
<br>
<b>Returns</b>: void
<br>

<b>Example</b>:
    
```java
class PendoCallbackImp implements PendoPhasesCallbackInterface {

    @Override
    public void onInitComplete() {
        Log.d("The session has begun");
    }

    @Override
    public void onInitFailed() {
        Log.d("Session failed to begin");
    }
}

... {
Pendo.setup(appContext, "your.app.key", null, new PendoCallbackImp());
}
```
</details>

### `onInitFailed`

```java 
void onInitFailed()
```

>This callback is triggered on a failed attempt to establish a connection with Pendo's server or on a failed attempt to start a new session when calling Pendo's Setup or StartSession APIs respectively.

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Interface</b>: PendoPhasesCallbackInterface
<br><b>Kind</b>: class method
<br>
<b>Returns</b>: void
<br>

<b>Example</b>:
    
```java
class PendoCallbackImp implements PendoPhasesCallbackInterface {

    @Override
    public void onInitComplete() {
        Log.d("The session has begun");
    }

    @Override
    public void onInitFailed() {
        Log.d("Session failed to begin");
    }
}

... {
Pendo.setup(appContext, "your.app.key", null, new PendoCallbackImp());   
}
```
</details>

<br>

## JWT APIs

> [!IMPORTANT]
> To use secure metadata sessions, contact Pendo support to enable this feature. <br> For full details on how to use secure metadata sessions and what information needs to be included in the JWTs see the [mobile installation using signed metadata with JWT](https://support.pendo.io/hc/en-us/articles/360039616892-Send-signed-metadata-with-JWT) article.

> [!NOTE]
>To generate or find your JWT signing-key name and corresponding secret value go to your app’s Install Settings section in your Pendo Subscription Settings.

> [!CAUTION]
> There should be no existence of the signing-key value in the code of your mobile application.

### `jwt.startSession`

```java 
static void startSession(final String jwt,  final String signingKeyName)
```

>Starts a mobile session with the provided JWT and the signing-key name used to sign the JWT. Create the signed JWT on your server-side and pass it to the device, together with the signing-key name, before calling the startSession API.

> If a session is already in progress, the current session will terminate and a new session will begin. The termination of the app will also terminate the session.

> The JWT payload must contain both the visitor and account elements, each with an `id` property and value. To generate an anonymous visitor use an empty string as the value of the `id` property of the visitor element. The account `id` property may be set to an empty string as well. Additional visitor and account properties are optional.
 
<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>


<b>Class</b>: JWT
<br><b>Kind</b>: class method
<br>
<b>Returns</b>: void
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| jwt | String | The signed JWT string containing the visitor and account elements  |
| signingKeyName | String | The name of the key used to sign the JWT |

<b>Example</b>:
    
```java
/**
 * Example code on you server side to generate the JWT
 * 
 * const jwt = JWT.sign({
 *      nonce: "abcdefg78910xyz",
 *      visitor: {                  <-- the visitor element
 *          id: "John Doe",         <-- the id is mandatory
 *          age: "21"               <-- optional 
 *      },
 *      account: {                  <-- the account element
 *          id: "ACME",             <-- the id is mandatory
 *          Tier: "1"               <-- optional 
 *      }
 *      },
 *      'SECRET KEY VALUE'          <-- sign with the secret key 
 * );
*/

// fetch the signed JWT and signing key from your server
String jwt = Server.getSignedJWT();
String sKeyName = Server.getJWTSigningKeyName();

Pendo.jwt.startSession(jwt, sKeyName);  
```

</details>

### `jwt.setVisitorData`

```java 
static void setVisitorData(final String jwt,  final String signingKeyName)
```

>To generate or find your JWT signing-key name and corresponding secret value go to your app’s Install Settings section in your Pendo Subscription Settings.

>Updates the visitor metadata of the ongoing session with the provided JWT and the signing-key name used to sign the JWT. Create the signed JWT on your server-side and pass it to the device, together with the signing-key name, before calling the setVisitorData API. 

>The JWT payload should not include the account element, and the visitor ‘id’ property value must match the visitor ‘id’ value used to start the session.
 
<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>


<b>Class</b>: JWT
<br><b>Kind</b>: class method
<br>
<b>Returns</b>: void
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| jwt | String | The signed JWT string containing the visitor element  |
| signingKeyName | String | The name of the key used to sign the JWT |

<b>Example</b>:
    
```java
/**
 * Example code on you server side to generate the JWT
 * 
 * const jwt = JWT.sign({
 *      nonce: "abcdefg78910xyz",
 *      visitor: { 
 *          id: "John Doe",             <-- same visitor id as the session JWT
 *          age: "25",                  <-- updated metadata 
 *          birthday: "01-01-1990"      <-- new metadata 
 *      }                               <-- no account element 
 *      },
 *      'SECRET KEY VALUE'              <-- sign with the secret key
 * );
*/

// fetch the signed JWT and signing key from your server
String jwt = Server.getSignedJWT();
String sKeyName = Server.getJWTSigningKeyName();

Pendo.jwt.setVisitorData(jwt, sKeyName);  
```

</details>

### `jwt.setAccountData`

```java 
static void setAccountData(final String jwt,  final String signingKeyName)
```

>To generate or find your JWT signing-key name and corresponding secret value go to your app’s Install Settings section in your Pendo Subscription Settings.

>Updates the account metadata of the ongoing session with the provided JWT and the signing-key name used to sign the JWT. Create the signed JWT on your server-side and pass it to the device, together with the signing-key name, before calling the setAccountData API.

>The JWT payload should not include the visitor element, and the account ‘id’ property value must match the account ‘id’ value used to start the session.

 
<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>


<b>Class</b>: JWT
<br><b>Kind</b>: class method
<br>
<b>Returns</b>: void
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| jwt | String | The signed JWT string containing the account element  |
| signingKeyName | String | The name of the key used to sign the JWT |

<b>Example</b>:
    
```java
/**
 * Example code on you server side to generate the JWT
 * 
 * const jwt = JWT.sign({
 *      nonce: "abcdefg78910xyz",
 *      account: { 
 *          id: "ACME",                 <-- same visitor id as the session JWT
 *          Tier: "2"                   <-- updated metadata 
 *          country: "USA"              <-- new metadata 
 *      }                               <-- no visitor element 
 *      },
 *      'SECRET KEY VALUE'              <-- sign with the secret key
 * );
*/

// fetch the signed JWT and signing key from your server
String jwt = Server.getSignedJWT();
String sKeyName = Server.getJWTSigningKeyName();

Pendo.jwt.setAccountData(jwt, sKeyName);  
```

</details>

<br>

## Session Replay — Privacy Configuration

> [!IMPORTANT]
> Session Replay privacy is first configured server-side through a **preset** (for example, masking all text, or masking input fields only). The APIs below let you override that preset on individual elements from your app code — in XML, with Kotlin/Java `View` extensions, or with a Jetpack Compose `Modifier`. All APIs live in the `sdk.pendo.io` package.

> An element's privacy is expressed with the `PrivacyAction` enum: `MASK`, `UNMASK`, or `BLOCK`. An action applies to the element it is set on and **cascades down** to its descendants, unless a descendant sets its own action (see [Cascade & inheritance](#cascade--inheritance)).

### `PrivacyAction`

```kotlin
enum class PrivacyAction { MASK, UNMASK, BLOCK }
```

> The value passed to every element-level privacy API.

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Class</b>: PrivacyAction
<br><b>Kind</b>: enum
<br>

| Value | Effect |
| :---: | :--- |
| MASK | Redacts the element's **text**, which is rendered as asterisks in the replay. Text-only — does not affect images or media. |
| UNMASK | Reveals **text** that the active preset would otherwise mask. Text-only — does not reveal a blocked image or media. |
| BLOCK | Replaces the element (text, image, container, or media) with a layout-preserving gray placeholder, so its content is never captured. |

> [!NOTE]
> `MASK` and `UNMASK` affect **text only**. Images and other media are controlled by `BLOCK` together with the backend preset (a `blockedSelectors` `"img"` entry). To hide an image or a region, use `BLOCK`.

</details>

## Views / XML APIs

### `applyPendoSRPrivacy`

```kotlin
fun View.applyPendoSRPrivacy(action: PrivacyAction)
```

> Kotlin extension on `android.view.View` that sets a Session Replay privacy action on a view instance, overriding the active preset for that view and its descendants.

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Class</b>: ReplayPrivacyExtensionsKt
<br><b>Kind</b>: Kotlin extension function on View
<br>
<b>Returns</b>: void
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| action | PrivacyAction | The privacy action to apply (`MASK`, `UNMASK`, or `BLOCK`) |

<b>Example (Kotlin)</b>:

```kotlin
import sdk.pendo.io.PrivacyAction
import sdk.pendo.io.applyPendoSRPrivacy

// Redact the account balance text
balanceTextView.applyPendoSRPrivacy(PrivacyAction.MASK)

// Reveal marketing copy the preset would otherwise mask
promoTextView.applyPendoSRPrivacy(PrivacyAction.UNMASK)

// Hide an entire payment section (text, images, and media)
paymentContainer.applyPendoSRPrivacy(PrivacyAction.BLOCK)
```

<b>Example (Java)</b>:

> The Kotlin extensions are exposed to Java as static methods on `ReplayPrivacyExtensionsKt`.

```java
import sdk.pendo.io.PrivacyAction;
import sdk.pendo.io.ReplayPrivacyExtensionsKt;

ReplayPrivacyExtensionsKt.applyPendoSRPrivacy(balanceTextView, PrivacyAction.MASK);
ReplayPrivacyExtensionsKt.applyPendoSRPrivacy(paymentContainer, PrivacyAction.BLOCK);
```
</details>

### `clearPendoSRPrivacy`

```kotlin
fun View.clearPendoSRPrivacy()
```

> Kotlin extension on `android.view.View` that removes any privacy action previously set on the view instance. After clearing, the element falls back to its inherited action (from an ancestor) or to the active preset.

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Class</b>: ReplayPrivacyExtensionsKt
<br><b>Kind</b>: Kotlin extension function on View
<br>
<b>Returns</b>: void
<br>

<b>Example (Kotlin)</b>:

```kotlin
import sdk.pendo.io.clearPendoSRPrivacy

// Remove a previously applied rule; the view reverts to inherited/preset behavior
balanceTextView.clearPendoSRPrivacy()
```

<b>Example (Java)</b>:

```java
import sdk.pendo.io.ReplayPrivacyExtensionsKt;

ReplayPrivacyExtensionsKt.clearPendoSRPrivacy(balanceTextView);
```
</details>

### XML privacy tag

```xml
<tag android:id="@id/pnd_replay_privacy" android:value="mask|unmask|block" />
```

> Declare a privacy action directly in a layout XML file by nesting a `<tag>` element inside the view. Use the `pnd_replay_privacy` id and set `android:value` to `mask`, `unmask`, or `block`.

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Kind</b>: XML layout attribute
<br>

| Attribute | Value | Description |
| :---: | :---: | :--- |
| android:id | @id/pnd_replay_privacy | Identifies the tag as a Pendo Session Replay privacy rule |
| android:value | mask \| unmask \| block | The privacy action to apply to the enclosing view |

<b>Example</b>:

```xml
<TextView
    android:id="@+id/balance"
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    android:text="Balance: $42,850.00">
    <tag android:id="@id/pnd_replay_privacy" android:value="mask" />
</TextView>

<ImageView
    android:id="@+id/id_card"
    android:layout_width="wrap_content"
    android:layout_height="wrap_content">
    <tag android:id="@id/pnd_replay_privacy" android:value="block" />
</ImageView>
```
</details>

## Jetpack Compose APIs

### `Modifier.applyPendoSRPrivacy`

```kotlin
fun Modifier.applyPendoSRPrivacy(action: PrivacyAction): Modifier
```

> Jetpack Compose `Modifier` extension that sets a Session Replay privacy action on a composable, overriding the active preset for that composable and its descendants.

> [!IMPORTANT]
> Apply a **single** privacy modifier per composable. Compose collapses same-node semantics, so chaining does **not** follow last-write-wins — the **first-declared** modifier wins. To clear a rule, omit the modifier entirely or use [`clearPendoSRPrivacy`](#modifierclearpendosrprivacy) on its own; do **not** append `clearPendoSRPrivacy()` after `applyPendoSRPrivacy(...)`.

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Class</b>: Pendo
<br><b>Kind</b>: Jetpack Compose Modifier
<br>
<b>Returns</b>: Modifier
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| action | PrivacyAction | The privacy action to apply (`MASK`, `UNMASK`, or `BLOCK`) |

<b>Example</b>:

```kotlin
import sdk.pendo.io.PrivacyAction
import sdk.pendo.io.applyPendoSRPrivacy

// Redact text
Text(
    text = "Balance: $42,850.00",
    modifier = Modifier.applyPendoSRPrivacy(PrivacyAction.MASK)
)

// Reveal text the preset would mask
Text(
    text = "Public marketing copy — safe to show",
    modifier = Modifier.applyPendoSRPrivacy(PrivacyAction.UNMASK)
)

// Hide a whole payment region
Column(
    modifier = Modifier.applyPendoSRPrivacy(PrivacyAction.BLOCK)
) {
    // payment fields...
}
```

> [!WARNING]
> Do not chain two privacy modifiers on one composable. The following applies `MASK` (first-declared wins) and ignores the `UNMASK`:
> ```kotlin
> // ❌ Ignored: UNMASK never takes effect
> Modifier
>     .applyPendoSRPrivacy(PrivacyAction.MASK)
>     .applyPendoSRPrivacy(PrivacyAction.UNMASK)
> ```
</details>

### `Modifier.clearPendoSRPrivacy`

```kotlin
fun Modifier.clearPendoSRPrivacy(): Modifier
```

> Jetpack Compose `Modifier` extension that clears any privacy rule for the composable, so it falls back to its inherited action or the active preset.

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Class</b>: Pendo
<br><b>Kind</b>: Jetpack Compose Modifier
<br>
<b>Returns</b>: Modifier
<br>

<b>Example</b>:

```kotlin
import sdk.pendo.io.clearPendoSRPrivacy

Text(
    text = "No explicit rule — inherits preset",
    modifier = Modifier.clearPendoSRPrivacy()
)
```

> [!NOTE]
> Use `clearPendoSRPrivacy()` on its own. Because the first-declared privacy modifier wins, appending it after `applyPendoSRPrivacy(...)` has no effect — to clear, simply omit the `applyPendoSRPrivacy` modifier or replace it with `clearPendoSRPrivacy()`.
</details>

## Actions & behavior

> - **MASK** — redacts the element's text, rendered as asterisks. Text-only.
> - **UNMASK** — reveals text that the preset would otherwise mask. Text-only.
> - **BLOCK** — replaces the element with a layout-preserving gray placeholder. Works for any element type: text, image, container, or media.
>
> `MASK` and `UNMASK` **never** affect images or media. Image and media capture is governed by `BLOCK` and the backend preset (a `blockedSelectors` `"img"` entry). To hide an image or region, use `BLOCK`. `MASK` does not gray out an image, and `UNMASK` does not lift an image block.

## Cascade & inheritance

> A privacy action set on an element applies to that element **and cascades down** the view hierarchy to all of its descendants, until a descendant overrides it with its own action.

> [!IMPORTANT]
> **`BLOCK` is terminal.** Once an ancestor is blocked, a descendant `UNMASK` (or `MASK`) cannot override the inherited `BLOCK` — the blocked subtree stays a placeholder.

<b>Example</b>:

```kotlin
// Container is blocked -> the whole subtree is a gray placeholder
rootContainer.applyPendoSRPrivacy(PrivacyAction.BLOCK)

// This has NO effect: a descendant cannot escape an inherited BLOCK
childTextView.applyPendoSRPrivacy(PrivacyAction.UNMASK) // still blocked
```

```kotlin
// Container masks all text; a specific child is revealed
formContainer.applyPendoSRPrivacy(PrivacyAction.MASK)
promoTextView.applyPendoSRPrivacy(PrivacyAction.UNMASK) // this child's text is shown
```

## Safety rails

> [!CAUTION]
> Sensitive inputs are **always masked**, even under an explicit `UNMASK`. This safety rail cannot be overridden. It covers password fields, credit-card fields, email and phone inputs, and any field with an autofill hint. Use `BLOCK` if you additionally want such a field rendered as a placeholder.

## RecyclerView clear-in-bind

> [!IMPORTANT]
> The privacy tag is stored on the `View` and **persists across view recycling**. In a `RecyclerView`, a `View` set to `MASK` for one item can be reused for another item that should not be masked, leaking a stale rule. Always set the correct privacy for the bound item in `onBindViewHolder`, or call `clearPendoSRPrivacy()` when the new item needs no rule.

<b>Example</b>:

```kotlin
override fun onBindViewHolder(holder: RowViewHolder, position: Int) {
    val item = items[position]
    holder.valueView.text = item.value

    // Set privacy to match THIS item; never rely on the recycled view's prior state
    if (item.isSensitive) {
        holder.valueView.applyPendoSRPrivacy(PrivacyAction.MASK)
    } else {
        // Clear any stale rule left over from a previous binding
        holder.valueView.clearPendoSRPrivacy()
    }
}
```
