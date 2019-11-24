//
//  GADMediationAdapterPollfish.m
//  TestAdMob
//
//  Created by Pollfish on 21/11/19.
//  Copyright © 2019 POLLFISH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GADMRewardedAdPollfish.h"
#import "GADMediationAdapterPollfish.h"
#import "GADPollfishRewardedNetworkExtras.h"
#import "GADMAdapterPollfishConstants.h"

@import GoogleMobileAds;


@interface GADMediationAdapterPollfish () <GADRewardedAdDelegate>
@end

@implementation GADMediationAdapterPollfish {
  GADMRewardedAdPollfish *_rewardedAd;
}

+ (nullable Class<GADAdNetworkExtras>)networkExtrasClass {
    return [GADPollfishRewardedNetworkExtras class];
}


+ (GADVersionNumber)adSDKVersion {
  NSString *versionString = kGADMAdapterPollfishVersion;
  NSArray *versionComponents = [versionString componentsSeparatedByString:@"."];
  GADVersionNumber version = {0};
  if (versionComponents.count == 3) {
    version.majorVersion = [versionComponents[0] integerValue];
    version.minorVersion = [versionComponents[1] integerValue];
    version.patchVersion = [versionComponents[2] integerValue];
  }
  return version;
}

+ (GADVersionNumber)version {
  NSString *versionString = kGADMAdapterPollfishVersion;
  NSArray *versionComponents = [versionString componentsSeparatedByString:@"."];
  GADVersionNumber version = {0};
  if (versionComponents.count == 4) {
    version.majorVersion = [versionComponents[0] integerValue];
    version.minorVersion = [versionComponents[1] integerValue];

    // Adapter versions have 2 patch versions. Multiply the first patch by 100.
    version.patchVersion = [versionComponents[2] integerValue] * 100
      + [versionComponents[3] integerValue];
  }
  return version;
}

+ (void)setUpWithConfiguration:(GADMediationServerConfiguration *)configuration
             completionHandler:(GADMediationAdapterSetUpCompletionBlock)completionHandler {
   // INFO: Pollfish SDK doesn't have any initialization API.
   completionHandler(nil);
}

- (void)loadRewardedAdForAdConfiguration:(GADMediationRewardedAdConfiguration *)adConfiguration
                       completionHandler:
                           (GADMediationRewardedLoadCompletionHandler)completionHandler {
    
  _rewardedAd = [[GADMRewardedAdPollfish alloc] init];
  [_rewardedAd loadRewardedAdForAdConfiguration:adConfiguration
                              completionHandler:completionHandler];
}

- (void)rewardedAd:(nonnull GADRewardedAd *)rewardedAd userDidEarnReward:(nonnull GADAdReward *)reward {

}

@end
