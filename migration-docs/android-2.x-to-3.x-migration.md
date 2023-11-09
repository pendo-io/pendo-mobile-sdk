# Native Android Migration From 2.x to 3.x

## Changes Relevant to All Native Android Apps

The following deprecated APIs have been removed. Follow these instructions to replace them: 


<table border =2>

<tr>
<td align=center><b>Component / API</td>
<td align=center><b>Instructions</b></td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>initSDK </td>
<td>

Replace `initSDK` by calling the `setup` API followed by the `startSession` API. The `PendoInitParams` instance passed into `initSDK` no longer exists. The initialization parameters should be passed in directly to the `setup` and `startSession` APIs.

 <b>2.x:</b>

```kotlin
// set session parameters
val pendoParams = Pendo.PendoInitParams()
pendoParams.visitorId = "someVisitorID"
pendoParams.accountId = "someAccountID"
pendoParams.visitorData = mapOf("age" to 27, "country" to "USA")
pendoParams.accountData = mapOf("tier" to 1, "size" to "Enterprise")

// establish connection to server and start a session
Pendo.initSDK(
        this, // Application or Activity
        "someAppKey",
        pendoParams
)
```

<b>3.x:</b>

```kotlin
// establish connection to server
Pendo.setup(
        this, // Context
        "someAppKey",
        null, // PendoOptions
        null  // PendoPhasesCallbackInterface
)

// start a session
Pendo.startSession(
        "someVisitorID", 
        "someAccountID", 
        mapOf("age" to 27, "country" to "USA"), 
        mapOf("tier" to 1, "size" to "Enterprise")
)
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>initSDKWithoutVisitor </td>
<td>

Call `setup` instead of `initSDKWithoutVisitor`.

<b>2.x:</b>

```kotlin
// establish connection to server
Pendo.initSDKWithoutVisitor(
        this, // Application or Activity
        "someAppKey",
        null, // PendoOptions
        null  // PendoPhasesCallbackInterface
)
```

<b>3.x:</b>

```kotlin
// establish connection to server
Pendo.setup(
        this, // Context
        "someAppKey",
        null, // PendoOptions
        null  // PendoPhasesCallbackInterface
)
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>clearVisitor </td>
<td>

Call `startSession` with `null` values instead of `clearVisitor`.

<b>2.x:</b>

```kotlin
// start a session with an anonymous visitor
Pendo.clearVisitor()
```

<b>3.x:</b>

```kotlin
// start a session with an anonymous visitor
Pendo.startSession(
        null, // visitorId
        null, // accountId
        null, // visitorData
        null  // accountData
)
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>switchVisitor </td>
<td>

Call `startSession` instead of `switchVisitor`.

<b>2.x:</b>

```kotlin
Pendo.switchVisitor(
        "someVisitorID", 
        "someAccountID", 
        mapOf("age" to 27, "country" to "USA"), 
        mapOf("tier" to 1, "size" to "Enterprise")
)
```

<b>3.x:</b>

```kotlin
Pendo.startSession(
        "someVisitorID", 
        "someAccountID", 
        mapOf("age" to 27, "country" to "USA"), 
        mapOf("tier" to 1, "size" to "Enterprise")
)
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>setAccountId </td>
<td>

Call `startSession` with the new account id value instead of `setAccountId`.

<b>2.x:</b>

```kotlin
Pendo.setAccountId("someAccountID")
```

<b>3.x:</b>

```kotlin
// start a new session passing in the new accountId 
Pendo.startSession(
        "someVisitorID", 
        "someAccountID", 
        mapOf("age" to 27, "country" to "USA"), 
        mapOf("tier" to 1, "size" to "Enterprise")
)
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>pauseGuides</b> <br> <i>(without any arguments)</i> </td>
<td>

Pass a boolean value to `pauseGuides` to control the dismissal of any guide displayed when the API is invoked. The removed API by default set the value to `true`.

<b>2.x:</b>

```kotlin
Pendo.pauseGuides()
```

<b>3.x:</b>

```kotlin
Pendo.pauseGuides(true) // true == dismiss any displayed guide
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>isInitStarted callback </td>
<td>

The `onInitStarted` callback was removed from the `PendoPhasesCallbackInterface`.

<b>3.x:</b>

```kotlin
class myPendoCallbackImplementation : PendoPhasesCallbackInterface {
    override fun onInitStarted() { ... }
    override fun onInitComplete() { ... }
    override fun onInitFailed() { ... }
}
```

<b>3.x:</b>

```kotlin
class myPendoCallbackImplementation : PendoPhasesCallbackInterface {
    override fun onInitComplete() { ... }
    override fun onInitFailed() { ... }
}
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

```kotlin
Pendo.startSession("someJWT", "someSigningKeyName")
```

<b>3.x:</b>

```kotlin
Pendo.jwt.startSession("someJWT", "someSigningKeyName")
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>setVisitorData </td>
<td>

<b>2.x:</b>

```kotlin
Pendo.setVisitorData("someJWT", "someSigningKeyName")
```

<b>3.x:</b>

```kotlin
Pendo.jwt.setVisitorData("someJWT", "someSigningKeyName")
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>setAccountData </td>
<td>

<b>2.x:</b>

```kotlin
Pendo.setAccountData("someJWT", "someSigningKeyName")
```

<b>3.x:</b>

```kotlin
Pendo.jwt.setAccountData("someJWT", "someSigningKeyName")
```

</td>
</tr>

</table>