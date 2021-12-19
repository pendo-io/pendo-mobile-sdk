
<a name="react-native-navigation_anchor"></a>
## React Native Navigation
### Requirements
We support  _react native navigation 6 or above_

### 1. Adding Pendo dependency
In the root folder of your react app run the folowing:
```
npm i rn-pendo-sdk  
```

or 

```
yarn add rn-pendo-sdk
```
after that `cd ios` and run:
`pod install `

### 2. Project Setup
In order to enable Pendo pairing mode (taging and testing) select your project select the info tab and add Url Type with pendo url scheme 

<img src="https://user-images.githubusercontent.com/56674958/144723345-15c54098-28db-414c-90da-ef4a5256ae6a.png" width="500" height="300">

### 3. Production Bundle - Modify Javascript Obfuscation
In the `metro.config.js` file add the following:
```javascript
module.exports = {
  transformer: {
    // ...
    minifierConfig: {
        keep_classnames: true, // Preserve class names
        keep_fnames: true, // Preserve function names
        mangle: {
          keep_classnames: true, // Preserve class names
          keep_fnames: true, // Preserve function names
        }
    }
  }
}
```

### 4. Integration
In the application main file (App.js/.ts/.tsx), add the following code:
```javascript
const navigationOptions = {library: NavigationLibraryType.ReactNativeNavigation, navigation: Navigation};
const pendoKey = 'YOUR_KEY';
PendoSDK.setup(pendoKey, navigationOptions);
```
Initialize Pendo Session where your visitor is being identified (e.g. login, register, etc.).
```javascript
const visitorId = 'John Smith';
const accountId = 'Acme Inc.';
const visitorData = {'Age': '25', 'Country': 'USA'};
const accountData = {'Tier': '1', 'Size': 'Enterprise'};

PendoSDK.startSession(visitorId, accountId, visitorData, accountData);
```

## Pivots
Please pay attention to the following APIs ``` setup ``` and ```startSession``` the former *must* be called once per session and will create initial setup for the SDK, the later should be called whenever you have the visitor you would like to assign the analytics/guides to. In case you would like to have an anonymous visitor pass ```nil``` to the ```startSession``` and call it again as soon as you have the vistor. 

## Limitations
* To support hybrid mode in React native navigation please open a ticket
* We dont currently support M1 by default please use official react native [suggestion](https://github.com/facebook/react-native/issues/31941)
