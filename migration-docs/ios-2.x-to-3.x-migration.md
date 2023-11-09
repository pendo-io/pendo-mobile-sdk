# Native iOS Migration From 2.x to 3.x

## Table of Contents:
- [Instructions for SwiftUI Beta SDK](#mandatory-migration-instructions-for-swiftui-beta-sdk)
- [Instructions for All Native iOS SDK Integrations](#changes-relevant-to-all-native-ios-apps)
- [Instructions for Secure Metadata Sessions using JWT](#changes-relevant-to-secure-metadata-sessions-using-jwt)

## Mandatory Migration Instructions for SwiftUI Beta SDK  

Pendo’s SwiftUI support is moving to GA and is now offered as part for the iOS native SDK. The SwiftUI beta integration is no longer in use. If using SwiftUI beta support please move to the iOS native SDK integration as described in the table below:

<table border=2>
<tr>
<td align=center><b>Component / API </td>
<td align=center><b>Instructions</b></td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>Integration with Cocoapods</td>
<td>

In the podfile replace `pod 'PendoSwiftUI'` with `pod 'Pendo'`

</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>Integration with SPM</td>
<td>

In the SPM find the Pendo package and switch the Dependency Rule from `Branch` to `Up to Next Major Version` 
</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>enableSwiftUI</b></td>
</td>
<td>

The `enableSwitfUI` method was renamed as `pendoEnableSwitfUI`.

<b>2.x:</b>

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

The `enableClickAnalytics` method was renamed as `pendoRecognizeClickAnalytics`. 

<b>2.x:</b>

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

## Changes Relevant to All Native iOS Apps

The following deprecated APIs have been removed. Follow these instructions to replace them:


<table border =2 style="width:1007px">

<tr>
<td align=center><b>Component / API</td>
<td align=center><b>Instructions</b></td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>minimum <br> deployment target</td>
<td>

<b>2.x:</b> 
`iOS 9.0`
<br><b>3.x:</b> 
`iOS 11.0`
</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>initSDK </td>
<td>

Replace `initSDK` by calling the `setup` API followed by the `startSession` API. The `PendoInitParams` instance passed into `initSDK` no longer exists. The initialization parameters should be passed in directly to the `setup` and `startSession` APIs.

<b>2.x:</b>

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

<b>2.x:</b>

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

<b>2.x:</b>

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

<b>2.x:</b>

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
<td align=center><b>pauseGuides</b><br> <i>(without any arguments)</i> </td>
<td>

Pass a boolean value to `pauseGuides` to control the dismissal of guides displayed when the API is invoked. The removed API by default set this value to `true`.

<b>2.x:</b>

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

Call the `pendoRecognizeClickAnalytics` method on the UIView instance instead of passing the UIView instance as a paramater of `PendoManager.shared().enableClickAnalytics`.

<b>2.x:</b>

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

<b>2.x:</b>

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

This property has been removed and no longer exists.

<b>2.x:</b>

```swift
let appKey = PendoManager.shared().appKey
```

</td>
</tr>
</table>


## Changes Relevant to Secure Metadata Sessions Using JWT

JWT-related methods have been moved to a sub-namespace called `jwt` as follows:

<table border =2>

<tr>
<td align=center><b>Component / API</td>
<td align=center><b>Instructions</b></td>

</tr>

<!--- new row --->

<tr>
<td align=center><b>startSession </td>
<td>

<b>2.x:</b>

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

<b>2.x:</b>

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

<b>2.x:</b>

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