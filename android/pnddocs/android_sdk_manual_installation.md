## Pendo SDK Android Manual Installation

If you are having problems installing the SDK, please follow these steps - 

1. Download the Pendo SDK (we always recommend taking the latest) <a href="https://pendo.jfrog.io/ui/native/androidx-release/manual/" target="_blank">here.</a>

2. Unzip the downloaded file.

3. Add the local directory to the gradle file.

example:
```java
    repositories {
      maven {
         url "/path/to/local/file"
      }
    } 
```

4. Specify the version number for the Pendo dependency in the gradle file:

example, for version 2.22.0.5604 :

```java
    implementation (group:'sdk.pendo.io' , name:'pendoIO', version:'2.22.0.5604', changing:true)
```

