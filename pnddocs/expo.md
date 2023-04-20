## Expo iOS using React Navigation

### 1. Adding Pendo dependency
### Requirements:
We support codeless solution for react-native 0.6+ ,react-navigation 5+ and EXPO Sdk 41+<br>
Please note in order for the codeless solution to work all the elements *MUST be wrapped in react-native ui components*<br>
As any other analytics tool we are dependent on react-navigation [screen change callbacks](https://reactnavigation.org/docs/screen-tracking/)
Which means that codeless tracking analytics is available for screen components only


In the root folder of your expo app run the following:

```
npx expo install rn-pendo-sdk
```
OR use one of your package managers
```
npm i rn-pendo-sdk  
```

or

```
yarn add rn-pendo-sdk
```
### 2. Project Setup
In the `app.json` please add the following
```
"plugins": [
      [
        "rn-pendo-sdk",
        {
          "ios-scheme": "YOUR_IOS_URL_SCHEME",
          "android-scheme": "YOUR_ANDROID_URL_SCHEME"
        }
      ]
    ]
```
This configuration allows pendo to enter pair mode in order to tag pages and features

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
import {PendoSDK, NavigationLibraryType} from "rn-pendo-sdk";

function initPendo() {
    const navigationOptions = { 'library': NavigationLibraryType.ReactNavigation };
    const key = 'YOUR_KEY';
    //note the following API will only setup initial configuration, to start collect analytics use start session
    PendoSDK.setup(key, navigationOptions);
}
```

In the file where the `NavigationContainer` is created.
Import `WithPendoReactNavigation`:

```typescript
    import {WithPendoReactNavigation} from 'rn-pendo-sdk'    
```

Wrap `NavigationContainer` with  `WithPendoReactNavigation` HOC

```typescript
    const PendoNavigationContainer = WithPendoReactNavigation(NavigationContainer);    
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
### 5. Running the project
To run the project with Pendo integration you should be able to generate iOS and Android projects.
You can generate them by running `npx expo prebuild`, or `npx expo run:[ios|android]` (which will run prebuild automatically). You can also use development builds in this context - the easiest way to do this is to run `npx expo install expo-dev-client` prior to prebuild or run, and it's also possible to add the library at any later time (Additional information can be found here: [Adding custom native code](https://docs.expo.dev/workflow/customizing/#generate-native-projects-with-prebuild) )

## Limitations
Please note **Expo Go** is not supported by Pendo because Pendo SDK has a native plugin which is not part of the Expo Go app.
Pendo can be used in development builds *only*.
You can read more about development builds [Adding custom native code with development builds](https://docs.expo.dev/workflow/customizing/)

## Pivots
Please pay attention to the following APIs ``` setup ``` and ```startSession``` the former *must* be called once per session and will create initial setup for the SDK, the later should be called whenever you have the visitor you would like to assign the analytics/guides to. In case you would like to have an anonymous visitor pass ```nil``` to the ```startSession``` and call it again as soon as you have the visitor.  
