# Expo iOS using React Navigation

>[!IMPORTANT]
>- **Expo SDK** 41-52 using React Navigation 5+ is supported by our codeless solution.
>- **Expo Go** is not supported. Pendo SDK has a native plugin that is not part of the Expo Go app.
Pendo can *only* be used in development builds. For more about development builds read [adding custom native code with development builds](https://docs.expo.dev/workflow/customizing/).
>- Beta support for React Native's New Architecture (Fabric) is available starting from version 3.6.1.

>[!IMPORTANT]
>Requirements:
>- Deployment target of `iOS 11` or higher 
>- Swift Compatibility `5.7` or higher
>- Xcode `14` or higher

## Step 1. Add Pendo dependency

In the **root folder of your expo app**, add Pendo using one of your package managers: 

```shell
#example with npx expo
npx expo install rn-pendo-sdk

#example with npm
npm install --save rn-pendo-sdk

#example with yarn
yarn add rn-pendo-sdk
```

## Step 2. Project setup

>[!NOTE]
>Find your scheme ID in the Pendo UI under `Settings` > `Subscription settings` > select an app > `App Details`.

In the `app.config.js` or `app.json`, add the following:
```json
{
  "plugins": [
    [
      "rn-pendo-sdk",
      {
        "ios-scheme": "YOUR_IOS_SCHEME_ID",
        "android-scheme": "YOUR_ANDROID_SCHEME_ID"
      }
    ]
  ]
}
```
This configuration enables Pendo to enter pair mode to tag pages and features.

## Step 3. Production bundle - modify Javascript minification
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
## Step 4.Integration

>[!NOTE]
>Find your API key in the Pendo UI under `Settings` > `Subscription settings` > select an app > `App Details`.

In the application main file (App.js/.ts/.tsx), add the following code:

```typescript
import {PendoSDK, NavigationLibraryType} from "rn-pendo-sdk";

function initPendo() {
    const navigationOptions = {'library': NavigationLibraryType.ReactNavigation};
    const key = 'YOUR_API_KEY_HERE';
    //note the following API will only setup initial configuration, to start collect analytics use start session
    PendoSDK.setup(key, navigationOptions);
}

initPendo();
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

Replace `NavigationContainer` tag with `PendoNavigationContainer` tag:

```typescript
<PendoNavigationContainer>
{/* Rest of your app code */}
</PendoNavigationContainer>
```
Initialize Pendo Session where your visitor is being identified (e.g., login, register, etc.).
```typescript
const visitorId = 'John Smith';
const accountId = 'Acme Inc.';
const visitorData = {'Age': 25, 'Country': 'USA'};
const accountData = {'Tier': 1, 'Size': 'Enterprise'};

PendoSDK.startSession(visitorId, accountId, visitorData, accountData);
```

>[!TIP]
>To begin a session for an  <a href="https://support.pendo.io/hc/en-us/articles/360032202751" target="_blank">anonymous visitor</a>, pass ```null``` or an empty string ```''``` as the Visitor ID. You can call the `startSession` API more than once and transition from an anonymous session to an identified session (or even switch between multiple identified sessions). 

If some of your own _custom_ react native components are not taggable because we can't detect it in the regular detection flow,
you can try to add it manually to the scanning flow. To do this, add a prop `nativeID` to your component.
For instance:
```typescript
<TouchableOpacity onPress={open} nativeID={"myProp"}>      
</TouchableOpacity> 
```
and change your integration to the following:
```typescript
const PendoNavigationContainer = WithPendoReactNavigation(NavigationContainer,{nativeIDs:["myProp"]});
```
## Step 5. Running the project
To run the project with Pendo integration, you should be able to generate iOS and Android projects.
You can generate them by running `npx expo prebuild`, or `npx expo run:[ios|android]` (which will run prebuild automatically). You can also use development builds in this context - the easiest way to do this is to run `npx expo install expo-dev-client` prior to prebuild or run, and it's also possible to add the library at any later time (additional information can be found here: [Adding custom native code](https://docs.expo.dev/workflow/customizing/#generate-native-projects-with-prebuild)).

## Step 6. Verify installation

1. In the Pendo UI, go to Settings>Subscription Settings.
2. Select the **Applications** tab and then your application.
3. Select the **Install Settings** tab and follow the instructions under Verify Your Installation to ensure you have successfully integrated the Pendo SDK.
4. Confirm that you can see your app as Integrated under <a href="https://app.pendo.io/admin" target="_blank">subscription settings</a>.


## Limitations
For the codeless solution to work, all the elements *MUST be wrapped in react-native ui components*.<br>
As with other analytics tools, we are dependent on react-navigation [screen change callbacks](https://reactnavigation.org/docs/screen-tracking/)
which means that codeless tracking analytics is available for screen components only.

## Developer documentation

- API documentation available [here](/api-documentation/rn-apis.md).

## Troubleshooting

- For technical issues, please [review open issues](https://github.com/pendo-io/pendo-mobile-sdk/issues) or [submit a new issue](https://github.com/pendo-io/pendo-mobile-sdk/issues).
- See our [release notes](https://developers.pendo.io/category/mobile-sdk/).
- For additional documentation, visit our [Help Center](https://support.pendo.io/hc/en-us/categories/23324531103771-Mobile-implementation).
