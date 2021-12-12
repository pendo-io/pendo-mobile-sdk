
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

const initParams = {
  visitorId: 'visitor1',
  accountId: 'account1',
};
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
As soon as you have the user to which you want to relate your guides and analytics please call:
```PendoSDK.startSession("visitor1","acoount1", null, null);```

## Pivots
Please pay attention to the follwowing api's ``` setup ``` and ```startSession``` the former *must* be called once per session and will create initial setup for the SDK, the later should be called whenever you have the visitor you would like to assign the analytics/guides to. In case you would like to have an anonymous visitor pass ```nil``` to the ```statSession``` and call it again as son as you have the vistor. 

## Limitations
* To support hybrid mode in React native pelase open a ticket
* We dont currently support M1 by default please use official react native [suggetsion](https://github.com/facebook/react-native/issues/31941)

