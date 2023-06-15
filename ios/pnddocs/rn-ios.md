## React Native using React Navigation

### Step 1. Install Pendo SDK

#### Pendo now supports Expo SDK 41-48. Follow <a href="expo_rn.md">Expo Integration</a> instruction.

1. #### In the **application folder**, run the following command:

    Using NPM:

```shell
    npm install --save rn-pendo-sdk
```
    Using YARN:

```shell
    yarn add rn-pendo-sdk
```

2. #### In the **iOS folder**, run the following command:

```shell script 
    pod install
```

3. #### Modify Javascript Obfuscation

    When bundling for production, React Native minifies class and function names to reduce the size of the bundle.  
    This means there is no access to the original component names that are used for the codeless solution.

    In the application **metro.config.js**, add the following statements in the transformer:  

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

-------------

### Step 2. Pendo SDK Integration

1. In the application **main file (App.js/.ts/.tsx)**, add the following code:  

```typescript
    import { PendoSDK, NavigationLibraryType } from 'rn-pendo-sdk';

    function initPendo() {
        const navigationOptions = {library: NavigationLibraryType.ReactNavigation};
        const pendoKey = 'YOUR_APPKEY_HERE';
        //note the following API will only setup initial configuration, to start collect analytics use startSession
        PendoSDK.setup(pendoKey, navigationOptions);
    }   
    initPendo();
```
2. Initialize Pendo where your visitor is being identified (e.g. login, register, etc.).

```typescript
    const visitorId = 'VISITOR-UNIQUE-ID';
    const accountId = 'ACCOUNT-UNIQUE-ID';
    const visitorData = {'Age': '25', 'Country': 'USA'};
    const accountData = {'Tier': '1', 'Size': 'Enterprise'};

    PendoSDK.startSession(visitorId, accountId, visitorData, accountData);
```

3. In the file where the `NavigationContainer` is created.

   Import `WithPendoReactNavigation`:

```typescript
    import {WithPendoReactNavigation} from 'rn-pendo-sdk'    
```

   Wrap `NavigationContainer` with  `WithPendoReactNavigation` HOC

```typescript
    const PendoNavigationContainer = WithPendoReactNavigation (NavigationContainer);    
```

   replace `NavigationContainer` tag with `PendoNavigationContainer` tag

```typescript jsx
   <PendoNavigationContainer>
   {/* Rest of your app code */}
   </PendoNavigationContainer>
```


**Notes**  

**visitorId**: a user identifier (e.g. John Smith)  
**visitorData**: the user metadata (e.g. email, phone, country, etc.)  
**accountId**: an affiliation of the user to a specific company or group (e.g. Acme inc.)  
**accountData**: the account metadata (e.g. tier, level, ARR, etc.)  

Passing `null` or `""` to the visitorId or not setting the `initParams.visitorId` will generate an <a href="https://help.pendo.io/resources/support-library/analytics/anonymous-visitors.html" target="_blank">anonymous visitor id</a>.

-------------

### Step 3. Mobile device connectivity for tagging and testing
These steps allow <a href="https://support.pendo.io/hc/en-us/articles/360033609651-Tagging-Mobile-Pages#HowtoTagaPage" target="_blank">page tagging</a>
and <a href="https://support.pendo.io/hc/en-us/articles/360033487792-Creating-a-Mobile-Guide#test-guide-on-device-0-6" target="_blank">guide testing</a> capabilities.

1. #### Add Pendo URL Scheme to **info.plist** file:
  
      Under App Target > Info > URL Types, create a new URL by clicking the + button.  
      Set **Identifier** to pendo-pairing or any name of your choosing.  
      Set **URL Scheme** to `YOUR_SCHEME_HERE`.

<img src="https://user-images.githubusercontent.com/56674958/144723345-15c54098-28db-414c-90da-ef4a5256ae6a.png" width="500" height="300" alt="Mobile Tagging"/>

2. #### In AppDelegate file add or modify the function **application:openURL:options**:
```objective-c
   #import <Pendo/Pendo.h>
```

```objective-c
   - (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
         if ([[url scheme] containsString:@"pendo"]) {
            [[PendoManager sharedManager] initWithUrl:url];
            return YES;
         }
         //  your code here ...
         return YES;
   }
```

-------------

### Step 4. Verify Installation

* Test using Xcode:  
Run the app while attached to Xcode.  
Review the device log and look for the following message:  
`Pendo Mobile SDK was successfully integrated and connected to the server.`
* Click to go through a <a href="#" data-start-verification>verification process</a> for the SDK integration.
* Test using the Pendo UI:  
Confirm that you can see your app as Integrated under <a href="https://app.pendo.io/admin" target="_blank">subscription settings</a>.

-------------

### Developer Documentation

* API documentation available <a href="https://support.pendo.io/hc/en-us/articles/360057646611-React-Native-Developer-API-Documentation-iOS-Android-" target="_blank">here</a>
* Sample app with Pendo SDK integrated available <a href="https://github.com/pendo-io/RN-demo-app-React-Navigation" target="_blank">here</a>
-------------

### Troubleshooting

* Review the <a href="https://developers.pendo.io/category/mobile-sdk/" target="_blank">iOS release notes</a> for any backward compatibility issues
* Additional support can be found <a href="https://github.com/pendo-io/pendo-mobile-sdk/ios" target="_blank">here</a>
