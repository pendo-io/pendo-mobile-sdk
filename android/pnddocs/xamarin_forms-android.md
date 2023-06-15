## Xamarin forms

### Step 1. Install Pendo SDK

1. In **Visual Studio** Solution Explorer, right-click on your project, then select "Add" - > "Add NuGet Packages…".
2. Search for: **PendoSDKXamarin** with latest version.<br/>
3. Press **Add Package**.

#### **Using Proguard / R8**

The rules that must be added to proguard are in this file: <a href="https://cdn.pendo.io/sdk/install-instructions/pendo-proguard.cfg">pendo-proguard.cfg</a>

If using **proguard-android-optimize.txt,** add the following in the optimizations code line:  
`!code/allocation/variable`  
Your optimizations line should look like this:  
`-optimizations *other optimizations*,!code/allocation/variable`

-------------

### Step 2. Pendo SDK Integration

Note: PendoSDKXamarin plugin requires TargetFrameworkVersion v12.0

1. #### Open the shared application **App.xaml.cs**

   Add the following under 'using'

    ```c#
    ...
    using PendoSDKXamarin;
    ...

    namespace ExampleApp
    {
        public partial class App : Application
        {
            ....
            private static IPendoInterface Pendo = DependencyService.Get<IPendoInterface>();
            ....    
    ```  

    In the **protected override void OnStart()** method, add the following code:

    ```c#
    protected override void OnStart()
    {
       string appKey = "YOUR_APPKEY_HERE";
       Pendo.Setup(appKey);
       ...
    ```

2. #### Start the visitor's session in the page where your visitor is being identified (e.g. login, register, etc.).

    ```c#
    ...
    using PendoSDKXamarin;
    ...

    namespace ExampleApp
    {
        class ExampleLoginClass
        {
        ...
        private static IPendoInterface Pendo = DependencyService.Get<IPendoInterface>();
        ...
        public void MethodExample()
        {
            ....
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

   This code ends the previous mobile session (if applicable), starts a new mobile session and retrieves all guides based on the provided information.

   **Tip:** Passing `null` or `""` as the visitorId will generate <a href="https://help.pendo.io/resources/support-library/analytics/anonymous-visitors.html" target="_blank">anonymous visitor id</a>.

-------------

### Step 3. Mobile device connectivity for tagging and testing

These steps allow page <a href="https://support.pendo.io/hc/en-us/articles/360033609651-Tagging-Mobile-Pages#HowtoTagaPage" target="_blank">tagging</a>
and <a href="https://support.pendo.io/hc/en-us/articles/360033487792-Creating-a-Mobile-Guide#test-guide-on-device-0-6" target="_blank">guide</a> testing capabilities.

1. #### Add the following **activity** to the application **AndroidManifest.xml** in the **<Application>** tag:

    ```xml
    <activity android:name="sdk.pendo.io.activities.PendoGateActivity" android:launchMode="singleInstance" android:exported="true">
     <intent-filter>
       <action android:name="android.intent.action.VIEW"/>
       <category android:name="android.intent.category.DEFAULT"/>
       <category android:name="android.intent.category.BROWSABLE"/>
       <data android:scheme="YOUR_SCHEME_HERE"/>
     </intent-filter>
    </activity>
    ```
-------------

### Step 4. Verify Installation

1. Test using Visual Studio:  
Run the app.  
Review the device log and look for the following message:  
`Pendo SDK was successfully integrated and connected to the server.`
2. In the Pendo UI, go to Settings>Subscription Settings.
3. Hover over your app and select View app details.
4. Select the Install Settings tab and follow the instructions under Verify Your Installation to ensure you have successfully integrated the Pendo SDK.
5. Confirm that you can see your app as Integrated under <a href="https://app.pendo.io/admin" target="_blank">subscription settings</a>.

-------------

### Developer Documentation

* API documentation available <a href="https://support.pendo.io/hc/en-us/articles/360057203531-Android-Developer-API-Documentation" target="_blank">here.</a>

-------------

### Troubleshooting

* Review the <a href="https://developers.pendo.io/category/mobile-sdk/" target="_blank">release notes</a> for any backward compatibility issues.
* If for any reason you need to manually install the SDK - please refer to the <a href="https://github.com/pendo-io/pendo-mobile-sdk/blob/master/android/pnddocs/android_sdk_manual_installation.md">manual installation page</a>

