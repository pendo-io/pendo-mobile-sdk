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
    - Using Expo with Expo Router:
    [Android](/android/pnddocs/expo_router-android.md) |
    [iOS](/ios/pnddocs/expo_router-ios.md)
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
[iOS](/ios/pnddocs/flutter-ios.md) |
[Native with Flutter components](/other/native-with-flutter-components.md)

For integration using signed metadata see: [JWT integration instructions](https://support.pendo.io/hc/en-us/articles/360039616892-Send-signed-metadata-with-JWT)


## API documentation

- [Native Android](/api-documentation/native-android-apis.md)
- [Native iOS](/api-documentation/native-ios-apis.md)
- [React Native](/api-documentation/rn-apis.md)
- [Xamarin Forms](/api-documentation/xamarin-forms-apis.md)
- [MAUI](/api-documentation/xamarin-maui-apis.md)
- [Flutter](/api-documentation/flutter-apis.md)


## Additional resources 

- [Release notes](https://developers.pendo.io/category/mobile-sdk/)
- [Plan your mobile implementation](https://support.pendo.io/hc/en-us/articles/23527373013275-Plan-your-mobile-implementation)
- [Supported Mobile Frameworks and OS Versions](https://support.pendo.io/hc/en-us/articles/360031861572-Supported-mobile-frameworks-and-OS-versions)
- [Codeless tracking vs Track Events](https://support.pendo.io/hc/en-us/articles/360061487572-Codeless-tracking-vs-Track-Events)
- [Using Pendo with hybrid apps](https://support.pendo.io/hc/en-us/articles/23804736263195-Use-Pendo-with-hybrid-apps)
- [Configuring CNAME Hostnames](https://support.pendo.io/hc/en-us/articles/360047607631-Configure-CNAME-for-Pendo-Mobile)
- [Work with dynamic content in your mobile app](https://support.pendo.io/hc/en-us/articles/24836902488219-Work-with-dynamic-content-in-your-mobile-app)

Visit the [Mobile Resource Center](https://support.pendo.io/hc/en-us/categories/23324531103771-Mobile-implementation) For additional documentation.

## Troubleshooting

- For technical issues, [review open issues](https://github.com/pendo-io/pendo-mobile-sdk/issues) or [submit a new issue](https://github.com/pendo-io/pendo-mobile-sdk/issues).

## Performance benchmarks

These measurements of the SDK are captured using Pendo’s testing applications and may differ among applications, depending on their screen complexity and user interaction.

### SDK performance

|                | Size Impact\*  |  Battery Impact  | Memory Impact |  CPU Impact\*\* |
|     :---:      |     :---:     |       :---:       |     :---:     |     :---:       |   
|    Android     |    +2.7MB     |        Low        |   (~) +27MB   |      Low        |
|      iOS       |    +5.7MB     |        Low        |    (~) +4MB   |      Low        |

<b>\*</b> Size impact regarding the release builds, available through Google Play or App Store.
<br>
<b>\*\*</b> Slight CPU impact may occur during app launch or UI-intensive operations.

### SDK network usage

The Pendo SDK network traffic consists of two parts:
* The SDK initialization process to establish a connection between the device and Pendo’s server, starting a session and fetching any guides relevant to the session.
* During the session, ongoing analytics are sent in bulk from the device. 

**Incoming traffic** (during the session startup)

|    No guides   | A single guide with three steps | A single guide with nine steps |
|     :---:      |              :---:              |              :---:             |
|   Up to 40KB   |            Up to 64KB           |           Up to 90KB           |

Network requests are executed in parallel, prioritizing guides with higher priority to be downloaded first and becoming available earlier during the initialization process of the session. For example, guides with an app launch trigger will be available immediately, while lower-priority guides may take a few additional seconds to be available during the session.

**Outgoing traffic**

The analytics captured by the SDK include starting a session, the application state (foreground and background), screen changing, clicks, guide events, and manual track events. The size of each analytic event varies from 1KB to 6.5KB.

**Network usage example**

A session with a single guide including four steps, 6 session analytics, 42 page transitions, 65 feature clicks, 13 guide events
and 3 track events, recorded ~120KB of data received and ~320KB of data transmitted.

