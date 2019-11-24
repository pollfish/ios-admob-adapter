# Pollfish iOS AdMob Mediation Adapter

AdMob Mediation Adapter for iOS apps looking to load and show Rewarded Surveys from Pollfish in the same waterfall with other Rewarded Ads.

> **Note:** A detailed step by step guide is provided on how to integrate can be found [here](https://github.com/pollfish/docs/edit/master/ios-admob-adapter.md) 

### Step 1: Add Pollfish AdMob Adapter to your project

Download Pollfish iOS AdMob Adapter framework and then in Xcode, select the target that you want to use and in the Build Phases tab expand the Link Binary With Libraries section. Press the + button, and press Add other… In the dialog box that appears, go to the Pollfish framework’s location and select it.

**OR**

#### **Retrieve Pollfish AdMob Adapter through CocoaPods**

Add a Podfile with Pollfish framework as a pod reference:

```
pod 'PollfishAdMobAdapter'
```
You can find latest Pollfish iOS SDK version on CocoaPods here

Run pod install on the command line to install Pollfish cocoapod.

### Step 2: Use and control Pollfish AdMob Adapter in your Rewarded Ad Unit 

Pollfish AdMob Adapter provides different options that you can use to control the behaviour of Pollfish SDK.

<br/>
Below you can see all the available options of **GADPollfishRewardedNetworkExtras** instance that is used to configure the behaviour of Pollfish SDK.

<br/>

No | Description
------------ | -------------
5.1 | **.pollfishAPIKey**  <br/> Sets Pollfish SDK API key as provided on Pollfish
5.2 | **.requestUUID**  <br/> Sets a unique id to identify a user and be passed through server-to-server callbacks
5.3 | **.releaseMode**  <br/> Sets Pollfish SDK to Developer or Release mode


#### 2.1 .pollfishAPIKey

Pollfish API Key as provided by Pollfish on  [Pollfish Dashboard](https://www.pollfish.com/publisher/) after you sign up to the platform.  If you have already specified Pollfish API Key on AdMob's UI, this param will be ignored.

#### 2.2 .requestUUID

Sets a unique id to identify a user and be passed through server-to-server callbacks on survey completion. 

In order to register for such callbacks you can set up your server URL on your app's page on Pollfish Developer Dashboard and then pass your requestUUID through ParamsBuilder object during initialization. On each survey completion you will receive a callback to your server including the requestUUID param passed.

If you would like to read more on Pollfish s2s cllab

#### 2.3 .releaseMode

Sets Pollfish SDK to Developer or Release mode.

*   **Developer mode** is used to show to the developer how Pollfish surveys will be shown through an app (useful during development and testing).
*   **Release mode** is the mode to be used for a released app in any app store (start receiving paid surveys).

Pollfish AdMob Adapter runs Pollfish SDK in release mode by default. If you would like to test with Test survey, you should set release mode to fasle.
```
GADRequest *request = [GADRequest request];
    
GADPollfishRewardedNetworkExtras *pollfishNetworkExtras = [[GADPollfishRewardedNetworkExtras alloc] init];
    
pollfishNetworkExtras.pollfishAPIKey = @"POLLFISH_API_KEY";
pollfishNetworkExtras.releaseMode = false;
pollfishNetworkExtras.requestUUID = @"YOUR_USER_ID";
    
[request registerAdNetworkExtras:pollfishNetworkExtras];
```

### Step 3: Publish 

If you everything worked fine during the previous steps, you should turn Pollfish to release mode and publish your app.


