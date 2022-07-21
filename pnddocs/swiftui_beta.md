# SwiftUI Integration 
Currently SwiftUI support is provided as beta and is available via cocoapods and SPM:<br>

## Cocoapods
```
    #Place it at the top of your Podfile
    source 'https://github.com/pendo-io/specs-beta.git'
    source 'https://github.com/CocoaPods/Specs.git'
```

Add Pendo pod with all rest of the pods:
`pod 'Pendo'`

## SPM
In the SPM search for _pendo_ and use `swiftui_beta` branch:<br>
<img width="700" alt="SPM" src="https://user-images.githubusercontent.com/56674958/180163385-59639b68-df10-4d85-bd72-08dca771bd51.png">
 
### Integration
Pure swiftUI apps don't include `AppDelegate` file by default. Please create an `AppDelegate` file and complete the following steps:<br> 
In the _AppDelegate_ file <br>

```swift
import UIKit
import Pendo
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let key = "YOUR_KEY"
        //please note the following API will only setup initial configuration, to start collect analytics use start session
        PendoManager.shared().setup(key)
        return true
    }
}
```
As soon as you have the  user to which you want to relate your guides and analytics please call:

```swift
PendoManager.shared().startSession("visitor1", accountId: "account1", visitorData:[], accountData: [])
```

SwiftUI applications **don't respond** to the method <br>
 `application(_ app: UIApplication,open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool` <br>
  when the app entry point is a struct attributed with `@main`.<br>
In this case please add `.onOpenURL(perform:)` to your main view, for instance:
```swift
@main
struct YourApp: App {
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        return WindowGroup {
            TabView {
                YourView().tabItem {
                    Image("Icon")
                    Text("Text")
                }
            }
            .onOpenURL(perform: handleURL)
        }
    }
    
    func handleURL(_ url: URL) {
        _ = appDelegate.application(UIApplication.shared, open: url, options: [:])

    }
``` 

### Project Setup
To setup the Pendo pairing mode (tagging and test on device) select your project, navigate to the relevant target, select the info tab and create a URL Type using the Pendo url scheme (found in your subscription under the App Details tab)

<img src="https://user-images.githubusercontent.com/56674958/144723345-15c54098-28db-414c-90da-ef4a5256ae6a.png" width="500" height="300">
