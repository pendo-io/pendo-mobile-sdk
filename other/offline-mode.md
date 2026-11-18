# Offline Mode — Guides and Analytics Without a Connection

With offline mode on, Pendo keeps working when the device can't reach Pendo. Your users still see
the guides you set up for offline use, and their analytics are saved on the device and sent when
the connection returns.

| | |
|---|---|
| **Frameworks** | Native iOS, native Android, React Native (including Expo), Flutter, MAUI, Compose Multiplatform, Kotlin Multiplatform with native UI |
| **SDK version** | Pendo iOS and Android SDK **3.15.0 and later**, and the 3.15 release of each framework plugin |
| **Default** | Off |

> [!NOTE]
> Xamarin Forms doesn't support offline mode.

## Contents

- [What offline mode does](#what-offline-mode-does)
- [Requirements](#requirements)
- [Turn it on](#turn-it-on)
- [Set up guides for offline](#set-up-guides-for-offline)
- [How a session works](#how-a-session-works)
- [Analytics offline](#analytics-offline)
- [Limitations](#limitations)
- [Test it](#test-it)
- [FAQ](#faq)

---

## What offline mode does

Your app must be online the first time a visitor uses it. During that online session the SDK saves
what it needs on the device. After that, the app can start Pendo with no connection.

- **Guides.** Guides set to **Show only when offline** or **Show when online and offline** are saved
  on the device and shown when there's no connection. Guides set to **Show when online and offline**
  also show as usual while online.
- **Analytics.** Page views, feature clicks, track events and guide events are saved on the device
  and uploaded, oldest first, when Pendo can be reached again.
- **Session Replay.** If it's enabled for the visitor, recording continues offline and is uploaded
  later.
- **Guide display limits.** Each visitor's limits are kept offline. A guide set to show once doesn't
  show again after it's dismissed.

## Requirements

- Pendo iOS and Android SDK **3.15.0 or later**. For a cross-platform app, use the 3.15 release of
  the Pendo plugin, which depends on those native versions.
- An **identified visitor**: `startSession` needs a visitor ID. An account ID is optional.
  Anonymous visitors don't get offline guides.
- **One online session first**, on a build with offline mode on. The device must reach Pendo once
  before it can start offline.
- Guides set to show offline (see [Set up guides for offline](#set-up-guides-for-offline)).

## Turn it on

Set `offlineMode` in the options you pass to `setup`. Nothing else in your integration changes:
call `setup` and `startSession` as you do today.

> [!IMPORTANT]
> The SDK reads `offlineMode` once, when `setup` runs. Changing it later in the same app launch
> has no effect.

<details open><summary><b>Native iOS</b></summary>

```swift
let options = PendoOptions()
options.offlineMode = true
PendoManager.shared().setup("your.app.key", with: options)
```

```objc
PendoOptions *options = [[PendoOptions alloc] init];
options.offlineMode = YES;
[[PendoManager sharedManager] setup:@"your.app.key" withOptions:options];
```
</details>

<details><summary><b>Native Android</b></summary>

```java
Pendo.PendoOptions options = new Pendo.PendoOptions.Builder()
        .setOfflineMode(true)
        .build();
Pendo.setup(this, "your.app.key", options, null);
```

```kotlin
val options = Pendo.PendoOptions.Builder()
    .setOfflineMode(true)
    .build()
Pendo.setup(this, "your.app.key", options, null)
```
</details>

<details><summary><b>React Native and Expo</b></summary>

```typescript
const navigationOptions = {library: NavigationLibraryType.ReactNavigation};
PendoSDK.setup('your.app.key', navigationOptions, {offlineMode: true});
```
</details>

<details><summary><b>Flutter</b></summary>

```dart
await PendoSDK.setup('your.app.key', pendoOptions: {'offlineMode': true});
```
</details>

<details><summary><b>MAUI</b></summary>

```c#
var options = new Dictionary<string, object> { { "offlineMode", true } };
Pendo.Setup("your.app.key", options);
```
</details>

<details><summary><b>Compose Multiplatform</b></summary>

```kotlin
Pendo.setup(
    appKey = "your.app.key",
    options = PendoOptions(offlineMode = true),
)
```
</details>

<details><summary><b>Kotlin Multiplatform with native UI</b></summary>

Set the option in each platform's native `setup` call, as shown for native iOS and native Android
above.
</details>

## Set up guides for offline

Each guide has a **Connectivity** setting that decides when it can show. To change it, open the
guide in the Visual Design Studio and select **Activation** in the top bar. **Connectivity** is the
first section of **Activation settings**. Choose an option, then select **Save**.

| Connectivity setting | Shows online | Shows offline | Saved on the device |
|---|---|---|---|
| **Show only when online** (the default) | Yes | No | No |
| **Show only when offline** | No | Yes | Yes |
| **Show when online and offline** | Yes | Yes | Yes |

Use **Show only when offline** for content that only makes sense without a connection, for example
"You're offline. Your changes will sync later." Use **Show when online and offline** for guides that
should reach users wherever they are.

> [!WARNING]
> **Offline-only guides need offline mode.** If the app hasn't turned on `offlineMode`, guides set to
> **Show only when offline** never show. On iOS, the SDK logs a warning in the console that names
> each one.

**Design tips for offline guides**

- **Avoid images.** Images aren't saved for offline use, so a step that has an image can't show
  offline. Use text, buttons and colors.
- **Avoid web content.** Anything that loads from the internet, such as links, embedded video or
  remote images, won't load offline.
- **Use priority to pick the winner.** When several guides could show, the SDK uses the same order
  online and offline.

## How a session works

1. **First launch, online.** The SDK starts as usual and saves the visitor, your app's Pendo
   settings, and the guides marked for offline use, with their content.
2. **Later launch, offline.** `setup` and `startSession` complete from the saved data with no
   network calls. Saved guides show where they're targeted, and analytics are saved on the device.
3. **Connection drops during a session.** A guide already on screen continues. From then on, only
   guides set to show offline can start.
4. **Connection comes back.** Saved analytics upload automatically, oldest first. Guides set to
   **Show only when offline** stop showing. The guide list itself refreshes at the next online
   `startSession`.
5. **Next online launch.** Saved analytics finish uploading before guides are fetched, so Pendo
   knows which guides the visitor already saw or dismissed offline. The saved guides are then
   replaced with the latest ones.

**How long saved guides last.** Each online session refreshes the saved guides. A saved guide that
hasn't been refreshed online for **5 days** isn't shown. A guide that's no longer published, or no
longer targets the visitor, is removed after the next online session.

**Several visitors on one device.** Guides and display counts are kept separately for each visitor
and account, so one visitor's dismissals never affect another's. Each visitor needs their own online
session before they can get offline guides.

## Analytics offline

Saving analytics on the device doesn't depend on offline mode. What offline mode adds is the ability
to **start** a session with no connection.

| Situation | Offline mode off | Offline mode on |
|---|---|---|
| The session started online, then the connection drops | Saved, sent on reconnect | Saved, sent on reconnect |
| The app is closed before the events are sent | Kept, sent at the next online launch | Kept, sent at the next online launch |
| The app launches with no connection | Not collected until Pendo can be reached | Saved, sent on reconnect |

- Events are deleted from the device only after Pendo confirms it received them.
- Each event keeps the visitor and account it happened under, even if a different visitor starts a
  session before the upload.
- Every event carries a `deviceOffline` field (`true` or `false`), so you can tell offline activity
  apart in Pendo.
- Saved events have a storage limit. If the device stays offline long enough to reach it, the oldest
  events are dropped first.

For storage limits, upload batching and Session Replay offline behavior, see the
[iOS data handling reference](/ios/pnddocs/offline-support-ios.md).

## Limitations

| Limitation | What happens |
|---|---|
| Images in guides | Images aren't saved for offline use. A step with images doesn't show offline. |
| Anonymous visitors | No offline guides. Analytics are still saved and sent later. |
| First use of a device | The first launch must be online. If it isn't, Pendo doesn't start until a launch reaches Pendo. |
| Snoozed guides | Snooze isn't applied offline. |
| Initialization callbacks | The SDK's "initialized" notification or callback fires only after an online start, not when the session starts from saved data. |
| Wi-Fi with a sign-in page | On a hotel or airport network that hasn't been signed in to, the SDK may try to reach Pendo instead of starting from saved data, so offline guides might not show for that launch. |
| Xamarin Forms | Not supported. |

## Test it

1. In Pendo, publish a guide set to **Show only when offline** (**Activation** → **Connectivity**)
   that targets a screen in your app. Keep it to text and buttons.
2. Run a build with `offlineMode` on. Start a session online with a visitor ID, then open a few
   screens.
3. Close the app completely and turn on Airplane Mode.
4. Launch the app and go to the targeted screen. The guide shows.
5. Turn off Airplane Mode. Within a minute, the saved events upload and show up in Pendo with their
   original times.

> [!TIP]
> Test on a real device. A simulator or emulator that still has a network route can behave
> differently from a device with no connection.

## FAQ

**Does offline mode change anything when the device is online?**
Guides and analytics work as before. The SDK also saves your offline guides and the visitor's
settings on the device, and offline-only guides never show while online.

**Where is the data stored?**
In your app's private storage on the device. It doesn't include your access token.

**What happens when a visitor dismisses a guide offline?**
The dismissal counts toward the guide's display limit right away, on that device, for that visitor.
It reaches Pendo with the rest of the saved analytics.

**What happens if I turn offline mode off in a later release?**
The SDK stops saving and reading offline guide data, and offline-only guides stop showing. Saved
analytics are still uploaded.

**Do I need to change how I call `startSession` or `endSession`?**
No. Call them as you do today; the SDK decides whether to start online or from saved data.

For help, contact Pendo Support with your SDK version, whether offline mode is on, and console logs
from a launch with debug logging enabled.
