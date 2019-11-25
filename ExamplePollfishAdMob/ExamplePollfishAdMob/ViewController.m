//
//  ViewController.m
//  TestAdMob
//
//  Created by Pollfish on 20/11/19.
//  Copyright © 2019 POLLFISH. All rights reserved.
//

#import "ViewController.h"

#import <PollfishAdMobAdapter/GADPollfishRewardedNetworkExtras.h>

@import GoogleMobileAds;

@interface ViewController ()<GADRewardedAdDelegate>
@property(nonatomic, strong)  GADRewardedAd *rewardedAd;
@property (strong, nonatomic) IBOutlet UIButton *rewardedAdBtn;
@end


@implementation ViewController
@synthesize rewardedAdBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rewardedAd = [self createAndLoadRewardedAd];
}

- (IBAction)showRewardedAd:(id)sender {
    
    if (self.rewardedAd.isReady) {
        [self.rewardedAd presentFromRootViewController:self delegate:self];
    } else {
        NSLog(@"Ad wasn't ready");
    }
}

- (GADRewardedAd *)createAndLoadRewardedAd {
    
    rewardedAdBtn.hidden=true;
    
    NSLog(@"createAndLoadRewardedAd");
    
    //GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers =@[ kGADSimulatorID, @"369ab630a1f3482229dd73c624095464"];
    
    
    GADRewardedAd *rewardedAd  = [[GADRewardedAd alloc]
                                  initWithAdUnitID:@"ADMOB_AD_UNIT_KEY"];
    
    GADRequest *request = [GADRequest request];
    
    GADPollfishRewardedNetworkExtras *pollfishNetworkExtras = [[GADPollfishRewardedNetworkExtras alloc] init];
    
    pollfishNetworkExtras.pollfishAPIKey = @"POLLFISH_API_KEY";
    pollfishNetworkExtras.releaseMode = false;
    pollfishNetworkExtras.requestUUID = @"USER_ID";
    
    [request registerAdNetworkExtras:pollfishNetworkExtras];
    
    [rewardedAd loadRequest:request completionHandler:^(GADRequestError * _Nullable error) {
        if (error) {
            // Handle ad failed to load case.
            NSLog(@"Error");
        } else {
            
            // Ad successfully loaded.
            self->rewardedAdBtn.hidden=false;
            NSLog(@"Ad successfully loaded.");
        }
    }];
    
    return rewardedAd;
}


#pragma mark GADRewardedAdDelegate implementation

- (void)rewardedAd:(nonnull GADRewardedAd *)rewardedAd
 userDidEarnReward:(nonnull GADAdReward *)reward {
    NSString *rewardMessage =
    [NSString stringWithFormat:@"Reward received with currency %@ , amount %lf", reward.type,
     [reward.amount doubleValue]];
    NSLog(@"%@", rewardMessage);
}

- (void)rewardedAd:(nonnull GADRewardedAd *)rewardedAd
didFailToPresentWithError:(nonnull NSError *)error {
    NSLog(@"Rewarded ad failed to present with error: %@.", error);
    rewardedAdBtn.hidden=true;
}

- (void)rewardedAdDidPresent:(nonnull GADRewardedAd *)rewardedAd {
    NSLog(@"Rewarded ad has presented.");
}

- (void)rewardedAdDidDismiss:(nonnull GADRewardedAd *)rewardedAd {
    NSLog(@"Rewarded ad is closed.");
    self.rewardedAd = [self createAndLoadRewardedAd];
}


@end
