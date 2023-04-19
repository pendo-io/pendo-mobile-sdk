## Expo iOS using React Native Navigation

### 1. Adding Pendo dependency
### Requirements: 
We support codeless solution for EXPO Sdk 41+ and React Native Navigation 6+<br>
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
### 4. Integration
In the application main file (App.js/.ts/.tsx), add the following code:
```javascript
Navigation.events().registerAppLaunchedListener(() => {
    const navigationOptions = {library: NavigationLibraryType.ReactNativeNavigation, navigation: Navigation};
    const pendoKey = 'YOUR_KEY';
    PendoSDK.setup(pendoKey, navigationOptions);
});
```
Initialize Pendo Session where your visitor is being identified (e.g. login, register, etc.).
```javascript
const visitorId = 'John Smith';
const accountId = 'Acme Inc.';
const visitorData = {'Age': 25, 'Country': 'USA'};
const accountData = {'Tier': 1, 'Size': 'Enterprise'};

PendoSDK.startSession(visitorId, accountId, visitorData, accountData);
```

### 5. Running the project
To run the project with Pendo integration you should be able to generate iOS and Android projects.
You can generate them by running `npx expo prebuild`, or `npx expo run:[ios|android]` (which will run prebuild automatically). You can also use development builds in this context - the easiest way to do this is to run `npx expo install expo-dev-client` prior to prebuild or run, and it's also possible to add the library at any later time (Additional information can be found here: [Adding custom native code](https://docs.expo.dev/workflow/customizing/#generate-native-projects-with-prebuild) )

## Limitations 
Please note **Expo Go** is not supported by Pendo because Pendo SDK has a native plugin which is not part of the Expo Go app.
Pendo can be used in development builds **only**. 
You can read more about development builds [Adding custom native code with development builds](https://docs.expo.dev/workflow/customizing/)

## Pivots
Please pay attention to the following APIs ``` setup ``` and ```startSession``` the former *must* be called once per session and will create initial setup for the SDK, the later should be called whenever you have the visitor you would like to assign the analytics/guides to. In case you would like to have an anonymous visitor pass ```nil``` to the ```startSession``` and call it again as soon as you have the visitor.  

## Limitations
* To support hybrid mode with React Native Navigation please open a ticket
