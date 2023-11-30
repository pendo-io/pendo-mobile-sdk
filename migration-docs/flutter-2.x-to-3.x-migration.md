# Flutter migration from version 2.x to version 3.x


Follow these instructions to resolve breaking changes in your app::

<table border =2>

<tr>
<td align=center><b>Component / API</td>
<td align=center><b>Instructions</b></td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>Minimum <br> Flutter version</b> <br></td>
<td>

<b>2.x (deprecated):</b> `2.0.0 - 2.10.5`
<br>
<b>3.x:</b> `3.3.0`

</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>Minimum <br> Dart version</b> <br></td>
<td>

<b>2.x (deprecated):</b> `2.12.0 - 2.16.2`
<br>
<b>3.x:</b> `2.18`

</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>Minimum <br> JAVA version</b> <br> <i> (Relevant for Android apps only) </td>
<td>

<b>2.x (deprecated):</b> `JAVA 8`
<br>
<b>3.x:</b> `JAVA 11`

</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>Minimum <br> Kotlin version</b> <br> <i> (Relevant for Android apps only) </td>
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

Replace `initSDK` by calling `setup` and then `startSession`.

<b>2.x (deprecated):</b>

```dart
// set session paramaters
final dynamic pendoParams = {'visitorId':'someVisitorID',
               'accountId':'someAccountID',
               'vistiorData':  {'age':'25', 'country':'USA'},
               'accountData':  {'tier': '1', 'size':'Enterprise'}};
                     
// establish connection to server and start a session
await PendoFlutterPlugin.startSession('someAppKey', pendoParams);
```

<b>3.x:</b>

```dart
// establish connection to server
await PendoFlutterPlugin.setup('someAppKey'
                                null // pendo app params
);

// start a session
await PendoFlutterPlugin.startSession('someVisitorID', 
                'someAccountID', 
                {'age': '25', 'country': 'USA'}, 
                {'tier': '1', 'size': 'Enterprise'});
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>initSDKWithoutVisitor </td>
<td>

Call `setup` instead of `initSDKWithoutVisitor`.

<b>2.x (deprecated):</b>

```dart
// establish connection to server
await PendoFlutterPlugin.initSDKWithoutVisitor('someAppKey'
                null // pendo app params
);
```

<b>3.x:</b>


```dart
// establish connection to server
await PendoFlutterPlugin.setup('someAppKey'
            null // pendo app params
);
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>clearVisitor </td>
<td>

Call `startSession` with `null` values instead of `clearVisitor`.

<b>2.x (deprecated):</b>

```dart
// start a session with an anonymous visitor
await PendoFlutterPlugin.clearVisitor()
```

<b>3.x:</b>

```dart
// start a session with an anonymous visitor
await PendoFlutterPlugin.startSession(null, null, null, null);
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>switchVisitor </td>
<td>

Call `startSession` with a new visitor or account id instead of `switchVisitor`.

<b>2.x (deprecated):</b>

```dart
await PendoFlutterPlugin.switchVisitor('someVisitorID', 
            'someAccountID', 
            {'age': '25', 'country': 'USA'}, 
            {'tier': '1', 'size': 'Enterprise'});
```

<b>3.x:</b>

```dart
await PendoFlutterPlugin.startSession('someVisitorID', 
            'someAccountID', 
            {'age': '25', 'country': 'USA'}, 
            {'tier': '1', 'size': 'Enterprise'});
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center><b>setAccountId </td>
<td>

Call `startSession` with the new account id value instead of `setAccountId`.

<b>2.x (deprecated):</b>

```dart
await PendoFlutterPlugin.setAccountId('someAccountID');
```

<b>3.x:</b>

```dart
// start a new session passing in the new accountId 
await PendoFlutterPlugin.startSession('someVisitorID', 
            'someAccountID', 
            {'age': '25', 'country': 'USA'}, 
            {'tier': '1', 'size': 'Enterprise'});
```

</td>
</tr>
</table>