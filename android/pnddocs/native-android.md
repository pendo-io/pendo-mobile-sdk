## Native Android

### Step 1. Install Pendo SDK

1. #### Add Pendo Repository to **build.gradle**

    ```java
    repositories {
      maven {
        url "https://software.mobile.pendo.io/artifactory/androidx-release"
      }
      mavenCentral()
    } 
    ```

2. #### Add Pendo a dependency to **build.gradle**

    ```shell
    dependencies {
       implementation group:'sdk.pendo.io' , name:'pendoIO', version:'2.22.+', changing:true
    }
    ```

- **Minimum and compile SDK Version**  
If applicable, set your app to be compiled with **compileSdkVersion 31** or higher and **minSdkVersion 21** or higher:

  ```java
  android {
      minSdkVersion 21
      compileSdkVersion 31
  }
  ```

- **Java 8 Compatibility**  
If applicable, configure your app compilation to targetCompatibility **JavaVersion.VERSION_1_8**:

  ```java
  android {
      compileOptions {
          targetCompatibility JavaVersion.VERSION_1_8
      }
  }
  ```
 
3. #### Using ProGuard

    For whom is using ProGuard(D8/DX only) to perform compile-time code optimization and have `proguard-android-optimize.txt`, add the following in the optimizations code line:  
    `!code/allocation/variable`  
    Your optimizations line should look like this:  
    `-optimizations *other optimizations*,!code/allocation/variable`

-------------

### Step 2. Pendo SDK Integration

**Both Scheme ID and API Key can be found in your Pendo Subscription under App Details**

1. #### Set up Pendo on **Application class**.

    Add the following code in the **onCreate** method:

    ```java
    import sdk.pendo.io.*;

    String pendoApiKey = "YOUR_API_KEY_HERE";
    
    Pendo.setup(
       this,
       pendoApiKey,
       null,
       null
    );
    ```

    **Note:** Get updates on the initialization state using  **PendoPhasesCallbackInterface**. Pass `null` if not needed.

2. #### Initialize Pendo in the **Activity/fragment** where your visitor is being identified.

    ```java
    String visitorId = "VISITOR-UNIQUE-ID";
    String accountId = "ACCOUNT-UNIQUE-ID";

    // send Visitor Level Data
    HashMap<String, Object> visitorData = new HashMap<>();
    visitorData.put("age", 27);
    visitorData.put("country", "USA");

    // send Account Level Data
    HashMap<String, Object> accountData = new HashMap<>();
    accountData.put("Tier", 1);
    accountData.put("Size", "Enterprise");

    Pendo.startSession(
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
&nbsp;  
    This code ends the previous mobile session (if applicable), starts a new mobile session and retrieves all guides based on the provided information.  
&nbsp;  
    **Tip:** Passing `null` or `""` as the visitorId will generate an <a href="https://help.pendo.io/resources/support-library/analytics/anonymous-visitors.html" target="_blank">anonymous visitor id</a>.

-------------

### Step 3. Mobile device connectivity for tagging and testing

These steps allow page <a href="https://support.pendo.io/hc/en-us/articles/360033609651-Tagging-Mobile-Pages#HowtoTagaPage" target="_blank">tagging</a>
and <a href="https://support.pendo.io/hc/en-us/articles/360033487792-Creating-a-Mobile-Guide#test-guide-on-device-0-6" target="_blank">guide</a> testing capabilities.

#### Add the following activity to the application's AndroidManifest.xml in the <Application> tag:

    <activity android:name="sdk.pendo.io.activities.PendoGateActivity" android:launchMode="singleInstance" android:exported="true">
        <intent-filter>
            <action android:name="android.intent.action.VIEW"/>
            <category android:name="android.intent.category.DEFAULT"/>
            <category android:name="android.intent.category.BROWSABLE"/>
            <data android:scheme="YOUR_SCHEME_ID_HERE"/>
        </intent-filter>
    </activity>

-------------

### Step 4. Verify Installation

1. Test using Android Studio:  
Run the app while attached to the Android Studio.  
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
* If you are encountering **Dex** problems, please refer to <a href="https://developer.android.com/studio/build/multidex" target="_blank">https://developer.android.com/studio/build/multidex</a>.
* If for any reason you need to manually install the SDK - please refer to the <a href="https://github.com/pendo-io/pendo-mobile-sdk/blob/master/android/pnddocs/android_sdk_manual_installation.md">manual installation page</a>
