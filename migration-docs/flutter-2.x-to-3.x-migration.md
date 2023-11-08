# Flutter Migration From 2.x to 3.x


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

```dart
// set session paramaters
final dynamic pendoParams = {'visitorId':'someVisitorID',
               'accountId':'someAccountID',
               'vistiorData':  {'age':'25', 'country':'USA'},
               'accountData':  {'tier': '1', 'size':'Enterprise'}};
                     
// establish connection to server and start a session
await PendoFlutterPlugin.startSession('someAppKey', pendoParams);
```

</td>
<td>

Replace `PendoFlutterPlugin.initSDK` by calling `PendoFlutterPlugin.setup` and then `PendoFlutterPlugin.startSession`:

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
<td align=center> initSDKWithoutVisitor </td>
<td>

```dart
// establish connection to server
await PendoFlutterPlugin.initSDKWithoutVisitor('someAppKey'
                null // pendo app params
);
```

</td>
<td>

Call `PendoFlutterPlugin.setup` instead of `PendoFlutterPlugin.initSDKWithoutVisitor`:

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
<td align=center> clearVisitor </td>
<td>

```dart
// start a session with an anonymous visitor
await PendoFlutterPlugin.clearVisitor()
```

</td>
<td>

Call `PendoFlutterPlugin.startSession` with `null` values instead of `PendoFlutterPlugin.clearVisitor`:

```dart
// start a session with an anonymous visitor
await PendoFlutterPlugin.startSession(null, null, null, null);
```

</td>
</tr>

<!--- new row --->

<tr>
<td align=center> switchVisitor </td>
<td>

```dart
await PendoFlutterPlugin.switchVisitor('someVisitorID', 
            'someAccountID', 
            {'age': '25', 'country': 'USA'}, 
            {'tier': '1', 'size': 'Enterprise'});
```

</td>
<td>

Call `PendoFlutterPlugin.startSession` instead of `PendoFlutterPlugin.switchVisitor`:

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
<td align=center> setAccountId </td>
<td>

```dart
await PendoFlutterPlugin.setAccountId('someAccountID');
```

</td>
<td>

Call `PendoFlutterPlugin.startSession` with the new account id value instead of `PendoFlutterPlugin.setAccountId`:

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