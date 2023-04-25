# Pendo Mobile SDK for IOS 


<div align="center">

![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/pendo-io/pendo-mobile-ios?color=brightgreen&label=version&sort=semver)
![Cocoapods](https://img.shields.io/badge/xcframework-compatibale-brightgreen)
![Cocoapods](https://img.shields.io/badge/cocoapods-compatibale-brightgreen)
![Cocoapods](https://img.shields.io/badge/manual%20integration-compatibale-brightgreen)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fpendo-io%2Fpendo-mobile-ios%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/pendo-io/pendo-mobile-ios)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fpendo-io%2Fpendo-mobile-ios%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/pendo-io/pendo-mobile-ios)

</div>

The Pendo Mobile SDK is a code-less, retro-active analytics collector across all of your app versions. The SDK allows presentation of in-app messages, tooltips and multi-step walkthrough guides built using Pendo's Visual Design Studio.

* The integration requires only a few lines of code.

* The SDK will start collecting analytics once the SDK is integrated.

* Analytics and guides will work across all your app versions.

## Installation Instructions 
- [Native IOS](/pnddocs/native.md)
- [SwiftUI](/pnddocs/swiftui.md)
- [React Native using React Navigation](/pnddocs/react_native.md)
- [React Native using React Native Navigation](/pnddocs/react_native_navigation.md)
- [Expo using React Navigation](/pnddocs/expo.md)
- [Expo using React Native Navigation](/pnddocs/expo_native_navigation.md)
- [Xamarin](/pnddocs/xamarin.md)
- [MAUI](/pnddocs/maui.md)
- [Flutter](/pnddocs/flutter.md)
- [Benchmarks](#benchmarks_anchor)


## Benchmarks
The SDK will increase the size of your production app (on App Store) by roughly _2.3MB_<br>
A typical Pendo session payload, including calling  `setup` and `startSession` and downloading 3 guides will consume about _~80KB _ of data can take around _3sec_.<br>
Network requests are executed in parallel, prioritizing guides with higher priority to be downloaded first and becoming available earlier during the initialization process of the session.
