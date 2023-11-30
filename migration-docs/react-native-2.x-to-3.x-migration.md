# React Native migration from version 2.x to version 3.x


Follow these instructions to resolve breaking changes in your app:

<table border =2>

<tr>
<td align=center><b>Component / API </td>
<td align=center><b>Instructions</b></td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>withPendoRN </td>
<td>

Use `WithPendoReactNavigation` instead of `withPendoRN` and remove any Pendo related code (ref, onStateChange and onReady implementations):

<b>2.x (deprecated):</b>

```javascript
// in the file where the NavigationContainer is created
import {withPendoRN} from 'rn-pendo-sdk'    

function RootNavigator(props) {
    const navigationRef = useRef();
    return (    
        <NavigationContainer
            ref={navigationRef}
            onStateChange={()=> {
                const state = navigationRef.current.getRootState()
                props.onStateChange(state);
            }}
            onReady ={()=>{
                const state = navigationRef.current.getRootState()
                props.onStateChange(state);
            }}>
            {MainStackScreen()}
        </NavigationContainer>
    )
    export default withPendoRN(RootNavigator);  
}
```

<b>3.x:</b>

```javascript
// in the file where the NavigationContainer is created
import {WithPendoReactNavigation} from 'rn-pendo-sdk'    

// wrap NavigationContainer with WithPendoReactNavigation HOC
const PendoNavigationContainer = WithPendoReactNavigation(NavigationContainer);    

// replace NavigationContainer tag with PendoNavigationContainer tag
<PendoNavigationContainer>

{/* The rest of your app code */}

</PendoNavigationContainer>
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>initSDK </td>
<td>

Replace `initSDK` by calling `setup` and then `startSession`.

<b>2.x (deprecated):</b>

```javascript
import { PendoSDK, NavigationLibraryType } from 'rn-pendo-sdk';

// only if using React Native Navigation
import { Navigation } from "react-native-navigation";

// set session parameters
const pendoParams = {'visitorId': 'someVisitorID',
                     'accountId': 'someAccountID',
                     'vistiorData':  {'age': '25', 'country': 'USA'},
                     'accountData':  {'tier': '1', 'size': 'Enterprise'}};

// select the correct NavigationLibraryType according to your application
const navigationOptions = {library: NavigationLibraryType.ReactNavigation}; 
const navigationOptions = {library: NavigationLibraryType.ReactNativeNavigation, navigation: Navigation};
const navigationOptions = {library: NavigationLibraryType.Other}; 

// establish connection to server and start a session
PendoSDK.initSdk('someAppKey', 
                  pendoParams, 
                  navigationOptions);
```

<b>3.x:</b>

```javascript
import { PendoSDK, NavigationLibraryType } from 'rn-pendo-sdk';

// only if using React Native Navigation
import { Navigation } from "react-native-navigation";


// select the correct NavigationLibraryType according to your application
const navigationOptions = {library: NavigationLibraryType.ReactNavigation}; 
const navigationOptions = {library: NavigationLibraryType.ReactNativeNavigation, navigation: Navigation};
const navigationOptions = {library: NavigationLibraryType.Other};

// establish connection to server
PendoSDK.setup('someAppKey', navigationOptions);

// start a session
PendoSDK.startSession('someVisitorID', 
                     'someAccountID', 
                     {'age': '25', 'country': 'USA'}, 
                     {'tier': '1', 'size': 'Enterprise'});
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>initSDKWithoutVisitor </td>
<td>

Call `setup` instead of `initSDKWithoutVisitor`.

<b>2.x (deprecated):</b>

```javascript
import { PendoSDK, NavigationLibraryType } from 'rn-pendo-sdk';

// only if using React Native Navigation
import { Navigation } from "react-native-navigation";


// select the correct NavigationLibraryType according to your application
const navigationOptions = {library: NavigationLibraryType.ReactNavigation}; 
const navigationOptions = {library: NavigationLibraryType.ReactNativeNavigation, navigation: Navigation};
const navigationOptions = {library: NavigationLibraryType.Other};

// establish connection to server
PendoSDK.initSDKWithoutVisitor('someAppKey', navigationOptions);
```

<b>3.x:</b>

```javascript
import { PendoSDK, NavigationLibraryType } from 'rn-pendo-sdk';

// only if using React Native Navigation
import { Navigation } from "react-native-navigation";


// select the correct NavigationLibraryType according to your application
const navigationOptions = {library: NavigationLibraryType.ReactNavigation}; 
const navigationOptions = {library: NavigationLibraryType.ReactNativeNavigation, navigation: Navigation};
const navigationOptions = {library: NavigationLibraryType.Other};

// establish connection to server
PendoSDK.setup('someAppKey', navigationOptions);
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>clearVisitor </td>
<td>

Call `startSession` with `null` values instead of `clearVisitor`.

<b>2.x (deprecated):</b>

```javascript
// start a session with an anonymous visitor
PendoSDK.clearVisitor()
```

<b>3.x:</b>

```javascript
// start a session with an anonymous visitor
PendoSDK.startSession(null, null, null, null);
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>switchVisitor </td>
<td>

Call `startSession` with a new visitor or account id instead of `switchVisitor`.

<b>2.x (deprecated):</b>

```javascript
PendoSDK.switchVisitor('someVisitorID', 
            'someAccountID', 
            {'age': '25', 'country': 'USA'}, 
            {'tier': '1', 'size': 'Enterprise'});
```

<b>3.x:</b>

```javascript
PendoSDK.startSession('someVisitorID', 
            'someAccountID', 
            {'age': '25', 'country': 'USA'}, 
            {'tier': '1', 'size': 'Enterprise'});
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>setAccountId </td>
<td>

Call `startSession` with the new account id value instead of `setAccountId`.

<b>2.x (deprecated):</b>

```javascript
PendoSDK.setAccountId('someAccountID');
```

<b>3.x:</b>

```javascript
// start a new session passing in the new accountId 
PendoSDK.startSession('someVisitorID', 
            'someAccountID', 
            {'age': '25', 'country': 'USA'}, 
            {'tier': '1', 'size': 'Enterprise'});
```

</td>
</tr>
</table>