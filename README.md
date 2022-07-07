# Pendo SDK for IOS 
![Cocoapods platforms](https://img.shields.io/cocoapods/p/Pendo)
![Cocoapods](https://img.shields.io/cocoapods/v/Pendo)
![Cocoapods](https://img.shields.io/badge/cocoapods-compatibale-brightgreen)
![Cocoapods](https://img.shields.io/badge/xcframework-compatibale-brightgreen)
![Cocoapods](https://img.shields.io/badge/manual%20integration-compatibale-brightgreen)
![Cocoapods](https://img.shields.io/cocoapods/l/Pendo)

The Pendo Mobile SDK is a code-less, retro-active analytics collector across all of your app's versions. The SDK also allows presentation of in-app messages, tooltips and multi-step walkthrough guides built using Pendo's Visual Design Studio online tool.

* The integration requires just three lines of code.

* The SDK will begin collecting all analytics the moment the SDK is integrated, without any additional steps.

* Tracking the analytics and guides will work across all your app versions.

## Installation Instructions 
- [Native IOS](pnddocs/native.md)
- [SwiftUI beta](pnddocs/swiftui_beta.md)
- [React Native](pnddocs/react_native.md)
- [React Native Navigation](pnddocs/react_native_navigation.md)
- [Xamarin](pnddocs/xamarin.md)
- [Flutter](pnddocs/flutter.md)
- [Benchmarks](#benchmarks_anchor)


## Benchmarks
The SDK will increase your production app (on App Store) by roughly _2.3MB_<br>
A session including the init process (usage of `setup`, `startSession` methods) and downloading 3 guides (_~80KB overall_) will elapse approximately _3sec_.<br>
Network load is executed in parallel, prioritizing guides with higher priority to be downloaded first and becoming available earlier during the initialization process of the session.
