# SwiftUI Integration 
Currently SwiftUI support is provided as beta and is available via cocoapods and SPM:<br>
The codeless solution is supported with IOS 15 and 16. Screen navigation tracking is available since IOS 13. (For Iphones)

## Cocoapods
Add Pendo pod with all rest of the pods:
`pod 'PendoSwiftUI'`

## SPM
In the SPM search for _pendo_ and use `swiftui` branch:<br>
<img width="700" alt="SPM" src="https://user-images.githubusercontent.com/56674958/188460208-254ef03d-fef9-49f4-a1e6-5751eb0ee4e4.png">
 
### Integration
By default, Pure SwiftUI apps do not include an AppDelegate file. To use Pendo in your app, we recommend to create an `AppDelegate` file and complete the following steps:

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
After you have identified the user to which you want to relate your guides and analytics, call `PendoManager.shared().startSession()` with the appropriate parameters.

```swift
PendoManager.shared().startSession("visitor1", accountId: "account1", visitorData:[], accountData: [])
```

To support SwiftUI the Pendo SDK requires you to apply the `enableSwiftUI()` modifier on each one of the `rootViews` in your app. See example below:
```swift
struct YourView: View {
    var body: some View {
        Text("RootView")
            .enableSwiftUI()
    }
}
```

If the entry point to your app is a struct attributed with `@main`, your SwiftUI application will not respond to the method `application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool`.<br>
To handle URL schemes in your SwiftUI app, add the `.onOpenURL()` modifier to your main view.<br>
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
            .enableSwiftUI()
            .onOpenURL(perform: handleURL)
        }
    }
    
    func handleURL(_ url: URL) {
        _ = appDelegate.application(UIApplication.shared, open: url, options: [:])

    }
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
If you don't add accessibility labels the OS will assign default values to the UI elements in your app<br>
Accessibility identifiers, accessibility labels, and accessibility hints are all supported and can be used by Pendo for unique identification <br>

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
:technologist: - Dynamic Content (content that appears after your screen was loaded, like data loaded from server) currently not supported, please use `screenContentChanged` api for such screens <br>
:technologist: - Clickable elements buttons/tapGestures etc. When creating clickable elements that don't have a background color set on them (e.x. VStack or HStack) please set a background color to them that is NOT transparent<br>
:technologist: - SwiftUI beta components like `PresentationContainers` are not supported yet<br>
:technologist: - SwiftUI IOS 16 navigation api's not supported yet

## NOTE
We highly recommend checking out the following sample apps to observe examples of feature tagging and how Pendo analytics work<br>
(Please pay attention to comments with _PENDO CHANGE_ which in some places require minor changes like integration code or adding a background color)<br>

ACHNBrowserUI - https://github.com/pendo-io/ACHNBrowserUI <br>
TeslaApp      - https://github.com/pendo-io/TeslaSwiftUIApp <br>


If you encounter issues using SwiftUI please open a GitHub ticket with the minimal sample code required to reproduce it.

## Integration Demo Video<br>

<div align="left">
  <a href="https://youtu.be/ZDUSJZSvO_4"><img src="https://user-images.githubusercontent.com/56674958/232925410-4ed248c1-f75c-4946-ae23-a997bb9686e6.png" width="500" height="300" alt="IMAGE ALT TEXT"></a>
</div>




