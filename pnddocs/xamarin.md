
## Xamarin
### 1. Adding Pendo dependecy 
In Visual Studio `Project->Manage Nuget Packages` search for _pendo_ and add the **pendo-sdk-IOS**

### 2. Integration
```csharp
using Pendo;
[Register("AppDelegate")]
public partial class AppDelegate : FormsApplicationDelegate {
        public override bool FinishedLaunching(UIApplication app, NSDictionary options) {
            string appKey = "YOUR_KEY";
            //please note the following API will only setup initial configuartion, to start collect analytics use start session
            PendoManager.SharedManager().setup(appKey);
            return base.FinishedLaunching(app, options);
        }
        //This step is done to alllow capture mode (taging/testing)
        public override bool OpenUrl(UIApplication application, NSUrl url, string sourceApplication, NSObject annotation) {
            if (url.Scheme.Contains("pendo")) {
                Pendo.PendoManager.SharedManager().InitWithUrl(url);
                return true;
            }
            //Your code here...
            return true;
        }
 }
 
```
As soon as you have the user to which you want to relate your guides and analytics call:
```
Pendo.PendoManager.SharedManager().StartSession("visitor1", "account1", null, null);
```
