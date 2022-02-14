
## React Native

### 1. Adding Pendo dependency
#### Requirements: 
We support codeless solution for _react-native 0.6 and above and react-navigation 5 and above_
Please note in order for the codeless solution to work all the elements *MUST be wrapped in react-native ui components*<br>
As any other anlytics tool we are dependent on react-navigation [screen change callbacks](https://reactnavigation.org/docs/screen-tracking/)


In the root folder of your react app run the folowing:
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
In order to enable Pendo pairing mode (taging and testing) select your project select the info tab and add Url Type with pendo url scheme 

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

```typescript
import {withPendoRN, PendoSDK, NavigationLibraryType} from "rn-pendo-sdk";
import { useRef } from 'react';

const navigationOptions = { 'library': NavigationLibraryType.ReactNavigation };
const key = 'YOUR_KEY'; 

//note the following API will only setup initial configuartion, to start collect analytics use start session
PendoSDK.setup(key,navigationOptions,null);

//your code 

function YOUR_MAIN_FUNCTION(props) {
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
    }} >
      {MainStackScreen()}
    </NavigationContainer >
  )
};
export default withPendoRN(YOUR_MAIN_FUNCTION);
```
Initialize Pendo Session where your visitor is being identified (e.g. login, register, etc.).
```typescript
const visitorId = 'John Smith';
const accountId = 'Acme Inc.';
const visitorData = {'Age': '25', 'Country': 'USA'};
const accountData = {'Tier': '1', 'Size': 'Enterprise'};

PendoSDK.startSession(visitorId, accountId, visitorData, accountData);
```
If some of your own _custom_ react native components are not taggable as we cant detect it in normal detection flow,
you can try to add it manually to the scaning flow. In order to do it add a prop `nativeID` to your component.
For instance:
```typescript
<TouchableOpacity onPress={open} nativeID={"myProp"}>      
</TouchableOpacity> 
```
and change your integration to the following:
```typescript
export default withPendoRN(YOUR_MAIN_FUNCTION,{nativeIDs:["myProp"]});
```
Sample app with Pendo integration can be found here:
[PendoReactNativeIntegration](https://github.com/pendo-io/PendoReactNativeIntegration)


## Pivots
Please pay attention to the following APIs ``` setup ``` and ```startSession``` the former *must* be called once per session and will create initial setup for the SDK, the later should be called whenever you have the visitor you would like to assign the analytics/guides to. In case you would like to have an anonymous visitor pass ```nil``` to the ```startSession``` and call it again as soon as you have the vistor.  

## Limitations
* To support hybrid mode in React native please open a ticket
* We dont currently support M1 by default please use official react native [suggestion](https://github.com/facebook/react-native/issues/31941)

