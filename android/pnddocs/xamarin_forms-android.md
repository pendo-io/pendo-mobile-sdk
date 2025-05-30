# Xamarin Forms Android

>[!NOTE]
>The following integration instructions are relevant for SDK 3.0 or higher. <br> Follow our migration instructions to [upgrade from SDK 2.x to 3.0](/migration-docs/README.md) or refer to our [2.x integration instruction](https://github.com/pendo-io/pendo-mobile-sdk/blob/2.22.5/README.md).

>[!IMPORTANT]
>Requirements:
>- .NET 4
>- Xamarin.Forms version 5.0.0.2612 or higher
>- Kotlin version 1.9.0 or higher
>- Target Android Version 13.0 or higher

## Step 1. Install Pendo SDK

1. In **Visual Studio** Solution Explorer, right-click on your shared project, then select "Add" - > "Add NuGet Packages…".
2. Search for: **pendo-xamarin-forms** with latest version.<br/>
3. Press **Add Package**.
4. #### Using ProGuard / R8

- If you are using **ProGuard**, the rules that need to be added to ProGuard can be found here: [pendo-proguard.cfg](/android/pnddocs/pendo-proguard.cfg).

- If you are using **ProGuard(D8/DX only)** to perform compile-time code optimization, and have `{Android SDK Location}/tools/proguard/proguard-android-optimize.txt`, add `!code/allocation/variable` to the `-optimizations` line in your `app/proguard-rules.pro` file. 
The optimizations line should look like this:  
`-optimizations *other optimizations*,!code/allocation/variable`


## Step 2. Integrate with the Pendo SDK

>[!NOTE]
>Find your API key in the Pendo UI under `Settings` > `Subscription settings` > select an app > `App Details`.

1. #### Open the shared project **App.xaml.cs**

   Add the following under 'using':

    ```c#
    using PendoSDKXamarin;

    namespace ExampleApp
    {
        public partial class App : Application
        {
            private static IPendoInterface pendo = DependencyService.Get<IPendoInterface>();
            
            ...

        }
    } 
    ```  

    In the **protected override void OnStart()** method, add the following code:

    ```c#
    protected override void OnStart()
    {
       string apiKey = "YOUR_API_KEY_HERE";
       pendo.Setup(apiKey);

       ...
    }
    ```

2. #### Start the visitor's session in the Page where your visitor is being identified (e.g., login, register, etc.).

    ```c#
    using PendoSDKXamarin;

    namespace ExampleApp
    {
        class ExampleLoginClass
        {
        ...
        private static IPendoInterface Pendo = DependencyService.Get<IPendoInterface>();

        public void MethodExample()
        {
            
            ...

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

            pendo.StartSession(visitorId, accountId, visitorData, accountData);
            
            ...
        }

        ...

    }
    ```

   **visitorId**: a user identifier (e.g., John Smith)  
   **visitorData**: the user metadata (e.g., email, phone, country, etc.)  
   **accountId**: an affiliation of the user to a specific company or group (e.g., Acme inc.)  
   **accountData** : the account metadata (e.g., tier, level, ARR, etc.)

   This code ends the previous mobile session (if applicable), starts a new mobile session, and retrieves all guides based on the provided information.

>[!TIP]
>To begin a session for an  <a href="https://support.pendo.io/hc/en-us/articles/360032202751" target="_blank">anonymous visitor</a>, pass ```null``` or an empty string ```""``` as the Visitor ID. You can call the `startSession` API more than once and transition from an anonymous session to an identified session (or even switch between multiple identified sessions). 

## Step 3. Connect mobile device for tagging and testing

>[!NOTE]
>Find your scheme ID in the Pendo UI under `Settings` > `Subscription settings` > select an app > `App Details`.

This step enables Page <a href="https://support.pendo.io/hc/en-us/articles/360033609651-Tagging-Mobile-Pages#HowtoTagaPage" target="_blank">tagging</a>
and <a href="https://support.pendo.io/hc/en-us/articles/360033487792-Creating-a-Mobile-Guide#test-guide-on-device-0-6" target="_blank">guide</a> testing capabilities.

Add the following **activity** to the application **AndroidManifest.xml** in the `<Application>` tag:

```xml
<activity android:name="sdk.pendo.io.activities.PendoGateActivity" android:launchMode="singleInstance" android:exported="true">
    <intent-filter>
    <action android:name="android.intent.action.VIEW"/>
    <category android:name="android.intent.category.DEFAULT"/>
    <category android:name="android.intent.category.BROWSABLE"/>
    <data android:scheme="YOUR_SCHEME_ID_HERE"/>
    </intent-filter>
</activity>
```

## Step 4. Verify installation

1. Test using Visual Studio:  
Run the app.  
Review the Android Studio logcat and look for the following message:  
`Pendo SDK was successfully integrated and connected to the server.`
2. In the Pendo UI, go to `Settings` > `Subscription Settings`.
3. Select your application from the list.
4. Select the `Install Settings tab` and follow the instructions under `Verify Your Installation` to ensure you have successfully integrated the Pendo SDK.
5. Confirm that you can see your app as `Integrated` under <a href="https://app.pendo.io/admin" target="_blank">subscription settings</a>.

-------------

## Developer documentation

- API documentation available [here](/api-documentation/xamarin-forms-apis.md).

## Troubleshooting

- For technical issues, please [review open issues](https://github.com/pendo-io/pendo-mobile-sdk/issues) or [submit a new issue](https://github.com/pendo-io/pendo-mobile-sdk/issues).
- See our [release notes](https://developers.pendo.io/category/mobile-sdk/).
- For additional documentation, visit our [Help Center](https://support.pendo.io/hc/en-us/categories/23324531103771-Mobile-implementation).
