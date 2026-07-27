# Analytics & Session Replay — Data Handling and Offline Support (iOS)

This document explains how the Pendo iOS SDK collects, stores, and uploads its two data
streams — **analytics** and **Session Replay** — and how each behaves when the device is
offline.

> ### ⚠️ Version scope
> The **analytics** behavior described here is accurate up to SDK 3.14; the analytics
> pipeline is being rewritten after 3.14.

> ### Notes
> - iOS-specific. Storage and transport rules run in the native layer, so React Native,
>   Flutter, Xamarin, and MAUI apps inherit this behavior (see [Cross-platform](#cross-platform)).
> - Most values below have a default set by Pendo and can be changed through backend
>   configuration per subscription, **up to a fixed maximum** that the backend cannot
>   exceed.

## Contents

- [Analytics](#analytics)
  - [How analytics data is handled](#how-analytics-data-is-handled)
  - [Analytics offline behavior](#analytics-offline-behavior)
- [Session Replay](#session-replay)
  - [How Session Replay data is handled](#how-session-replay-data-is-handled)
  - [Session Replay offline behavior](#session-replay-offline-behavior)
- [Offline signals](#offline-signals)
- [Configuration reference](#configuration-reference)
- [Cross-platform](#cross-platform)

---

## Analytics

### How analytics data is handled

Analytics events (screen views, clicks, track events, guide events, session lifecycle,
etc.) are not uploaded one at a time. The SDK collects them, saves them to on-device
storage, and uploads them in batches:

```
event  →  in-memory queue  →  on-device storage  →  upload to backend
```

1. Each new event goes into a small in-memory queue.
2. From the queue, events are moved into the persistent on-device buffer. Once in the buffer,
   events are saved to storage and survive the app closing.
3. When a **flush trigger** fires (see below) and the device has a connection, the buffered
   events are uploaded. They are deleted from the buffer only after the backend confirms it
   received them; if the upload fails, they stay in the buffer and are retried later.

**Flush triggers** — the SDK uploads whenever any one of these is reached:

| What triggers an upload | Default | Backend key | Hard limit |
|---|---|---|---|
| Number of queued events | 20 events | `bufferQueueSize` | 1000 |
| Time since last upload | 30 s | `bufferDuration` | 300 s |
| An "urgent" event occurs | immediate | `immediateEvents` | — |

The **Default** column is the value built into the SDK. Pendo backend configuration can
override it per subscription, but only up to the **Hard limit** — the backend cannot go
beyond those ceilings (they are fixed in the SDK). For example, the SDK's built-in event
count is 20, while the backend commonly overrides it to 10.

**Urgent events** trigger an immediate upload, skipping the count and time triggers. This
flushes **everything currently buffered**, not just the urgent event itself. Default urgent
events: `AppSessionEnd`, `AppInBackground`, `GuideDismissed`, `GuideSnoozed`.

**Rough event size** — varies a lot by app and screen complexity, so treat these as
estimates, not fixed values. In memory (uncompressed), click and screen-change events are
in the same ballpark, roughly **2–9 KB each** (either can be larger depending on the
screen); lifecycle events (e.g. session start) are ~0.3 KB. On the network each event is
gzipped as part of the batch, roughly **4–6× smaller** — about **1–1.5 KB** for a typical
click or screen-change event.

### Analytics offline behavior

While offline, uploads simply fail, so events keep accumulating in on-device storage until
the connection returns.

- **Storage cap.** The buffer is capped (default 10 MB, up to 500 MB). When it reaches the
  cap, the SDK deletes the **oldest** events until the buffer is back down to 80% of the
  cap, then keeps collecting. So the newest events are always kept.
- **Reconnect.** When the connection returns, the SDK uploads everything it has stored in
  one request — it does not trickle it out in small batches.
- **Retry backoff.** After a failed upload the SDK waits before trying again: 1 s, then
  doubling each time (2 s, 4 s, …) up to a maximum of 60 s. The wait resets after a
  successful upload or when the connection returns.
- **Crash / relaunch recovery.** Events saved on the device from a previous run are
  uploaded the next time the SDK starts, so nothing is lost across an app close or crash.
- **Back-dated session end.** Pendo ends a session if the app is sent to the background and
  not reopened within the inactivity timeout (default 30 min). The session-end event is
  timestamped with the moment the app was actually backgrounded — not the moment Pendo
  later noticed the timeout — so the reported session length stays correct. 

---

## Session Replay

### How Session Replay data is handled

Session Replay records the on-screen view hierarchy as a series of snapshots. Each
snapshot is packaged into an **envelope**, encoded with Pendo's **JZB** format
(gzip-compressed JSON), saved to a local database, and then uploaded. Saving before
uploading is called **store-then-forward**.

```
snapshot  →  envelope (JZB-encoded)  →  saved to on-device database  →  upload
```

- A saved item is deleted only after it uploads successfully. If it can't be sent yet
  (offline, or blocked by the transport policy below), it stays in the database and is
  retried later.
- To avoid flooding the network, the SDK uploads saved items in small groups sized to the
  connection: up to **10 at a time on WiFi**, **3 at a time on cellular**.
- **Image compression.** Images are the largest part of a snapshot, so before they're
  embedded the SDK renders each at **0.8 scale** and encodes it as **JPEG at 10% quality**.
  Each encoded image is also **cached per image**, so an image that appears in multiple
  snapshots is only rendered and encoded once. The whole envelope is then gzipped (JZB) on
  top of that. This keeps both CPU/memory and upload size down — often shrinking each image
  to just a few percent of its original size (roughly 10–20× smaller).

**Transport policy** (`networkTransportMode`) controls whether replay data may upload over
a metered (e.g., cellular) connection. Recording itself is never affected — only *when* the
data is uploaded.

| Mode | Behavior |
|---|---|
| `wifiAndCellular` (default) | Upload over any connection |
| `wifiOnly` | Keep data on the device while on cellular; upload once on WiFi |

**On-device storage:** capped at 250 MB by default (see below).

### Session Replay offline behavior

While offline, recorded data stays in the local database and is uploaded when the
connection returns. Two guardrails protect the device:

- **Storage cap (pause / resume).** The database is capped (default 250 MB,
  backend-configurable via `offlineStorageLimit`). When it fills to the cap, the SDK
  **stops recording** so it won't use more space. Once uploads bring it back below **80%**
  of the cap, recording **resumes**. The gap between stopping at 100% and resuming at 80%
  keeps recording from flickering on and off right at the limit.
- **Low device storage.** Separately, if the whole device drops below **300 MB** of free
  space, the SDK pauses recording so it doesn't fill up the user's phone.
- **Retry then discard.** If uploading a saved item keeps timing out, the SDK retries up
  to 3 times, then discards it so it can't block everything behind it.
- **Recovery.** Anything left in the database is uploaded the next time the app launches,
  so recordings survive an app close or crash.

---

## Offline signals

The SDK reports when data was collected offline, or when the storage limit was hit, in two
ways.

### 1. Session Replay envelope fields

Each Session Replay item carries two flags:

| JSON key | Meaning |
|---|---|
| `isOfflineMode` | `true` if the device had no internet when this data was captured. |
| `isOfflineLimitReached` | `true` on the single item recorded right as the storage cap was hit. Not set on any other item. |

### 2. Analytics events

The SDK automatically emits these analytics events (they appear alongside your other Pendo
analytics):

| Event | Emitted when |
|---|---|
| `AppOffline` | The device loses internet during an active Session Replay session. |
| `AppOnline` | The device regains internet — only after a matching `AppOffline`. |
| `AppOfflineLimitReached` | The Session Replay storage cap (default 250 MB) is reached. At most once per session. |

`AppOffline` / `AppOnline` track internet loss/restore only — not WiFi ↔ cellular switches.
The 300 MB low-device-storage pause does **not** emit `AppOfflineLimitReached`.

---

## Configuration reference

| Area | Setting (backend key) | Changeable by backend? | Default | Notes |
|---|---|---|---|---|
| Analytics | Batch size (`bufferQueueSize`) | Yes | 20 events | Max 1000; commonly set to 10 |
| Analytics | Time interval (`bufferDuration`) | Yes | 30 s | Max 300 s |
| Analytics | Storage cap (`maxStorageSizeMB`) | Yes | 10 MB | Max 500 MB |
| Analytics | Urgent events (`immediateEvents`) | Yes | `AppSessionEnd`, `AppInBackground`, `GuideDismissed`, `GuideSnoozed` | Uploaded immediately |
| Analytics | Overflow behavior | Fixed | Drop oldest, trim to 80% of cap | Offline / retry only |
| Analytics | Retry backoff | Fixed | 1 s → doubles → 60 s max | Resets on success/reconnect |
| Analytics | Session timeout | Yes | 30 min | Back-dates session end |
| Session Replay | Storage cap (`offlineStorageLimit`) | Yes | 250 MB | Backend value sent in bytes |
| Session Replay | Resume threshold | Fixed | 80% of cap | Recording pauses at 100% |
| Session Replay | Low-device-storage pause | Fixed | 300 MB free | Pauses recording |
| Session Replay | Transport policy (`networkTransportMode`) | Yes | `wifiAndCellular` | `wifiAndCellular` or `wifiOnly` |
| Session Replay | WiFi upload group size | Fixed | 10 items | Items uploaded per group on WiFi |
| Session Replay | Cellular upload group size | Fixed | 3 items | Items uploaded per group on cellular |
| Session Replay | Upload retries | Fixed | 3 | Then discarded |

---
