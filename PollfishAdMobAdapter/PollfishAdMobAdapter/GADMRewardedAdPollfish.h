//
//  GADMRewardedAdPollfish.h
//  TestAdMob
//
//  Created by Pollfish on 20/11/19.
//  Copyright © 2019 POLLFISH. All rights reserved.
//

#import <Foundation/Foundation.h>

@import GoogleMobileAds;

static BOOL panelOpen =false;

@interface GADMRewardedAdPollfish : NSObject <GADMediationRewardedAd>

- (void)loadRewardedAdForAdConfiguration:(GADMediationRewardedAdConfiguration *)adConfiguration
                       completionHandler:
                           (GADMediationRewardedLoadCompletionHandler)completionHandler;

@end
