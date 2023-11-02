# Pendo Mobile SDK

The Pendo Mobile SDK is a codeless, retroactive analytics collector across all version of your app. The SDK provides the ability to display in-app messages, tooltips and multi-step walkthrough guides built using Pendo's Visual Design Studio.

* The integration requires a few lines of code.

* The SDK starts collecting analytics from the moment the SDK has been integrated.

* The analytics and guides are supported across all versions of your app.


## Integration Instructions 

The following integration insructions are relevant for SDK 3.0 or higher. Follow our migration instructions to [upgrade from SDK 2.x to 3.0](TODO:missing-link) or refer to our [2.x integration instruction](https://github.com/pendo-io/pendo-mobile-sdk/blob/2.22.5/README.md).


- Native: 
[Android](/android-integration/native-android.md) | 
[iOS](/ios-integration/native-ios.md)
- React Native:
    - Using React Navigation:
    [Android](/android-integration/rn-android.md) | 
    [iOS](/ios-integration/rn-ios.md)
    - Using React Native Navigation: 
    [Android](/android-integration/rnn-android.md) | 
    [iOS](/ios-integration/rnn-ios.md)
    - Using Expo with React Navigation:
    [Android](/android-integration/expo_rn-android.md) | 
    [iOS](/ios-integration/expo_rn-ios.md)
    - Using Expo with React Native Navigation 
    [Android](/android-integration/expo_rnn-android.md) | 
    [iOS](/ios-integration/expo_rnn-ios.md)
- Xamarin Forms: 
[Android](/android-integration/xamarin_forms-android.md) | 
[iOS](/ios-integration/xamarin_forms-ios.md)
- MAUI: 
[Android](/android-integration/xamarin_maui-android.md) | 
[iOS](/ios-integration/xamarin_maui-ios.md)
- Flutter: 
[Android](/android-integration/flutter-android.md) | 
[iOS](/ios-integration/flutter-ios.md)


## API Documentation

- [Native Android](TODO:missing-link)
- [Native iOS](TODO:missing-link)
- [React Native](TODO:missing-link)
- [Xamarin Forms](TODO:missing-link)
- [MAUI](TODO:missing-link)
- [Flutter](TODO:missing-link)


## Additional Resources 

- [Supported Mobile Frameworks and OS Versions](https://support.pendo.io/hc/en-us/articles/360031861572-Supported-mobile-frameworks-and-OS-versions)
- [Configuring CNAME Hostnames](https://support.pendo.io/hc/en-us/articles/360047607631-Configure-CNAME-for-Pendo-Mobile)
- [Integraton using JWT Sessions with Signed Meta Data](https://support.pendo.io/hc/en-us/articles/4427183644827-Mobile-installation-using-signed-metadata-with-JSON-web-token)

Visit the [Mobile Resource Center](https://support.pendo.io/hc/en-us/categories/4403654621851-Mobile) for additional documentation 


## Performance Benchmarks

<b>App Size</b>
- For Android The SDK will increase the size of your production app (on Google play) by roughly 3MB
- For iOS the SDK will increase the size of your production app (on App Store) by roughly _2.3MB_

<b>Payload Size</b>
- A typical Pendo session payload, including calling `setup` and `startSession` and downloading 3 guides will consume about _~118KB_ of data for Android or _~80KB_ of data for iOS and can take around 3sec.
- Network requests are executed in parallel, prioritizing guides with higher priority to be downloaded first and becoming available earlier during the initialization process of the session.


## Troubleshooting
- For technical issues please [review open issues](https://github.com/pendo-io/pendo-mobile-sdk/issues) or [submit a new issue](https://github.com/pendo-io/pendo-mobile-sdk/issues).
- Release notes can be found [here](https://developers.pendo.io/category/mobile-sdk/).
- For Dex issues with Android applications refer to this [resource](https://developer.android.com/studio/build/multidex).
- For additional documentation visit our [Help Center Mobile Section](https://support.pendo.io/hc/en-us/categories/4403654621851-Mobile).
