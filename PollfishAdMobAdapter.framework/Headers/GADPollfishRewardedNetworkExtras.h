//
//  PollfishNetworkExtras.h
//  TestAdMob
//
//  Created by Pollfish on 20/11/19.
//  Copyright © 2019 POLLFISH. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GADAdNetworkExtras.h>

@interface GADPollfishRewardedNetworkExtras : NSObject <GADAdNetworkExtras>

/*!
* @brief Pollfish API Key
*/
@property (nonatomic, copy) NSString *pollfishAPIKey;
/*!
* @brief Custom id for the user
*/
@property (nonatomic, copy) NSString *requestUUID;

/*!
* @brief Controls whether Pollfish will run in Release or Debug mode
*/
@property (nonatomic, assign) bool releaseMode;



@end
