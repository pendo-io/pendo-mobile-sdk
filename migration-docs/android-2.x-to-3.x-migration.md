# Native Android migration from version 2.x to version 3.x

## Table of contents:
- [Instructions for all native Android SDK integrations](#changes-relevant-to-all-native-android-apps)
- [Instructions for secure metadata sessions using JWT](#changes-relevant-to-secure-metadata-sessions-using-jwt)

## Changes relevant to all native Android apps

Follow these instructions to resolve breaking changes in your app: 


<table border =2>

<tr>
<td align=center><b>Component / API</td>
<td align=center><b>Instructions</b></td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>Minimum <br> JAVA version</b> <br> </td>
<td>

<b>2.x (deprecated):</b> `JAVA 8`
<br>
<b>3.x:</b> `JAVA 11`

</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>Minimum <br> Kotlin version</b> <br> </td>
<td>

<b>2.x (deprecated):</b> `1.7.20`
<br>
<b>3.x:</b> `1.9.0`

</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>initSDK </td>
<td>

Replace `initSDK` by calling the `setup` API, followed by the `startSession` API. The `PendoInitParams` instance passed into `initSDK` no longer exists. The initialization parameters should be passed directly to the `setup` and `startSession` APIs.

 <b>2.x (deprecated):</b>

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

<b>2.x (deprecated):</b>

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

<b>2.x (deprecated):</b>

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

Call `startSession` with a new visitor or account id instead of `switchVisitor`.

<b>2.x (deprecated):</b>

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

<b>2.x (deprecated):</b>

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
<td align=center><b>pauseGuides</b> <br> <i>(without arguments)</i> </td>
<td>

Pass a boolean value to `pauseGuides` to control dismissal of a guide if displayed when the API is invoked. By default, the deprecated API set the value to `true`.

<b>2.x (deprecated):</b>

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

The `onInitStarted` callback has been removed from the `PendoPhasesCallbackInterface`.

<b>2.x (deprecated):</b>

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

<b>2.x (deprecated):</b>

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

<b>2.x (deprecated):</b>

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