# Analytics & Session Replay — Data Handling and Offline Support (Android)

This document explains how the Pendo Android SDK collects, stores, and uploads its two data
streams — **analytics** and **Session Replay** — and how each behaves when the device can't
reach Pendo.

> [!NOTE]
> - Describes Android SDK **3.15.0 and later**. In 3.15.0 analytics moved to an on-device
>   database. On the first launch after upgrading, events that an older SDK saved and didn't send
>   are moved into the database and sent as usual.
> - Android-specific. Storage and upload rules run in the native layer, so React Native, Flutter,
>   MAUI and Compose Multiplatform apps on Android behave the same way.
> - Most values below have a default set by Pendo and can be changed through backend
>   configuration per subscription, **up to a fixed maximum** that the backend cannot exceed.
> - This page covers data handling only, with or without offline mode. To show guides and start
>   sessions with no connection, see [Offline mode](/other/offline-mode.md).

## Contents

- [Analytics](#analytics)
  - [How analytics data is handled](#how-analytics-data-is-handled)
  - [Analytics offline behavior](#analytics-offline-behavior)
- [Session Replay](#session-replay)
  - [How Session Replay data is handled](#how-session-replay-data-is-handled)
  - [Session Replay offline behavior](#session-replay-offline-behavior)
- [Offline signals](#offline-signals)
- [Configuration reference](#configuration-reference)

---

## Analytics

### How analytics data is handled

Analytics events (screen views, clicks, track events, guide events, session lifecycle, etc.) are
saved to an on-device database as soon as they happen, then uploaded in batches:

```
event  →  on-device database  →  upload to backend
```

1. Each new event is saved to the database, so it survives the app closing or crashing.
2. When a **flush trigger** fires (see below) and Pendo can be reached, the SDK uploads the saved
   events, oldest first.
3. Events are deleted from the database only after the backend confirms it received them. If an
   upload fails, they stay saved and are retried later.

**Flush triggers** — the SDK uploads whenever any one of these is reached:

| What triggers an upload | Default | Backend key | Hard limit |
|---|---|---|---|
| Number of events saved since the last upload | 20 events | `bufferQueueSize` | 1000 |
| Time since last upload | 30 s | `bufferDuration` | 600 s |
| An "urgent" event occurs | immediate | `immediateEvents` | — |
| Pendo becomes reachable again | immediate | — | — |

The **Default** column is the value built into the SDK. Pendo backend configuration can override
it per subscription, but only up to the **Hard limit**. For example, the SDK's built-in event count
is 20, while the backend commonly overrides it to 10.

**Urgent events** trigger an immediate upload of **everything currently saved**, not just the
urgent event itself. Default urgent events: `AppSessionEnd`, `AppInBackground`, `guideDismissed`,
`guideSnoozed`. `AppInBackground` always triggers an upload, even if the backend list leaves it out.

**Batches.** The flush trigger decides *when* to upload, not how much goes in one request. Each
request carries up to **50 events** or **1 MB**, whichever comes first, and the SDK sends one
request after another until everything that was saved when the upload started has been sent.
Each request contains the events of a single visitor and account, so events saved under one
visitor are always sent under that visitor, even if another visitor starts a session first.

**After `endSession`.** Timed uploads, retries and reconnect uploads pause until the next session
starts. The upload that `endSession` itself triggers still runs. Anything left is sent during the
next session.

### Analytics offline behavior

While Pendo can't be reached, the SDK doesn't attempt uploads. Events keep accumulating in the
database until the connection returns.

- **Storage cap.** The database is capped (default 10 MB, up to 1000 MB). When it goes over the
  cap, the SDK deletes the **oldest** events until it's back down to 80% of the cap, then keeps
  collecting. So the newest events are always kept. Events in an upload that's in progress are
  never deleted.
- **Reconnect.** When Pendo becomes reachable again, the SDK starts uploading right away, in the
  batches described above, oldest first.
- **Retry backoff.** After a failed upload the SDK waits before trying again: 30 s, then doubling
  each time (60 s, 120 s, …) up to 600 s, for up to 10 retries. After that it stops retrying until
  the next flush trigger. The backoff resets after a successful upload or when Pendo becomes
  reachable again.
- **Relaunch recovery.** Events saved on the device from a previous run are uploaded the next time
  the SDK starts, before guides are fetched, so Pendo knows what the visitor did while offline.
- **`deviceOffline` field.** Every event carries `deviceOffline` (`true` or `false`), so you can
  tell activity collected without a connection apart in Pendo.

---

## Session Replay

### How Session Replay data is handled

Session Replay records the screen as a series of snapshots. Each snapshot is packaged into an
**envelope**, saved to a local database, and then uploaded. Saving before uploading is called
**store-then-forward**.

```
snapshot  →  envelope  →  saved to on-device database  →  upload
```

- Saved envelopes are uploaded oldest first, up to **5 at a time**. The SDK checks for more to
  send every **2 seconds** until nothing is left.
- An envelope is deleted only after it uploads successfully. If an upload fails, the envelope stays
  saved and is retried on a later pass.
- Uploads run only while **the app is in the foreground**, Pendo can be reached, and the transport
  policy below allows the current network. When any of those changes back, uploading resumes on
  its own.

**Transport policy** (`networkTransportMode`) controls whether replay data may upload over a
metered (for example, cellular) connection. Recording itself is never affected, only *when* the
data is uploaded.

| Mode | Behavior |
|---|---|
| `wifiAndCellular` (default) | Upload over any connection |
| `wifiOnly` | Keep data on the device while on a metered network; upload once on an unmetered one |

Until the Session Replay configuration has loaded, the SDK uploads only on an unmetered network.

**On-device storage:** capped at 250 MB by default (see below).

### Session Replay offline behavior

While Pendo can't be reached, recorded data stays in the local database and is uploaded when the
connection returns.

- **Storage cap.** The database is capped (default 250 MB, backend-configurable via
  `offlineStorageLimit`). The envelope that reaches the cap is saved and marked (see
  [Offline signals](#offline-signals)). After that, new envelopes are **dropped** while the
  database is full. New envelopes are saved again as soon as uploads free space.
- **Recovery.** Anything left in the database is uploaded the next time the app runs, so
  recordings survive an app close or crash. An upload interrupted by the app closing is retried.
- **With offline mode on.** The SDK also saves each visitor's Session Replay configuration, so a
  session that starts with no connection can still record. See [Offline mode](/other/offline-mode.md).

---

## Offline signals

The SDK reports when data was collected offline, or when the storage limit was hit, in three ways.

### 1. Session Replay envelope fields

Each Session Replay envelope carries two flags:

| JSON key | Meaning |
|---|---|
| `isOfflineMode` | `true` if Pendo couldn't be reached when this data was captured. |
| `isOfflineLimitReached` | `true` on the envelope recorded right as the storage cap was hit. Not set on any other envelope. |

### 2. Analytics events

The SDK automatically emits these analytics events (they appear alongside your other Pendo
analytics):

| Event | Emitted when |
|---|---|
| `AppOffline` | Pendo stops being reachable. |
| `AppOnline` | Pendo becomes reachable again. |
| `AppOfflineLimitReached` | The Session Replay storage cap (default 250 MB) is reached. |

`AppOffline` and `AppOnline` come from the Session Replay component, so they're reported only once
it has started in the app. They track whether Pendo can be reached, not Wi-Fi ↔ cellular switches.

### 3. The `deviceOffline` field

Every analytics event carries `deviceOffline`: `true` if Pendo couldn't be reached when the event
happened.

---

## Configuration reference

| Area | Setting (backend key) | Changeable by backend? | Default | Notes |
|---|---|---|---|---|
| Analytics | Upload trigger count (`bufferQueueSize`) | Yes | 20 events | Max 1000; commonly set to 10 |
| Analytics | Time interval (`bufferDuration`) | Yes | 30 s | Max 600 s |
| Analytics | Storage cap (`maxStorageSizeMB`) | Yes | 10 MB | Max 1000 MB |
| Analytics | Urgent events (`immediateEvents`) | Yes | `AppSessionEnd`, `AppInBackground`, `guideDismissed`, `guideSnoozed` | Uploaded immediately |
| Analytics | Batch size per request | Fixed | 50 events or 1 MB | Whichever comes first |
| Analytics | Overflow behavior | Fixed | Drop oldest, trim to 80% of cap | Events being uploaded are kept |
| Analytics | Retry backoff | Fixed | 30 s → doubles → 600 s max, 10 retries | Resets on success or reconnect |
| Session Replay | Storage cap (`offlineStorageLimit`) | Yes | 250 MB | Backend value sent in bytes |
| Session Replay | Overflow behavior | Fixed | Drop new envelopes while full | Resumes when uploads free space |
| Session Replay | Transport policy (`networkTransportMode`) | Yes | `wifiAndCellular` | `wifiAndCellular` or `wifiOnly` |
| Session Replay | Uploads in parallel | Fixed | 5 envelopes | Checked every 2 s |
| Session Replay | Upload conditions | Fixed | App in foreground, Pendo reachable | Plus the transport policy |

For the iOS equivalent, see [iOS data handling reference](/ios/pnddocs/offline-support-ios.md).
