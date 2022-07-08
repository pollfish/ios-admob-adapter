//
//  ViewController.m
//  ExamplePollfishAdMob
//
//  Copyright © 2020 Pollfish, Inc. All rights reserved.
//

#import "ViewController.h"

#import <PollfishAdMobAdapter/GADPollfishRewardedNetworkExtras.h>

@import GoogleMobileAds;

@interface ViewController ()<GADFullScreenContentDelegate>
@property(nonatomic, strong)  GADRewardedAd *rewardedAd;
@property (strong, nonatomic) IBOutlet UIButton *rewardedAdBtn;
@end

@implementation ViewController
@synthesize rewardedAdBtn;

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (@available(iOS 14, *)) {
        [self requestIDFAPermission];
    } else {
        [self createAndLoadRewardedAd];
    }
}

- (void)requestIDFAPermission {
#if __has_include(<AppTrackingTransparency/AppTrackingTransparency.h>)
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self createAndLoadRewardedAd];
            });
        }];
    } else {
        // Fallback on earlier versions
    }
#endif
}

- (IBAction)showRewardedAd:(id)sender {
    if (self.rewardedAd) {
        [self.rewardedAd presentFromRootViewController:self userDidEarnRewardHandler:^(void) {
            GADAdReward *reward = self.rewardedAd.adReward;
            NSString *rewardMessage = [NSString stringWithFormat:@"Reward received with currency %@, amount %lf", reward.type, [reward.amount doubleValue]];
            NSLog(@"%@", rewardMessage);
        }];
    } else {
        NSLog(@"Ad wasn't ready");
    }
}

- (void) createAndLoadRewardedAd {
    
    rewardedAdBtn.hidden = true;
    
    NSLog(@"createAndLoadRewardedAd");
    
    GADRequest *request = [GADRequest request];
    
    GADPollfishRewardedNetworkExtras *pollfishNetworkExtras = [[GADPollfishRewardedNetworkExtras alloc] init];
    
    pollfishNetworkExtras.pollfishAPIKey = @"POLLFISH_API_KEY";
    pollfishNetworkExtras.releaseMode = false;
    pollfishNetworkExtras.requestUUID = @"USER_ID";
    
    [request registerAdNetworkExtras:pollfishNetworkExtras];
    
    [GADRewardedAd loadWithAdUnitID:@"ADMOB_AD_UNIT_KEY" request:request completionHandler:^(GADRewardedAd *ad, NSError *error) {
        if (error) {
            NSLog(@"Failed to load interstitial ad with error: %@", [error localizedDescription]);
            return;
        }
        self.rewardedAdBtn.hidden = false;
        self.rewardedAd = ad;
        self.rewardedAd.fullScreenContentDelegate = self;
    }];
}

#pragma mark GADFullScreenContentDelegate methods

- (void)adDidPresentFullScreenContent:(id)ad {
    NSLog(@"Rewarded ad has presented.");
}

- (void)ad:(id)ad didFailToPresentFullScreenContentWithError:(NSError *)error {
    NSLog(@"Rewarded ad failed to present with error: %@.", error);
    rewardedAdBtn.hidden=true;
}

- (void)adDidDismissFullScreenContent:(id)ad {
    NSLog(@"Rewarded ad is closed.");
    [self createAndLoadRewardedAd];
}

@end
