
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
### 3. Project setup
Add Pendo URL Scheme to info.plist file

<img alt="Screen Shot 2021-12-08 at 16 39 20" src="https://user-images.githubusercontent.com/56674958/145228026-f7a5af6c-33c9-4174-afc9-a0295dd6844e.png" width="500" height="300">

## Pivots
Please pay attention to the following APIs: ``` setup ``` and ```startSession``` the former *must* be called once per session and will create initial setup for the SDK, the later should be called whenever you have the visitor you would like to assign the analytics/guides to. In case you would like to have an anonymous visitor pass ```nil``` to the ```startSession``` and call it again as soon as you have the vistor. 

