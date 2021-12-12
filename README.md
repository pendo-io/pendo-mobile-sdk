# Pendo SDK for IOS 
![Cocoapods platforms](https://img.shields.io/cocoapods/p/Pendo)
![Cocoapods](https://img.shields.io/cocoapods/v/Pendo)
![Cocoapods](https://img.shields.io/badge/cocoapods-compatibale-brightgreen)
![Cocoapods](https://img.shields.io/badge/xcframework-compatibale-brightgreen)
![Cocoapods](https://img.shields.io/badge/manual%20integration-compatibale-brightgreen)
![Cocoapods](https://img.shields.io/cocoapods/l/Pendo)

TODO: (Naor) Some description aboout the SDK

## Installation Instruction 
- [Native IOS](pnddocs/native.md)
- [React Native](pnddocs/react_native.md)
- [React Native Navigation](pnddocs/react_native_navigation.md)
- [Xamarin](pnddocs/xamarin.md)
- [Flutter](pnddocs/flutter.md)
- [Benchmarks](#benchmarks_anchor)
- [Pivots](#pivots_anchor)

<a name="benchmarks_anchor"></a>
## Benchmarks
SDK size in production is about _2.3MB_<br>
The init process which includes  `setup`, `startSession` and downloading amount of 3 guides with 3 step each (_~80KB overall_ ) will take around _3sec_ for all of the guides.<br>
 The network load is executed in paraller so the the guides with highest priority will be downloaded faster and will be availble before the totall download time.

<a name="pivots_anchor"></a>
## Pivots
Please pay attention to the follwowing api's ``` setup ``` and ```startSession``` the former *must* be called once per session and will create initial setup for the SDK, the later should be called whenever you have the visitor you would like to assign the analytics/guides to. In case you would like to have an anonymous visitor pass ```nil``` to the ```statSession``` and call it again as son as u have the vistor. 

