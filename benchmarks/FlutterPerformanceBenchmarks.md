## Performance benchmarks

These measurements of the SDK are captured using Pendo’s testing applications and may differ among applications, depending on their screen complexity and user interaction.

### SDK performance

|                | Size Impact | Memory Impact | CPU Impact\* |
|     :---:      |     :---:   |     :---:     |    :---:     |   
|    Flutter     |    103 KB   | (~) 60-200KB  |   (~) 10%    |

<b>\*</b> Slight CPU impact may occur during app launch or UI-intensive operations.

### SDK network usage
**Outgoing traffic**

The analytics captured by the SDK include starting a session, the application state (foreground and background), screen changing, clicks, guide events, and manual track events. 
The size of each analytic event varies from 1KB to 9KB.

** These benchmarks relate to the performance of Pendo's Flutter plugin. to see the native benchmark behind it, please visit the [Native benchmarks](https://github.com/pendo-io/pendo-mobile-sdk/benchmarks/NativePerformanceBenchmarks.md) page.