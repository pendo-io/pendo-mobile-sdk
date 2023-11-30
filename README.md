# Pendo Mobile SDK

The Pendo Mobile SDK is a codeless library that collects analytics retroactively across all versions of your app. The SDK also provides the ability to display in-app messages, tooltips and multi-step walkthrough guides built using Pendo's Visual Design Studio. The SDK starts collecting analytics as soon as it is integrated. The integration requires minimal effort with a few lines of code.


## Integration instructions 

>[!NOTE]
>The following integration instructions are relevant for SDK 3.0 or higher. <br> Follow our migration instructions to [upgrade from SDK 2.x to 3.0](/migration-docs/README.md) or refer to our [2.x integration instruction](https://github.com/pendo-io/pendo-mobile-sdk/blob/2.22.5/README.md).


- Native: 
[Android](/android/pnddocs/native-android.md) | 
[iOS](/ios/pnddocs/native-ios.md)
- React Native:
    - Using React Navigation:
    [Android](/android/pnddocs/rn-android.md) | 
    [iOS](/ios/pnddocs/rn-ios.md)
    - Using React Native Navigation: 
    [Android](/android/pnddocs/rnn-android.md) | 
    [iOS](/ios/pnddocs/rnn-ios.md)
    - Using Expo with React Navigation:
    [Android](/android/pnddocs/expo_rn-android.md) | 
    [iOS](/ios/pnddocs/expo_rn-ios.md)
    - Using Expo with React Native Navigation 
    [Android](/android/pnddocs/expo_rnn-android.md) | 
    [iOS](/ios/pnddocs/expo_rnn-ios.md)
- Xamarin Forms: 
[Android](/android/pnddocs/xamarin_forms-android.md) | 
[iOS](/ios/pnddocs/xamarin_forms-ios.md)
- MAUI: 
[Android](/android/pnddocs/xamarin_maui-android.md) | 
[iOS](/ios/pnddocs/xamarin_maui-ios.md)
- Flutter: 
[Android](/android/pnddocs/flutter-android.md) | 
[iOS](/ios/pnddocs/flutter-ios.md)


## API documentation

- [Native Android](/api-documentation/native-android-apis.md)
- [Native iOS](/api-documentation/native-ios-apis.md)
- [React Native](/api-documentation/rn-apis.md)
- [Xamarin Forms](/api-documentation/xamarin-forms-apis.md)
- [MAUI](/api-documentation/xamarin-maui-apis.md)
- [Flutter](/api-documentation/flutter-apis.md)


## Additional resources 

- [Supported Mobile Frameworks and OS Versions](https://support.pendo.io/hc/en-us/articles/360031861572-Supported-mobile-frameworks-and-OS-versions)
- [Configuring CNAME Hostnames](https://support.pendo.io/hc/en-us/articles/360047607631-Configure-CNAME-for-Pendo-Mobile)
- [Integration using JWT Sessions with Signed Meta Data](https://support.pendo.io/hc/en-us/articles/4427183644827-Mobile-installation-using-signed-metadata-with-JSON-web-token)

Visit the [Mobile Resource Center](https://support.pendo.io/hc/en-us/categories/4403654621851-Mobile) For additional documentation,. 


## Performance benchmarks

<b>App Size</b>
- Android - the SDK increases the size of your production app (on Google play) by roughly 3MB.
- iOS - the SDK increases the size of your production app (on App Store) by roughly 2.3MB.

<b>Payload Size</b>
- A typical Pendo session payload, including calling the `setup` API and the `startSession` API, and downloading three guides, consumes approximately ~118KB of data for Android or ~80KB of data for iOS. All guides are available after approximately 3 seconds.
- Network requests are executed in parallel, prioritizing guides with higher priority to be downloaded first and becoming available earlier during the initialization process of the session.


## Troubleshooting
- For technical issues, [review open issues](https://github.com/pendo-io/pendo-mobile-sdk/issues) or [submit a new issue](https://github.com/pendo-io/pendo-mobile-sdk/issues).
- Release notes can be found [here](https://developers.pendo.io/category/mobile-sdk/).
- For Dex issues with Android applications, refer to this [resource](https://developer.android.com/studio/build/multidex).
- For additional documentation, visit the Mobile section in our [Help Center](https://support.pendo.io/hc/en-us/categories/4403654621851-Mobile).
