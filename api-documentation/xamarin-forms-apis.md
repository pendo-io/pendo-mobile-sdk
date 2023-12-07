# Xamarin Forms public developer API documentation

> [!IMPORTANT]
>The `Setup` API must be called before the `StartSession` API. <br> 
> All other APIs must be called after both the `Setup` and `StartSession` APIs, otherwise they will be ignored. <br>
>The `SetDebugMode` API is the exception to that rule and may be called anywhere in the code.

### IPendoInterface APIs
[PendoInterface](#pendointerface) ⇒ `IPendoInterface` <br>
[Setup](#setup) ⇒ `void` <br>
[StartSession](#startsession) ⇒ `void` <br>
[SetVisitorData](#setvisitordata) ⇒ `void` <br>
[SetAccountData](#setaccountdata) ⇒ `void` <br>
[EndSession](#endsession) ⇒ `void` <br>
[Track](#track) ⇒ `void` <br>
[PauseGuides](#pauseguides) ⇒ `void`<br>
[ResumeGuides](#resumeguides) ⇒ `void` <br>
[DismissVisibleGuides](#dismissvisibleguides) ⇒ `void` <br>
[GetDeviceId](#getdeviceid) ⇒ `string` <br>
[GetVisitorId](#getvisitorid) ⇒ `string` <br>
[GetAccountId](#getaccountid) ⇒ `string` <br>
[SetDebugMode](#setdebugmode) ⇒ `void`<br>

## IPendoInterface APIs

### `PendoSDK`

```c# 
interface IPendoInterface
```

>The interface of the Pendo shared instance. 

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Example</b>:
    
```c#
using PendoSDKXamarin;

namespace ExampleApp
{
    public partial class App : Application
    {
        private static IPendoInterface pendo = DependencyService.Get<IPendoInterface>();
        
        // the rest of your code

    }
}      
```
</details>

### `Setup`

```c# 
static void Setup(string appKey)
```

>Establishes a connection with Pendo’s server. Call this API in your application’s OnStart() method. The setup method can only be called once during the application lifecycle. Calling this API is required before tracking sessions or invoking session-related APIs. 

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Class</b>: PendoInterface
<br><b>Kind</b>: class method
<br>
<b>Returns</b>: void
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| appKey | string | The App Key is listed in your Pendo Subscription Settings in App Details |

<b>Example</b>:
    
```c#
pendo.Setup("your.app.key");  
```
</details>


### `StartSession`

```c# 
void StartSession(string visitorId, string accountId, Dictionary<string, object> visitorData, Dictionary<string, object> accountData)
```

>Starts a mobile session with the provided visitor and account information. If a session is already in progress, the current session will terminate and a new session will begin. The termination of the app will also terminate the session.

>To generate an anonymous visitor, pass `null` as the visitorId. Visitor data and Account data are optional.

> No action will be taken if the visitor and account IDs do not change when calling the startSession API during an ongoing session. 
 
<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>


<b>Class</b>: PendoInterface
<br><b>Kind</b>: class method
<br>
<b>Returns</b>: void
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| visitorId | string | The session visitor ID. For an anonymous visitor set to `null` |
| accountId | string | The session account ID |
| visitorData | Dictionary<string, object> | Additional visitor metadata |
| accountData | Dictionary<string, object> | Additional account metadata |


<b>Example</b>:
    
```c#
var visitorData = new Dictionary<string, object>
{
    { "age", 21 },
    { "country", "USA" }
};

var accountData = new Dictionary<string, object>
{
    { "Tier", 1 },
    { "Size", "Enterprise" }
};

pendo.StartSession("John Doe", "ACME", visitorData, accountData);
```

</details>

### `SetVisitorData`

```c# 
void SetVisitorData(Dictionary<string, object> visitorData)
```

>Updates the visitor metadata of the ongoing session.
  
<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>


<b>Class</b>: PendoInterface
<br><b>Kind</b>: class method
<br>
<b>Returns</b>: void
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| visitorData | Dictionary<string, object> | The visitor metadata to be updated |


<b>Example</b>:
    
```c#
var visitorData = new Dictionary<string, object>
{
    { "age", 25 },
    { "country", "UK" },
    { "birthday", "01-01-1990" }
};

pendo.SetVisitorData(visitorData);
```

</details>

### `SetAccountData`

```c# 
void SetAccountData(Dictionary<string, object> accountData)
```

>Updates the account metadata of the ongoing session.
  
<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>


<b>Class</b>: PendoInterface
<br><b>Kind</b>: class method
<br>
<b>Returns</b>: void
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| accountData | Dictionary<string, object> | The account metadata to be updated |


<b>Example</b>:
    
```c#
var accountData = new Dictionary<string, object>
{
    { "Tier", 2 },
    { "size", "Mid-Market" },
    { "signing-date", "01-01-2020" }
};

pendo.SetAccountData(accountData);
```

</details>

### `EndSession`

```c# 
void EndSession()
```

>Ends the active session and stops collecting analytics or showing guides to the user. A new session can be started by calling the startSession API.

>This API is commonly used when the user logs out of your application.


  
<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>


<b>Class</b>: PendoInterface
<br><b>Kind</b>: class method
<br>
<b>Returns</b>: void
<br>

<b>Example</b>:
    
```c#
pendo.EndSession(); 
```

</details>

### `Track`

```c#
void Track(string eventName,
Dictionary<string, object> trackData)
```

>Sends a track event with the specified properties.

<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>

<b>Class</b>: PendoInterface<br>
<b>Kind</b>: class method<br>
<b>Returns</b>: void<br>
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| eventName | string | The track event name |
| properties | Dictionary<string, object> | Additional metadata to be sent as part of the track event |

<b>Example:</b>

```c#
var trackEventProperties = new Dictionary<string, object>
{
    { "Theme", "Dark Mode" },
};

pendo.Track("App Opened", trackEventProperties);
```
</details>

### `PauseGuides`

```c# 
void PauseGuides(bool dismissGuides)
```

>Pauses any guides from appearing during an active session. If the `DismissGuides` value is set to `true`, then any visible guide will be dismissed.

<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Class:</b> PendoInterface<br>
<b>Kind:</b> class method<br>
<b>Returns:</b> void<br>
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| dismissGuides | bool | Determines wether the displayed guide, if one is visible, will be dismissed when pausing the display of further guides |

<b>Example:</b>

```c#
pendo.PauseGuides(false);
```
</details>


### `ResumeGuides`

```c# 
void ResumeGuides()
```

>Resumes displaying guides during the ongoing session. This API reverses the logic of the `PauseGuides` API.

<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Class:</b> PendoInterface<br>
<b>Kind:</b> class method<br>
<b>Returns:</b> void<br>
<br>
<b>Example:</b>

```c#
Pendo.ResumeGuides();
```
</details>

### `DismissVisibleGuides`

```c# 
void DismissVisibleGuides()
```

>Dismisses any visible guide.

<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Class:</b> PendoInterface<br>
<b>Kind:</b> class method<br>
<b>Returns:</b> void<br>
<br>
<b>Example:</b>

```c#
Pendo.DismissVisibleGuides();
```
</details>

### `GetDeviceId`

```c# 
string GetDeviceId()
```

>Returns the device's unique Pendo-generated ID. 

<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Class:</b> PendoInterface<br>
<b>Kind:</b> class method<br>
<b>Returns:</b> String<br>
<br>
<b>Example:</b>

```c#
Pendo.GetDeviceId();
```
</details>

### `GetVisitorId`

```c# 
string GetVisitorId()
```

>Returns the ID of the visitor in the active session.

<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Class:</b> PendoInterface<br>
<b>Kind:</b> class method<br>
<b>Returns:</b> String<br>
<br>
<b>Example:</b>

```c#
Pendo.GetVisitorId();
```
</details>

### `GetAccountId`

```c# 
string GetAccountId()
```

>Returns the ID of the account in the active session.

<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Class:</b> PendoInterface<br>
<b>Kind:</b> class method<br>
<b>Returns:</b> String<br>
<br>
<b>Example:</b>

```c#
Pendo.GetAccountId();
```
</details>

### `SetDebugMode`

```c# 
void SetDebugMode(bool isDebugEnabled)
```

>Enable/disable debug logs from Pendo SDK. To debug the Pendo SDK we recommend calling this API before calling the setup API.

>Debug logs are turned off by default. Releasing your production app with the debug logs enabled is not recommended and may have performance repercussions on your app.

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Class</b>: PendoInterface
<br><b>Kind</b>: class method
<br>
<b>Returns</b>: void
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| isDebugEnabled | bool | Set to `true` to enable debug logs, `false` to disable |


<b>Example</b>:

```c#
Pendo.SetDebugMode(true);
Pendo.Setup("your.app.key");
```
</details>
