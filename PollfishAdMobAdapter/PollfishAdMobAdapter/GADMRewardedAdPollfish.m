//
//  GADMRewardedAdPollfish.m
//  PollfishAdMobAdapter
//
//  Copyright © 2020 Pollfish, Inc. All rights reserved.
//

#import "GADMRewardedAdPollfish.h"
#import <Pollfish/Pollfish-Swift.h>
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
    
    if(Pollfish.isPollfishPanelOpen) {

           NSError *error = [NSError errorWithDomain:kGADMAdapterPollfishErrorDomain

                               code:0

                           userInfo:@{NSLocalizedDescriptionKey : @"Survey Already Present, Skipping"}];

           completionHandler(nil, error);

           return;

       }
    
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
    __block bool releaseMode = true;
    __block bool offerwallMode = false;
    NSString *jsonParams=nil;
    
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

    jsonParams = adConfiguration.credentials.settings[@"parameter"];

    if ((jsonParams!=nil) && ([jsonParams length] > 0)) {
        
        NSLog(@"Pollfish jsonParams: %@", jsonParams);
        
        NSData *data = [jsonParams dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if((jsonDictionary!=nil) && ([jsonDictionary count]>0)){
           
            if ([jsonDictionary objectForKey:@"api_key"]) {
               
                pollfishAPIKey = [jsonDictionary objectForKey:@"api_key"];
                
                if(POLLFISH_DEBUG) NSLog(@"Pollfish API Key from AdMob UI: %@", pollfishAPIKey);
            }
            
            if ([jsonDictionary objectForKey:@"request_uuid"]) {
               
                requestUUID = [jsonDictionary objectForKey:@"request_uuid"];
                
                if(POLLFISH_DEBUG) NSLog(@"Pollfish requestUUID  from AdMob UI: %@", requestUUID);
            }
            
            if ([jsonDictionary objectForKey:@"release_mode"]) {
                
                releaseMode = [[jsonDictionary objectForKey:@"release_mode"] boolValue];
                     
                if(POLLFISH_DEBUG) NSLog(@"Pollfish releaseMode from AdMob UI: %d", releaseMode);
            }
            
            
            if ([jsonDictionary objectForKey:@"offerwall_mode"]) {
                         
                offerwallMode = [[jsonDictionary objectForKey:@"offerwall_mode"] boolValue];
                               
                if(POLLFISH_DEBUG) NSLog(@"Pollfish offerwall_mode from AdMob UI: %d", offerwallMode);
                           
            }
        }
    }
    
    if(POLLFISH_DEBUG) NSLog(@"Pollfish API Key: %@", pollfishAPIKey);
    
    if ([pollfishAPIKey length] == 0) {
        NSError *error = [NSError errorWithDomain:kGADMAdapterPollfishErrorDomain code:204 userInfo:nil];
        completionHandler(nil, error);
        return;
    }
    
    //used to retrieve the top level window
    __block UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    
    PollfishParams *pollfishParams = [[PollfishParams alloc] init:pollfishAPIKey];
    [pollfishParams indicatorPosition:IndicatorPositionMiddleRight];
    [pollfishParams platform:PlatformAdMob];
    [pollfishParams releaseMode:releaseMode];
    [pollfishParams rewardMode:true];
    [pollfishParams requestUUID:requestUUID];
    [pollfishParams offerwallMode:offerwallMode];
    [pollfishParams viewContainer:window.rootViewController.view];
    
    [Pollfish initWith:pollfishParams delegate:self];
    
    NSLog(@"Initializing Pollfish...");
}

#pragma mark - GADMediationRewardedAd

- (void)presentFromViewController:(UIViewController *)viewController {
    [Pollfish show];
}

#pragma mark - PollfishDelegate methods

- (void) pollfishSurveyCompletedWithSurveyInfo:(SurveyInfo *)surveyInfo
{
    int rewardValue = [[surveyInfo rewardValue] intValue];
    NSString *rewardName = [surveyInfo rewardName];
    
    if(POLLFISH_DEBUG) NSLog(@"Pollfish Survey Completed RewardName:%@ andRewardValue:%d", rewardName, rewardValue);
    
    GADAdReward *pollfishReward = [[GADAdReward alloc] initWithRewardType:rewardName
                                                             rewardAmount:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", rewardValue]]];
    
    [_adEventDelegate didRewardUserWithReward:pollfishReward];
}

- (void) pollfishSurveyReceivedWithSurveyInfo:(SurveyInfo *)surveyInfo
{
    _adEventDelegate = _completionHandler(self, nil);
    
    if (surveyInfo != nil) {
        int rewardValue = [[surveyInfo rewardValue] intValue];
        NSString *rewardName = [surveyInfo rewardName];
        
        if(POLLFISH_DEBUG) NSLog(@"Pollfish Survey Received RewardName:%@ andRewardValue:%d", rewardName, rewardValue);
    } else {
        if(POLLFISH_DEBUG) NSLog(@"Pollfish Survey Received");
    }
}

- (void) pollfishClosed
{
    if(POLLFISH_DEBUG) NSLog(@"Pollfish Closed");
    
    [_adEventDelegate didEndVideo];
    [_adEventDelegate didDismissFullScreenView];
}

- (void) pollfishOpened
{
    if(POLLFISH_DEBUG) NSLog(@"Pollfish Opened");

    [_adEventDelegate willPresentFullScreenView];
    [_adEventDelegate didStartVideo];
    [_adEventDelegate reportClick];
    [_adEventDelegate reportImpression];
}

- (void) pollfishSurveyNotAvailable
{
    if(POLLFISH_DEBUG) NSLog(@"Pollfish Not Available");
 
    NSError *error =
    [NSError errorWithDomain:kGADMAdapterPollfishErrorDomain
                        code:0
                    userInfo:@{NSLocalizedDescriptionKey : @"Survey Not Available"}];
    
    _completionHandler(nil, error);
}

- (void) pollfishUserNotEligible
{
    if(POLLFISH_DEBUG)  NSLog(@"Pollfish User Not Eligible");
    
    [_adEventDelegate willDismissFullScreenView];
    [_adEventDelegate didDismissFullScreenView];
}

- (void) pollfishUserRejectedSurvey
{
    if(POLLFISH_DEBUG) NSLog(@"Pollfish User Rejected Survey");

    [_adEventDelegate willDismissFullScreenView];
    [_adEventDelegate didDismissFullScreenView];
}

@end
