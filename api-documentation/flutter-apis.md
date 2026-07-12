# Flutter public developer API documentation

> [!IMPORTANT]
>The `setup` API must be called before the `startSession` API. <br> 
> All other APIs must be called after both the `setup` and `startSession` APIs, otherwise they will be ignored. <br>
>The `setDebugMode` API is the exception to that rule and may be called anywhere in the code.

### PendoSDK APIs
[setup](#setup) ⇒ `void` <br>
[startSession](#startsession) ⇒ `void` <br>
[setVisitorData](#setvisitordata) ⇒ `void` <br>
[setAccountData](#setaccountdata) ⇒ `void` <br>
[endSession](#endsession) ⇒ `void` <br>
[track](#track) ⇒ `void` <br>
[pauseGuides](#pauseguides) ⇒ `void`<br>
[resumeGuides](#resumeguides) ⇒ `void` <br>
[dismissVisibleGuides](#dismissvisibleguides) ⇒ `void` <br>
[getDeviceId](#getdeviceid) ⇒ `String` <br>
[getVisitorId](#getvisitorid) ⇒ `String` <br>
[getAccountId](#getaccountid) ⇒ `String` <br>
[setDebugMode](#setdebugmode) ⇒ `void`<br>
[setSnapshotableWidgetTypes](#setsnapshotablewidgettypes) ⇒ `void` <br>
[setAnimatedSnapshotableWidgetTypes](#setanimatedsnapshotablewidgettypes) ⇒ `void` <br>

**Session Replay — Privacy Configuration**
<br>
[PendoReplayMask](#pendoreplaymask) ⇒ `Widget` <br>
[PendoReplayUnmask](#pendoreplayunmask) ⇒ `Widget` <br>
[PendoReplayBlock](#pendoreplayblock) ⇒ `Widget` <br>
[Widget extension sugar](#widget-extension-sugar) <br>
[Resolution priority](#resolution-priority) <br>
[Safety rail](#safety-rail) <br>
[Block behavior](#block-behavior) <br>

## PendoSDK APIs

### `setup`

```dart
static Future<void> setup(String appKey, {Map<String, dynamic>? pendoOptions}) async
```

>Establishes a connection with Pendo’s server. Call this API in your application’s main file (lib/main.dart). The setup method can only be called once during the application lifecycle. Calling this API is required before tracking sessions or invoking session-related APIs. 

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Class</b>: PendoSDK
<br><b>Kind</b>: static method
<br>
<b>Returns</b>: void
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| appKey | String | The App Key is listed in your Pendo Subscription Settings in App Details |
| pendoOptions | Map<String, dynamic>? | PendoOptions should be `null` unless instructed otherwise by Pendo Support |


<b>Example</b>:
    
```dart
await PendoSDK.setup('your.app.key', null);  
```
</details>


### `startSession`

```dart
static Future<void> startSession(String? visitorId, String? accountId, Map<String, dynamic>? visitorData, Map<String, dynamic>? accountData) async
```

>Starts a mobile session with the provided visitor and account information. If a session is already in progress, the current session will terminate and a new session will begin. The termination of the app will also terminate the session.

>To generate an anonymous visitor, pass 'nil' as the visitorId. Visitor data and Account data are optional.

> No action will be taken if the visitor and account IDs do not change when calling the startSession API during an ongoing session. 
 
<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>


<b>Class</b>: PendoSDK
<br><b>Kind</b>: static method
<br>
<b>Returns</b>: void
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| visitorId | String? | The session visitor ID. For an anonymous visitor set to `null` |
| accountId | String? | The session account ID |
| visitorData | Dictionary<string, object>? | Additional visitor metadata |
| accountData | Dictionary<string, object>? | Additional account metadata |


<b>Example</b>:
    
```dart
Map<String, dynamic> visitorData = {'age': 21, 'country': 'USA'};
Map<String, dynamic> accountData = {'Tier': 1, 'Size': 'Enterprise'};

await PendoSDK.startSession('John Doe', 'ACME', visitorData, accountData)
```

</details>

### `setVisitorData`

```dart
static Future<void> setVisitorData(Map<String, dynamic> visitorData) async
```

>Updates the visitor metadata of the ongoing session.
  
<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>


<b>Class</b>: PendoSDK
<br><b>Kind</b>: static method
<br>
<b>Returns</b>: void
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| visitorData | Map<String, dynamic> | The visitor metadata to be updated |


<b>Example</b>:
    
```dart
Map<String, dynamic> visitorData = {'age': 25, 'country': 'UK', 'birthday': '01-01-1990'};

await PendoSDK.setVisitorData(visitorData)
```

</details>

### `setAccountData`

```dart
static Future<void> setAccountData(Map<String, dynamic> accountData) async
```

>Updates the account metadata of the ongoing session.
  
<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>


<b>Class</b>: PendoSDK
<br><b>Kind</b>: static method
<br>
<b>Returns</b>: void
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| accountData | Map<String, dynamic> | The account metadata to be updated |


<b>Example</b>:
    
```dart
Map<String, dynamic> accountData = {'Tier': 2, 'size': 'Mid-Market', 'signing-date': '01-01-2020'};

await PendoSDK.setAccountData(accountData)

```

</details>

### `endSession`

```dart
static Future<void> endSession() async
```

>Ends the active session and stops collecting analytics or showing guides to the user. A new session can be started by calling the startSession API.

>This API is commonly used when the user logs out of your application.


  
<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>


<b>Class</b>: PendoSDK
<br><b>Kind</b>: static method
<br>
<b>Returns</b>: void
<br>

<b>Example</b>:
    
```dart
await PendoSDK.endSession(); 
```

</details>

### `track`

```dart
static Future<void> track(String event, Map<String, dynamic>? properties) async
```

>Sends a track event with the specified properties.

<details>
    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>

<b>Class</b>: PendoSDK<br>
<b>Kind</b>: static method<br>
<b>Returns</b>: void<br>
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| event | String | The track event name |
| properties | Map<String, dynamic>? | Additional metadata to be sent as part of the track event |

<b>Example:</b>

```dart
await PendoSDK.track('App Opened', {'Theme': 'Dark Mode'});
```
</details>

### `pauseGuides`

```dart
static Future<void> pauseGuides(bool dismissGuides) async
```

>Pauses any guides from appearing during an active session. If the `dismissGuides` value is set to `true`, then any visible guide will be dismissed. Calling this API affects the current session. Starting a new session reverts this logic, enabling guides to be presented.

<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Class:</b> PendoSDK<br>
<b>Kind:</b> static method<br>
<b>Returns:</b> void<br>
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| dismissGuides | bool | Determines whether the displayed guide, if one is visible, is dismissed when pausing the display of the further guides |

<b>Example:</b>

```dart
await PendoSDK.pauseGuides(false);
```
</details>


### `resumeGuides`

```dart
static Future<void> resumeGuides() async
```

>Resumes displaying guides during the ongoing session. This API reverses the logic of the `pauseGuides` API.

<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary>
<br>
<b>Class:</b> PendoSDK<br>
<b>Kind:</b> static method<br>
<b>Returns:</b> void<br>
<br>
<b>Example:</b>

```dart
await PendoSDK.resumeGuides();
```
</details>

### `dismissVisibleGuides`

```dart
static Future<void> dismissVisibleGuides() async
```

>Dismisses any visible guide.

<details>
<summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Class:</b> PendoSDK<br>
<b>Kind:</b> static method<br>
<b>Returns:</b> void<br>
<br>
<b>Example:</b>

```dart
await PendoSDK.dismissVisibleGuides();
```
</details>

### `getDeviceId`

```dart
static Future<String?> getDeviceId() async
```

>Returns the device's unique Pendo-generated ID. 

<details>
    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>
<br>
<b>Class:</b> PendoSDK<br>
<b>Kind:</b> static method<br>
<b>Returns:</b> String<br>
<br>
<b>Example:</b>

```dart
await PendoSDK.getDeviceId();
```
</details>

### `getVisitorId`

```dart
static Future<String?> getVisitorId() async
```

>Returns the ID of the visitor in the active session.

<details>
    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>
<br>
<b>Class:</b> PendoSDK<br>
<b>Kind:</b> static method<br>
<b>Returns:</b> String<br>
<br>
<b>Example:</b>

```dart
await PendoSDK.getVisitorId();
```
</details>

### `getAccountId`

```dart
static Future<String?> getAccountId() async
```

>Returns the ID of the account in the active session.

<details>
    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>
<b>Class:</b> PendoSDK<br>
<b>Kind:</b> static method<br>
<b>Returns:</b> String<br>
<br>
<b>Example:</b>

```dart
await PendoSDK.getAccountId();
```
</details>

### `setDebugMode`

```dart
static Future<void> setDebugMode(bool isDebugEnabled) async
```

>Enable/disable debug logs from Pendo SDK. To debug the Pendo SDK we recommend calling this API before calling the setup API.

>Debug logs are turned off by default. Releasing your production app with the debug logs enabled is not recommended and may have performance repercussions on your app.

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Class</b>: PendoSDK
<br><b>Kind</b>: static method
<br>
<b>Returns</b>: void
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| isDebugEnabled | bool | Set to `true` to enable debug logs, `false` to disable |


<b>Example</b>:

```dart
await PendoSDK.setDebugMode(true);
await PendoSDK.setup("your.app.key", null);
```
</details>

### `setSnapshotableWidgetTypes`

```dart
static void setSnapshotableWidgetTypes(Set<Type> types)
```

>Registers widget types that have no dedicated Session Replay extractor so they are captured as `<img>` render snapshots. Use this for **static** visual widgets such as `flutter_svg`'s `SvgPicture`. The snapshot is cached and reused across scans. For animated widgets, use [setAnimatedSnapshotableWidgetTypes](#setanimatedsnapshotablewidgettypes) instead.

>Registered types are treated as images for privacy purposes: the `img` selector in your privacy configuration blocks/masks them just like any other image, so vector or custom content cannot bypass your privacy rules. Call this API before the widgets are scanned (typically right after `setup`).

<details>
    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>

<b>Class</b>: PendoSDK<br>
<b>Kind</b>: static method<br>
<b>Returns</b>: void<br>
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| types | Set\<Type\> | The set of widget types to capture as static `<img>` render snapshots |

<b>Example:</b>

```dart
import 'package:flutter_svg/flutter_svg.dart';

PendoSDK.setSnapshotableWidgetTypes({SvgPicture});
```
</details>

### `setAnimatedSnapshotableWidgetTypes`

```dart
static void setAnimatedSnapshotableWidgetTypes(Set<Type> types)
```

>Like [setSnapshotableWidgetTypes](#setsnapshotablewidgettypes), but for **animated** widgets such as the `gif` package's `Gif` or Lottie. Registered types bypass the snapshot image cache, so each Session Replay scan re-captures the current frame and the widget animates (at the scan cadence) instead of freezing on its first captured frame. Use [setSnapshotableWidgetTypes](#setsnapshotablewidgettypes) for static widgets so they stay cached.

>Registered types are treated as images for privacy purposes: the `img` selector in your privacy configuration blocks/masks them just like any other image. Call this API before the widgets are scanned (typically right after `setup`).

<details>
    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary><br>

<b>Class</b>: PendoSDK<br>
<b>Kind</b>: static method<br>
<b>Returns</b>: void<br>
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| types | Set\<Type\> | The set of animated widget types to re-capture as `<img>` render snapshots on every scan |

<b>Example:</b>

```dart
import 'package:gif/gif.dart';
import 'package:lottie/lottie.dart';

PendoSDK.setAnimatedSnapshotableWidgetTypes({Gif, LottieBuilder});
```
</details>

## Session Replay — Privacy Configuration

> Session Replay privacy presets are configured server-side: `maxPrivacy` masks all captured text, and `onlyInput` masks input fields only. Under **both** presets, input fields (`TextField`, `TextFormField`) are masked by default. The APIs below let you override that default on a per-widget basis, in a subtree, or app-wide.

### `PendoReplayMask`

```dart
const PendoReplayMask({required Widget child, Key? key})
```

>Marks `child` (and its descendants, unless overridden by a closer wrapper) so its text is masked in Session Replay, overriding the active preset. Masking is **text-only** — use [PendoReplayBlock](#pendoreplayblock) to hide images or other non-text content.

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Class</b>: Widget (StatelessWidget)
<br><b>Kind</b>: wrapper widget
<br>
<b>Returns</b>: Widget
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| child | Widget | The subtree to mask in Session Replay |

<b>Example</b>:

```dart
PendoReplayMask(child: Text('Balance: \$42,850.00'))
```
</details>

### `PendoReplayUnmask`

```dart
const PendoReplayUnmask({required Widget child, Key? key})
```

>Marks `child` (and its descendants, unless overridden by a closer wrapper) to be captured as-is in Session Replay, overriding the active preset. Cannot reveal a [safety rail](#safety-rail) field.

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Class</b>: Widget (StatelessWidget)
<br><b>Kind</b>: wrapper widget
<br>
<b>Returns</b>: Widget
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| child | Widget | The subtree to capture unmasked in Session Replay |

<b>Example</b>:

```dart
PendoReplayUnmask(child: Text('Public marketing copy — safe to show'))
```
</details>

### `PendoReplayBlock`

```dart
const PendoReplayBlock({required Widget child, Key? key})
```

>Marks `child` and its whole subtree to be excluded from Session Replay. Every element in the subtree is captured as its own gray placeholder, so the layout is preserved but no content is read — including taps: interactions inside a blocked region are dropped, not just hidden, so tap coordinates over sensitive content (e.g. a PIN pad) never leave the device. Unconditionally terminal — nothing can cancel a block on a nested subtree. See [Block behavior](#block-behavior) for how nesting and always-blocked media interact with this wrapper.

<details>    <summary> <b>Details</b><i> - Click to expand or collapse</i></summary>

<br>

<b>Class</b>: Widget (StatelessWidget)
<br><b>Kind</b>: wrapper widget
<br>
<b>Returns</b>: Widget
<br>

| Param  | Type | Description |
| :---: | :---: | :--- |
| child | Widget | The subtree to exclude from Session Replay |

<b>Example</b>:

```dart
PendoReplayBlock(
  child: Container(
    padding: const EdgeInsets.all(12),
    child: const Text('Payment form (blocked)'),
  ),
)
```
</details>

### Widget extension sugar

>`PendoReplayWidgetExtension` adds fluent methods on `Widget` that are equivalent to wrapping — pick whichever call site reads better.

| Extension method | Equivalent to |
| :--- | :--- |
| `widget.pendoReplayMask()` | `PendoReplayMask(child: widget)` |
| `widget.pendoReplayUnmask()` | `PendoReplayUnmask(child: widget)` |
| `widget.pendoReplayBlock()` | `PendoReplayBlock(child: widget)` |

<b>Example</b>:

```dart
Text('Card #: 4242 4242 4242 4242').pendoReplayMask()
```

### Resolution priority

>Each widget's Session Replay treatment is resolved in this order, highest priority first:
>
>1. **Safety rail** — see [Safety rail](#safety-rail) below. Always wins except a stricter block.
>2. **Nearest wrapper** — the closest enclosing `PendoReplayMask`/`Unmask`/`Block` ancestor. A closer wrapper overrides a farther one, **except** `PendoReplayBlock` is unconditionally terminal: a nested `PendoReplayMask`/`PendoReplayUnmask` cannot downgrade an enclosing, still-active block — nothing can cancel it.
>3. **Preset** — falls through to the active `maxPrivacy` / `onlyInput` behavior when no wrapper applies.

For example, `PendoReplayBlock(child: PendoReplayMask(child: Text(...)))` still renders as a blocked placeholder, not masked text — the inner mask cannot escape the outer block. There is no wrapper that reveals part of a blocked subtree.

### Safety rail

>Always masked in Session Replay, regardless of preset or any `PendoReplayUnmask` wrapper — they cannot be revealed:
>- Password fields (`obscureText: true`).
>- Inputs with a `visiblePassword`, `emailAddress`, `phone`, or any numeric (`TextInputType.number`/`numberWithOptions`) keyboard type — covers PINs, card numbers, CVV codes, OTPs, and SSNs.
>- Inputs carrying a `password`, `newPassword`, `email`, `creditCardNumber`, `creditCardSecurityCode`, or `oneTimeCode` autofill hint, even with a default keyboard type (e.g. a password field shown via a "show password" toggle).
>
>A `PendoReplayBlock` around such a field still blocks it (block is stricter than mask, so it wins), but no wrapper can unmask a safety rail field.

### Block behavior

>- A blocked subtree ([PendoReplayBlock](#pendoreplayblock)) renders every descendant as its own gray placeholder — the layout is preserved, but content is never read and taps are never captured. Unconditionally terminal — no wrapper cancels a block on a nested subtree.
>- Embedded media that Session Replay cannot safely capture — `WebView` and `VideoPlayer` widgets — is **always** rendered as a placeholder, the same as an explicit block. This system-level block cannot be cancelled either.
>- Masking is text-only. To hide an image, video, or other non-text region, use `PendoReplayBlock` (or the existing block-images privacy configuration) instead of `PendoReplayMask`.
