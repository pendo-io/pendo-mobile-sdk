# Expo using React Native Navigation

>[!IMPORTANT]
>- **Expo SDK** 41-48 using React Native Navigation 6+ is supported by our codeless solution.<br>
>- **Expo Router** is supported by our track events only solution. We have plans to develop codeless support in the future.
>- **Expo Go** is not supported. Pendo SDK has a native plugin that is not part of the Expo Go app.
Pendo can *only* be used in development builds. For more about development builds read [adding custom native code with development builds](https://docs.expo.dev/workflow/customizing/).

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
>The `Scheme ID` can be found in your Pendo Subscription Settings under the App Details section.

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
This configuration allows pendo to enter pair mode to tag pages and features. 

## Step 3. Production bundle - modify Javascript obfuscation

In the `metro.config.js` file, add the following:
```typescript
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
## Step 4. Integration

>[!NOTE]
>The `API Key` can be found in your Pendo Subscription Settings under the App Details Section.

In the application main file (App.js/.ts/.tsx), add the following code:
```typescript
function initPendo() {
    const navigationOptions = {library: NavigationLibraryType.ReactNativeNavigation, navigation: Navigation};
    const pendoKey = 'YOUR_API_KEY_HERE';
    //note the following API will only setup initial configuration, to start collect analytics use start session
    PendoSDK.setup(pendoKey, navigationOptions);
}
```
Initialize Pendo Session where your visitor is being identified (e.g. login, register, etc.).
```typescript
const visitorId = 'John Smith';
const accountId = 'Acme Inc.';
const visitorData = {'Age': 25, 'Country': 'USA'};
const accountData = {'Tier': 1, 'Size': 'Enterprise'};

PendoSDK.startSession(visitorId, accountId, visitorData, accountData);
```

## Step 5. Running the project

To run the project with Pendo integration, you should be able to generate iOS and Android projects.
You can generate them by running `npx expo prebuild`, or `npx expo run:[ios|android]` (which will run prebuild automatically). You can also use development builds in this context - the easiest way to do this is to run `npx expo install expo-dev-client` prior to prebuild or run, and it's also possible to add the library at a later time (Additional information can be found here: [Adding custom native code](https://docs.expo.dev/workflow/customizing/#generate-native-projects-with-prebuild) )

## Step 6. Verify installation

1. In the Pendo UI, go to Settings>Subscription Settings.
2. Hover over your app and select View app details.
3. Select the **Install Settings** tab and follow the instructions under Verify Your Installation to ensure you have successfully integrated the Pendo SDK.
4. Confirm that you can see your app as Integrated under <a href="https://app.pendo.io/admin" target="_blank">subscription settings</a>.

## Limitations
For the codeless solution to work, all the elements *MUST be wrapped in react-native ui components*.<br>
As with other analytics tools, we are dependent on react-navigation [screen change callbacks](https://reactnavigation.org/docs/screen-tracking/)
which means that codeless tracking analytics is available for screen components only.

## Pivots
Pay attention to the following APIs, ``` setup ``` and ```startSession```; the former *must* be called once per session and it creates an initial setup for the SDK, the latter should be called when you have the visitor you would like to assign the analytics/guides to. If you want an anonymous visitor, pass ```nil``` to the ```startSession``` and call it again as soon as you have the visitor.  

## Limitations
* To support hybrid mode with React Native Navigation, please open a ticket.

## Developer documentation

* API documentation available [here](TODO:missing-link)

## Troubleshooting

- For technical issues please [review open issues](https://github.com/pendo-io/pendo-mobile-sdk/issues) or [submit a new issue](https://github.com/pendo-io/pendo-mobile-sdk/issues).
- Release notes can be found [here](https://developers.pendo.io/category/mobile-sdk/).
- For additional documentation visit our [Help Center Mobile Section](https://support.pendo.io/hc/en-us/categories/4403654621851-Mobile).