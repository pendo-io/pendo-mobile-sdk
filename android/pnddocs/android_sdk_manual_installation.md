# Pendo Android SDK manual installation

If you are having problems installing the SDK, please follow these steps:

1. Download the Pendo SDK (we always recommend taking the latest) <a href="https://pendo.jfrog.io/ui/native/androidx-release/manual/" target="_blank">here.</a>

2. Unzip the downloaded file.

3. Add the local directory to the gradle file or to the settings.gradle if using dependencyResolutionManagement:

    ```java
    repositories {
        maven {
            url = uri("/path/to/local/file")
        }
    } 
    ```

4. Specify the version number for the Pendo dependency in the gradle file. <br>For example, for version 3.9.0.x it should look like this: 

    ```java
    implementation (group:'sdk.pendo.io' , name:'pendoIO', version:'3.9.0.x', changing:true)
    ```

## Developer documentation

- View our [API documentation](/api-documentation/native-android-apis.md).


## Troubleshooting

- For technical issues, please [review open issues](https://github.com/pendo-io/pendo-mobile-sdk/issues) or [submit a new issue](https://github.com/pendo-io/pendo-mobile-sdk/issues).
- See our [release notes](https://developers.pendo.io/category/mobile-sdk/).
- For additional documentation, visit our [Help Center](https://support.pendo.io/hc/en-us/categories/23324531103771-Mobile-implementation).
