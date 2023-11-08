# Native Android Migration From 2.x to 3.x

## Changes Relevant to All Native Android Apps

The following deprecated APIs have been removed. Follow these instructions to replace them: 


<table border =2>

<tr>
<td> </td>
<td><b> 2.x</b></td>
<td><b>3.x</b></td>
</tr>

<!--- new row --->

<tr>
<td align=center> initSDK </td>
<td>

```kotlin
// set session paramaters
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

</td>
<td>

Replace `Pendo.initSDK` by calling `Pendo.setup` and then `Pendo.startSession`.

The `PendoInitParams` class 
 no longer exists.

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
<td align=center> initSDKWithoutVisitor </td>
<td>

```kotlin
// establish connection to server
Pendo.initSDKWithoutVisitor(
        this, // Application or Activity
        "someAppKey",
        null, // PendoOptions
        null  // PendoPhasesCallbackInterface
)
```

</td>
<td>

Call `Pendo.setup` instead of `Pendo.initSDKWithoutVisitor`:

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
<td align=center> clearVisitor </td>
<td>

```kotlin
// start a session with an anonymous visitor
Pendo.clearVisitor()
```

</td>
<td>

Call `Pendo.startSession` with `null` values instead of `Pendo.clearVisitor`:

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
<td align=center> switchVisitor </td>
<td>

```kotlin
Pendo.switchVisitor(
        "someVisitorID", 
        "someAccountID", 
        mapOf("age" to 27, "country" to "USA"), 
        mapOf("tier" to 1, "size" to "Enterprise")
)
```

</td>
<td>

Call `Pendo.startSession` instead of `Pendo.switchVisitor`:

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
<td align=center> setAccountId </td>
<td>

```kotlin
Pendo.setAccountId("someAccountID")
```

</td>
<td>

Call `Pendo.startSession` with the new account id value instead of `Pendo.setAccountId`:

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
<td align=center> pauseGuides <i>(without dismissGuides argument)</i> </td>
<td>

```kotlin
Pendo.pauseGuides()
```

</td>
<td>

Pass a boolean value to `Pendo.pauseGuides` to control the dismissal of any guide displayed when the API is invoked. The removed API by default set the value to `true`:

```kotlin
Pendo.pauseGuides(true) // true == dismiss any displayed guide
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center> isInitStarted callback </td>
<td>

```kotlin
class myPendoCallbackImplementation : PendoPhasesCallbackInterface {
    override fun onInitStarted() { ... }
    override fun onInitComplete() { ... }
    override fun onInitFailed() { ... }
}
```

</td>
<td>

The `onInitStarted` callback was removed from the `PendoPhasesCallbackInterface`:

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
<td> </td>
<td><b> 2.x</b></td>
<td><b>3.x</b></td>
</tr>

<!--- new row --->

<tr>
<td align=center> startSession </td>
<td>

```kotlin
Pendo.startSession("someJWT", "someSigningKeyName")
```

</td>
<td>

```kotlin
Pendo.jwt.startSession("someJWT", "someSigningKeyName")
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center> setVisitorData </td>
<td>

```kotlin
Pendo.setVisitorData("someJWT", "someSigningKeyName")
```

</td>
<td>

```kotlin
Pendo.jwt.setVisitorData("someJWT", "someSigningKeyName")
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center> setAccountData </td>
<td>

```kotlin
Pendo.setAccountData("someJWT", "someSigningKeyName")
```

</td>
<td>

```kotlin
Pendo.jwt.setAccountData("someJWT", "someSigningKeyName")
```

</td>
</tr>

</table>