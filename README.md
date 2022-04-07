# Pollfish iOS AdMob Mediation Adapter

AdMob Mediation Adapter for iOS apps looking to load and show Rewarded Surveys from Pollfish in the same waterfall with other Rewarded Ads.

> **Note:** A detailed step by step guide is provided on how to integrate can be found [here](https://www.pollfish.com/docs/ios-admob-adapter) 

<br/>

## Step 1: Add Pollfish AdMob Adapter to your project

Download the following frameworks

* [Pollfish SDK](https://www.pollfish.com/docs/ios)
* [PollfishAdMobAdapter](https://github.com/pollfish/ios-admob-adapter)

and add them in your App's target dependecies 

1. Navigate to your project
2. Select your App's target and go to the **General** tab section **Frameworks, Libraries and Embedded Content**
3. Add all dependent framewokrs one by one by pressing the + button -> Add other and selecting the appropriate framework

Add the following frameworks (if you don’t already have them) in your project

- AdSupport.framework  
- CoreTelephony.framework
- SystemConfiguration.framework 
- WebKit.framework (added in Pollfish v4.4.0)

**OR**

#### **Retrieve Pollfish AdMob Adapter through CocoaPods**

Add a Podfile with Pollfish framework as a pod reference:

```ruby
pod 'PollfishAdMobAdapter'
```
You can find latest Pollfish iOS SDK version on CocoaPods [here](https://cocoapods.org/pods/PollfishAdMobAdapter)

Run pod install on the command line to install Pollfish cocoapod.

<br/>

## Step 2: Request for a RewardedAd

Import `GoogleMobileAds`

<span style="text-decoration:underline">Swift</span>

```swift
import GoogleMobileAds
```

<span style="text-decoration:underline">Objective C</span>

```objc
@import GoogleMobileAds;
```

<br/>

Initialize the SDK in your app delegate’s `application:applicationDidFinishLaunching:` method

<span style="text-decoration:underline">Swift</span>

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    GADMobileAds.sharedInstance().start()
    
    return true
}
```

<span style="text-decoration:underline">Objective C</span>

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[GADMobileAds sharedInstance] startWithCompletionHandler:nil];
    return YES;
}
```

<br/>

Implement `GoogleMobileAds` so that you are notified when your ad is ready and of other ad-related events.

<br/>

Request a GADRewardedAd from AdMob by calling `load` in the `GADRewardedAd` object passing a `GADRequest` instance and your `AD_UNIT_ID` id. By default Pollfish AdMob Adapter will use the configuration as provided on AdMob's dashboard. If no configuration is provided or if you want to override any of those params please see step 3.

<br/>

<span style="text-decoration:underline">Swift</span>

```swift
class ViewController: UIViewController, GADFullScreenContentDelegate {

    var rewardedAd: GADRewardedAd?

    ...

    func createRewardedAd() {
        let request = GADRequest()

        GADRewardedAd.load(withAdUnitID: "AD_UNIT_ID",
                           request: request) { (ad, error) in

            guard let error = error else {
                print("Failed to load ad with error: \(error!.localizedDescription)")
                return
            }
            
            self.rewardedAd = ad
            self.rewardedAd?.fullScreenContentDelegate = self
        }
    }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {}
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {}
    
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {}

}
```

<span style="text-decoration:underline">Objective C</span>

```objc
@interface ViewController()<GADFullScreenContentDelegate>
@property(nonatomic, strong) GADRewardedAd *rewardedAd;
@end

@implementation ViewController

...

- (void)createRewardedAd
{
    GADRequest *request = [GADRequest request];

    [GADRewardedAd loadWithAdUnitID:@"AD_UNIT_ID" request:request completionHandler:^(GADRewardedAd *ad, NSError *error) {
        if (error) {
            NSLog(@"Failed to load interstitial ad with error: %@", [error localizedDescription]);
            return;
        }
        
        self.rewardedAd = ad;
        self.rewardedAd.fullScreenContentDelegate = self;
    }];
}

#pragma mark - GADFullScreenContentDelegate Protocol

- (void)adDidPresentFullScreenContent:(id)ad {}

- (void)ad:(id)ad didFailToPresentFullScreenContentWithError:(NSError *)error {}

- (void)adDidDismissFullScreenContent:(id)ad {}

@end
```

When the Rewarded Ad is ready, present the ad by invoking `rewardedAd.present` which accepts a `ViewController` and a reward completion block. Just to be sure, you can combine present with a nullity check to see if the Ad you are about to show is actualy ready.

<span style="text-decoration:underline">Swift</span>

```swift
if (rewardedAd != nil) {
    rewardedAd?.present(fromRootViewController: self) {
        let reward = self.rewardedAd!.adReward
        print("Reward received with currency \(reward.type), amount \(reward.amount)")
    }
} 
```

<span style="text-decoration:underline">Objective C</span>

```objc
if (self.rewardedAd) {
    [self.rewardedAd presentFromRootViewController:self userDidEarnRewardHandler:^(void) {
        GADAdReward *reward = self.rewardedAd.adReward;
        NSString *rewardMessage = [NSString stringWithFormat:@"Reward received with currency %@, amount %lf", reward.type, [reward.amount doubleValue]];
        NSLog(@"%@", rewardMessage);
    }];
} 
```

<br/>

## Step 3: Use and control Pollfish AdMob Adapter in your Rewarded Ad Unit (Optional)

Pollfish AdMob Adapter provides different options that you can use to control the behaviour of Pollfish SDK. This configuration, if applied, will override any configuration done in AdMob's dashboard.

<br/>

Below you can see all the available options of **GADPollfishRewardedNetworkExtras** instance that is used to configure the behaviour of Pollfish SDK.

<br/>

No | Description
------------ | -------------
3.1 | **`.pollfishAPIKey`**  <br/> Sets Pollfish SDK API key as provided by Pollfish
3.2 | **`.requestUUID`**  <br/> Sets a unique id to identify a user and be passed through server-to-server callbacks
3.3 | **`.releaseMode`**  <br/> Sets Pollfish SDK to Developer or Release mode
3.4 | **`.offerwallMode`** <br/> Sets Pollfish SDK to Offerwall Mode   


### 3.1 `.pollfishAPIKey`

Pollfish API Key as provided by Pollfish on  [Pollfish Dashboard](https://www.pollfish.com/publisher/) after you sign up to the platform.  If you have already specified Pollfish API Key on AdMob's UI, this param will be ignored.

### 3.2 `.requestUUID`

Sets a unique id to identify a user and be passed through server-to-server callbacks on survey completion. 

In order to register for such callbacks you can set up your server URL on your app's page on Pollfish Developer Dashboard and then pass your requestUUID through ParamsBuilder object during initialization. On each survey completion you will receive a callback to your server including the requestUUID param passed.

If you would like to read more on Pollfish s2s callbacks you can read the documentation [here](https://www.pollfish.com/docs/s2s)

### 3.3 `.releaseMode`

Sets Pollfish SDK to Developer or Release mode.

*   **Developer mode** is used to show to the developer how Pollfish surveys will be shown through an app (useful during development and testing).
*   **Release mode** is the mode to be used for a released app in any app store (start receiving paid surveys).

Pollfish AdMob Adapter runs Pollfish SDK in release mode by default. If you would like to test with Test survey, you should set release mode to fasle.

### 3.4 `.offerwallMode`

Enables offerwall mode. If not set, one single survey is shown each time.

Below you can see an example on how you can use `GADPollfishRewardedNetworkExtras` to pass info to Pollfish AdMob Adapter:

<span style="text-decoration:underline">Swift</span>

```swift
import PollfishAdMobAdapter

...

let request = GADRequest()
        
let pollfishNetworkExtras = GADPollfishRewardedNetworkExtras()
pollfishNetworkExtras.pollfishAPIKey = "POLLFISH_API_KEY"
pollfishNetworkExtras.releaseMode = false
pollfishNetworkExtras.requestUUID = "USER_ID"
pollfishNetworkExtras.offerwallMode = false

request.register(pollfishNetworkExtras)
```

<span style="text-decoration:underline">Objective C</span>

```objc
#import <PollfishAdMobAdapter/GADPollfishRewardedNetworkExtras.h>

...

GADRequest *request = [GADRequest request];
    
GADPollfishRewardedNetworkExtras *pollfishNetworkExtras = [[GADPollfishRewardedNetworkExtras alloc] init];
    
pollfishNetworkExtras.pollfishAPIKey = @"POLLFISH_API_KEY";
pollfishNetworkExtras.releaseMode = false;
pollfishNetworkExtras.requestUUID = @"YOUR_USER_ID";
pollfishNetworkExtras.offerwallMode = false;
    
[request registerAdNetworkExtras:pollfishNetworkExtras];
```

<br/>

## Step 4: Publish your app on the store

If you everything worked fine during the previous steps, you should turn Pollfish to release mode and publish your app.

> **Note:** After you take your app live, you should request your account to get verified through Pollfish Dashboard in the App Settings area.

> **Note:** There is an option to show **Standalone Demographic Questions** needed for Pollfish to target users with surveys even when no actually surveys are available. Those surveys do not deliver any revenue to the publisher (but they can increase fill rate) and therefore if you do not want to show such surveys in the Waterfall you should visit your **App Settings** are and disable that option.

