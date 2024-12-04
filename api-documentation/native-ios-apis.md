# Native iOS public developer API documentation

> [!IMPORTANT]
>The `setup` API must be called before the `startSession` API. <br> 
> All other APIs must be called after both the `setup` and `startSession` APIs, otherwise they will be ignored. <br>
>The `setDebugMode` API is the exception to that rule and may be called anywhere in the code.

> [!TIP]
>Checkout out these sample apps integrated with Pendo:
>  - [ACHNBrowserUI](https://github.com/pendo-io/ACHNBrowserUI)
> - [TeslaApp](https://github.com/pendo-io/Tesla_Clone_Swiftui)

### PendoManager APIs
[shared](#shared) ⇒ `PendoManager` <br>
[setup](#setup) ⇒ `void` <br>
[initWith](#initwith) ⇒ `void` <br>
[startSession](#startsession) ⇒ `void` <br>
[setVisitorData](#setvisitordata) ⇒ `void` <br>
[setAccountData](#setaccountdata) ⇒ `void` <br>
[endSession](#endsession) ⇒ `void` <br>
[track](#track) ⇒ `void` <br>
[screenContentChanged](#screencontentchanged) ⇒ `void` <br>
[pauseGuides](#pauseguides) ⇒ `void` <br>
[resumeGuides](#resumeguides) ⇒ `void` <br>
[dismissVisibleGuides](#dismissvisibleguides) ⇒ `void` <br>
[getDeviceId](#getdeviceid) ⇒ `String` <br>
[getVisitorId](#getvisitorid) ⇒ `String` <br>
[getAccountId](#getaccountid) ⇒ `String` <br>
[jwt](#jwt) ⇒ `PendoJWT`<br>
[setDebugMode](#setdebugmode) ⇒ `void`<br>

### UIView
[UIView.pendoRecognizeClickAnalytics](#uiviewpendorecognizeclickanalytics) ⇒ `void` <br>

### View
[View.pendoEnableSwiftUI](#viewpendoenableswiftui) ⇒ `void` <br>
[View.pendoRecognizeClickAnalytics](#viewpendorecognizeclickanalytics) ⇒ `void` <br>

### NSNotifications
[kPNDDidSuccessfullyInitializeSDKNotification](#kpnddidsuccessfullyinitializesdknotification) <br>
[kPNDErrorInitializeSDKNotification](#kpnderrorinitializesdknotification) <br>

### JWT APIs
[jwt.startSession](#jwtstartsession) ⇒ `void` <br>
[jwt.setVisitorData](#jwtsetvisitordata) ⇒ `void` <br>
[jwt.setAccountData](#jwtsetaccountdata) ⇒ `void` <br>

## PendoManager APIs

### `shared`

```swift 
class func shared() -> Self
```

>Returns a shared instance of the PendoManager class. 

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Class</b>: PendoManager
<br><b>Kind</b>: static method 
<br>
<b>Returns</b>: PendoManager (shared instance)
<br>

<b>Example</b>:
    
```swift
PendoManager.shared()    
```
</details>

### `setup`

```swift 
func setup(_ appKey: String, with options: PendoOptions?)
```

> Establishes a connection with Pendo's server. The setup API method can only be called once during the application lifecycle. Calling this API is required before tracking sessions or invoking session-related APIs.

> If setup API is called while the device is offline, the setup API call fails. Make sure you call the setup API when network connection is available.

> setup API can only be called once during the application lifecycle.

> setup API will attempt 3 retries before failing and will not send a notification regardless of whether it succeeds or fails.


<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Class</b>: PendoManager
<br><b>Kind</b>: class method
<br>
<b>Returns</b>: void
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| appKey | String | The App Key is listed in your Pendo Subscription Settings in App Details |
| pendoOptions | PendoOptions | PendoOptions should be `nil` unless instructed otherwise by Pendo Support |


<b>Example</b>:
    
```swift
PendoManager.shared().setup("your.app.key", with: nil);

```
</details>

### `initWith`

```swift 
func initWith(_ url: URL)
```

>Call the API to enter the device into Pairing Mode when launching the app from a deep link provided by your Pendo subscription. Pairing Mode is used to tag your application and preview guides. 

>This API should be called either in the appDelegate or sceneDelegate class inside the openURL or openURLContexts method respectively.

>Setting up the Pendo URL scheme in your app is required for your device to pair. The scheme ID can be found in your Pendo Subscription Settings in App Details. 

>For more information see the native iOS installation instructions. Additional steps for pure SwiftUI applications are required and can be found in the installation instructions as well. 

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Class</b>: PendoManager
<br><b>Kind</b>: class method
<br>
<b>Returns</b>: void
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| url | URL | The URL argument of the AppDelegate openURL or SceneDelegate openURLContexts method |

<b>Example</b>:
    
```swift
// Implementation example in the AppDelegate file 

import Pendo

...

func application(_ app: UIApplication,open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    if url.scheme?.range(of: "pendo") != nil {
        PendoManager.shared().initWith(url)
        return true
    }
    // your code here...
    return true
}
```
</details>

### `startSession`

```swift 
func startSession(_ visitorId: String?, accountId: String?, visitorData: [AnyHashable : Any]?, accountData: [AnyHashable : Any]?)
```

> Starts a mobile session with the provided visitor and account information. If a session is already in progress, the current session terminates and a new session begins. The termination of the app also terminates the session.

> To generate an anonymous visitor, pass 'nil' as the visitorId. Visitor data and Account data are optional.

> No action is taken if the visitor and account IDs don’t change when calling the startSession API during an ongoing session.

> If the setup API fails, the startSession API will also fail, and the SDK will not initialize. To ensure proper functionality, always call the startSession API when an active internet connection is available. After three failed connection attempts, the SDK will stop trying to connect to the server.

> If startSession API is successful, the SDK posts a notification called "kPNDDidSuccessfullyInitializeSDKNotification".

> If startSession API fails, the SDK posts a notification called "kPNDErrorInitializeSDKNotification".
 
<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Class</b>: PendoManager
<br><b>Kind</b>: class method
<br>
<b>Returns</b>: void
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| visitorId | String? | The session visitor ID. For an anonymous visitor set to `nil` |
| accountId | String? | The session account ID |
| visitorData | [AnyHashable : Any]? | Additional visitor metadata |
| accountData | [AnyHashable : Any]? | Additional account metadata |

<b>Example</b>:
    
```swift
var visitorData = ["age": 27, "country": "USA"]
var accountData = ["Tier": 1, "size": "Enterprise"]
PendoManager.shared().startSession("John Doe", accountId: "ACME", visitorData: visitorData, accountData: accountData)  
```

</details>

### `setVisitorData`

```swift 
func setVisitorData(_ visitorData: [AnyHashable : Any])
```

>Updates the visitor metadata of the ongoing session.
  
<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>


<b>Class</b>: PendoManager
<br><b>Kind</b>: class method
<br>
<b>Returns</b>: void
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| visitorData | [AnyHashable : Any] | The visitor metadata to be updated |


<b>Example</b>:
    
```swift
var visitorData = ["age": 27, "country": "UK", "birthday" : "01-01-1990"]
PendoManager.shared().setVisitorData(visitorData) 
```

</details>

### `setAccountData`

```swift 
func setAccountData(_ accountData: [AnyHashable : Any])
```

>Updates the account metadata of the ongoing session.
  
<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>


<b>Class</b>: PendoManager
<br><b>Kind</b>: class method
<br>
<b>Returns</b>: void
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| accountData | [AnyHashable : Any] | The account metadata to be updated |


<b>Example</b>:
    
```swift
var accountData = ["Tier": 2, "Size": "Mid-Market", "Signing-date" : "01-01-2020"]
PendoManager.shared().setAccountData(accountData) 
```

</details>

### `endSession`

```swift 
func endSession()
```

>Ends the active session and stops collecting analytics or showing guides to the user. A new session can be started by calling the startSession API.

>This API is commonly used when the user logs out of your application.

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Class</b>: PendoManager
<br><b>Kind</b>: class method
<br>
<b>Returns</b>: void
<br>

<b>Example</b>:
    
```swift
PendoManager.shared().endSession()    
```

</details>


### `track`

```swift
func track(_ event: String, properties: [AnyHashable : Any]?)
```

>Sends a track event with the specified properties.

<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Class</b>: PendoManager<br>
<b>Kind</b>: class method<br>
<b>Returns</b>: void<br>
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| event | String | The track event name |
| properties | [AnyHashable : Any]? | Additional metadata to be sent as part of the track event |

<b>Example:</b>

```swift
var trackEventProperties = ["theme": "Dark Mode"]
PendoManager.shared().track("App Opened", trackEventProperties);
```
</details>


### `screenContentChanged`

```swift
func screenContentChanged()
```

>Manually triggers a rescan of the current screen layout hierarchy by the SDK. This API should be called on rare occasions when the SDK fails to collect analytics of an element on the page or when a tooltip guide connected to an element on the page fails to appear. Examples of such scenarios may include: views updated or added to the page after the initial loading of page, as well as changes to a view’s isHidden or alpha properties.

>The logic applied by this API is automatically invoked when scrolling the screen content of the app. Elements below the fold created dynamically while scrolling will be identified automatically by the SDK and there is no need to call the screenContentChanged API.

<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Class</b>: PendoManager<br>
<b>Kind</b>: class method<br>
<b>Returns</b>: void<br>

<br>
Example:

```swift
PendoManager.shared().screenContentChanged();
```
</details>

### `pauseGuides`

```swift 
func pauseGuides(_ dismissGuides: Bool)
```

>Pauses any guides from appearing during an active session. If the `dismissGuides` value is set to `true`, then any visible guide will be dismissed. Calling this API affects the current session. Starting a new session reverts this logic, enabling guides to be presented.

<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Class:</b> PendoManager<br>
<b>Kind:</b> class method<br>
<b>Returns:</b> void<br>
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| dismissGuides | Bool | Determines whether the displayed guide, if one is visible, is dismissed when pausing the display of the further guides |

<b>Example:</b>

```swift
PendoManager.shared().pauseGuides(false);
```
</details>


### `resumeGuides`

```swift 
func resumeGuides()
```

>Resumes displaying guides during the ongoing session. This API reverses the logic of the `pauseGuides` API.

<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Class:</b> PendoManager<br>
<b>Kind:</b> class method<br>
<b>Returns:</b> void<br>
<br>
<b>Example:</b>

```swift
PendoManager.shared().resumeGuides();
```
</details>

### `dismissVisibleGuides`

```swift 
func dismissVisibleGuides()
```

>Dismisses any visible guide.

<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Class:</b> PendoManager<br>
<b>Kind:</b> class method<br>
<b>Returns:</b> void<br>
<br>
<b>Example:</b>

```swift
PendoManager.shared().dismissVisibleGuides();
```
</details>

### `getDeviceId`

```swift 
func getDeviceId() -> String
```

>Returns the device's unique Pendo-generated ID. 

<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Class:</b> PendoManager<br>
<b>Kind:</b> class method<br>
<b>Returns:</b> String<br>
<br>
<b>Example:</b>

```swift
PendoManager.shared().getDeviceId();
```
</details>

### `getVisitorId`

```swift 
private(set) var visitorId: String?
```

>Returns the ID of the visitor in the active session.

<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Class:</b> PendoManager<br>
<b>Kind:</b> property getter<br>
<b>Returns:</b> String<br>
<br>
<b>Example:</b>

```swift
PendoManager.shared().visitorId;
```
</details>

### `getAccountId`

```swift 
private(set) var accountId: String?
```

>Returns the ID of the account in the active session.

<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Class:</b> PendoManager<br>
<b>Kind:</b> property getter<br>
<b>Returns:</b> String<br>
<br>
<b>Example:</b>

```swift
PendoManager.shared().accountId;
```
</details>

### `jwt`

```swift 
private(set) var jwt: PendoJWT
```

>Returns the JWT instance for handling secure metadata sessions. 

>To use secure metadata sessions, contact Pendo support to enable this feature.

<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Class:</b> PendoManager<br>
<b>Kind:</b> property getter<br>
<b>Returns:</b> PendoJWT<br>
<br>
<b>Example:</b>

```swift
PendoManger.shared().jwt;
```
</details>

### `setDebugMode`

```swift 
func setDebugMode(_ isDebugEnabled: Bool)
```

>Enable/disable debug logs from Pendo SDK. To debug the Pendo SDK we recommend calling this API before calling the setup API.

>Debug logs are turned off by default. Releasing your production app with the debug logs enabled is not recommended and may have performance repercussions on your app.

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Class</b>: PendoManager
<br><b>Kind</b>: class method
<br>
<b>Returns</b>: void
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| isDebugEnabled | Bool | Set to `true` to enable debug logs, `false` to disable |


<b>Example</b>:

```swift
PendoManager.shared().setDebugMode(true);
PendoManager.shared().setup("your.app.key", with: nil);
```
</details>

<br>

## UIView

### `UIView.pendoRecognizeClickAnalytics`

```swift 
func pendoRecognizeClickAnalytics() 
```

>Call this method on the UIView to manually enable analytics collection and the display of tooltip guides on the view. Use the API only on the rare occasion when the Pendo SDK does not automatically recognize the clickable feature.

>This API will only work on UIViews that inherit from UIResponder.


<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Class</b>: UIView
<br><b>Kind</b>: extension class method
<br>
<b>Returns</b>: void
<br>

<b>Example</b>:

```swift
someUIView.pendoRecognizeClickAnalytics();
```
</details>

<br>

## View

### `View.pendoEnableSwiftUI` 

> [!NOTE]
>Deprecated from SDK 3.1. The SDK automatically performs the logic, removing the need to use this API. Calling it will be ignored.

```swift 
func pendoEnableSwiftUI() 
```

>To support SwiftUI you must apply this modifier to the application rootView. If there are multiple rootViews (ex. usage of multiple UIHostingControllers), apply the modifier to each main rootView.

>See the iOS native installation instructions for additional information and examples.

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Class</b>: View
<br><b>Kind</b>: extension class method
<br>
<b>Returns</b>: void
<br>

<b>Example</b>:

```swift
struct YourView: View {
    var body: some View {
        Text("RootView")
            .pendoEnableSwiftUI()
    }
}
```
</details>


### `View.pendoRecognizeClickAnalytics`

```swift 
func pendoRecognizeClickAnalytics() 
```

>Call this method on the View to manually enable analytics collection and the display of tooltip guides on the view. Use the API only on the rare occasion when the Pendo SDK does not automatically recognize the clickable feature.

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Class</b>: View
<br><b>Kind</b>: extension class method
<br>
<b>Returns</b>: void
<br>

<b>Example</b>:

```swift
someView.pendoRecognizeClickAnalytics();
```
</details>

<br>

## NSNotifications

### `kPNDDidSuccessfullyInitializeSDKNotification`

>An NSNotification will be sent once per session, as soon as the analytics recording of the session has begun and the session guides are ready to be displayed.

>Guides that are not triggered on app launch may take a few additional moments after this notification has been sent to be ready for display.

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Example</b>:

```swift
NotificationCenter.default.addObserver(self, 
    selector: #selector(self.methodOfReceivedNotification(notification:)), 
    name: NSNotification.Name.pndDidSuccessfullyInitializeSDK, 
    object: nil)

@objc func methodOfReceivedNotification(notification: Notification) {
    // your code here
}

// optional - if callback is no longer relevant

deinit {
NotificationCenter.default.removeObserver(self, 
    name: NSNotification.Name.pndDidSuccessfullyInitializeSDK, 
    object: nil)
}
```
</details>

### `kPNDErrorInitializeSDKNotification`

>An NSNotification will be sent on a failed attempt to establish a connection with Pendo's server or on a failed attempt to start a new session when calling Pendo's Setup or StartSession APIs respectively.

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Example</b>:

```swift
NotificationCenter.default.addObserver(self, 
    selector: #selector(self.methodOfReceivedNotification(notification:)), 
    name: NSNotification.Name.pndErrorInitializeSDK, 
    object: nil)

@objc func methodOfReceivedNotification(notification: Notification) {
    // your code here
}

// optional - if callback is no longer relevant

deinit {
NotificationCenter.default.removeObserver(self, 
    name: NSNotification.Name.pndErrorInitializeSDK, 
    object: nil)
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

```swift 
func startSession(_ jwt: String, signingKeyName: String)
```

>Starts a mobile session with the provided JWT and the signing-key name used to sign the JWT. Create the signed JWT on your server-side and pass it to the device, together with the signing-key name, before calling the startSession API.

> If a session is already in progress, the current session will terminate and a new session will begin. The termination of the app will also terminate the session.

> The JWT payload must contain both the visitor and account elements, each with an `id` property and value. To generate an anonymous visitor use an empty string as the value of the `id` property of the visitor element. The account `id` property may be set to an empty string as well. Additional visitor and account properties are optional.
 
<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>


<b>Class</b>: PendoJWT
<br><b>Kind</b>: class method
<br>
<b>Returns</b>: void
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| jwt | String | The signed JWT string containing the visitor and account elements  |
| signingKeyName | String | The name of the key used to sign the JWT |

<b>Example</b>:
    
```swift
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

PendoManager.shared().jwt.startSession(jwt, signingKeyName:sKeyName);  
```

</details>

### `jwt.setVisitorData`

```swift 
func setVisitorData(_ jwt: String, signingKeyName: String)
```

>To generate or find your JWT signing-key name and corresponding secret value go to your app’s Install Settings section in your Pendo Subscription Settings.

>Updates the visitor metadata of the ongoing session with the provided JWT and the signing-key name used to sign the JWT. Create the signed JWT on your server-side and pass it to the device, together with the signing-key name, before calling the setVisitorData API.

>The JWT payload should not include the account element, and the visitor ‘id’ property value must match the visitor ‘id’ value used to start the session.
 
<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>


<b>Class</b>: PendoJWT
<br><b>Kind</b>: class method
<br>
<b>Returns</b>: void
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| jwt | String | The signed JWT string containing the visitor element  |
| signingKeyName | String | The name of the key used to sign the JWT |

<b>Example</b>:
    
```swift
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

PendoManager.shared().jwt.setVisitorData(jwt, signingKeyName:sKeyName);  
```

</details>

### `jwt.setAccountData`

```swift 
func setAccountData(_ jwt: String, signingKeyName: String)
```

>To generate or find your JWT signing-key name and corresponding secret value go to your app’s Install Settings section in your Pendo Subscription Settings.

>Updates the account metadata of the ongoing session with the provided JWT and the signing-key name used to sign the JWT. Create the signed JWT on your server-side and pass it to the device, together with the signing-key name, before calling the setAccountData API.

>The JWT payload should not include the visitor element, and the account ‘id’ property value must match the account ‘id’ value used to start the session.

 
<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>


<b>Class</b>: PendoJWT
<br><b>Kind</b>: class method
<br>
<b>Returns</b>: void
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| jwt | String | The signed JWT string containing the account element  |
| signingKeyName | String | The name of the key used to sign the JWT |

<b>Example</b>:
    
```swift
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

PendoManager.shared().jwt.setAccountData(jwt, signingKeyName:sKeyName);  
```

</details>
