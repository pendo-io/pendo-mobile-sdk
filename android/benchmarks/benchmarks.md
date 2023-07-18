# Android supported frameworks
## Native
- SDK 2.15, 2.16 supports up to Android 11 (API 30)
- SDK 2.17-2.22 supports up to Android 12 (API 31)

## React Native
- SDK 2.15-2.18 supported RN version: 0.65-0.69
- SDK 2.19-2.20 supports RN version: 0.70
- SDK 2.21-2.22 supports RN version: 0.71

## React Native Navigation
- SDK 2.15-2.19 supports RNN version: 5.x

## React Native Expo
- SDK 2.19-2.22 supports Expo version: > 41

## XamarinForms
- SDK 2.19-2.22 supports .Net version: .Net5

## Flutter
- SDK 2.15-2.22 supports Flutter version: 3.0.0

link: https://pendo-io.atlassian.net/wiki/spaces/ENG/pages/2731343879/Tracking+Frameworks+and+OS+Versions+Updates

# Benchmarks
## App size
The SDK will increase the size of your production app (on Google play) by roughly _3MB_

## Payload size
- <br>A typical Pendo session payload, including calling  `setup` and `startSession` and downloading 3 guides will consume about _~118KB _ of data can take around _3sec_.<br>
- Network requests are executed in parallel, prioritizing guides with higher priority to be downloaded first and becoming available earlier during the initialization process of the session.


link: https://pendo-io.atlassian.net/wiki/spaces/ENG/pages/1877410072/Android+Profiling+Data