# Expo using React Navigation

### 1. Add Pendo dependency
### Requirements:
We support a codeless solution for Expo Sdk 41-48 using react-navigation 5+.<br>
Note that for the codeless solution to work, all the elements *MUST be wrapped in react-native ui components*.<br>
As with other analytics tools, we are dependent on react-navigation [screen change callbacks](https://reactnavigation.org/docs/screen-tracking/)
which means that codeless tracking analytics is available for screen components only.


In the root folder of your expo app, run the following:

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

**Both Scheme ID and API Key can be found in your Pendo Subscription under App Details**

In the `app.config.js` or `app.json`, add the following:
```
"plugins": [
      [
        "rn-pendo-sdk",
        {
          "ios-scheme": "YOUR_IOS_SCHEME_ID",
          "android-scheme": "YOUR_ANDROID_SCHEME_ID"
        }
      ]
    ]
```
This configuration allows Pendo to enter pair mode to tag pages and features.

### 3. Production Bundle - Modify Javascript Obfuscation
In the `metro.config.js` file, add the following:
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
    const key = 'YOUR_API_KEY_HERE';
    //note the following API will only setup initial configuration, to start collect analytics use start session
    PendoSDK.setup(key, navigationOptions);
}
```

In the file where the `NavigationContainer` is created:
import `WithPendoReactNavigation`:

```typescript
    import {WithPendoReactNavigation} from 'rn-pendo-sdk'    
```

Wrap `NavigationContainer` with  `WithPendoReactNavigation` HOC:

```typescript
    const PendoNavigationContainer = WithPendoReactNavigation(NavigationContainer);    
```

replace `NavigationContainer` tag with `PendoNavigationContainer` tag:

```typescript jsx
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
If some of your own _custom_ react native components are not taggable because we can't detect it in the regular detection flow,
you can try to add it manually to the scanning flow. To do this, add a prop `nativeID` to your component.
For instance:
```typescript jsx
    <TouchableOpacity onPress={open} nativeID={"myProp"}>      
    </TouchableOpacity> 
```
and change your integration to the following:
```typescript
const PendoNavigationContainer = WithPendoReactNavigation(NavigationContainer,{nativeIDs:["myProp"]});
```
### 5. Running the project
To run the project with Pendo integration, you should be able to generate iOS and Android projects.
You can generate them by running `npx expo prebuild`, or `npx expo run:[ios|android]` (which will run prebuild automatically). You can also use development builds in this context - the easiest way to do this is to run `npx expo install expo-dev-client` prior to prebuild or run, and it's also possible to add the library at any later time (Additional information can be found here: [Adding custom native code](https://docs.expo.dev/workflow/customizing/#generate-native-projects-with-prebuild) )

### 6. Verify Installation

1. In the Pendo UI, go to Settings>Subscription Settings.
2. Hover over your app and select View app details.
3. Select the **Install Settings** tab and follow the instructions under Verify Your Installation to ensure you have successfully integrated the Pendo SDK.
4. Confirm that you can see your app as Integrated under <a href="https://app.pendo.io/admin" target="_blank">subscription settings</a>.

## Limitations
Note that **Expo Go** is not supported by Pendo because Pendo SDK has a native plugin that is not part of the Expo Go app.
Pendo can be used in development builds *only*.
You can read more about development builds [Adding custom native code with development builds](https://docs.expo.dev/workflow/customizing/)

## Pivots
Pay attention to the following APIs, ``` setup ``` and ```startSession```; the former *must* be called once per session and it creates the initial setup for the SDK, the latter should be called when you have the visitor you would like to assign the analytics/guides to. If you want an anonymous visitor, pass ```nil``` to the ```startSession``` and call it again as soon as you have the visitor.  

## Developer Documentation

* API documentation available [here](TODO:missing-link)

## Troubleshooting

- For technical issues please [review open issues](https://github.com/pendo-io/pendo-mobile-sdk/issues) or [submit a new issue](https://github.com/pendo-io/pendo-mobile-sdk/issues).
- Release notes can be found [here](https://developers.pendo.io/category/mobile-sdk/).
- For Dex issues with Android applications refer to this [resource](https://developer.android.com/studio/build/multidex).
- For additional documentation visit our [Help Center Mobile Section](https://support.pendo.io/hc/en-us/categories/4403654621851-Mobile).