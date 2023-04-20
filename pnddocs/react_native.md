## React Native iOS using React Navigation

### 1. Adding Pendo dependency
#### Requirements: 
We support codeless solution for _react-native 0.6 and above and react-navigation 5 and above_
Please note in order for the codeless solution to work all the elements *MUST be wrapped in react-native ui components*<br>
As any other analytics tool we are dependent on react-navigation [screen change callbacks](https://reactnavigation.org/docs/screen-tracking/)
Which means that codeless tracking analytics is available for screen components only


In the root folder of your react app run the following:
```
npm i rn-pendo-sdk  
```

or 

```
yarn add rn-pendo-sdk
```
after that `cd ios` and run:
`pod install `

### 2. Project Setup
In the `AppDelegate.m` add the following:
```objectivec
@import Pendo;
//your code
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([[url scheme] containsString:@"pendo"]) {
        [[PendoManager sharedManager] initWithUrl:url];
        return YES;
    }
    //  your code here ...
    return YES;
}
```
To setup the Pendo pairing mode (tagging and test on device) select your project, navigate to the relevant target, select the info tab and create a URL Type using the Pendo url scheme (found in your subscription under the App Details tab)

<img src="https://user-images.githubusercontent.com/56674958/144723345-15c54098-28db-414c-90da-ef4a5256ae6a.png" width="500" height="300">

### 3. Production Bundle - Modify Javascript Obfuscation
In the `metro.config.js` file add the following:
```javascript
module.exports = {
  transformer: {
    // ...
    minifierConfig: {
        keep_classnames: true, // Preserve class names
        keep_fnames: true, // Preserve function names
        mangle: {
          keep_classnames: true, // Preserve class names
          keep_fnames: true, // Preserve function names
        }
    }
  }
}
```
### 4.Integration

In the application **main file (App.js/.ts/.tsx)**, add the following code:
```typescript
import {PendoSDK, NavigationLibraryType} from "rn-pendo-sdk";
function initPendo (){
    const navigationOptions = { 'library': NavigationLibraryType.ReactNavigation };
    const key = 'YOUR_KEY';
    //note the following API will only setup initial configuration, to start collect analytics use start session
    PendoSDK.setup(key,navigationOptions);
}
initPendo();

```
In the file where the `NavigationContainer` is created.
    Import `WithPendoReactNavigation`:

```typescript
    import {WithPendoReactNavigation} from 'rn-pendo-sdk'    
```
   
Wrap `NavigationContainer` with  `WithPendoReactNavigation` HOC

```typescript
    const PendoNavigationContainer = WithPendoReactNavigation (NavigationContainer);    
```
    
replace `NavigationContainer` tag with `PendoNavigationContainer` tag
   
```typescript
   <PendoNavigationContainer>
   {/* Rest of your app code */}
   </PendoNavigationContainer>
```

Initialize Pendo Session where your visitor is being identified (e.g. login, register, etc.).
```typescript
const visitorId = 'John Smith';
const accountId = 'Acme Inc.';
const visitorData = {'Age': 25, 'Country': 'USA'};
const accountData = {'Tier': 1, 'Size': 'Enterprise'};

PendoSDK.startSession(visitorId, accountId, visitorData, accountData);
```
If some of your own _custom_ react native components are not taggable as we cant detect it in normal detection flow,
you can try to add it manually to the scanning flow. In order to do it add a prop `nativeID` to your component.
For instance:
```typescript
<TouchableOpacity onPress={open} nativeID={"myProp"}>      
</TouchableOpacity> 
```
and change your integration to the following:
```typescript
const PendoNavigationContainer = WithPendoReactNavigation(NavigationContainer,{nativeIDs:["myProp"]});
```
Sample app with Pendo integration can be found here:
[PendoReactNativeIntegration](https://github.com/pendo-io/PendoReactNativeIntegration)


## Pivots
Please pay attention to the following APIs ``` setup ``` and ```startSession``` the former *must* be called once per session and will create initial setup for the SDK, the later should be called whenever you have the visitor you would like to assign the analytics/guides to. In case you would like to have an anonymous visitor pass ```nil``` to the ```startSession``` and call it again as soon as you have the visitor.  

## Limitations
* To support hybrid mode in React native please open a ticket


