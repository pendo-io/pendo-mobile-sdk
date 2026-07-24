# Analytics & Session Replay — Data Handling and Offline Support (iOS)

This document describes how the Pendo iOS SDK handles the two data streams it produces
— **analytics** and **Session Replay** — from the moment data is captured on the device
until it reaches the Pendo backend. Offline behavior is part of this story, not a
separate mode: the same buffering and persistence that let the SDK batch and retry
uploads are also what let it survive periods without connectivity. We describe the full
pipeline first, then call out what specifically happens while offline.

We start with **analytics**, then cover **Session Replay**.

> ### ⚠️ Version scope
> The **analytics** data-handling described here is accurate **up to SDK 3.14**. The
> analytics on-device data-handling model is being **rewritten in 3.14**, so on 3.14 and
> later the analytics buffering/persistence behavior differs — verify against the release
> notes for that version. The **Session Replay** behavior in this document is not affected
> by that rewrite.

> ### Notes
> - iOS-specific. Storage and transport policy are enforced in the native layer, so
>   React Native, Flutter, Xamarin, and MAUI apps inherit this behavior (see
>   [Cross-platform](#cross-platform)).
> - The parameters below are set by Pendo backend configuration. Defaults are listed;
>   values can be adjusted per subscription on request.

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
etc.) are not uploaded one-by-one as they occur. They are collected on the device,
persisted to durable on-device storage, batched, and uploaded together. Persisting
before sending is what lets the SDK batch efficiently and survive periods without
connectivity.

```
event → in-memory queue → persistent on-device buffer → (flush trigger + online) → backend
                                     │
                              removed only after the backend confirms receipt
```

- Events first collect in a small in-memory queue, which moves them into the persistent
  buffer in small groups (**default: every 2 events**, or immediately for an *urgent*
  event).
- The persistent buffer holds events until a **flush trigger** fires. When the device is
  online, the batch is uploaded and removed only after the backend confirms receipt; if
  the upload fails, the events stay on device.

**Flush triggers & limits** — these govern how often data is uploaded and how much may
accumulate. All are backend-configurable per subscription:

| Parameter | What it controls | Default | Backend key | Max |
|---|---|---|---|---|
| Batch size | Upload after this many events | 20 events\* | `bufferQueueSize` | 1000 |
| Time interval | Upload at least this often | 30 s | `bufferDuration` | 300 s |
| Buffer cap | Max on-device accumulation | 10 MB | `maxStorageSizeMB` | 500 MB |
| Urgent events | Events that force an immediate upload | see below | `immediateEvents` | — |

\* The SDK's built-in fallback is 20 events; production backend configuration commonly
sets this to 10.

**Urgent events** upload immediately, bypassing the batch-size and time triggers. By
default: `AppSessionEnd`, `AppInBackground`, `GuideDismissed`, `GuideSnoozed`. The list
is backend-configurable via `immediateEvents`.

**On-device consumption:** disk is bounded by the buffer cap (default 10 MB); memory is
just the small in-memory queue.

### Analytics offline behavior

Because events are persisted before they're sent, losing connectivity changes only one
thing: uploads can't complete, so events accumulate in the on-device buffer instead of
being removed.

- **Accumulation cap.** The buffer is capped (default 10 MB, backend-configurable via
  `maxStorageSizeMB`, up to 500 MB). If accumulation exceeds the cap, the SDK discards
  the **oldest** events first (FIFO), trimming back down to 80% of the cap and keeping
  the newest data. This trimming happens only while offline or while retrying after a
  failed upload — never during healthy online operation.
- **Reconnect.** When connectivity returns, the SDK uploads everything currently in its
  buffer in a single request — it does **not** drip the backlog out in small batches
  (subject to the buffer cap).
- **Retry backoff.** After a failed upload the SDK waits before retrying, starting at
  **1 s** and **doubling** on each failure up to a **60 s** cap. The delay resets on the
  next successful upload or when connectivity is restored.
- **Crash / relaunch recovery.** Events still on device from a previous session are
  re-loaded and uploaded on the next SDK launch, so data survives an offline period
  followed by an app kill or crash.
- **Back-dated session end.** If a session ends because the app was backgrounded past
  the inactivity timeout (default 30 min), the SDK stamps the session-end events with
  the time the app was actually backgrounded — not the time it was next launched — so
  session duration stays accurate. (This applies to the background-timeout path only;
  it is not reconstructed after a hard crash.)

---

## Session Replay

### How Session Replay data is handled

Session Replay captures the on-screen view hierarchy as a stream of snapshot payloads.
Each payload is wrapped in an envelope, encoded, and — following the same
persist-before-send model as analytics — written to a local on-device database before
any upload (this is called **store-then-forward**).

```
capture snapshot → envelope → encode → persist to on-device DB → upload in batches
                                             │                          │
                                             │        success → payload removed
                                             │        offline / blocked → payload kept
                                             ▼
                                  drained by a flush loop when uploads are allowed
```

- A payload is removed only after it's successfully uploaded; if it can't be sent yet
  (offline, or blocked by transport policy), it stays for a later flush.
- Uploads happen in **batches**, paced to the connection so they don't saturate it: on
  **WiFi, 10 payloads every 100 ms**; on **cellular, 3 payloads every 500 ms**.
- **Recording size roll.** A single recording is limited to **100 MiB** of encoded data
  (`recordingSizeLimit`). When a recording reaches that size, the SDK closes it and
  starts a new recording segment (a new recording ID). This keeps any one recording
  bounded rather than growing without limit during long sessions.
- **Inactivity cutoff.** If the app stays in the background for **30 minutes**
  (`inactivityDuration`), or loses internet, the current recording is finalized.

**Transport policy** (`networkTransportMode`) controls whether replay data may be
uploaded over a metered (e.g., cellular) connection. Recording is never affected — only
when the already-recorded data is uploaded.

| Mode | Behavior |
|---|---|
| `wifiAndCellular` (default) | Upload over any connection with internet |
| `wifiOnly` | Hold data on device over metered connections; upload once on WiFi / unmetered |

**On-device consumption:** disk is bounded by the offline storage cap (default
250 MiB). All Session Replay sizes use MiB (1024² bytes).

### Session Replay offline behavior

Store-then-forward means an offline period is handled by simply letting persisted
payloads accumulate in the local database until they can be uploaded, with two
guardrails that protect device storage:

- **SR storage cap + pause/resume.** The on-device SR store has a cap (default
  **250 MiB**, backend-configurable via `offlineStorageLimit`). When the store fills to
  the cap, the SDK **stops recording** so it won't consume more space. It **resumes
  recording** only once enough buffered data has uploaded to bring the store back below
  **80%** of the cap. The 100% → 80% gap is deliberate: it prevents recording from
  rapidly stopping and starting right at the limit.
- **Device free-space guard.** Independently of the SR cap, if the device's own free
  storage falls below **300 MiB**, the SDK pauses recording to avoid filling up the
  user's device.
- **Retry then discard.** A queued payload that repeatedly times out on upload is
  retried up to **3 times**, then dropped so it can't block the queue indefinitely.
- **Recovery.** Anything still in the local database is uploaded on the next launch, so
  recorded data survives an app kill or crash.

---

## Offline signals

The SDK reports when data was collected offline, or when a storage limit was hit, so
this is visible on the backend. There are two mechanisms.

### 1. Session Replay envelope fields

Each SR payload carries two flags:

| JSON key | Meaning |
|---|---|
| `isOfflineMode` | `true` if the device had no internet when this data was captured. |
| `isOfflineLimitReached` | `true` on the single payload recorded right as the SR storage cap was hit. Not set on any other payload. |

### 2. Analytics events

The SDK automatically emits these analytics events (they appear alongside your other
Pendo analytics):

| Event | Emitted when |
|---|---|
| `AppOffline` | The device loses internet during an active Session Replay session. |
| `AppOnline` | The device regains internet — only after a matching `AppOffline`. |
| `AppOfflineLimitReached` | The SR storage cap (default 250 MiB) is reached. At most once per session. |

`AppOffline` / `AppOnline` track internet loss/restore only — not WiFi ↔ cellular
switches. The 300 MiB device free-space guard does **not** emit
`AppOfflineLimitReached`.

---

## Configuration reference

| Area | Parameter (backend key) | Configurable? | Default | Notes |
|---|---|---|---|---|
| Analytics | Batch size (`bufferQueueSize`) | Backend | 20 events | Up to 1000; production commonly 10 |
| Analytics | Time interval (`bufferDuration`) | Backend | 30 s | Up to 300 s |
| Analytics | Buffer cap (`maxStorageSizeMB`) | Backend | 10 MB | Up to 500 MB |
| Analytics | Urgent events (`immediateEvents`) | Backend | `AppSessionEnd`, `AppInBackground`, `GuideDismissed`, `GuideSnoozed` | Force immediate upload |
| Analytics | Overflow trim target | Fixed | 80% of cap | Oldest-first; offline/backoff only |
| Analytics | Retry backoff | Fixed | 1 s → ×2 → 60 s | Reset on success/reconnect |
| Analytics | Session timeout | Fixed | 30 min | Back-dates session end |
| Session Replay | Offline storage cap (`offlineStorageLimit`) | Backend | 250 MiB | Wire value in **bytes** |
| Session Replay | Resume threshold | Fixed | 80% of cap | Pairs with 100% pause |
| Session Replay | Device free-space guard | Fixed | 300 MiB | Pauses recording |
| Session Replay | Recording size roll (`recordingSizeLimit`) | Backend | 100 MiB | Starts a new recording ID |
| Session Replay | Inactivity cutoff (`inactivityDuration`) | Backend | 30 min | Wire value in **ms** |
| Session Replay | Transport policy (`networkTransportMode`) | Backend | `wifiAndCellular` | `wifiAndCellular` \| `wifiOnly` |
| Session Replay | WiFi upload pacing | Fixed | 10 / 100 ms | Batch size / interval |
| Session Replay | Cellular upload pacing | Fixed | 3 / 500 ms | Batch size / interval |
| Session Replay | Queued-payload retries | Fixed | 3 | Then discarded |

---

## Cross-platform

Offline **storage** and **transport policy** are enforced in the native iOS layer.
Session Replay data for React Native, Flutter, Xamarin, and MAUI flows through the same
native handler, so those platforms inherit this behavior automatically. Correspondingly,
the storage/transport policy keys (`offlineStorageLimit`, `networkTransportMode`) are
native-only and are not forwarded across the cross-platform bridges.
