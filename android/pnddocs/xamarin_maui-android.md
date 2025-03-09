# MAUI Android

>[!NOTE]
>The following integration instructions are relevant for SDK 3.0 or higher. <br> Follow our migration instructions to [upgrade from SDK 2.x to 3.0](/migration-docs/README.md) or refer to our [2.x integration instruction](https://github.com/pendo-io/pendo-mobile-sdk/blob/2.22.5/README.md).

>[!IMPORTANT]
>Requirements:
>- .NET 8 or .NET 9
>- Kotlin version 1.9.0 or higher
>- Target Android Version 13.0 or higher

## Step 1. Install the Pendo SDK

1. In **Visual Studio** Solution Explorer, right-click on your shared project, then select "Add" - > "Add NuGet Packages…".
2. Search for: [**pendo-maui**](https://www.nuget.org/packages/pendo-maui) with latest version.<br/>
3. Press **Add Package**.

4. #### **Using Proguard / R8**

- If you are using **ProGuard**, the rules that need to be added to ProGuard can be found here: [pendo-proguard.cfg](/android/pnddocs/pendo-proguard.cfg).


- If you are using **ProGuard(D8/DX only)** to perform compile-time code optimization, and have `{Android SDK Location}/tools/proguard/proguard-android-optimize.txt`, add `!code/allocation/variable` to the `-optimizations` line in your `app/proguard-rules.pro` file. 
The optimizations line should look like this:  
`-optimizations *other optimizations*,!code/allocation/variable`

## Step 2. Integrate with the Pendo SDK

>[!NOTE]
>Find your API key in the Pendo UI under `Settings` > `Subscription settings` > select an app > `App Details`.

1. Open the shared project **App.xaml.cs**

    Add the following under 'using':

    ```c#
    using PendoMAUIPlugin;
    ``` 

    In the **protected override void OnStart()** method, add the following code:

    ```c#
    protected override void OnStart()
    {
        IPendoService pendo = PendoServiceFactory.CreatePendoService();

        /** if your app supports additional Platforms other than iOS and Android
        verify the Pendo instance is not null */
        if (pendo != null) {            
            string apiKey = "YOUR_API_KEY_HERE";
            pendo.Setup(apiKey);
        }

        ...

    }
    ```

2. Start the visitor's session in the page where your visitor is being identified (e.g., login, register, etc.).

    ```c#
    ...
    using PendoMAUIPlugin;
    ...

    namespace ExampleApp
    {
        class ExampleLoginClass
        {

        public void ExampleMethod()
        {
            ...

            IPendoService pendo = PendoServiceFactory.CreatePendoService();

            /** if your app supports additional Platforms other than iOS and Android
            verify the Pendo instance is not null */
            if (pendo != null) {             
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
            }

            ...

        }        
    }
    ```

   **visitorId**: a user identifier (e.g., John Smith)  
   **visitorData**: the user metadata (e.g., email, phone, country, etc.)  
   **accountId**: an affiliation of the user to a specific company or group (e.g., Acme inc.)  
   **accountData** : the account metadata (e.g., tier, level, ARR, etc.)

   This code ends the previous mobile session (if applicable), starts a new mobile session, and retrieves all guides based on the provided information.

>[!TIP]
>To begin a session for an  <a href="https://support.pendo.io/hc/en-us/articles/360032202751" target="_blank">anonymous visitor</a>, pass ```null``` or an empty string ```""``` as the Visitor ID. You can call the `startSession` API more than once and transition from an anonymous session to an identified session (or even switch between multiple identified sessions). 


3. If your app is using **Gestures**, you must upgrade to SDK version 3.1 or above and then register **Pendo Effects** (PendoRoutingEffect, PendoPlatformEffect) in your **MauiProgram.cs** file as shown in the code below. 

    ```c#
    ...
    using PendoMAUIPlugin;
    ...

   public static class MauiProgram
    {
        public static MauiApp CreateMauiApp()
        {
            var builder = MauiApp.CreateBuilder();
            builder.UseMauiApp<App>();

            builder.ConfigureEffects(effects =>
            {
                effects.Add<PendoRoutingEffect, PendoPlatformEffect>();
            });
            return builder.Build();
        }
    }
    ```

## Step 3. Connect mobile device for tagging and testing

>[!NOTE]
>Find your scheme ID in the Pendo UI under `Settings` > `Subscription settings` > select an app > `App Details`.

This step enables page <a href="https://support.pendo.io/hc/en-us/articles/360033609651-Tagging-Mobile-Pages#HowtoTagaPage" target="_blank">tagging.</a>
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


## Developer documentation

- API documentation available [here](/api-documentation/xamarin-maui-apis.md)

## Troubleshooting

- For technical issues, please [review open issues](https://github.com/pendo-io/pendo-mobile-sdk/issues) or [submit a new issue](https://github.com/pendo-io/pendo-mobile-sdk/issues).
- See our [release notes](https://developers.pendo.io/category/mobile-sdk/).
- For additional documentation, visit our [Help Center](https://support.pendo.io/hc/en-us/categories/23324531103771-Mobile-implementation).
