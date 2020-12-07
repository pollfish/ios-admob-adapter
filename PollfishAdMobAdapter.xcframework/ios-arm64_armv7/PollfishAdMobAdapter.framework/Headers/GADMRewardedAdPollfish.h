//
//  GADMRewardedAdPollfish.h
//  PollfishAdMobAdapter
//
//  Copyright © 2020 Pollfish, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface GADMRewardedAdPollfish : NSObject <GADMediationRewardedAd>

- (void)loadRewardedAdForAdConfiguration:(GADMediationRewardedAdConfiguration *)adConfiguration
                       completionHandler:
                           (GADMediationRewardedLoadCompletionHandler)completionHandler;

@end
