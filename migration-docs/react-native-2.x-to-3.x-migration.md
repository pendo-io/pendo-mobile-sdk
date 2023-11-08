# React Native Migration From 2.x to 3.x


The following deprecated APIs have been removed. Follow these instructions to replace them:

<table border =2>

<tr>
<td> </td>
<td><b> 2.x</b></td>
<td><b>3.x</b></td>
</tr>

<!--- new row --->

<tr>
<td align=center> withPendoRN </td>
<td>

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

</td>
<td>

Replace `withPendoRN` with `WithPendoReactNavigation`:

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
<td align=center> initSDK </td>
<td>

```javascript
// set session paramaters
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

</td>
<td>

Replace `PendoSDK.initSDK` by calling `PendoSDK.setup` and then `PendoSDK.startSession`:

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
<td align=center> initSDKWithoutVisitor </td>
<td>

```javascript
// establish connection to server
const navigationOptions = {library: NavigationLibraryType.ReactNavigation};
PendoSDK.initSDKWithoutVisitor('someAppKey', navigationOptions);
```

</td>
<td>

Call `PendoSDK.setup` instead of `PendoSDK.initSDKWithoutVisitor`:

```javascript
// establish connection to server
const navigationOptions = {library: NavigationLibraryType.ReactNavigation};
PendoSDK.setup('someAppKey', navigationOptions);
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center> clearVisitor </td>
<td>

```javascript
// start a session with an anonymous visitor
PendoSDK.clearVisitor()
```

</td>
<td>

Call `PendoSDK.startSession` with `null` values instead of `PendoSDK.clearVisitor`: 

```javascript
// start a session with an anonymous visitor
PendoSDK.startSession(null, null, null, null);
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center> switchVisitor </td>
<td>

```javascript
PendoSDK.switchVisitor('someVisitorID', 
            'someAccountID', 
            {'age': '25', 'country': 'USA'}, 
            {'tier': '1', 'size': 'Enterprise'});
```

</td>
<td>

Call `PendoSDK.startSession` instead of `PendoSDK.switchVisitor`:

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
<td align=center> setAccountId </td>
<td>

```javascript
PendoSDK.setAccountId('someAccountID');
```

</td>
<td>

Call `PendoSDK.startSession` with the new account id value instead of `PendoSDK.setAccountId`:

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