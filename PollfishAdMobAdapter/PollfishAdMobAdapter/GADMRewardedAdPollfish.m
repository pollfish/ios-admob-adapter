//
//  GADMRewardedAdPollfish.m
//  TestAdMob
//
//  Created by Pollfish on 20/11/19.
//  Copyright © 2019 POLLFISH. All rights reserved.
//

#import "GADMRewardedAdPollfish.h"
#import <Pollfish/Pollfish.h>
#include <stdatomic.h>
#import "GADPollfishRewardedNetworkExtras.h"
#import "GADMAdapterPollfishConstants.h"

@interface GADMRewardedAdPollfish()
@end

@implementation GADMRewardedAdPollfish{
    
    // An ad event delegate to invoke when ad rendering events occur.
    __weak id<GADMediationRewardedAdEventDelegate> _adEventDelegate;
    
    /// The completion handler to call when the ad loading succeeds or fails.
    GADMediationRewardedLoadCompletionHandler _completionHandler;
    
    /// Ad Configuration for the ad to be rendered.
    GADMediationRewardedAdConfiguration *_adConfig;
    
    /// Pollfish API Key
    NSString *pollfishAPIKey;
    
}
- (void)loadRewardedAdForAdConfiguration:(GADMediationRewardedAdConfiguration *)adConfiguration
                       completionHandler:
(GADMediationRewardedLoadCompletionHandler)completionHandler {
    
    if(POLLFISH_DEBUG) NSLog(@"loadRewardedAdForAdConfiguration");
    
    
    _adConfig = adConfiguration;
    __block atomic_flag completionHandlerCalled = ATOMIC_FLAG_INIT;
    __block GADMediationRewardedLoadCompletionHandler originalCompletionHandler =
    [completionHandler copy];
    _completionHandler = ^id<GADMediationRewardedAdEventDelegate>(
                                                                  id<GADMediationRewardedAd> rewardedAd, NSError *error) {
        if (atomic_flag_test_and_set(&completionHandlerCalled)) {
            return nil;
        }
        id<GADMediationRewardedAdEventDelegate> delegate = nil;
        if (originalCompletionHandler) {
            delegate = originalCompletionHandler(rewardedAd, error);
        }
        originalCompletionHandler = nil;
        return delegate;
    };
    
    // Look for Pollfish Params Extras provided to the adapter
    
    __block NSString *requestUUID=nil;
    __block bool releaseMode = false;
    NSString *apiKey=nil;
    
    GADPollfishRewardedNetworkExtras *extras = [_adConfig extras];
    
    if (extras) {
        
        pollfishAPIKey = extras.pollfishAPIKey;
        requestUUID  = extras.requestUUID;
        releaseMode = extras.releaseMode;
        
        if(POLLFISH_DEBUG) NSLog(@"Pollfish API Key: %@", pollfishAPIKey);
        if(POLLFISH_DEBUG) NSLog(@"Pollfish RequestUUID: %@", requestUUID);
        if(POLLFISH_DEBUG) NSLog(@"Pollfish Release Mode: %d", releaseMode);
        
    }
    
    // Look for the "parameter" key to fetch the parameter you defined in the AdMob UI.
    
    apiKey = adConfiguration.credentials.settings[@"parameter"];
    
    if ((apiKey!=nil) && ([apiKey length] == 0)) {
        pollfishAPIKey = apiKey;
        if(POLLFISH_DEBUG) NSLog(@"Pollfish API Key from AdMob UI: %@", pollfishAPIKey);
    }
    if(POLLFISH_DEBUG) NSLog(@"Pollfish API Key: %@", pollfishAPIKey);
    
    if ([pollfishAPIKey length] == 0) {
        NSError *error = [NSError errorWithDomain:kGADMAdapterPollfishErrorDomain code:204 userInfo:nil];
        completionHandler(nil, error);
        return;
    }
    
    PollfishParams *pollfishParams =  [PollfishParams initWith:^(PollfishParams *pollfishParams) {
        
        pollfishParams.indicatorPosition=PollFishPositionMiddleRight;
        pollfishParams.releaseMode= releaseMode;
        pollfishParams.rewardMode=true;
        pollfishParams.requestUUID=requestUUID;
    }];
    
    [Pollfish initWithAPIKey:pollfishAPIKey andParams:pollfishParams];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pollfishNotAvailable) name:@"PollfishSurveyNotAvailable" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pollfishCompleted:) name:@"PollfishSurveyCompleted" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pollfishReceived:) name:@"PollfishSurveyReceived" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pollfishOpened) name:@"PollfishOpened" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pollfishClosed) name:@"PollfishClosed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pollfishUsernotEligible) name:@"PollfishUserNotEligible" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pollfishUserRejectedSurvey) name:@"PollfishUserRejectedSurvey" object:nil];
    
    
}
#pragma mark - GADMediationRewardedAd

- (void)presentFromViewController:(UIViewController *)viewController {
    [Pollfish show];
}



#pragma mark - Pollfish Delegate methods

- (void)pollfishCompleted:(NSNotification *)notification
{
    int rewardValue = [[[notification userInfo] valueForKey:@"reward_value"] intValue];
    NSString *rewardName = [[notification userInfo] valueForKey:@"reward_name"];
    
    if(POLLFISH_DEBUG) NSLog(@"Pollfish Survey Completed RewardName:%@ andRewardValue:%d",rewardName,rewardValue);
    
    GADAdReward *pollfishReward =[[GADAdReward alloc] initWithRewardType:rewardName
                                                            rewardAmount:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", rewardValue]]];
    
    [_adEventDelegate didRewardUserWithReward:pollfishReward];
}

- (void)pollfishReceived:(NSNotification *)notification
{
    
    _adEventDelegate = _completionHandler(self, nil);
    
    int rewardValue = [[[notification userInfo] valueForKey:@"reward_value"] intValue];
    NSString *rewardName = [[notification userInfo] valueForKey:@"reward_name"];
    
    if(POLLFISH_DEBUG) NSLog(@"Pollfish Survey Received RewardName:%@ andRewardValue:%d",rewardName,rewardValue);
    
}

- (void)pollfishOpened
{
    if(POLLFISH_DEBUG) NSLog(@"Pollfish Opened");
    
    [_adEventDelegate willPresentFullScreenView];
    [_adEventDelegate didStartVideo];
    [_adEventDelegate reportClick];
    [_adEventDelegate reportImpression];
}

- (void)pollfishClosed
{
    if(POLLFISH_DEBUG) NSLog(@"Pollfish Closed");
    
    
    [_adEventDelegate didEndVideo];
    [_adEventDelegate didDismissFullScreenView];
}

- (void)pollfishNotAvailable
{
    if(POLLFISH_DEBUG) NSLog(@"Pollfish Not Available");
    
    NSError *error =
    [NSError errorWithDomain:kGADMAdapterPollfishErrorDomain
                        code:0
                    userInfo:@{NSLocalizedDescriptionKey : @"Survey Not Available"}];
    
    _completionHandler(nil, error);
}


- (void)pollfishUsernotEligible
{
    if(POLLFISH_DEBUG)  NSLog(@"Pollfish User Not Eligible");
    NSError *error =
    [NSError errorWithDomain:kGADMAdapterPollfishErrorDomain
                        code:0
                    userInfo:@{NSLocalizedDescriptionKey : @"User not eligible"}];
    
    [_adEventDelegate didFailToPresentWithError:error];
}

- (void)pollfishUserRejectedSurvey
{
    if(POLLFISH_DEBUG) NSLog(@"Pollfish User Rejected Survey");
    
    NSError *error =
    [NSError errorWithDomain:kGADMAdapterPollfishErrorDomain
                        code:0
                    userInfo:@{NSLocalizedDescriptionKey : @"User Rejected Survey"}];
    
    [_adEventDelegate didFailToPresentWithError:error];
}

@end
