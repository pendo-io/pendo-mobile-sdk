### Step 1. Install Pendo SDK

1. In **Visual Studio** Solution Explorer, right-click on your project, then select "Add" - > "Add NuGet Packages…"
2. search for: **PendoMAUIPlugin** with latest version
3. Press **Add Package**

-------------

### Step 2. Pendo SDK Integration

1. #### Open the shared application **App.xaml.cs** and add the following under 'using'

    ```c#
    ...
    using PendoMAUIPlugin;
    ...   
    ``` 

    in the **protected override void OnStart()** method, add the following code:

    ```c#
    protected override void OnStart()
    {
       PendoInterface Pendo = new PendoInterface();
       string appKey = "_insert_app_key";
       Pendo.Setup(appKey);
       ...
    ```

2. #### Start the visitor's Session in the page where your visitor is being identified (e.g. login, register, etc.).

    ```c#
    ...
    using PendoMAUIPlugin;
    ...

    namespace ExampleApp
    {
        class ExampleLoginClass
        {
            public void MethodExample()
            {
                ....
                PendoInterface Pendo = new PendoInterface();
                
                var visitorId = "VISITOR-UNIQUE-ID";
                var accountId = "ACCOUNT-UNIQUE-ID";

                var visitorData = new Dictionary<string, object>
                {
                    { "age", 27 },
                    { "country", "USA" }
                };

                var accountData = new Dictionary<string, object>
                {
                    { "Tier", 1 },
                    { "Size", "Enterprise" }
                };

                Pendo.StartSession(visitorId, accountId, visitorData, accountData);
                ...
            }
        ...
    ```

   **visitorId**: a user identifier (e.g. John Smith)  
   **visitorData**: the user metadata (e.g. email, phone, country, etc.)  
   **accountId**: an affiliation of the user to a specific company or group (e.g. Acme inc.)  
   **accountData** : the account metadata (e.g. tier, level, ARR, etc.)

   This code will end the previous mobile session (if applicable), start a new mobile session and retrieve all guides based on the provided information.

   **Tip:** Passing `null` or `""` as the visitorId will generate <a href="https://help.pendo.io/resources/support-library/analytics/anonymous-visitors.html" target="_blank">anonymous visitor id</a>.

-------------

### Step 3. Mobile device connectivity for tagging and testing

These steps will allow page <a href="https://support.pendo.io/hc/en-us/articles/360033609651-Tagging-Mobile-Pages#HowtoTagaPage" target="_blank">tagging</a>
and <a href="https://support.pendo.io/hc/en-us/articles/360033487792-Creating-a-Mobile-Guide#test-guide-on-device-0-6" target="_blank">guide</a> testing capabilities.

### iOS
1. #### Add Pendo URL Scheme to **info.plist** file

   Under the iOS App Target > open info.plist > if URL Types doesn't exist, click on 'Add new entry' and name it 'URL types', for the type choose 'Array'.
   Create a new URL by clicking the + button.
   Under the new created Dictionary, change 'Document role' to 'URL Schemes' with type 'Array'.
   Expand 'URL Schemes' and add the `pendo-_insert_app_scheme` under the 'Value'.
   Under the created Dictionary in the previous step, add new entry with the name 'URL Identifier', type 'string' and set a name of your preference under its 'Value'.

2. #### Add or modify the function **OpenURL**

   open ***AppDelegate.cs*** file and add ***using PendoMaui;*** 
   add the following code under ***OpenUrl*** method:

    ```C#
    public override bool OpenUrl(UIApplication app, NSUrl url, NSDictionary options)
    {
        if (url.Scheme.Contains("pendo"))
        {
            PendoManager.InitWithUrl(url.AbsoluteString);
            return true;
        }
        return base.OpenUrl(app, url, options);
    }
    ```

-------------

### Step 4. Verify Installation
1. Using Visual Studio: Run the app and search in the device log for:  
   `Pendo SDK was successfully integrated and connected to the server.`
2. Click to go through a <a href="#" data-start-verification>verification process</a> for the SDK integration.
3. Confirm that you can see your app under <a href="https://app.pendo.io/admin" target="_blank">subscription settings</a> as Integrated.

-------------

### Developer Documentation

* API documentation available <a href="https://support.pendo.io/hc/en-us/articles/4405948770715-Xamarin-Developer-API-Documentation-iOS" target="_blank">here</a>

-------------

### Troubleshooting

+ Review the <a href="https://developers.pendo.io/ios-sdk-2-19-0/" target="_blank">release notes</a> for any backward compatibility issues.
+ If you are encountering the following error: '-E -IIOJWT - Failed to create public key, which results in verification failure. OSStatus = ....', follow steps listed below:
  1. In the Visual Studio Editor - right click on the project.
  2. Select the 'Options' menu button.
  3. In the Build category list - Select the “iOS bundle signing” option.
  4. Select the three dots button of the “custom entitlements” field.
  5. Choose the “Entitlements.plist” file from the box and click the OK button.
+ Additional support can be found <a href="https://github.com/pendo-io/pendo-mobile-ios" target="_blank">here</a>

Visit the <a href="https://help.pendo.io/resources/support-library/installation/iOS-troubleshooting.html" target="_blank">iOS section of the Help Center</a> for additional documentation.

