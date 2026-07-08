# Migrating from CocoaPods to Swift Package Manager (SPM)

CocoaPods has [announced](https://blog.cocoapods.org/) that their registry will become read-only in December 2026, after which new pod versions can no longer be published. To ensure your application continues to receive the latest features, performance improvements, and critical bug fixes, you should migrate your Pendo iOS SDK dependency from CocoaPods to Swift Package Manager (SPM).

---

## Overview

* **What's changing?** CocoaPods is moving to a read-only state. Pendo will stop publishing new SDK versions to CocoaPods.
* **Will my app break?** No. Existing versions of the Pendo SDK on CocoaPods will remain available indefinitely, and your apps using those versions will continue to function normally.
* **Why migrate?** To continue receiving new features, performance enhancements, and critical fixes, you must migrate your dependency to Swift Package Manager (SPM).

---

## Step-by-Step Migration Guide

Migrating from CocoaPods to Swift Package Manager is straightforward and does not require any changes to your application code.

### Step 1: Remove CocoaPods from your project

1. Close Xcode.
2. Open your terminal, navigate to your project directory, and run:
   ```bash
   pod deintegrate
   ```
3. Delete the CocoaPods-generated `.xcworkspace` file, `Podfile`, and `Podfile.lock` (if you are migrating all dependencies).
   > [!TIP]
   > It is industry best practice to use a single dependency manager for your entire project. Mixing CocoaPods and SPM within the same target can lead to complex dependency cycles and build errors.

### Step 2: Add Pendo via Swift Package Manager

1. Open your `.xcodeproj` file in Xcode.
2. Navigate to **File > Add Package Dependencies...** (or select your project in the Project Navigator, go to the **Package Dependencies** tab, and click the `+` button).
3. In the search bar, enter the Pendo SPM repository URL:
   ```text
   https://github.com/pendo-io/pendo-mobile-ios
   ```
4. For the **Dependency Rule**, select **Up to Next Major Version** and specify the latest version (e.g., `3.13.6`).
5. Click **Add Package**.
6. In the next dialog, ensure the `Pendo` library is checked and added to your application's target.

### Step 3: Link the Framework (if needed)

1. Select your app target in Xcode.
2. Go to the **General** tab.
3. Scroll down to **Frameworks, Libraries, and Embedded Content**.
4. Verify that `Pendo` is listed there. If not, click the `+` button and add it manually.

---

## Migrating Cross-Platform Wrappers

If you are using one of our cross-platform wrappers (React Native, Flutter, MAUI, Xamarin), the migration process on iOS is handled similarly:

* **React Native**:
  1. Remove `pod 'Pendo'` or the React Native Pendo pod from your `ios/Podfile`.
  2. Run `pod install` inside the `ios/` folder.
  3. Open your iOS project in Xcode and add the Pendo SPM package to your main app target following the SPM instructions above.
* **Flutter**:
  1. **Prerequisites**: Swift Package Manager support for Flutter plugins requires **Flutter 3.24 or later** on the host application.
  2. **Enable SPM in Flutter**: In your terminal, run the following command to enable Swift Package Manager support in your Flutter environment:
     ```bash
     flutter config --enable-swift-package-manager
     ```
  3. **Remove CocoaPods references**:
     * Open your Flutter project's `ios/Podfile` and remove any explicit Pendo references (if any).
     * Run `pod deintegrate` inside the `ios/` directory to clean up CocoaPods scaffolding.
  4. **Build with SPM**:
     * Run a clean build of your Flutter application:
       ```bash
       flutter clean
       flutter pub get
       flutter build ios
       ```
     * On the first build, Flutter will automatically generate SPM scaffolding under `ios/Flutter/ephemeral/Packages/` and resolve the native Pendo XCFramework dependency.
  5. **Verification**: Open the `ios/` folder in Xcode and verify that `pendo_sdk` is listed under **Package Dependencies** in your project settings.
