# Native iOS Migration From 2.x to 3.x

## Changes Relevant to SwiftUI Migration

Pendo’s SwiftUI support is moving to GA and is now offered as part for the iOS native SDK. The SwiftUI beta integration is no longer in use. If using SwiftUI beta support please move to the iOS native SDK integration as described in the table below:

<table border=2>
<tr>
<td align=center><b>Component / API </td>
<td align=center><b>Instructions</b></td>
</tr>

<!--- new row --->

<tr>
<td align=center>Integration with Cocoapods</td>
<td>

In the podfile replace `pod 'PendoSwiftUI'` with `pod 'Pendo'`

</td>
</tr>

<!--- new row --->

<tr>
<td align=center>Integration with SPM</td>
<td>

In the SPM find the Pendo package and switch the Dependency Rule from `Branch` to `Up to Next Major Version` 
</td>
</tr>

<!--- new row --->

<tr>
<td align=center>enableSwiftUI</b></td>
</td>
<td>

The `enableSwitfUI` method was renamed as `pendoEnableSwitfUI`.
 <br>Example code:
```swift
someView.pendoEnableSwitfUI()
```
</td>
</tr>

<!--- new row --->

<tr>
<td align=center>enableClickAnalytics</td>
<td>

The `enableClickAnalytics` method was renamed as `pendoRecognizeClickAnalytics`. 
<br> Example code: 

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
<td align=center>minimum <br> deployment target</td>
<td>

Previously: `iOS 9.0`
<br> Going forward: `iOS 11.0`
</td>
</tr>

<!--- new row --->

<tr>
<td align=center> initSDK </td>
<td>

Replace `initSDK` by calling the `setup` API followed by the `startSession` API. 
<br> The `PendoInitParams` instance passed into `initSDK` no longer exists. The initialization paramaters can be passed in directly to the `setup` and `startSession` APIs.

Legacy code example:
```swift
// set session paramaters
let pendoInitParams = PendoInitParams()
pendoInitParams.visitorId = "someVisitorID"
pendoInitParams.accountId = "someAccountID"
pendoInitParams.visitorData = ["age" : 27, "country" : "USA"]
pendoInitParams.accountData = ["tier" : 1, "size" : "Enterprise"]

// establish connection to server and start a session
PendoManager.shared().initSDK("someAppKey", initParams: pendoInitParams)
```

New code example:
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
<td align=center> initSDKWithoutVisitor </td>
<td>

Call the `setup` API instead of `initSDKWithoutVisitor`.

Legacy code example:
```swift
PendoManager.shared().initSDKWithoutVisitor("someAppKey", with: nil)
```
New code example:
```swift
PendoManager.shared().setup("someAppKey", with: nil)
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center> clearVisitor </td>
<td>

Call the `startSession` API with `nil` values instead of `clearVisitor`.

Legacy code example:
```swift
// start a session with an anonymous visitor
PendoManager.shared().clearVisitor()
```

New code example:
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
<td align=center> switchVisitor </td>
<td>

Call the `startSession` API instead of `switchVisitor`.

Legacy code example:
```swift
PendoManager.shared().switchVisitor("someVisitorID", 
      accountId: "someAccountID", 
      visitorData: ["age" : 27, "country" : "USA"], 
      accountData: ["tier" : 1, "size" : "Enterprise"])
```
New code example:
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
<td align=center> pauseGuides <i>(without dismissGuides argument)</i> </td>
<td>

Pass a boolean value to `pauseGuides` to control the dismissal of guides displayed when the API is invoked. The removed API by default set this value to `true`.

Legacy code example:
```swift
PendoManager.shared().pauseGuides()
```
New code example:
```swift
PendoManager.shared().pauseGuides(true) // true == dismiss any displayed guide
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center> enableClickAnalytics </td>
<td>

Call the `pendoRecognizeClickAnalytics` method on the UIView instance instead of passing the UIView instance as a paramater of `PendoManager.shared().enableClickAnalytics`.

Legacy code example:
```swift
PendoManager.shared().enableClickAnalytics(someUIView)
```
New code example:
```swift
someUIView.pendoRecognizeClickAnalytics()
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center> accountId property setter </td>
<td>

Call `startSession` with the new account id value instead of setting the account id as a value of the `PendoManager.shared().accountId` property.

Legacy code example:
```swift
PendoManager.shared().accountId = "someAccountId"
```
New code example:
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
<td align=center> appkey property getter </td>
<td>

This property has been removed and no longer exists.

Legacy code example:
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
<td align=center> startSession </td>
<td>

Legacy code example:
```swift
PendoManager.shared().startSession("someJWT", "someSigningKeyName")
```
New code example:
```swift
PendoManager.shared().jwt.startSession("someJWT", "someSigningKeyName")
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center> setVisitorData </td>
<td>

Legacy code example:
```swift
PendoManager.shared().setVisitorData("someJWT", "someSigningKeyName")
```
New code example:
```swift
PendoManager.shared().jwt.setVisitorData("someJWT", "someSigningKeyName")
```
</td>
</tr>

<!--- new row --->

<tr>
<td align=center> setAccountData </td>
<td>

Legacy code example:
```swift
PendoManager.shared().setAccountData("someJWT", "someSigningKeyName")
```
New code example:
```swift
PendoManager.shared().jwt.setAccountData("someJWT", "someSigningKeyName")
```
</td>
</tr>

</table>