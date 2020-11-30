//
//  GADMRewardedAdPollfish.h
//
//  Created by Pollfish, Inc on 21/11/19.
//  Copyright © 2019 Pollfish, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface GADMRewardedAdPollfish : NSObject <GADMediationRewardedAd>

- (void)loadRewardedAdForAdConfiguration:(GADMediationRewardedAdConfiguration *)adConfiguration
                       completionHandler:
                           (GADMediationRewardedLoadCompletionHandler)completionHandler;

@end
