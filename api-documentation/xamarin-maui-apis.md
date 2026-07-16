# MAUI public developer API documentation

> [!IMPORTANT]
>The `Setup` API must be called before the `StartSession` API. <br> 
> All other APIs must be called after both the `Setup` and `StartSession` APIs, otherwise they will be ignored. <br>
>The `SetDebugMode` API is the exception to that rule and may be called anywhere in the code.

### IPendoInterface APIs
[IPendoService](#ipendoservice) ⇒ `IPendoService` <br>
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
[ScreenContentChanged](#screencontentchanged) ⇒ `void`<br>

### Session Replay — Privacy Configuration
[PendoPrivacyAction](#pendoprivacyaction) ⇒ `enum` <br>
[VisualElement.ApplyPendoSRPrivacy](#applypendosrprivacy) ⇒ `void` <br>
[VisualElement.ClearPendoSRPrivacy](#clearpendosrprivacy) ⇒ `void` <br>
[PendoSR.ReplayPrivacy](#pendosrreplayprivacy) (XAML attached property) <br>
[Actions & behavior](#actions--behavior) <br>
[Cascade & inheritance](#cascade--inheritance) <br>
[Safety rails](#safety-rails) <br>

## IPendoInterface APIs

### `IPendoService`

```c# 
interface IPendoService
```

>The interface of the Pendo shared instance. 

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Example:</b>
    
```c#
using PendoSDKXamarin;

namespace ExampleApp
{
    public partial class App : Application
    {
        IPendoService Pendo = PendoServiceFactory.CreatePendoService();

        /** if your app supports additional Platforms other than iOS and Android
        verify the Pendo instance is not null */

        if (pendo != null) {        

            // pendo related code

        }
        
        // the rest of your code
    }
}      
```
</details>

### `Setup`

```c# 
void Setup(string appKey)
```

>Establishes a connection with Pendo’s server. Call this API in your application’s OnStart() method. The setup method can only be called once during the application lifecycle. Calling this API is required before tracking sessions or invoking session-related APIs. 

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>
<b>Interface:</b> IPendoService
<br><b>Class:</b> PendoAndroidService/PendoiOSService
<br><b>Kind:</b> class method
<br><b>Returns:</b> void
<br>

| Param  |  Type  | Description                                                              |
|:------:|:------:|:-------------------------------------------------------------------------|
| appKey | string | The App Key is listed in your Pendo Subscription Settings in App Details |

<b>Example:</b>
    
```c#
Pendo.Setup("your.app.key");  
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

<b>Interface:</b> IPendoService
<br><b>Class:</b> PendoAndroidService/PendoiOSService
<br><b>Kind:</b> class method
<br><b>Returns:</b> void
<br>

|    Param    |            Type            | Description                                                    |
|:-----------:|:--------------------------:|:---------------------------------------------------------------|
|  visitorId  |           string           | The session visitor ID. For an anonymous visitor set to `null` |
|  accountId  |           string           | The session account ID                                         |
| visitorData | Dictionary<string, object> | Additional visitor metadata                                    |
| accountData | Dictionary<string, object> | Additional account metadata                                    |


<b>Example:</b>
    
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

Pendo.StartSession("John Doe", "ACME", visitorData, accountData);
```

</details>

### `SetVisitorData`

```c# 
void SetVisitorData(Dictionary<string, object> visitorData)
```

>Updates the visitor metadata of the ongoing session.
  
<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>


<b>Interface:</b> IPendoService
<br><b>Class:</b> PendoAndroidService/PendoiOSService
<br><b>Kind:</b> class method
<br><b>Returns:</b> void
<br>

|    Param    |            Type            | Description                        |
|:-----------:|:--------------------------:|:-----------------------------------|
| visitorData | Dictionary<string, object> | The visitor metadata to be updated |


<b>Example:</b>
    
```c#
var visitorData = new Dictionary<string, object>
{
    { "age", 25 },
    { "country", "UK" },
    { "birthday", "01-01-1990" }
};

Pendo.SetVisitorData(visitorData);
```

</details>

### `SetAccountData`

```c# 
void SetAccountData(Dictionary<string, object> accountData)
```

>Updates the account metadata of the ongoing session.
  
<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>


<b>Interface:</b> IPendoService
<br><b>Class:</b> PendoAndroidService/PendoiOSService
<br><b>Kind:</b> class method
<br><b>Returns</b>: void
<br>

|    Param    |            Type            | Description                        |
|:-----------:|:--------------------------:|:-----------------------------------|
| accountData | Dictionary<string, object> | The account metadata to be updated |


<b>Example:</b>
    
```c#
var accountData = new Dictionary<string, object>
{
    { "Tier", 2 },
    { "size", "Mid-Market" },
    { "signing-date", "01-01-2020" }
};

Pendo.SetAccountData(accountData);
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


<b>Interface:</b> IPendoService
<br><b>Class:</b> PendoAndroidService/PendoiOSService
<br><b>Kind:</b> class method
<br><b>Returns</b>: void
<br>

<b>Example:</b>
    
```c#
Pendo.EndSession(); 
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

<b>Interface:</b> IPendoService
<br><b>Class:</b> PendoAndroidService/PendoiOSService
<br><b>Kind:</b> class method
<br><b>Returns:</b> void
<br>

|   Param    |            Type            | Description                                               |
|:----------:|:--------------------------:|:----------------------------------------------------------|
| eventName  |           string           | The track event name                                      |
| properties | Dictionary<string, object> | Additional metadata to be sent as part of the track event |

<b>Example:</b>

```c#
var trackEventProperties = new Dictionary<string, object>
{
    { "Theme", "Dark Mode" },
};

Pendo.Track("App Opened", trackEventProperties);
```
</details>

### `PauseGuides`

```c# 
void PauseGuides(bool dismissGuides)
```

>Pauses any guides from appearing during an active session. If the `DismissGuides` value is set to `true`, then any visible guide will be dismissed. Calling this API affects the current session. Starting a new session reverts this logic, enabling guides to be presented.

<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>

<b>Interface:</b> IPendoService
<br><b>Class:</b> PendoAndroidService/PendoiOSService
<br><b>Kind:</b> class method
<br><b>Returns:</b> void
<br>

|     Param     | Type | Description                                                                                                             |
|:-------------:|:----:|:------------------------------------------------------------------------------------------------------------------------|
| dismissGuides | bool | Determines whether the displayed guide, if one is visible, is dismissed when pausing the display of the further guides |

<b>Example:</b>

```c#
Pendo.PauseGuides(false);
```
</details>


### `ResumeGuides`

```c# 
void ResumeGuides()
```

>Resumes displaying guides during the ongoing session. This API reverses the logic of the `PauseGuides` API.

<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Interface:</b> IPendoService
<br><b>Class:</b> PendoAndroidService/PendoiOSService
<br><b>Kind:</b> class method
<br><b>Returns:</b> void
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
<summary><b>Details</b></summary>
<br>
<b>Interface:</b> IPendoService
<br><b>Class:</b> PendoAndroidService/PendoiOSService
<br><b>Kind:</b> class method
<br><b>Returns:</b> void
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
<b>Interface:</b> IPendoService
<br><b>Class:</b> PendoAndroidService/PendoiOSService
<br><b>Kind:</b> class method
<br><b>Returns:</b> String
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
<b>Interface:</b> IPendoService
<br><b>Class:</b> PendoAndroidService/PendoiOSService
<br><b>Kind:</b> class method
<br><b>Returns:</b> string
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
<b>Interface:</b> IPendoService
<br><b>Class:</b> PendoAndroidService/PendoiOSService
<br><b>Kind:</b> class method
<br><b>Returns:</b> string
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

<b>Interface:</b> IPendoService
<br><b>Class:</b> PendoAndroidService/PendoiOSService
<br><b>Kind:</b> class method
<br><b>Returns:</b> void
<br>

|     Param      | Type | Description                                            |
|:--------------:|:----:|:-------------------------------------------------------|
| isDebugEnabled | bool | Set to `true` to enable debug logs, `false` to disable |


<b>Example:</b>

```c#
Pendo.SetDebugMode(true);
Pendo.Setup("your.app.key");
```
</details>

### `ScreenContentChanged`

```c# 
void ScreenContentChanged()
```

>Rescans the Page enabling the Pendo SDK to identify changes that have occurred since the Page loaded.

>Using this API is required to display tooltip guides and fix inaccurate analytics on elements that weren't present, or have been modified since the initial Page load.

>The API does not generate an additional Page load event.

<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Interface:</b> IPendoService
<br><b>Class:</b> PendoAndroidService/PendoiOSService
<br><b>Kind:</b> class method
<br><b>Returns:</b> void
<br>
<b>Example:</b>

```c#
Pendo.ScreenContentChanged();
```
</details>

<br>

## Session Replay — Privacy Configuration

> [!IMPORTANT]
> Session Replay privacy is first configured server-side through a **preset** (for example, masking all text, or masking input fields only). The APIs below let you override that preset on individual elements from your app code — imperatively with C# `VisualElement` extension methods, or declaratively with the `PendoSR.ReplayPrivacy` XAML attached property. All APIs live in the `PendoMAUIPlugin` namespace.

> An element's privacy is expressed with the `PendoPrivacyAction` enum: `Mask`, `Unmask`, or `Block`. An action applies to the element it is set on and **cascades down** to its descendants, unless a descendant sets its own action (see [Cascade & inheritance](#cascade--inheritance)).

> [!NOTE]
> This element-level API applies privacy rules to individual element **instances** and is currently available on **Android**.

### `PendoPrivacyAction`

```c#
public enum PendoPrivacyAction { Mask, Unmask, Block }
```

> The value passed to every element-level privacy API.

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Enum:</b> PendoPrivacyAction
<br><b>Namespace:</b> PendoMAUIPlugin
<br>

| Value | Effect |
| :---: | :--- |
| Mask | Redacts the element's **text**, which is rendered as asterisks in the replay. Text-only — does not affect images or media. |
| Unmask | Reveals **text** that the active preset would otherwise mask. Text-only — does not reveal a blocked image or media. |
| Block | Replaces the element (text, image, container, or media) with a layout-preserving gray placeholder, so its content is never captured. Also suppresses the replay of touch interactions over the element's bounds. |

> [!NOTE]
> `Mask` and `Unmask` affect **text only**. Images and other media are controlled by `Block` together with the backend preset. To hide an image or a region, use `Block`.

</details>

## Imperative API (C#)

### `ApplyPendoSRPrivacy`

```c#
public static void ApplyPendoSRPrivacy(this VisualElement element, PendoPrivacyAction action)
```

> C# extension on `Microsoft.Maui.Controls.VisualElement` that sets a Session Replay privacy action on an element instance, overriding the active preset for that element and its descendants.

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Class:</b> PendoSRPrivacyExtensions
<br><b>Namespace:</b> PendoMAUIPlugin
<br><b>Kind:</b> extension method on VisualElement
<br><b>Returns:</b> void
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| action | PendoPrivacyAction | The privacy action to apply (`Mask`, `Unmask`, or `Block`) |

<b>Example:</b>

```c#
using PendoMAUIPlugin;

// Redact the account balance text
balanceLabel.ApplyPendoSRPrivacy(PendoPrivacyAction.Mask);

// Reveal marketing copy the preset would otherwise mask
promoLabel.ApplyPendoSRPrivacy(PendoPrivacyAction.Unmask);

// Hide an entire payment section (text, images, and media)
paymentLayout.ApplyPendoSRPrivacy(PendoPrivacyAction.Block);
```
</details>

### `ClearPendoSRPrivacy`

```c#
public static void ClearPendoSRPrivacy(this VisualElement element)
```

> C# extension on `Microsoft.Maui.Controls.VisualElement` that removes any privacy action previously set on the element instance. After clearing, the element falls back to its inherited action (from an ancestor) or to the active preset.

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Class:</b> PendoSRPrivacyExtensions
<br><b>Namespace:</b> PendoMAUIPlugin
<br><b>Kind:</b> extension method on VisualElement
<br><b>Returns:</b> void
<br>

<b>Example:</b>

```c#
using PendoMAUIPlugin;

// Remove a previously applied rule; the element reverts to inherited/preset behavior
balanceLabel.ClearPendoSRPrivacy();
```
</details>

## Declarative API (XAML)

### `PendoSR.ReplayPrivacy`

```xml
<Label pendo:PendoSR.ReplayPrivacy="Mask" ... />
```

> XAML attached property that sets a Session Replay privacy action directly in markup, overriding the active preset for that element and its descendants. From a developer's perspective this property is set-only. Declare the Pendo XAML namespace on the page's root element before using it:

```xml
xmlns:pendo="clr-namespace:PendoMAUIPlugin;assembly=PendoMAUIPlugin"
```

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Class:</b> PendoSR
<br><b>Namespace:</b> PendoMAUIPlugin
<br><b>Kind:</b> XAML attached property (set-only)
<br>

| Attribute | Value | Description |
| :---: | :---: | :--- |
| pendo:PendoSR.ReplayPrivacy | Mask \| Unmask \| Block | The privacy action to apply to the element |

<b>Example:</b>

```xml
<ContentPage xmlns="http://schemas.microsoft.com/dotnet/2021/maui"
             xmlns:x="http://schemas.microsoft.com/winfx/2009/xaml"
             xmlns:pendo="clr-namespace:PendoMAUIPlugin;assembly=PendoMAUIPlugin">

    <VerticalStackLayout>

        <!-- Redact text -->
        <Label Text="Balance: $42,850.00" pendo:PendoSR.ReplayPrivacy="Mask" />

        <!-- Reveal text the preset would mask -->
        <Label Text="Public marketing copy — safe to show" pendo:PendoSR.ReplayPrivacy="Unmask" />

        <!-- Hide a whole payment region (text, images, and media) -->
        <VerticalStackLayout pendo:PendoSR.ReplayPrivacy="Block">
            <!-- payment fields... -->
        </VerticalStackLayout>

    </VerticalStackLayout>
</ContentPage>
```
</details>

## Actions & behavior

> - **Mask** — redacts the element's text, rendered as asterisks. Text-only.
> - **Unmask** — reveals text that the preset would otherwise mask. Text-only.
> - **Block** — replaces the element with a layout-preserving gray placeholder and suppresses the replay of touch interactions over its bounds. Works for any element type: text, image, container, or media.
>
> `Mask` and `Unmask` **never** affect images or media. Image and media capture is governed by `Block` and the backend preset. To hide an image or region, use `Block`. `Mask` does not gray out an image, and `Unmask` does not lift an image block.

## Cascade & inheritance

> A privacy action set on an element applies to that element **and cascades down** the visual tree to all of its descendants, until a descendant overrides it with its own action.

> [!IMPORTANT]
> **`Block` is terminal.** Once an ancestor is blocked, a descendant `Unmask` (or `Mask`) cannot override the inherited `Block` — the blocked subtree stays a placeholder.

<b>Example:</b>

```c#
// Container is blocked -> the whole subtree is a gray placeholder
rootLayout.ApplyPendoSRPrivacy(PendoPrivacyAction.Block);

// This has NO effect: a descendant cannot escape an inherited Block
childLabel.ApplyPendoSRPrivacy(PendoPrivacyAction.Unmask); // still blocked
```

```c#
// Container masks all text; a specific child is revealed
formLayout.ApplyPendoSRPrivacy(PendoPrivacyAction.Mask);
promoLabel.ApplyPendoSRPrivacy(PendoPrivacyAction.Unmask); // this child's text is shown
```

## Safety rails

> [!CAUTION]
> Sensitive inputs are **always masked**, even under an explicit `Unmask`. This safety rail cannot be overridden. It covers password fields, credit-card fields, email and phone inputs, and any field with an autofill hint. Use `Block` if you additionally want such a field rendered as a placeholder.
