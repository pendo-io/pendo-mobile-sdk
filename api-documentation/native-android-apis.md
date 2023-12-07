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
[sendClickAnalytics](#sendclickanalytics) ⇒ `void` <br>
[pauseGuides](#pauseguides) ⇒ `void` <br>
[resumeGuides](#resumeguides) ⇒ `void` <br>
[dismissVisibleGuides](#dismissvisibleguides) ⇒ `void` <br>
[getDeviceId](#getdeviceid) ⇒ `String` <br>
[getVisitorId](#getvisitorid) ⇒ `String` <br>
[getAccountId](#getaccountid) ⇒ `String` <br>
[jwt](#jwt) ⇒ `JWT`<br>
[setDebugMode](#setdebugmode) ⇒ `void`<br>


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

>Establishes a connection with Pendo’s server. Call this API in your application’s onCreate() method. The setup method can only be called once during the application lifecycle. Calling this API is required before tracking sessions or invoking session-related APIs. 

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

>Starts a mobile session with the provided visitor and account information. If a session is already in progress, the current session will terminate and a new session will begin. The termination of the app will also terminate the session.

>To generate an anonymous visitor, pass `null` as the visitorId. Visitor data and Account data are optional.

> No action will be taken if the visitor and account IDs do not change when calling the startSession API during an ongoing session. 
 
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

>Manually triggers a rescan of the current screen layout hierarchy by the SDK. This API should be called on rare occasions where the delayed appearance of some elements on the screen is not recognized by the SDK (e.g., changes to a View’s 'visibility' or 'alpha' properties after the initial loading of a screen).

>The following cases are handled by our SDK and do not require the usage of the `screenContentChanged` API:
>- The View’s 'visibility' attribute was updated from 'gone' to 'visible'.
>- The View was added dynamically to the View Hierarchy.
>- The screen content was scrolled.

>If multiple page captures were used to tag all features on the page (where some features exist only in some state of the page), verify that all of the page captures of the screen are configured with identical page rules and page identifiers for correct analytics and guide behavior.

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


### `sendClickAnalytics`

```java
static boolean sendClickAnalytics(View view)
```

>Manually sends an RAClick analytic event for the view during the ongoing session. Use the API only when Pendo does not automatically recognize the view as a clickable feature or to resolve issues of displaying a guide that is activated by tapping this view.

>The View's clickable attribute must be set as `true` in the xml / activity. Call the API in your code as part of the action implementation (e.g., onTouchListener, onClickListener, etc).

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
Pendo.sendClickAnalytics(myButton);
```
</details>

### `pauseGuides`

```java 
static synchronized void pauseGuides(boolean dismissGuides)
```

>Pauses any guides from appearing during an active session. If the `dismissGuides` value is set to `true`, then any visible guide will be dismissed.

<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Class:</b> Pendo<br>
<b>Kind:</b> static method<br>
<b>Returns:</b> void<br>
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| dismissGuides | boolean | Determines wether the displayed guide, if one is visible, will be dismissed when pausing the display of further guides |

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


## PendoPhasesCallbackInterface Callbacks

### `onInitComplete`

```java 
void onInitComplete()
```

>This callback is triggered once per session, as soon as the analytics recording for the session has begun and the session guides are ready to be displayed.

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
> To use secure metadata sessions, contact Pendo support to enable this feature. <br> For full details on how to use secure metadata sessions and what information needs to be included in the JWTs see the [mobile installation using signed metadata with JWT](https://support.pendo.io/hc/en-us/articles/4427183644827-Mobile-installation-using-signed-metadata-with-JWT) article.

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
