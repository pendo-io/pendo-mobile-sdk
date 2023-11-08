# Native iOS Migration From 2.x to 3.x

## Changes Relevant to SwiftUI Migration

Pendo’s SwiftUI support is moving to GA and is now offered as part for the iOS native SDK. The SwiftUI beta integration is no longer in use. If using SwiftUI beta support please move to the iOS native SDK integration as described in the table below:

<table border=2>
<tr>
<td> </td>
<td><b> 2.x</b></td>
<td><b>3.x</b></td>
</tr>

<!--- new row --->

<tr>
<td align=center>Integration with <b>Cocoapods</b></td>
<td>

In the podfile add `pod 'PendoSwiftUI`
</td>
<td>

In the podfile replace `pod 'PendoSwiftUI'` with `pod 'Pendo'`

</td>
</tr>

<!--- new row --->

<tr>
<td align=center>Integration with <b>SPM</b></td>
<td>

In the SPM search for Pendo, set the Dependency Rule on the package to `Branch` and enter `swiftui` as the branch name

<pre lang='Swift' style="max-width:150px">
PendoManager.shared().initSDKWithoutVisitor("someAppKey", with: nil)
</pre>

<pre lang='Swift'>
PendoManager.shared().initSDKWithoutVisitor("someAppKey", with: nil)
</pre> 

</td>
<td>

Switch the Dependency Rule for the Pendo package from `Branch` to `Up to Next Major Version` 
</td>
</tr>

<!--- new row --->

<tr>
<td align=center>enableSwiftUI</b></td>
<td>

`someView.enableSwitfUI()`

</td>
<td>

The enableSwitfUI method was renamed as pendoEnableSwitfUI: `someView.pendoEnableSwitfUI()`
</td>
</tr>

<!--- new row --->

<tr>
<td align=center>enableClickAnalytics</td>
<td>

`someView.enableClickAnalytics()`

</td>
<td>

The enableClickAnalytics method was renamed as pendoRecognizeClickAnalytics: `someView.pendoRecognizeClickAnalytics()`

</td>
</tr>
</table>

## Changes Relevant to All Native iOS Apps

The following deprecated APIs have benn removed. Follow these instructions to replace them:


<table border =2 style="width:1007px">

<tr>
<td> </td>
<td><b> 2.x</b></td>
<td><b>3.x</b></td>
</tr>

<!--- new row --->

<tr>
<td align=center>deployment target</td>
<td>iOS 9.0</td>
<td>iOS 11.0</td>
</tr>

<!--- new row --->

<tr>
<td align=center> initSDK </td>
<td>

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

</td>
<td>

Replace `PendoManager.shared().initSDK` by calling `PendoManager.shared().setup` followed by `PendoManager.shared().startSession`. 

The `PendoInitParams` class 
 no longer exists.

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

```swift
PendoManager.shared().initSDKWithoutVisitor("someAppKey", with: nil)
```

</td>
<td>

Call `PendoManager.shared().setup` instead of `PendoManager.shared().initSDKWithoutVisitor`:

```swift
PendoManager.shared().setup("someAppKey", with: nil)
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center> clearVisitor </td>
<td>

```swift
// start a session with an anonymous visitor
PendoManager.shared().clearVisitor()
```

</td>
<td>

Call `PendoManager.shared().startSession` with `nil` values instead of `PendoManager.shared().clearVisitor`:

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

```swift
PendoManager.shared().switchVisitor("someVisitorID", 
            accountId: "someAccountID", 
            visitorData: ["age" : 27, "country" : "USA"], 
            accountData: ["tier" : 1, "size" : "Enterprise"])
```

</td>
<td>

Call `PendoManager.shared().startSession` instead of `PendoManager.shared().switchVisitor`:

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

```swift
PendoManager.shared().pauseGuides()
```

</td>
<td>

Pass a boolean value to `PendoManager.shared().pauseGuides` to control the dismissal of any guide displayed when the API is invoked. The removed API by default set the value to `true`:

```swift
PendoManager.shared().pauseGuides(true) // true == dismiss any displayed guide
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center> enableClickAnalytics </td>
<td>

```swift
PendoManager.shared().enableClickAnalytics(someUIView)
```

</td>
<td>

Call the `pendoRecognizeClickAnalytics` on the UIView instance instead of passing it as an argument to the `PendoManager.shared().enableClickAnalytics` API:

```swift
someUIView.pendoRecognizeClickAnalytics()
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center> accountId property setter </td>
<td>

```swift
PendoManager.shared().accountId = "someAccountId"
```

</td>
<td>

Call `PendoManager.shared().startSession` with the new account id value instead of setting a value to `PendoManager.shared().accountId` property:

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

```swift
let appKey = PendoManager.shared().appKey
```

</td>
<td>

This property has been removed and no longer exists.

</td>
</tr>
</table>


## Changes Relevant to Secure Metadata Sessions Using JWT

JWT-related methods have been moved to a sub-namespace called `jwt` as follows:

<table border =2>

<tr>
<td> </td>
<td><b> 2.x</b></td>
<td><b>3.x</b></td>
</tr>

<!--- new row --->

<tr>
<td align=center> startSession </td>
<td>

```swift
PendoManager.shared().startSession("someJWT", "someSigningKeyName")
```

</td>
<td>

```swift
PendoManager.shared().jwt.startSession("someJWT", "someSigningKeyName")
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center> setVisitorData </td>
<td>

```swift
PendoManager.shared().setVisitorData("someJWT", "someSigningKeyName")
```

</td>
<td>

```swift
PendoManager.shared().jwt.setVisitorData("someJWT", "someSigningKeyName")
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center> setAccountData </td>
<td>

```swift
PendoManager.shared().setAccountData("someJWT", "someSigningKeyName")
```

</td>
<td>

```swift
PendoManager.shared().jwt.setAccountData("someJWT", "someSigningKeyName")
```

</td>
</tr>

</table>











## THIS IS A TEST!

The following deprecated APIs have benn removed. Follow these instructions to replace them:


<table border =2 style="width:1007px">

<tr>
<td> </td>
<td><b>3.x</b></td>
</tr>

<!--- new row --->

<tr>
<td align=center>deployment target</td>
<td>iOS 9.0 -> iOS 11.0</td>
</tr>

<!--- new row --->

<tr>
<td align=center> initSDK </td>
<td>




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


Replace `PendoManager.shared().initSDK` by calling `PendoManager.shared().setup` followed by `PendoManager.shared().startSession`. 

The `PendoInitParams` class 
 no longer exists.

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

```swift
PendoManager.shared().initSDKWithoutVisitor("someAppKey", with: nil)
```

Call `PendoManager.shared().setup` instead of `PendoManager.shared().initSDKWithoutVisitor`:

```swift
PendoManager.shared().setup("someAppKey", with: nil)
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center> clearVisitor </td>
<td>

```swift
// start a session with an anonymous visitor
PendoManager.shared().clearVisitor()
```

Call `PendoManager.shared().startSession` with `nil` values instead of `PendoManager.shared().clearVisitor`:

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

```swift
PendoManager.shared().switchVisitor("someVisitorID", 
            accountId: "someAccountID", 
            visitorData: ["age" : 27, "country" : "USA"], 
            accountData: ["tier" : 1, "size" : "Enterprise"])
```

Call `PendoManager.shared().startSession` instead of `PendoManager.shared().switchVisitor`:

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

```swift
PendoManager.shared().pauseGuides()
```

Pass a boolean value to `PendoManager.shared().pauseGuides` to control the dismissal of any guide displayed when the API is invoked. The removed API by default set the value to `true`:

```swift
PendoManager.shared().pauseGuides(true) // true == dismiss any displayed guide
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center> enableClickAnalytics </td>
<td>

```swift
PendoManager.shared().enableClickAnalytics(someUIView)
```

Call the `pendoRecognizeClickAnalytics` on the UIView instance instead of passing it as an argument to the `PendoManager.shared().enableClickAnalytics` API:

```swift
someUIView.pendoRecognizeClickAnalytics()
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center> accountId property setter </td>
<td>

```swift
PendoManager.shared().accountId = "someAccountId"
```

Call `PendoManager.shared().startSession` with the new account id value instead of setting a value to `PendoManager.shared().accountId` property:

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

```swift
let appKey = PendoManager.shared().appKey
```

This property has been removed and no longer exists.

</td>
</tr>
</table>