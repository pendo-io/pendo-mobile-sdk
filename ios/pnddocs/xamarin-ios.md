## Xamarin

### Step 1. Install Pendo SDK

1. In **Visual Studio** Solution Explorer, right-click on your iOS project target, then select "Add" - > "Add NuGet Packages…".
2. Search for **pendo-sdk-iOS**.
3. Press **Add Package**.

-------------

### Step 2. Pendo SDK Integration

1. #### Open the application **AppDelegate class**:

    In the **FinishedLaunching** method of the application, add the following code:

```c#
    using Pendo;
    string appKey = "YOUR_APPKEY_HERE";
    PendoManager.SharedManager().Setup(appKey);
```

2. #### Start the visitor's Session in the **viewController** where your visitor is being identified (e.g. login, register, etc.).

```c#
    PendoManager.SharedManager().StartSession(
        visitorId,
        accountId,
        visitorData,
        accountData
    );
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

1. #### Add Pendo URL Scheme to **info.plist** file:

    Under App Target > Info > URL Types, create a new URL by clicking the + button.  
    Set **Identifier** to pendo-pairing or any name of your choosing.  
    Set **URL Scheme** to `YOUR_SCHEME_HERE`.

2. #### Add or modify the function **OpenURL**

```c#
    public override bool OpenUrl(UIApplication application, NSUrl url, string sourceApplication, NSObject annotation)
    {
      if (url.Scheme.Contains("pendo"))
      {
        PendoManager.SharedManager().InitWithUrl(url);
        return true;
      }
        //Your code here...
        return true;
    }
```

-------------

### Step 4. Verify Installation
1. Using Visual Studio: Run the app and search in the device log for:  
    `Pendo SDK was successfully integrated and connected to the server.`
2. In the Pendo UI, under your app's subscription settings, click the Install Settings tab, and look for the Start Verification button. Follow instructions there to make sure you have integrated correctly.  
3. Confirm that you can see your app as Integrated under <a href="https://app.pendo.io/admin" target="_blank">subscription settings</a>.

-------------

### Developer Documentation

* API documentation available <a href="https://support.pendo.io/hc/en-us/articles/4405948770715-Xamarin-Developer-API-Documentation-iOS" target="_blank">here.</a>

-------------

### Troubleshooting

+ Review the <a href="https://developers.pendo.io/category/mobile-sdk/" target="_blank">release notes</a> for any backward compatibility issues.
+ If you are encountering the following error: '-E -IIOJWT - Failed to create public key, which results in verification failure. OSStatus = ....', follow steps listed below:
  1. In the Visual Studio Editor, right-click on the project.
  2. Select Options.
  3. In the Build category list, select the “iOS bundle signing” option.
  4. Select the three dots button of the “Custom Entitlements” field.
  5. Choose the “Entitlements.plist” file from the box and click OK.
+ Additional support can be found <a href="https://github.com/pendo-io/pendo-mobile-sdk/ios" target="_blank">here.</a>
