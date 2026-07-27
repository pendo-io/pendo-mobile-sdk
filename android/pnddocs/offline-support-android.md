# Analytics & Session Replay — Data Handling and Offline Support (Android)

This document explains how the Pendo Android SDK collects, stores, and uploads its two data
streams — **analytics** and **Session Replay** — and how each behaves when the device is
offline.

> [!IMPORTANT]
> **Required manifest permission.** The Pendo SDK requires `ACCESS_NETWORK_STATE` in addition to
> `INTERNET`. The SDK does not declare either one, so your app's manifest must:
>
> ```xml
> <uses-permission android:name="android.permission.INTERNET" />
> <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
> ```
>
> Both are normal permissions — granted at install time, never prompted for. Without
> `ACCESS_NETWORK_STATE` the SDK treats the device as always connected and unmetered, which
> means the `wifiOnly` transport policy has no effect, `isOfflineMode` is always `false`, and
> the `AppOffline` / `AppOnline` events are never emitted.

## At a glance

| | Analytics | Session Replay |
|---|---|---|
| Stored in | Files in app-internal storage | SQLite database in app-internal storage |
| Default cap | 10 MiB (max 100 MiB) | 250 MiB |
| Behavior at the cap | Oldest events dropped | New recordings dropped, existing kept |
| Uploads while backgrounded | Yes | No |
| Uploads on a metered connection | Yes | Depends on `networkTransportMode` |
| Survives app kill / crash | Yes | Yes |
| Compressed on the wire | No | Yes (zlib deflate) |

Everything below is configured by Pendo per subscription — there is no app-side API for these
values. Contact Pendo Support to change them.

> [!NOTE]
> - Android-specific. An equivalent iOS document covers the iOS SDK. **The two platforms do not
>   share all of these values**, so do not read one as a substitute for the other.
> - Storage and transport rules run in the native Android layer, so React Native, Flutter,
>   Xamarin, and MAUI apps inherit this behavior (see [Cross-platform](#cross-platform)).
> - **Units.** Storage sizes are binary: 1 MiB = 1,048,576 bytes. Backend keys whose names say
>   `MB` (such as `maxStorageSizeMB`) are interpreted by the SDK as MiB.
> - **Version scope.** This describes Android SDK **3.13.9 and later**. Values were verified
>   against the 3.14 development branch; the analytics and Session Replay storage and transport
>   layers are unchanged from 3.13.9, so the behavior below applies to both.

## Contents

- [Analytics](#analytics)
  - [How analytics data is handled](#how-analytics-data-is-handled)
  - [Analytics offline behavior](#analytics-offline-behavior)
- [Session Replay](#session-replay)
  - [How Session Replay data is handled](#how-session-replay-data-is-handled)
  - [Session Replay offline behavior](#session-replay-offline-behavior)
- [On-device footprint](#on-device-footprint)
- [Offline signals](#offline-signals)
- [Configuration reference](#configuration-reference)
- [Cross-platform](#cross-platform)

---

## Analytics

### How analytics data is handled

Analytics events (screen views, clicks, track events, guide events, session lifecycle, etc.)
are not uploaded one at a time. They pass through three buffers — one in memory and two on
disk — before being uploaded in a batch:

```
event  →  in-memory queue  →  staging file  →  main buffer file  →  upload to backend
          3 events or 1 s    5 events or 5 s   flushed at 15 events or 30 s
```

| Stage | Where | Moves on | Configurable |
|---|---|---|---|
| In-memory queue | RAM | 3 events or 1 s | No |
| Staging buffer | File in app-internal storage | 5 events or 5 s | No |
| Main buffer | File in app-internal storage | 15 events or 30 s | Yes (see below) |

An event therefore reaches disk within a few seconds of being captured, so almost nothing is
lost if the app is killed. Only the **main buffer** is uploaded, and its contents are deleted
after the backend returns a success response — if the upload fails, the events stay on disk and
are retried. (One path deviates from this; see
[When buffered analytics can be lost](#when-buffered-analytics-can-be-lost).)

**Flush triggers** — the SDK uploads the main buffer whenever any one of these happens:

| What triggers an upload | Default | Backend key | Hard limit |
|---|---|---|---|
| Number of queued events | 15 events | `bufferQueueSize` | 1000 |
| Time since last upload | 30 s | `bufferDuration` | 300 s |
| An "urgent" event occurs | immediate | `immediateEvents` | — |
| Connectivity is restored | immediate | — | — |
| The app goes to the background | immediate | via `immediateEvents` | — |
| A new session starts, or the visitor/account changes | immediate | via `immediateEvents` | — |

The **Default** values can be changed by Pendo backend configuration per subscription, but only
up to the **Hard limit** — the backend cannot go beyond those ceilings, which are fixed in the
SDK. A configured value of `0` or less is ignored and the previous value is kept, so `0` cannot
be used to disable buffering.

The last two triggers are indirect: backgrounding and session end flush the in-memory queue, and
the resulting upload happens because `AppInBackground` and `AppSessionEnd` are in the default
urgent-event list. A subscription that overrides `immediateEvents` without those entries loses
those upload triggers.

There is **no size-based flush trigger**. The storage cap described below sheds events; it does
not trigger an upload.

**Urgent events** are uploaded immediately, skipping the count and time triggers. The default
list is `guideDismissed`, `guideSnoozed`, `AppSessionEnd`, `AppInBackground`. Matching is
case-sensitive against the event's `event` or `type` field.

**Wire format.** The batch is uploaded as a single `application/json; charset=UTF-8` array,
streamed using chunked transfer encoding rather than buffered into memory. **Analytics payloads
are not compressed** — only Session Replay compresses its payloads.

**Configuration persistence.** Whenever the backend supplies new buffer settings, the SDK stores
them on the device and reloads them on the next cold start, before any network call. So the
buffering behavior at launch is whatever the backend last configured, not the built-in defaults.

### Analytics offline behavior

While offline, uploads simply fail, so events keep accumulating in the main buffer file until
the connection returns.

- **Storage cap.** The main buffer is capped at **10 MiB by default, up to a fixed maximum of
  100 MiB** (`maxStorageSizeMB`). When the file exceeds the cap, the SDK deletes the **oldest**
  events until it is back down to **80% of the cap**, then keeps collecting, so the newest
  events are always kept. Note that the target is 80% of the *cap*, not 80% of the current size:
  if the file is far over cap (for example because the cap was just lowered), a single trim can
  drop much more than 20%. If no complete event survives the trim point, the buffer is cleared.
- **What the cap covers.** The cap applies to the main buffer only. The staging buffer is
  uncapped, but it drains every 5 events or 5 seconds, so it stays small.
- **When the cap is enforced.** The check runs when a send is attempted with no connectivity, and
  when new events arrive while an upload is already in flight. Between those points the file can
  briefly sit above the cap.
- **Reconnect.** When the connection returns, the SDK uploads everything it has stored in **one
  request** — it does not trickle it out in batches of `bufferQueueSize`. After a long offline
  period this can be a single request carrying the full buffer, which is why it is streamed
  rather than held in memory.
- **Retry backoff.** After a failed upload the SDK waits **30 s**, then doubles the wait each
  time (60 s, 120 s, 240 s, 480 s) up to a maximum of **600 s (10 minutes)**. A cycle schedules
  at most **9 retries** before giving up; the events stay on disk and are picked up by the next
  ordinary trigger (new events, reconnect, or the next app launch). The backoff resets only
  after a *successful* upload. If a cycle ends without one — because retries ran out, or simply
  because connectivity dropped mid-retry — the next cycle starts straight at the 600 s maximum
  instead of ramping up again. That second case is the common one when a device goes offline.
- **Back-dated session end.** Pendo ends a session if the app is sent to the background and not
  reopened within the inactivity timeout (default 30 min, `sessionTimeout`). The session-end
  event is timestamped with the moment the app was actually backgrounded — not the moment Pendo
  later noticed the timeout — so the reported session length stays correct. The backgrounding
  time is persisted, so this holds even if the process was killed in between.

#### Crash and relaunch recovery

Events left on disk from a previous run are uploaded when the SDK next starts. Partial writes
from a process that was killed mid-upload are detected and discarded without losing the events
themselves.

SDK initialization waits for that flush to complete before fetching its configuration. If the
app is launched **offline with a backlog on disk**, that flush cannot complete, so initialization
stays pending until connectivity returns — no configuration is fetched and no guides are shown
in the meantime. Event collection continues normally throughout, and everything proceeds once
the device is back online. If you are debugging "guides don't appear after an offline launch,"
this is the reason.

#### When buffered analytics can be lost

Buffered events are durable across app kills and crashes, with two exceptions worth knowing:

- **Kill switch.** If Pendo disables the SDK for your subscription, the buffers are discarded
  rather than uploaded, and collection stops.
- **Switching visitors on a secure (JWT) session.** Ending a session for a JWT visitor drains
  both buffers and uploads them out-of-band under the previous visitor's credentials. Unlike the
  normal path, the buffers are cleared as part of that operation, so if the device is offline at
  that moment the pending events are not retried. This path also reads the buffered events into
  memory rather than streaming them, so switching visitors after a long offline period with a
  large cap raises peak memory. If your app switches JWT visitors frequently, prefer a smaller
  `maxStorageSizeMB`.

---

## Session Replay

### How Session Replay data is handled

Session Replay records the on-screen view hierarchy as a series of snapshots. Snapshots are
grouped into an **envelope**, serialized to JSON, saved to a local SQLite database, and only
then uploaded. Saving before uploading is called **store-then-forward**.

```
snapshot  →  envelope (JSON)  →  row in on-device SQLite database  →  upload
```

- There is no fast path that skips the database — every envelope is persisted first, online or
  not.
- A row is deleted only after its upload returns an HTTP 2xx. If it can't be sent yet (offline,
  backgrounded, or blocked by the transport policy below), it stays in the database and is
  retried later. Delivery is at-least-once: if a response is lost after the backend committed
  the data, the row is uploaded again.
- **Compression.** The envelope JSON is compressed with **zlib deflate** at send time
  (`Content-Encoding: deflate`). Compression happens on the wire only — the database stores the
  uncompressed JSON.
- **Image encoding.** Images are the largest part of a snapshot. Each is encoded as **WebP at
  quality 80** and embedded inline as a `data:image/webp;base64,…` URI. Encoding is deferred
  until the envelope is serialized, so it stays off the capture path. Views captured through the
  native (non-Compose) path are encoded at their natural size; Jetpack Compose applies the
  render bounds described under [Memory](#memory).

**Upload pacing.** The SDK drains the database with at most **5 uploads in flight at a time**,
re-checking every **2 seconds**. This pacing is the same on every connection type — there is no
separate WiFi and cellular rate. Unusually large envelopes are read one at a time instead of in
a batch, which reduces throughput while they are being drained.

**Transport policy** (`networkTransportMode`) controls whether replay data may upload over a
metered connection. Recording itself is never affected — only *when* the data is uploaded.

| Mode | Behavior |
|---|---|
| `wifiAndCellular` (default) | Upload over any connection |
| `wifiOnly` | Keep data on the device while on a metered connection; upload once unmetered |

Two details worth knowing:

- **Before the first configuration response arrives in a process, the SDK behaves as
  `wifiOnly`.** This is deliberate — it avoids spending metered data before the subscription's
  policy is known. Once configuration is fetched, the backend value applies; if the backend omits
  the key entirely, it falls back to `wifiAndCellular`.
- **"WiFi" means unmetered, not literally WiFi.** The decision is based on the connection's
  metered flag, so a metered WiFi hotspot is treated as cellular, and a cellular connection the
  system reports as unmetered is treated as WiFi.

**Uploading also requires the app to be in the foreground.** Draining stops when the app is
backgrounded and resumes when it returns, so replay data is never uploaded behind the user's
back.

### Session Replay offline behavior

While offline, recorded data stays in the local database and is uploaded when the connection
returns.

- **Storage cap.** Session Replay's on-device footprint is bounded by `offlineStorageLimit`,
  **250 MiB by default**. The limit is set by Pendo per subscription; contact Pendo Support if
  you need it adjusted for your app. It is measured against the **uncompressed** JSON that is
  stored, so the amount actually sent over the network for a full buffer is considerably
  smaller. The count is taken on the JSON string length rather than its encoded byte length, so
  for screens with substantial non-Latin text the real byte size on disk runs slightly above the
  configured figure.
- **Behavior at the cap.** Recording, scanning, and envelope construction continue unchanged;
  only *persistence* stops. Envelopes produced while the database is full are dropped, and the
  envelope that crossed the limit is flagged (see [Offline signals](#offline-signals)) so the
  backend knows where the gap starts. As soon as uploads free space, the next envelope is stored
  again. There is no pause/resume threshold and no dead band around the limit.
- **Low device storage.** If a write fails because the device is out of space, the envelope is
  dropped and recording continues — Session Replay never blocks the app or surfaces an error
  because of low disk.
- **Retry.** Failed uploads are retried on the next drain cycle rather than discarded, so a
  transient network or server error never costs you a recording. A row is removed only once the
  backend confirms receipt. The trade-off is that an envelope the backend permanently rejects is
  retried indefinitely and continues to occupy space against the cap; because envelopes are
  dropped at the cap rather than evicted, that reduces the space available for new recordings.
- **Recovery.** Anything left in the database is uploaded the next time the app launches and
  comes to the foreground, so recordings survive an app close or crash. Rows that were still
  uploading when the process died are automatically released for retry.
- **Session end does not discard buffered data.** When a session ends or times out, the current
  envelope is flushed; rows already in the database are unaffected and are still uploaded later.
- **Snapshots can be dropped before they reach an envelope.** Captured snapshots are handed to
  the recording pipeline through a small bounded queue. If persistence is slower than capture —
  most likely with a large buffer on a slow device — snapshots are dropped at that point rather
  than queued without limit.

---

## On-device footprint

### Disk

| Stream | Location | Bound |
|---|---|---|
| Analytics | Files in app-internal storage | 10 MiB by default, up to 100 MiB (`maxStorageSizeMB`) |
| Session Replay | SQLite database in app-internal storage | 250 MiB by default (`offlineStorageLimit`) |

Both are internal-storage only. Neither stream writes to external or shared storage, and both
are removed with the app's data on uninstall or "Clear data".

Two caveats when sizing for worst case:

- **Analytics uses more than the cap while uploading.** Alongside the two buffer files, the SDK
  writes a short-lived snapshot of the region being uploaded and a scratch file used when
  trimming. Peak analytics disk during an upload-and-compact cycle is roughly **two to three
  times** the configured cap.
- **The Session Replay database does not shrink.** SQLite reuses freed pages rather than
  returning them to the filesystem, so after a large offline buffer drains, the database file
  stays near its high-water mark. Treat 250 MiB as the steady-state size after a long offline
  period, not just the peak.

### Memory

Analytics memory use is negligible on the normal path — at most a handful of events in RAM, and
uploads are streamed from disk rather than loaded whole. The JWT visitor-switch path described
[above](#when-buffered-analytics-can-be-lost) is the exception.

Session Replay's memory cost is dominated by bitmaps during a scan. Captured bitmaps are
normally `ARGB_8888` — **4 bytes per pixel** — though a source already in a narrower format such
as `RGB_565` is kept as-is:

| Capture path | Allocation per image | Bounded? |
|---|---|---|
| Native view snapshot | view width × height × 4 | No — scales with view size |
| Native drawable / `ImageView` | drawable bounds × 4 | No |
| Compose painter render | render size × 4 | Yes, see below |
| Compose `PixelCopy` / software-draw fallback | captured region × 4 | No |

**Compose render bounds.** A source image smaller than the box it is drawn in is scaled up to
cover that box, but never beyond **500 px on the longest side** — so a small vector in a large
container renders at 500 px, not at the container's size. A source larger than its box is scaled
down to the larger of the box size or 500 px. Two cases opt out: `ContentScale.None`, which keeps
the source's intrinsic pixel size, and painters that report no intrinsic size, which render at
the node's own dimensions with no cap.

Other factors that affect the peak:

- **Hardware bitmaps** (for example from Coil or Glide with `Config.HARDWARE`) cannot be read
  directly. On the Compose path they are copied to a software bitmap first, which transiently
  holds two copies of the image. On the native `ImageView` path there is no copy — the image
  cannot be read at all and is replaced with a blocked-content placeholder in the recording.
- **On Compose, the peak is a whole-scan sum, not a per-image peak.** Extracted bitmaps stay
  reachable until the envelope is serialized, so the peak is roughly the sum of all on-screen
  images, plus one full-screen buffer if a fallback capture is used.
- **Bitmaps are not pooled or reused** between scans; each scan allocates fresh and relies on
  garbage collection.
- **Uploading holds envelopes in memory.** Each in-flight upload holds its JSON payload and its
  compressed copy, so a reconnect drain adds up to five of those on top of any capture activity.
- Scans are debounced (350 ms by default, 1200 ms timeout) so a burst of UI changes produces one
  capture, not one per change.

The practical implication: on screens with many large images — full-bleed photos, image grids,
media players — Session Replay's transient memory use scales with the pixels on screen. Use
Pendo's privacy and blocking configuration to exclude such views if memory headroom is a concern.

---

## Offline signals

The SDK reports when data was collected offline, or when the storage limit was hit, in two ways.

### 1. Session Replay envelope fields

Each Session Replay envelope carries two flags:

| JSON key | Meaning |
|---|---|
| `isOfflineMode` | `true` if the device had no internet when this envelope was captured. |
| `isOfflineLimitReached` | `true` on the envelope that crossed the storage cap — the point where the recording starts having gaps. |

`isOfflineMode` is written when the envelope is stored and is never rewritten, so an envelope
captured offline still reports `true` when it is uploaded later. It reflects actual connectivity
only: an envelope buffered because of the `wifiOnly` policy reports `false`.

`isOfflineLimitReached` marks a single envelope per fill cycle. If the buffer drains and later
fills again, a new envelope carries the flag.

### 2. Analytics events

The SDK automatically emits these analytics events (they appear alongside your other Pendo
analytics):

| Event | Emitted when |
|---|---|
| `AppOffline` | The device loses internet connectivity. |
| `AppOnline` | The device regains internet connectivity. |
| `AppOfflineLimitReached` | The Session Replay storage cap is reached. |

`AppOffline` / `AppOnline` fire on **connectivity transitions only**. No event is emitted for the
initial state at startup, so the first event you see is always a change from whatever the state
was when the SDK started.

Do not assume the two are strictly paired. Emission is suppressed whenever the SDK is not
currently permitted to send analytics — for example between sessions — while the underlying
connectivity state still advances, so a transition during such a window is silently skipped. You
can therefore observe an `AppOnline` with no preceding `AppOffline`. Treat them as best-effort
indicators rather than a balanced ledger.

These events are also produced by the Session Replay subsystem, which is initialized after the
SDK's first successful handshake with the backend. An app that is offline from its very first
launch emits no connectivity events until that handshake completes.

Two things they do **not** track: WiFi ↔ cellular switches, and the `wifiOnly` transport policy.
A `wifiOnly` subscription sitting on cellular is buffering data but is not offline, so no
`AppOffline` is emitted.

`AppOfflineLimitReached` fires each time the buffer fills, which can be more than once per
session if the buffer drains and refills.

---

## Configuration reference

| Area | Setting (backend key) | Changeable by backend? | Default | Notes |
|---|---|---|---|---|
| Analytics | Batch size (`bufferQueueSize`) | Yes | 15 events | Max 1000 |
| Analytics | Time interval (`bufferDuration`) | Yes | 30 s | Max 300 s |
| Analytics | Storage cap (`maxStorageSizeMB`) | Yes | 10 MiB | Max 100 MiB |
| Analytics | Urgent events (`immediateEvents`) | Yes | `guideDismissed`, `guideSnoozed`, `AppSessionEnd`, `AppInBackground` | Uploaded immediately |
| Analytics | Session timeout (`sessionTimeout`) | Yes | 1800 s (30 min) | Back-dates session end |
| Analytics | In-memory / staging buffers | Fixed | 3 events or 1 s / 5 events or 5 s | Not configurable |
| Analytics | Overflow behavior | Fixed | Drop oldest, trim to 80% of cap | Main buffer only |
| Analytics | Retry backoff | Fixed | 30 s → doubles → 600 s max, up to 9 retries | Resets only on success |
| Analytics | Payload compression | Fixed | None | Plain JSON, chunked upload |
| Session Replay | Storage cap (`offlineStorageLimit`) | Yes | 250 MiB | Sent in bytes |
| Session Replay | Transport policy (`networkTransportMode`) | Yes | `wifiAndCellular` | `wifiOnly` until the first config response arrives |
| Session Replay | Envelope batching (`recordingPayloadSendingFrequencyTime`) | Yes | Backend-supplied | Time before an envelope is sent |
| Session Replay | Envelope batching (`recordingPayloadSendingFrequencyEvents`) | Yes | Backend-supplied | Snapshots per envelope |
| Session Replay | Concurrent uploads | Fixed | 5 | Same on WiFi and cellular |
| Session Replay | Drain interval | Fixed | 2000 ms | Same on WiFi and cellular |
| Session Replay | Upload retries | Fixed | Unlimited | No discard-on-failure |
| Session Replay | Foreground-only upload | Fixed | Yes | Draining pauses while backgrounded |
| Session Replay | Image encoding | Fixed | WebP, quality 80 | Inline base64 data URI |
| Session Replay | Compose render cap | Fixed | 500 px longest side | See [Memory](#memory) for the exact rule |
| Session Replay | Payload compression | Fixed | zlib deflate | Applied at send time |
| Session Replay | Scan debounce / timeout | No | 350 ms / 1200 ms | Set locally via `PendoOptions` |

---

## Cross-platform

Everything described above is enforced in the **native Android layer**. React Native, Flutter,
Xamarin, MAUI, and KMP integrations all route their captured data through the same storage,
transport, and offline logic — the frameworks differ only in how the view hierarchy is
collected, never in how the resulting data is stored or sent.

Consequences worth noting:

- The `ACCESS_NETWORK_STATE` requirement described at the top of this document applies to every
  integration, including plugin-based ones.
- There is no plugin-level API to change the storage cap or the transport policy. Both come from
  backend configuration and are applied natively.
- Flutter receives the Session Replay configuration over the bridge, including
  `networkTransportMode` and `offlineStorageLimit` when the backend supplies them, but these are
  enforced natively rather than on the Dart side.
