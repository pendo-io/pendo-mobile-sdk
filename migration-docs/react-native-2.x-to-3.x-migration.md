# React Native Migration From 2.x to 3.x


The following deprecated APIs have been removed. Follow these instructions to replace them:

<table border =2>

<tr>
<td align=center><b>Component / API </td>
<td align=center><b>Instructions</b></td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>withPendoRN </td>
<td>

Replace `withPendoRN` with `WithPendoReactNavigation`:

<b>2.x:</b>

```javascript
// in the file where the NavigationContainer is created
import {withPendoRN} from 'rn-pendo-sdk'    

// wrap NavigationContainer with WithPendoReactNavigation HOC
const PendoNavigationContainer = withPendoRN(NavigationContainer);    

// replace NavigationContainer tag with PendoNavigationContainer tag
<PendoNavigationContainer>

{/* The rest of your app code */}

</PendoNavigationContainer>
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

Replace `PendoSDK.initSDK` by calling `PendoSDK.setup` and then `PendoSDK.startSession`:

<b>2.x:</b>

```javascript
// set session parameters
const pendoParams = {'visitorId': 'someVisitorID',
                     'accountId': 'someAccountID',
                     'vistiorData':  {'age': '25', 'country': 'USA'},
                     'accountData':  {'tier': '1', 'size': 'Enterprise'}};
                     
const navigationOptions = {library: NavigationLibraryType.ReactNavigation};

// establish connection to server and start a session
PendoSDK.initSdk('someAppKey', 
                  pendoParams, 
                  navigationOptions);
```

<b>3.x:</b>

```javascript
// establish connection to server
const navigationOptions = {library: NavigationLibraryType.ReactNavigation};
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

Call `PendoSDK.setup` instead of `PendoSDK.initSDKWithoutVisitor`:

<b>2.x:</b>

```javascript
// establish connection to server
const navigationOptions = {library: NavigationLibraryType.ReactNavigation};
PendoSDK.initSDKWithoutVisitor('someAppKey', navigationOptions);
```

<b>3.x:</b>

```javascript
// establish connection to server
const navigationOptions = {library: NavigationLibraryType.ReactNavigation};
PendoSDK.setup('someAppKey', navigationOptions);
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>clearVisitor </td>
<td>

Call `PendoSDK.startSession` with `null` values instead of `PendoSDK.clearVisitor`: 

<b>2.x:</b>

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

Call `PendoSDK.startSession` instead of `PendoSDK.switchVisitor`:

<b>2.x:</b>

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

Call `PendoSDK.startSession` with the new account id value instead of `PendoSDK.setAccountId`:

<b>2.x:</b>

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