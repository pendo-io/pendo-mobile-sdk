## Performance benchmarks

These measurements of the SDK are captured using Pendo’s testing applications and may differ among applications, depending on their screen complexity and user interaction.

### SDK performance

|                | Size Impact\*  |  Battery Impact  | Memory Impact |  CPU Impact\*\* |
|     :---:      |     :---:     |       :---:       |     :---:     |     :---:       |   
|    Android     |    +2.7MB     |        Low        |   (~) +27MB   |      Low        |
|      iOS       |    +5.7MB     |        Low        |    (~) +4MB   |      Low        |

<b>\*</b> Size impact regarding the release builds, available through Google Play or App Store.
<br>
<b>\*\*</b> Slight CPU impact may occur during app launch or UI-intensive operations.

### SDK network usage

The Pendo SDK network traffic consists of two parts:
* The SDK initialization process to establish a connection between the device and Pendo’s server, starting a session and fetching any guides relevant to the session.
* During the session, ongoing analytics are sent in bulk from the device. 

**Incoming traffic** (during the session startup)

|    No guides   | A single guide with three steps | A single guide with nine steps |
|     :---:      |              :---:              |              :---:             |
|   Up to 40KB   |            Up to 64KB           |           Up to 90KB           |

Network requests are executed in parallel, prioritizing guides with higher priority to be downloaded first and becoming available earlier during the initialization process of the session. For example, guides with an app launch trigger will be available immediately, while lower-priority guides may take a few additional seconds to be available during the session.

**Outgoing traffic**

The analytics captured by the SDK include starting a session, the application state (foreground and background), screen changing, clicks, guide events, and manual track events. The size of each analytic event varies from 1KB to 6.5KB.

**Network usage example**

A session with a single guide including four steps, 6 session analytics, 42 page transitions, 65 feature clicks, 13 guide events
and 3 track events, recorded ~120KB of data received and ~320KB of data transmitted.

