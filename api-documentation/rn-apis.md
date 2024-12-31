# React Native public developer API documentation

> [!IMPORTANT]
>The `setup` API must be called before the `startSession`, `WithPendoReactNavigation` and `WithPendoModal` APIs. <br> 
> All other APIs must be called after both the `setup` and `startSession` APIs, otherwise they will be ignored. <br>
>The `setDebugMode` API is the exception to that rule and may be called anywhere in the code.

> [!TIP]
>Checkout out these sample apps integrated with Pendo:
>- [RN sample app](https://github.com/pendo-io/RN-demo-app-React-Navigation)
>- [RNN sample app](https://github.com/pendo-io/RN-demo-app-React-Native-Navigation)

### Pendo React Components
[WithPendoReactNavigation](#withpendoreactnavigation) <br/>
[WithPendoExpoRouter](#withpendoexporouter) <br/>
[WithPendoModal](#withpendomodal) <br/>

### PendoSDK APIs

[setup](#setup) ⇒ `void` <br>
[startSession](#startsession) ⇒ `void` <br>
[setVisitorData](#setvisitordata) ⇒ `void` <br>
[setAccountData](#setaccountdata) ⇒ `void` <br>
[endSession](#endsession) ⇒ `void` <br>
[track](#track) ⇒ `void` <br>
[screenContentChanged](#screencontentchanged) ⇒ `void` <br>
[sendClickAnalytic](#sendclickanalytic) ⇒ `void` <br>
[pauseGuides](#pauseguides) ⇒ `void`<br>
[resumeGuides](#resumeguides) ⇒ `void` <br>
[dismissVisibleGuides](#dismissvisibleguides) ⇒ `void` <br>
[getDeviceId](#getdeviceid) ⇒ `String` <br>
[getVisitorId](#getvisitorid) ⇒ `String` <br>
[getAccountId](#getaccountid) ⇒ `String` <br>
[setDebugMode](#setdebugmode) ⇒ `void`<br>

### Navigation

[NavigationOptions](#navigationoptions) <br>
[NavigationLibraryType](#setdebugmode) <br>


## Pendo React Components

### `WithPendoReactNavigation`

```typescript 
WithPendoReactNavigation(NavigationContainer)
```

>Only for apps that use React Navigation library. This function wraps the navigation container to track the navigation state. 

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Class</b>: React.FunctionComponent<P>

| Param  | Type | Description |
| :---: | :---: | :--- |
| navigationContainer | NavigationContainer | The app NavigationContainer, required by Pendo to track the app navigation states |

<b>Example</b>:
    
```typescript
// In the file where the NavigationContainer is created

import {WithPendoReactNavigation} from 'rn-pendo-sdk'    

const PendoNavigationContainer = WithPendoReactNavigation(NavigationContainer);    

// replace the NavigationContainer tag with PendoNavigationContainer tag

<PendoNavigationContainer>
{/* Rest of your app code */}
</PendoNavigationContainer>
```
</details>

### `WithPendoExpoRouter`

```typescript 
WithPendoExpoRouter(RootLayout)
```

>Only for apps that use Expo Router library. This function wraps the root layout container to track the navigation state.

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Class</b>: React.FunctionComponent<P>

|   Param    | Type | Description                                                 |
|:----------:| :---: |:------------------------------------------------------------|
| RootLayout | ReactNode | The app's root layout containing the expo router components |

<b>Example</b>:

In the file where your **Root Layout** is created
import `WithPendoExpoRouter`, `usePathname` and `useGlobalSearchParams`:

```typescript
import {WithPendoExpoRouter} from 'rn-pendo-sdk'
import {useGlobalSearchParams, usePathname} from 'expo-router';
```

Add the following code to the method building your **Root Layout** component. Make sure to pass **props** to your Root Layout method.

```typescript
function RootLayout(props: any): ReactNode {
    ...
    let pathname = usePathname();
    const params = useGlobalSearchParams();
    
    useEffect(() => {
        props.onExpoRouterStateChange(pathname, params);
    }, [pathname, params, props]);
    ...
}
```
Wrap your **Root Layout** component with **WithPendoExpoRouter**:
```typescript
export default WithPendoExpoRouter(RootLayout);
```
</details>

### `WithPendoModal`

```typescript 
WithPendoModal(ModalComponent)
```

>Only for apps that use React Navigation library. This function wraps the modal component so the SDK can track the modal.

>Note: gorhom/bottomSheetModal v4 and v5 is supported
<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Class</b>: React.FunctionComponent or gorhom/BottomSheetModal<P>

| Param  |    Type     | Description |
| :---: |:-----------:| :--- |
| modalComponent | React.Modal or gorhom/BottomSheetModal | The ModalComponent required by Pendo to track the modal |

<b>Example</b>:
    
```typescript
// In the file where the Modal is created

import {WithPendoModal} from 'rn-pendo-sdk';    

//In case of React.Modal
const PendoModal = WithPendoModal(Modal); 

//Or in case of gorhom/BottomSheetModal
const PendoModal = WithPendoModal(BottomSheetModal);

// replace the Modal tag with PendoModal tag

<PendoModal>
{/* Rest of your app code */}
</PendoModal>
```
</details>

<br>

## PendoSDK APIs

### `setup`

```typescript 
static setup(appKey: string, navigationOptions: NavigationOptions, pendoOptions?: PendoOptions): void
```

>Establishes a connection with Pendo’s server. Call this API in your application’s main file (App.js/.ts/.tsx). The setup method can only be called once during the application lifecycle. Calling this API is required before tracking sessions or invoking session-related APIs. 

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Class</b>: PendoSDK
<br><b>Kind</b>: static method
<br>
<b>Returns</b>: void
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| appKey | string | The App Key is listed in your Pendo Subscription Settings in App Details |
| navigationOptions | NavigationOptions | Convey the navigation library used by your app |
| pendoOptions | PendoOptions | PendoOptions should be `null` unless instructed otherwise by Pendo Support |


<b>Example</b>:
    
```typescript
// example using React Navigation 
const navigationOptions = {library: NavigationLibraryType.ReactNavigation}; 

PendoSDK.setup('your.app.key', navigationOptions);  
```
</details>


### `startSession`

```typescript 
static startSession(visitorId?: string, accountId?: string, visitorData?: object, accountData?: object): void
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
| visitorId | string | The session visitor ID. For an anonymous visitor set to `null` |
| accountId | string | The session account ID |
| visitorData | object | Additional visitor metadata |
| accountData | object | Additional account metadata |


<b>Example</b>:
    
```typescript
const visitorData = {'age': '21', 'country': 'USA'};
const accountData = {'Tier': '1', 'Size': 'Enterprise'};

PendoSDK.startSession('John Doe', 'ACME', visitorData, accountData);
```

</details>

### `setVisitorData`

```typescript 
static setVisitorData(visitorData: object): void
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
| visitorData | object | The visitor metadata to be updated |


<b>Example</b>:
    
```typescript
const visitorData = {'age': '25', 'country': 'UK', 'birthday': '01-01-1990'};
PendoSDK.setVisitorData(visitorData);
```

</details>

### `setAccountData`

```typescript 
static setAccountData(accountData: object): void

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
| accountData | object | The account metadata to be updated |


<b>Example</b>:
    
```typescript
const accountData = {'Tier': '2', 'size': 'Mid-Market', 'signing-date': '01-01-2020'};
PendoSDK.setAccountData(accountData);

```

</details>

### `endSession`

```typescript 
static endSession(): void
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
    
```typescript
PendoSDK.endSession(); 
```

</details>

### `track`

```typescript
static track(name: string, params?: object): void
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
| event | string | The track event name |
| properties | object | Additional metadata to be sent as part of the track event |

<b>Example:</b>

```typescript
// optional additional properties
const additionalProperties = {'Theme': 'Dark Mode'};

PendoSDK.track('App Opened', additionalProperties);
```
</details>

### `screenContentChanged`

```java
static screenContentChanged(): void
```

>This method manually triggers a rescan of the current screen layout hierarchy by the SDK. This API should be called on rare occasions where the delayed appearance of some elements on the screen is not recognized by the SDK.

>If multiple page captures were used to tag all features in the page (where some features exist only in some state of the page), verify that all of the page captures of the screen are configured with identical page rules and page identifiers for correct analytics and guide behavior.


<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Class</b>: Pendo<br>
<b>Kind</b>: static method<br>
<b>Returns</b>: void<br>

<br>
Example:

```java
PendoSDK.screenContentChanged();
```
</details>


### `sendClickAnalytic`

```java
static sendClickAnalytic(nativeID: string): void
```

>The API manually sends an RAClick analytic for the view during the ongoing session. Use the API only when Pendo does not automatically recognize a clickable feature by passing in the nativeID of the view. Call the API in your code as part of the action implementation (ex. onTouchListener, onClickListener, etc).

>This API’s logic is only relevant for handling issues encountered in your Android app (similar edge cases are not known to us in iOS). Calling this API will not resolve issues in your iOS app. 


<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Class</b>: Pendo<br>
<b>Kind</b>: static method<br>
<b>Returns</b>: void<br>
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| nativeID | string | The nativeID of the view to be used by the manual triggered RAClick analytic event |

<b>Example:</b>

```java
PendoSDK.sendClickAnalytic(myButton.nativeID);
```
</details>


### `pauseGuides`

```typescript 
static pauseGuides(dismissGuides: boolean): void
```

>Pauses any guides from appearing during an active session. If the `dismissGuides` value is set to `true`, then any visible guide will be dismissed. Calling this API affects the current session. Starting a new session reverts this logic, enabling guides to be presented.

<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Class:</b> PendoSDK<br>
<b>Kind:</b> static method<br>
<b>Returns:</b> void<br>
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| dismissGuides | boolean | Determines whether the displayed guide, if one is visible, is dismissed when pausing the display of the further guides |

<b>Example:</b>

```typescript
PendoSDK.pauseGuides(false);
```
</details>


### `resumeGuides`

```typescript 
static resumeGuides(): void
```

>Resumes displaying guides during the ongoing session. This API reverses the logic of the `pauseGuides` API.

<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Class:</b> PendoSDK<br>
<b>Kind:</b> static method<br>
<b>Returns:</b> void<br>
<br>
<b>Example:</b>

```typescript
PendoSDK.resumeGuides();
```
</details>

### `dismissVisibleGuides`

```typescript 
static dismissVisibleGuides(): void
```

>Dismisses any visible guide.

<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Class:</b> PendoSDK<br>
<b>Kind:</b> static method<br>
<b>Returns:</b> void<br>
<br>
<b>Example:</b>

```typescript
PendoSDK.dismissVisibleGuides();
```
</details>

### `getDeviceId`

```typescript 
static async getDeviceId(): Promise<string | null>
```

>Returns the device's unique Pendo-generated ID. 

<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Class:</b> PendoSDK<br>
<b>Kind:</b> static method<br>
<b>Returns:</b> Promise &lt string | null &gt <br>
<br>
<b>Example:</b>

```typescript
const deviceId = PendoSDK.getDeviceId();

deviceId.then((val) => {
    // success code
}).catch((err) => {
    // error code
});
```
</details>

### `getVisitorId`

```typescript 
static async getVisitorId(): Promise<string | null>
```

>Returns the ID of the visitor in the active session.

<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Class:</b> PendoSDK<br>
<b>Kind:</b> static method<br>
<b>Returns:</b> Promise &lt string | null &gt <br>
<br>
<b>Example:</b>

```typescript
const visitorId = PendoSDK.getVisitorId();

visitorId.then((val) => {
    // success code
}).catch((err) => {
    // error code
});
```
</details>

### `getAccountId`

```typescript 
static async getAccountId(): Promise<string | null>
```

>Returns the ID of the account in the active session.

<details>
<summary><b>Details</b></summary>
<br>
<b>Class:</b> PendoSDK<br>
<b>Kind:</b> static method<br>
<b>Returns:</b> Promise &lt string | null &gt<br>
<br>
<b>Example:</b>

```typescript
const accountId = PendoSDK.getAccountId();

accountId.then((val) => {
    // success code
}).catch((err) => {
    // error code
});
```
</details>

### `setDebugMode`

```typescript 
static setDebugMode(isDebugEnabled: boolean): void
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
| isDebugEnabled | boolean | Set to `true` to enable debug logs, `false` to disable |


<b>Example</b>:

```typescript
PendoSDK.setDebugMode(true);

// example using React Navigation 
const navigationOptions = {library: NavigationLibraryType.ReactNavigation}; 

PendoSDK.setup('your.app.key', navigationOptions);  
```
</details>

<br>

## Navigation

### `NavigationOptions`

```typescript 
NavigationOptions(library: NavigationLibraryType, navigation?: any)
```

>A NavigationOptions instance is required to call the setup API and establish a connection to Pendo’s server.

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| library | NavigationLibraryType | The navigation library used by the app |
| navigation | any? | The navigation property is required if and only if the React Native Navigation library is used for navigation. |


<b>Example using React Navigation</b>:

```typescript
const navigationOptions = {library: NavigationLibraryType.ReactNavigation}; 
PendoSDK.setup('your.app.key', navigationOptions);  
```

<b>Example using React Native Navigation</b>:

```typescript
import { Navigation } from "react-native-navigation";

const navigationOptions = { library: NavigationLibraryType.ReactNativeNavigation, navigation: Navigation };
PendoSDK.setup('your.app.key', navigationOptions);  
```
</details>

### `NavigationLibraryType`

```typescript 
enum NavigationLibraryType
```

>The navigation library used in you app. The available enum options include:
> - ReactNativeNavigation
> - ReactNavigation
> - Other
