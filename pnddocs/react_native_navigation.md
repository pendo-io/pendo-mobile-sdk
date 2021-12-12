
<a name="react-native-navigation_anchor"></a>
## React Native Navigation
### Requirements
We support  _react native navigation 6 or above_

Initial steps 1,2,3 are identical to *React Native*

### 4. Integration

```javascript
const initParams = {
        visitorId: 'visitor1',
        accountId: 'account1',
    };

    const navigationOptions = {library: NavigationLibraryType.ReactNativeNavigation, navigation: Navigation};
    const pendoKey = 'YOUR_KEY';
    PendoSDK.setup(pendoKey, initParams,navigationOptions); // initParams is optional.
```
As soon as you have the user to which you want to relate your guides and analytics please call:
```PendoSDK.startSession("visitor1","acoount1", null, null);```
