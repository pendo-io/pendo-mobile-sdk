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
       implementation group:'sdk.pendo.io' , name:'pendoIO', version:'2.21.+', changing:true
    }
    ```

    ##### Review Android minimum requirements (compileSdkVersion, minSdkVersion, etc.) <a href="https://support.pendo.io/hc/en-us/articles/4404065352987-Developer-s-Guide-to-Installing-the-Pendo-Android-SDK#requirements-0-0" target="_blank">here</a>

3. #### Using Proguard

    If using **proguard-android-optimize.txt,** add the following in the optimizations code line:  
    `!code/allocation/variable`  
    Your optimizations line should look like this:  
    `-optimizations *other optimizations*,!code/allocation/variable`

-------------

### Step 2. Pendo SDK Integration

1. #### Set up Pendo on **Application class**.

    Add the following code in the **onCreate** method:

    ```java
    import sdk.pendo.io.*;

    String pendoAppKey = "YOUR_APPKEY_HERE";
    
    Pendo.setup(
       this,
       pendoAppKey,
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

#### Add the following **activity** to the application **AndroidManifest.xml** in the **<Application>** tag:

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

1.  Using Android Studio: Run the app and search in the device log for:  
    `Pendo SDK was successfully integrated and connected to the server.`
2.  Click to go through a <a href="#" data-start-verification>verification process</a> for the SDK integration.
3.  Confirm that you can see your app as Integrated under <a href="https://app.pendo.io/admin" target="_blank">subscription settings</a>.

-------------

### Developer Documentation
* API documentation available <a href="https://support.pendo.io/hc/en-us/articles/360057203531-Android-Developer-API-Documentation" target="_blank">here.</a>

-------------

### Troubleshooting

* Review the <a href="https://developers.pendo.io/category/mobile-sdk/" target="_blank">release notes</a> for any backward compatibility issues.
* Review Android minimum requirements (compileSdkVersion, minSdkVersion, etc.) <a href="https://support.pendo.io/hc/en-us/articles/4404065352987-Developer-s-Guide-to-Installing-the-Pendo-Android-SDK#requirements-0-0" target="_blank">here.</a>
* If you are encountering **Dex** problems, please refer to <a href="https://developer.android.com/studio/build/multidex" target="_blank">https://developer.android.com/studio/build/multidex</a>.
