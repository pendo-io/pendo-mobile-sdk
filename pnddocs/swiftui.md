# SwiftUI Integration 
Currently SwiftUI support is provided as beta and is available via cocoapods and SPM:<br>
The codeless solution is supported with IOS 15 and 16. Screen tracking is available since IOS 13. (For Iphones)

## Cocoapods
Add Pendo pod with all rest of the pods:
`pod 'PendoSwiftUI'`

## SPM
In the SPM search for _pendo_ and use `swiftui` branch:<br>
<img width="700" alt="SPM" src="https://user-images.githubusercontent.com/56674958/188460208-254ef03d-fef9-49f4-a1e6-5751eb0ee4e4.png">
 
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
        //// the following API is required to initialize the SDK. To begin the collection of analytics and the usage of guides a call to the startSession method is required as well
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
  if the app entry point is a struct attributed with `@main`.<br>
If this is the case, please add `.onOpenURL(perform:)` to your main view. See the following code example:
Please note `.environment(\.accessibilityEnabled, true)` must be applied to main rootView of the app.
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
            .environment(\.accessibilityEnabled, true) 
            .onOpenURL(perform: handleURL)
        }
    }
    
    func handleURL(_ url: URL) {
        _ = appDelegate.application(UIApplication.shared, open: url, options: [:])

    }
``` 

### Project Setup
To setup the Pendo pairing mode (tagging and test on device) select your project, navigate to the relevant target, select the info tab and create a URL Type using the Pendo url scheme (found in your subscription under the App Details tab)

<img src="https://user-images.githubusercontent.com/56674958/144723345-15c54098-28db-414c-90da-ef4a5256ae6a.png" width="500" height="300"> <br>


# SwiftUI readiness list

This documentation reflects the current progress of Pendo SDK SwiftUI codeless solution.<br>
Please note that its still in beta and some elements may not be accurate in all scenarios,<br> 
please open a ticket with code sample in case you find a bug

## Screen tracking 

Screen change events are still supported by UIKit implementation with some additional enhancement from SwiftUI<br>
In addition to UIKit screen change event data Pendo will try to add unique SwiftUI identifier to make sure the analytics are consistent with each screen.<br>
Currently screen change events will be triggered by embeding the content of the app in `NavigationView`, `TabView`, `NavigationLink`, `ActionSheet`, `Sheets`, `PopOvers`

## Accessibility Support
In case you don't add accessibility modifiers ios will generate a default ones based on the ui elements of your app.
We should have the support of label/identifier/hint. <br>
Complex Nested accessibility forms might not be supported 

## Controls support

| SwiftUI | UIKit | Status |
|:---:|---|---|
| Button | N/A |:white_check_mark: Taggable, Analytics on click (see *LIMITATION* section)|
| onTapGesture (modifier) | N/A |:white_check_mark: Taggable, Analytics on click (see *LIMITATION* section)|
| Toggle | UISwitch | :white_check_mark: Taggable, Analytics on click |
| Stepper | UIStepper | :white_check_mark: Taggable, Analytics on click |
| Picker | UIPicker | :white_check_mark: Taggable, Analytics on click |
| List | UITableView | :white_check_mark: Taggable, Analytics on click |
| ToolbarItem | N/A | :white_check_mark: Taggable, Analytics on click |
| Menu | N/A | Not Supported

## UIKit In SwiftUI
UIKit elements should be supported by default.

## SwiftUI In UIKit 
SwiftUI is represented by `UIHostingController` when its embeded in UIKit the support is default SwiftUI support.

## Limitation 
:technologist: - Dynamic Content (content that appears after your screen was loaded, like data loaded from server) currently not supported, please use `screenContentChanged` for those screens <br>
:technologist: - Clickable elements buttons/tapGestures etc. When you create a clickable from element tha doesn't has background color of its own like VStack, HStack please set a background color to it (which is NOT transparent)
:technologist: - SwiftUI beta components like `PresentationContainers` are not supported yet 

## NOTE
We are highly recommend to use the following sample apps to tag features and see how Pendo ananlytics works.
(Please pay attention: to *PENDO CHANGE* comments where in some places we needed to have a minor changes)<br>

ACHNBrowserUI - https://github.com/pendo-io/ACHNBrowserUI <br>
TeslaApp      - https://github.com/pendo-io/TeslaSwiftUIApp <br>


IF you find any issue with swiftUI please open a github ticket with minimal code sample so we could reproduce it.



