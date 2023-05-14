## Flutter

### Step 1. Install Pendo SDK

1. In the **application folder**, run the following command:

    ```shell
    flutter pub add pendo_sdk
    ```

2. In the application **build.gradle** file:  
- Add the Pendo Repository to the repositories section:

    ```java
    repositories {
        maven {
            url "https://software.mobile.pendo.io/artifactory/androidx-release"
        }
    mavenCentral()
    }
    ```

- Minimum and compile SDK Version:  
If applicable, set your app to be compiled with **compileSdkVersion 31** or higher and **minSdkVersion 21** or higher:

    ```java
    android {
        minSdkVersion 21
        compileSdkVersion 31
    }
    ```

- Java 8 Compatibility  
If applicable, configure your app compilation to targetCompatibility **JavaVersion.VERSION_1_8** :

    ```java
    android {
        compileOptions {
            targetCompatibility JavaVersion.VERSION_1_8
        }
    }
    ```

3. In the application **Android.manifest** file:  
If applicable, add the following `<uses-permission>` to the manifest in the `<manifest>` tag:

    ```xml
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
    ```

4. Using Proguard / R8  
The rules that need to be added to proguard are in this file: <a href="https://cdn.pendo.io/sdk/install-instructions/pendo-proguard.cfg">pendo-proguard.cfg</a>  
If using `proguard-android-optimize.txt`, add the following in the optimizations code line:
`!code/allocation/variable`  
Your optimizations line should look like this:  
`-optimizations *other optimizations*,!code/allocation/variable`

-------------

### Step 2. Pendo SDK Integration

In the application **main file (lib/main.dart)**, add the following code:  

```dart
import 'package:pendo_sdk/pendo_sdk.dart';
```

1. Add the following code in the `initState` method:

    ```dart
    var pendoKey = 'YOUR_APPKEY_HERE';
    await PendoFlutterPlugin.setup(pendoKey);
    ```

2. Initialize Pendo where your visitor is being identified (e.g. login, register, etc.).

    ```dart
    final String visitorId = 'VISITOR-UNIQUE-ID';
    final String accountId = 'ACCOUNT-UNIQUE-ID';
    final Map<String, dynamic> visitorData = {'Age': '25', 'Country': 'USA'};
    final Map<String, dynamic> accountData = {'Tier': '1', 'Size': 'Enterprise'};

    PendoFlutterPlugin.startSession(visitorId, accountId, visitorData, accountData);
    ```

**Notes**

**visitorId**: a user identifier (e.g. John Smith)  
**visitorData**: the user metadata (e.g. email, phone, country, etc.)  
**accountId**: an affiliation of the user to a specific company or group (e.g. Acme inc.)  
**accountData**: the account metadata (e.g. tier, level, ARR, etc.)  

Passing `null` or `""` or not setting the `visitorId` will generate an <a href="https://help.pendo.io/resources/support-library/analytics/anonymous-visitors.html" target="_blank">anonymous visitor id</a>.
<br></br>

#### Track Events

Configure Pendo Track Events to capture analytics to notify Pendo of analytics events.

In the application files where you want to track an event, add the following code:

```dart
import 'package:pendo_sdk/pendo_sdk.dart';
```

```dart
await PendoFlutterPlugin.track('name', { 'firstProperty': 'firstPropertyValue', 'secondProperty': 'secondPropertyValue'});
```

-------------

### Step 3. Mobile device connectivity for testing
These steps allow <a href="https://support.pendo.io/hc/en-us/articles/360033487792-Creating-a-Mobile-Guide#test-guide-on-device-0-6" target="_blank">guide testing capabilities</a>.

Add the following `<activity>` to the manifest in the `<application>` tag:

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

* Test using Android Studio:  
Run the app while attached to the Android Studio.  
Review the device log and look for the following message:  
`Pendo SDK was successfully integrated and connected to the server.`
* Click to go through a <a href="#" data-start-verification>verification process</a> for the SDK integration.
* Test using the Pendo UI:  
Confirm that you can see your app  as Integrated under <a href="https://app.pendo.io/admin" target="_blank">subscription settings</a>.

-------------

### Developer Documentation

* API documentation available <a href="https://support.pendo.io/hc/en-us/articles/4405623533979-Flutter-Developer-API-Documentation" target="_blank">here</a>

-------------

### Troubleshooting

* Review the <a href="https://developers.pendo.io/category/mobile-sdk/" target="_blank">Android release notes</a> for any backward compatibility issues.
* Review Android minimum requirements (compileSdkVersion, minSdkVersion, etc.) <a href="https://support.pendo.io/hc/en-us/articles/4404065352987-Developer-s-Guide-to-Installing-the-Pendo-Android-SDK#requirements-0-0" target="_blank">here</a>
  * If you are encountering **Dex** problems, please refer to <a href="https://developer.android.com/studio/build/multidex" target="_blank">https://developer.android.com/studio/build/multidex</a>.
