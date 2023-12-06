# MAUI iOS


>[!NOTE]
>The following integration instructions are relevant for SDK 3.0 or higher. <br> Follow our migration instructions to [upgrade from SDK 2.x to 3.0](/migration-docs/README.md) or refer to our [2.x integration instruction](https://github.com/pendo-io/pendo-mobile-sdk/blob/2.22.5/README.md).

>[!IMPORTANT]
>Requirements:
>- .NET 7

## Step 1. Install the Pendo SDK

1. In **Visual Studio** Solution Explorer, right-click on your shared project, then select "Add" - > "Add NuGet Packages…".
2. Search for: **PendoMAUIPlugin** with latest version.<br/>
3. Press **Add Package**.


## Step 2. Pendo SDK Integration

>[!NOTE]
>The `API Key` can be found in your Pendo Subscription Settings in App Details.

1. Open the shared project **App.xaml.cs**:

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

2. Start the visitor's Session in the page where your visitor is being identified (e.g. login, register, etc.).

    ```c#
    using PendoMAUIPlugin;

    namespace ExampleApp
    {
        class ExampleLoginClass
        {

        public void MethodExample()
        {
            IPendoService pendo = PendoServiceFactory.CreatePendoService();

            ...

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

    **visitorId**: a user identifier (e.g. John Smith)  
    **visitorData**: the user metadata (e.g. email, phone, country, etc.)  
    **accountId**: an affiliation of the user to a specific company or group (e.g. Acme inc.)  
    **accountData** : the account metadata (e.g. tier, level, ARR, etc.)

    This code ends the previous mobile session (if applicable), starts a new mobile session and retrieves all guides based on the provided information.

>[!TIP]
>To begin a session for an  <a href="https://help.pendo.io/resources/support-library/analytics/anonymous-visitors.html" target="_blank">anonymous visitor</a>, pass ```null``` or an empty string ```''``` as the visitor id. You can call the `startSession` API more than once and transition from an anonymous session to an identified session (or even switch between multiple identified sessions). 

## Step 3. Mobile device connectivity for tagging and testing

>[!NOTE]
>The `Scheme ID` can be found in your Pendo Subscription Settings in App Details.

These steps enable page <a href="https://support.pendo.io/hc/en-us/articles/360033609651-Tagging-Mobile-Pages#HowtoTagaPage" target="_blank">tagging</a>
and <a href="https://support.pendo.io/hc/en-us/articles/360033487792-Creating-a-Mobile-Guide#test-guide-on-device-0-6" target="_blank">guide</a> testing capabilities.

1. Add a Pendo URL scheme to the **info.plist** file:

   <img width="953" alt="Screenshot 2023-12-05 at 22 01 30" src="https://github.com/pendo-io/pendo-mobile-sdk/assets/45537976/ed156f85-1817-483d-ae99-ab485ed25288" alt="info.plist schemeId">

   Under the iOS App Target > open info.plist > if `URL Types` doesn't exist, click on 'Add new entry' of type `Array` and name it `URL types`. Create a new `Dictionary` inside the `Array` with two entries:
    - `URL identifier` of type `String` with a value that begins with `pendo` (ex. `pendo-scheme-d`).
    - `URL Schemes` of type `Array`. Add a `String` item with `YOUR_SCHEME_ID` as the value.

2. Add or modify the function **OpenURL**:

   Open ***AppDelegate.cs*** file and add ***using PendoMaui;*** 
   add the following code under ***OpenUrl*** method:

      ```C#
    using PendoMaui;

    ...

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

## Step 4. Verify installation

1. Test using Visual Studio:  
Run the app.  
Review the Xcode console and look for the following message:  
`Pendo SDK was successfully integrated and connected to the server.`
2. In the Pendo UI, go to Settings>Subscription Settings.
3. Select the **Applications** tab and then your application.
4. Select the Install Settings tab and follow the instructions under Verify Your Installation to ensure you have successfully integrated the Pendo SDK.
5. Confirm that you can see your app as Integrated under <a href="https://app.pendo.io/admin" target="_blank">subscription settings</a>.

## Developer documentation

- API documentation available [here](/api-documentation/xamarin-maui-apis.md).

## Troubleshooting
- For technical issues, please [review open issues](https://github.com/pendo-io/pendo-mobile-sdk/issues) or [submit a new issue](https://github.com/pendo-io/pendo-mobile-sdk/issues).
- Release notes can be found [here](https://developers.pendo.io/category/mobile-sdk/).
- For additional documentation, visit our [Help Center Mobile Section](https://support.pendo.io/hc/en-us/categories/4403654621851-Mobile).