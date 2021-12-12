# Pendo SDK for IOS 
![Cocoapods platforms](https://img.shields.io/cocoapods/p/Pendo)
![Cocoapods](https://img.shields.io/cocoapods/v/Pendo)
![Cocoapods](https://img.shields.io/badge/cocoapods-compatibale-brightgreen)
![Cocoapods](https://img.shields.io/badge/xcframework-compatibale-brightgreen)
![Cocoapods](https://img.shields.io/badge/manual%20integration-compatibale-brightgreen)
![Cocoapods](https://img.shields.io/cocoapods/l/Pendo)

The Pendo Mobile SDK provides codeless, retroactive analytics across all of your app versions, as well as in-app messages, tooltips, and multi-step walkthrough guides built with Pendo's Visual Design Studio.

* The integration takes three lines of code.

* The SDK will start collecting analytics right away.

* Tracking analytics and guides will work across all your app versions.

## Installation Instruction 
- [Native IOS](pnddocs/native.md)
- [React Native](pnddocs/react_native.md)
- [React Native Navigation](pnddocs/react_native_navigation.md)
- [Xamarin](pnddocs/xamarin.md)
- [Flutter](pnddocs/flutter.md)
- [Benchmarks](#benchmarks_anchor)


## Benchmarks
SDK size in production is about _2.3MB_<br>
The init process which includes  `setup`, `startSession` and downloading amount of 3 guides with 3 step each (_~80KB overall_ ) will take around _3sec_ for all of the guides.<br>
 The network load is executed in paraller so the the guides with highest priority will be downloaded faster and will be availble before the totall download time.


