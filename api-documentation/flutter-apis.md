# Flutter public developer API documentation

> [!IMPORTANT]
>The `setup` API must be called before the `startSession` API. <br> 
> All other APIs must be called after both the `setup` and `startSession` APIs, otherwise they will be ignored. <br>
>The `setDebugMode` API is the exception to that rule and may be called anywhere in the code.

### PendoSDK APIs
[setup](#setup) ⇒ `void` <br>
[startSession](#startsession) ⇒ `void` <br>
[setVisitorData](#setvisitordata) ⇒ `void` <br>
[setAccountData](#setaccountdata) ⇒ `void` <br>
[endSession](#endsession) ⇒ `void` <br>
[track](#track) ⇒ `void` <br>
[pauseGuides](#pauseguides) ⇒ `void`<br>
[resumeGuides](#resumeguides) ⇒ `void` <br>
[dismissVisibleGuides](#dismissvisibleguides) ⇒ `void` <br>
[getDeviceId](#getdeviceid) ⇒ `String` <br>
[getVisitorId](#getvisitorid) ⇒ `String` <br>
[getAccountId](#getaccountid) ⇒ `String` <br>
[setDebugMode](#setdebugmode) ⇒ `void`<br>

## PendoSDK APIs

### `setup`

```c# 
static Future<void> setup(String appKey, {Map<String, dynamic>? pendoOptions}) async
```

>Establishes a connection with Pendo’s server. Call this API in your application’s main file (lib/main.dart). The setup method can only be called once during the application lifecycle. Calling this API is required before tracking sessions or invoking session-related APIs. 

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Class</b>: PendoSDK
<br><b>Kind</b>: static method
<br>
<b>Returns</b>: void
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| appKey | String | The App Key is listed in your Pendo Subscription Settings in App Details |
| pendoOptions | Map<String, dynamic>? | PendoOptions should be `null` unless instructed otherwise by Pendo Support |


<b>Example</b>:
    
```c#
await PendoSDK.setup('your.app.key', null);  
```
</details>


### `startSession`

```c# 
static Future<void> startSession(String? visitorId, String? accountId, Map<String, dynamic>? visitorData, Map<String, dynamic>? accountData) async
```

>Starts a mobile session with the provided visitor and account information. If a session is already in progress, the current session will terminate and a new session will begin. The termination of the app will also terminate the session.

>To generate an anonymous visitor, pass 'nil' as the visitorId. Visitor data and Account data are optional.

> No action will be taken if the visitor and account IDs do not change when calling the startSession API during an ongoing session. 
 
<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>


<b>Class</b>: PendoSDK
<br><b>Kind</b>: static method
<br>
<b>Returns</b>: void
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| visitorId | String? | The session visitor ID. For an anonymous visitor set to `null` |
| accountId | String? | The session account ID |
| visitorData | Dictionary<string, object>? | Additional visitor metadata |
| accountData | Dictionary<string, object>? | Additional account metadata |


<b>Example</b>:
    
```c#
Map<String, dynamic> visitorData = {'age': 21, 'country': 'USA'};
Map<String, dynamic> accountData = {'Tier': 1, 'Size': 'Enterprise'};

await PendoSDK.startSession('John Doe', 'ACME', visitorData, accountData)
```

</details>

### `setVisitorData`

```c# 
static Future<void> setVisitorData(Map<String, dynamic> visitorData) async
```

>Updates the visitor metadata of the ongoing session.
  
<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>


<b>Class</b>: PendoSDK
<br><b>Kind</b>: static method
<br>
<b>Returns</b>: void
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| visitorData | Map<String, dynamic> | The visitor metadata to be updated |


<b>Example</b>:
    
```c#
Map<String, dynamic> visitorData = {'age': 25, 'country': 'UK', 'birthday': '01-01-1990'};

await PendoSDK.setVisitorData(visitorData)
```

</details>

### `setAccountData`

```c# 
static Future<void> setAccountData(Map<String, dynamic> accountData) async
```

>Updates the account metadata of the ongoing session.
  
<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>


<b>Class</b>: PendoSDK
<br><b>Kind</b>: static method
<br>
<b>Returns</b>: void
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| accountData | Map<String, dynamic> | The account metadata to be updated |


<b>Example</b>:
    
```c#
Map<String, dynamic> accountData = {'Tier': 2, 'size': 'Mid-Market', 'signing-date': '01-01-2020'};

await PendoSDK.setAccountData(accountData)

```

</details>

### `endSession`

```c# 
static Future<void> endSession() async
```

>Ends the active session and stops collecting analytics or showing guides to the user. A new session can be started by calling the startSession API.

>This API is commonly used when the user logs out of your application.


  
<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>


<b>Class</b>: PendoSDK
<br><b>Kind</b>: static method
<br>
<b>Returns</b>: void
<br>

<b>Example</b>:
    
```c#
await PendoSDK.endSession(); 
```

</details>

### `track`

```c#
static Future<void> track(String event, Map<String, dynamic>? properties) async
```

>Sends a track event with the specified properties.

<details>
    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>

<b>Class</b>: PendoSDK<br>
<b>Kind</b>: static method<br>
<b>Returns</b>: void<br>
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| event | String | The track event name |
| properties | Map<String, dynamic>? | Additional metadata to be sent as part of the track event |

<b>Example:</b>

```c#
await PendoSDK.track('App Opened', {'Theme': 'Dark Mode'});
```
</details>

### `pauseGuides`

```c# 
static Future<void> pauseGuides(bool dismissGuides) async
```

>Pauses any guides from appearing during an active session. If the `dismissGuides` value is set to `true`, then any visible guide will be dismissed.

<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Class:</b> PendoSDK<br>
<b>Kind:</b> static method<br>
<b>Returns:</b> void<br>
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| dismissGuides | bool | Determines wether the displayed guide, if one is visible, will be dismissed when pausing the display of further guides |

<b>Example:</b>

```c#
await PendoSDK.pauseGuides(false);
```
</details>


### `resumeGuides`

```c# 
static Future<void> resumeGuides() async
```

>Resumes displaying guides during the ongoing session. This API reverses the logic of the `pauseGuides` API.

<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary>
<br>
<b>Class:</b> PendoSDK<br>
<b>Kind:</b> static method<br>
<b>Returns:</b> void<br>
<br>
<b>Example:</b>

```c#
await PendoSDK.resumeGuides();
```
</details>

### `dismissVisibleGuides`

```c# 
static Future<void> dismissVisibleGuides() async
```

>Dismisses any visible guide.

<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Class:</b> PendoSDK<br>
<b>Kind:</b> static method<br>
<b>Returns:</b> void<br>
<br>
<b>Example:</b>

```c#
await PendoSDK.dismissVisibleGuides();
```
</details>

### `getDeviceId`

```c# 
static Future<String?> getDeviceId() async
```

>Returns the device's unique Pendo-generated ID. 

<details>
    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>
<br>
<b>Class:</b> PendoSDK<br>
<b>Kind:</b> static method<br>
<b>Returns:</b> String<br>
<br>
<b>Example:</b>

```c#
await PendoSDK.getDeviceId();
```
</details>

### `getVisitorId`

```c# 
static Future<String?> getVisitorId() async
```

>Returns the ID of the visitor in the active session.

<details>
    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>
<br>
<b>Class:</b> PendoSDK<br>
<b>Kind:</b> static method<br>
<b>Returns:</b> String<br>
<br>
<b>Example:</b>

```c#
await PendoSDk.getVisitorId();
```
</details>

### `getAccountId`

```c# 
static Future<String?> getAccountId() async
```

>Returns the ID of the account in the active session.

<details>
    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Class:</b> PendoSDK<br>
<b>Kind:</b> static method<br>
<b>Returns:</b> String<br>
<br>
<b>Example:</b>

```c#
await PendoSDK.getAccountId();
```
</details>

### `setDebugMode`

```c# 
static Future<void> setDebugMode(bool isDebugEnabled) async
```

>Enable/disable debug logs from Pendo SDK. To debug the Pendo SDK we recommend calling this API before calling the setup API.

>Debug logs are turned off by default. Releasing your production app with the debug logs enabled is not recommended and may have performance repercussions on your app.

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Class</b>: PendoSDK
<br><b>Kind</b>: static method
<br>
<b>Returns</b>: void
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| isDebugEnabled | bool | Set to `true` to enable debug logs, `false` to disable |


<b>Example</b>:

```c#
await PendoSDK.setDebugMode(true);
await PendoSDK.setup("your.app.key", null);
```
</details>
