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
[setComposeNavigationController](#setcomposenavigationcontroller) ⇒ `void` <br>
[pendoStateModifier](#pendostatemodifier) ⇒ `Modifier` <br>
[pendoTag](#pendotag) ⇒ `Modifier` <br>

### PendoPhasesCallbackInterface Callbacks
[onInitComplete](#oninitcomplete) ⇒ `void` <br>
[onInitFailed](#oninitfailed) ⇒ `void` <br>


### JWT APIs
[jwt.startSession](#jwtstartsession) ⇒ `void` <br>
[jwt.setVisitorData](#jwtsetvisitordata) ⇒ `void` <br>
[jwt.setAccountData](#jwtsetaccountdata) ⇒ `void` <br>

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

```java 
static synchronized void setComposeNavigationController(NavHostController navHostController)
```
>This API allows the SDK to recognize Compose Pages in your app.

>If you are using a **Compose Navigation**, add the following as soon as possible, immediately after `rememberNavController` in your app.

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
>This modifier allows the SDK to automatically detect the Compose Drawer or ModalBottomSheetLayout in your app.

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
