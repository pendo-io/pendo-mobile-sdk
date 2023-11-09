# Flutter Migration From 2.x to 3.x


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

Replace `PendoFlutterPlugin.initSDK` by calling `PendoFlutterPlugin.setup` and then `PendoFlutterPlugin.startSession`:

<b>2.x:</b>

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

Call `PendoFlutterPlugin.setup` instead of `PendoFlutterPlugin.initSDKWithoutVisitor`:

<b>2.x:</b>

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

Call `PendoFlutterPlugin.startSession` with `null` values instead of `PendoFlutterPlugin.clearVisitor`:

<b>2.x:</b>

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

Call `PendoFlutterPlugin.startSession` instead of `PendoFlutterPlugin.switchVisitor`:

<b>2.x:</b>

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

Call `PendoFlutterPlugin.startSession` with the new account id value instead of `PendoFlutterPlugin.setAccountId`:

<b>2.x:</b>

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