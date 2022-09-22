//
//  GADMRewardedAdPollfish.h
//  PollfishAdMobAdapter
//
//  Copyright © 2020 Pollfish, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GoogleMobileAds;
#import <Pollfish/Pollfish-Swift.h>

@interface GADMRewardedAdPollfish : NSObject <GADMediationRewardedAd, PollfishDelegate>

- (void)loadRewardedAdForAdConfiguration:(GADMediationRewardedAdConfiguration *)adConfiguration
                       completionHandler:
                           (GADMediationRewardedLoadCompletionHandler)completionHandler;

@end
