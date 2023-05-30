## Xamarin

### Step 1. Install Pendo SDK

Right-click on your Android project target. 
1. Click "Add" and "Add NuGet Packages…".
2. Search for **"pendo-sdk-androidx"**.
3. Click "Add Package".

##### Review Android minimum requirements (compileSdkVersion, minSdkVersion, etc.) <a href="https://support.pendo.io/hc/en-us/articles/4404197902235" target="_blank">here.</a>


#### **Using Proguard / R8**

The rules that must be added to proguard are in this file: <a href="https://cdn.pendo.io/sdk/install-instructions/pendo-proguard.cfg">pendo-proguard.cfg</a>

If using **proguard-android-optimize.txt,** add the following in the optimizations code line:  
`!code/allocation/variable`  
Your optimizations line should look like this:  
`-optimizations *other optimizations*,!code/allocation/variable`

-------------

### Step 2. Pendo SDK Integration
1. #### Open the **Application class** that inherits from Android.App.Application.
    Initialize Pendo in the application **onCreate** method with the following code.

    ```c#
    using static Sdk.Pendo.IO.Pendo;
    ...
    const string pendoAppKey = "YOUR_APPKEY_HERE";
    Setup(this, pendoAppKey, null, null);
    ```

Note: A working example of Application class is in the Troubleshooting section below.



2. #### Initialize Pendo in the **Activity/fragment** where your visitor is being identified.

```c#
    var visitorId = "VISITOR-UNIQUE-ID";
    var accountId = "ACCOUNT-UNIQUE-ID";
/*
    Note: If you are using "pendo-sdk-androidx" plugin, use this line:
*/
    var visitorData = new Dictionary<string, Java.Lang.Object>
/*
     Note: If you are using "pendo-sdk-androidx" plugin, use this line:
*/
    var accountData = new Dictionary<string, Java.Lang.Object> 

    StartSession(
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
    **Tip:** Passing `null` or `""` as the visitorId will generate an <a href="https://help.pendo.io/resources/support-library/analytics/anonymous-visitors.html" target="_blank">anonymous visitor id</a>.

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
1. Using Android Studio: Run the app and search in the device log for:  
    `Pendo SDK was successfully integrated and connected to the server.`
2. Click to go through a <a href="#" data-start-verification>verification process</a> for the SDK integration.
3. Confirm that you can see your app as Integrated under <a href="https://app.pendo.io/admin" target="_blank">subscription settings</a>.

-------------

### Developer Documentation

* API documentation available <a href="https://support.pendo.io/hc/en-us/articles/360057203531-Android-Developer-API-Documentation" target="_blank">here.</a>

-------------

### Troubleshooting

* Review the <a href="https://developers.pendo.io/category/mobile-sdk/" target="_blank">release notes</a> for any backward compatibility issues.
* Review Android minimum requirements (compileSdkVersion, minSdkVersion, etc.) <a href="https://support.pendo.io/hc/en-us/articles/4404065352987-Developer-s-Guide-to-Installing-the-Pendo-Android-SDK#requirements-0-0" target="_blank">here.</a>
* If you are encountering **Dex** problems, refer to:  
  * <a href="https://developer.android.com/studio/build/multidex" target="_blank">https://developer.android.com/studio/build/multidex </a>
  * <a href="https://docs.microsoft.com/en-us/xamarin/android/deploy-test/release-prep/?tabs=macos#multi-dex" target="_blank">https://docs.microsoft.com/en-us/xamarin/android/deploy-test/release-prep/?tabs=macos#multi-dex </a>
* If the SDK is not giving any output, pass the Android Application instance to Pendo.Setup. See the following example on how to implement it.


 ```c#
using System;
using System.Collections.Generic;
using Android.App;
using Android.Runtime;
using static Sdk.Pendo.IO.Pendo;

namespace MyAppNameSpace.Android

{
#if DEBUG
    [Application(Debuggable = true)]
#else
    [Application(Debuggable = false)]
#endif
    public class MyApplication : Application
    {
        public MyApplication(IntPtr javaReference, JniHandleOwnership transfer) : base(javaReference, transfer)
        {
        }

        public override void OnCreate()
        {
            base.OnCreate();

            const string pendoAppKey = "YOUR_APPKEY_HERE";
            Setup(this, pendoAppKey, null, null);
        }

    }

}
 ```
