# Native iOS migration from version 2.x to version 3.x

## Table of contents:
- [Instructions for SwiftUI beta SDK](#mandatory-migration-instructions-for-the-swiftui-beta-sdk)
- [Instructions for all native iOS SDK integrations](#changes-relevant-to-all-native-ios-apps)
- [Instructions for secure metadata sessions using JWT](#changes-relevant-to-secure-metadata-sessions-using-jwt)

## Mandatory migration instructions for the SwiftUI beta SDK  

Pendo’s SwiftUI support is GA and its library is now merged into the iOS native SDK. The SwiftUI beta integration is no longer in use. If using SwiftUI beta support, follow the instructions in the table to switch over to the iOS native SDK.

<table border=2>
<tr>
<td align=center><b>Component / API </td>
<td align=center><b>Instructions</b></td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>Integration with Cocoapods</td>
<td>

In the podfile, replace `pod 'PendoSwiftUI'` with `pod 'Pendo'`.

</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>Integration with SPM</td>
<td>

In the SPM, find the Pendo package and switch the Dependency Rule from `Branch` to `Up to Next Major Version`. 
</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>enableSwiftUI</b></td>
</td>
<td>

The `enableSwitfUI` method has been renamed to `pendoEnableSwitfUI`.

<b>2.x (deprecated):</b>

```swift
someView.enableSwitfUI()
```
<b>3.x:</b>

```swift
someView.pendoEnableSwitfUI()
```
</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>enableClickAnalytics</td>
<td>

The `enableClickAnalytics` method has been renamed to `pendoRecognizeClickAnalytics`. 

<b>2.x (deprecated):</b>

```swift
someView.enableClickAnalytics()
```
<b>3.x:</b>

```swift
someView.pendoRecognizeClickAnalytics()
```


</td>
</tr>
</table>

## Changes relevant to all native iOS apps

Follow these instructions to resolve breaking changes in your app:


<table border =2 style="width:1007px">

<tr>
<td align=center><b>Component / API</td>
<td align=center><b>Instructions</b></td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>Minimum <br> deployment target</td>
<td>

<b>2.x (deprecated):</b> 
`iOS 9.0`
<br><b>3.x:</b> 
`iOS 11.0`
</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>Minimum <br> xCode version</td>
<td>

<b>2.x (deprecated):</b> 
`13`
<br><b>3.x:</b> 
`14`
</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>Minimum <br> Swift compatibility</td>
<td>

<b>2.x (deprecated):</b> 
`5.6`
<br><b>3.x:</b> 
`5.7`
</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>initSDK </td>
<td>

Replace `initSDK` by calling the `setup` API, followed by the `startSession` API. The `PendoInitParams` instance passed into `initSDK` no longer exists. The initialization parameters should be passed directly to the `setup` and `startSession` APIs.

<b>2.x (deprecated):</b>

```swift
// set session parameters
let pendoInitParams = PendoInitParams()
pendoInitParams.visitorId = "someVisitorID"
pendoInitParams.accountId = "someAccountID"
pendoInitParams.visitorData = ["age" : 27, "country" : "USA"]
pendoInitParams.accountData = ["tier" : 1, "size" : "Enterprise"]

// establish connection to server and start a session
PendoManager.shared().initSDK("someAppKey", initParams: pendoInitParams)
```

<b>3.x:</b>

```swift
// establish connection to server
PendoManager.shared().setup("someAppKey")

// start a session
PendoManager.shared().startSession("someVisitorID", 
      accountId: "someAccountID", 
      visitorData: ["age" : 27, "country" : "USA"], 
      accountData: ["tier" : 1, "size" : "Enterprise"])
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>initSDKWithoutVisitor </td>
<td>

Call the `setup` API instead of `initSDKWithoutVisitor`.

<b>2.x (deprecated):</b>

```swift
PendoManager.shared().initSDKWithoutVisitor("someAppKey", with: nil)
```
<b>3.x:</b>

```swift
PendoManager.shared().setup("someAppKey", with: nil)
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>clearVisitor </td>
<td>

Call the `startSession` API with `nil` values instead of `clearVisitor`.

<b>2.x (deprecated):</b>

```swift
// start a session with an anonymous visitor
PendoManager.shared().clearVisitor()
```

<b>3.x:</b>

```swift
// start a session with an anonymous visitor
PendoManager.shared().startSession(nil, 
      accountId:nil, 
      visitorData:nil, 
      accountData:nil)
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>switchVisitor </td>
<td>

Call the `startSession` API instead of `switchVisitor`.

<b>2.x (deprecated):</b>

```swift
PendoManager.shared().switchVisitor("someVisitorID", 
      accountId: "someAccountID", 
      visitorData: ["age" : 27, "country" : "USA"], 
      accountData: ["tier" : 1, "size" : "Enterprise"])
```
<b>3.x:</b>

```swift
PendoManager.shared().startSession("someVisitorID", 
      accountId: "someAccountID", 
      visitorData: ["age" : 27, "country" : "USA"], 
      accountData: ["tier" : 1, "size" : "Enterprise"])
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>pauseGuides</b><br> <i>(without arguments)</i> </td>
<td>

Pass a boolean value to `pauseGuides` to control dismissal of a guide if displayed when the API is invoked. By default, the deprecated API set the value to `true`.

<b>2.x (deprecated):</b>

```swift
PendoManager.shared().pauseGuides()
```
<b>3.x:</b>

```swift
PendoManager.shared().pauseGuides(true) // true == dismiss any displayed guide
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>enableClickAnalytics </td>
<td>

Call the `pendoRecognizeClickAnalytics` method on the UIView instance instead of passing the UIView instance as a parameter of `PendoManager.shared().enableClickAnalytics`.

<b>2.x (deprecated):</b>

```swift
PendoManager.shared().enableClickAnalytics(someUIView)
```
<b>3.x:</b>

```swift
someUIView.pendoRecognizeClickAnalytics()
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>accountId property setter </td>
<td>

Call `startSession` with the new account id value instead of setting the account id as a value of the `PendoManager.shared().accountId` property.

<b>2.x (deprecated):</b>

```swift
PendoManager.shared().accountId = "someAccountId"
```
<b>3.x:</b>

```swift
PendoManager.shared().startSession("someVisitorID", 
      accountId: "someAccountID", 
      visitorData: ["age" : 27, "country" : "USA"], 
      accountData: ["tier" : 1, "size" : "Enterprise"])
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>appkey property getter </td>
<td>

This property no longer exists.

<b>2.x (deprecated):</b>

```swift
let appKey = PendoManager.shared().appKey
```

</td>
</tr>
</table>


## Changes relevant to secure metadata sessions using JWT

JWT-related methods have been moved to a sub-namespace called `jwt`.

<table border =2>

<tr>
<td align=center><b>Component / API</td>
<td align=center><b>Instructions</b></td>

</tr>

<!--- new row --->

<tr>
<td align=center><b>startSession </td>
<td>

<b>2.x (deprecated):</b>

```swift
PendoManager.shared().startSession("someJWT", "someSigningKeyName")
```
<b>3.x:</b>

```swift
PendoManager.shared().jwt.startSession("someJWT", "someSigningKeyName")
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>setVisitorData </td>
<td>

<b>2.x (deprecated):</b>

```swift
PendoManager.shared().setVisitorData("someJWT", "someSigningKeyName")
```
<b>3.x:</b>

```swift
PendoManager.shared().jwt.setVisitorData("someJWT", "someSigningKeyName")
```
</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>setAccountData </td>
<td>

<b>2.x (deprecated):</b>

```swift
PendoManager.shared().setAccountData("someJWT", "someSigningKeyName")
```
<b>3.x:</b>

```swift
PendoManager.shared().jwt.setAccountData("someJWT", "someSigningKeyName")
```
</td>
</tr>

</table>