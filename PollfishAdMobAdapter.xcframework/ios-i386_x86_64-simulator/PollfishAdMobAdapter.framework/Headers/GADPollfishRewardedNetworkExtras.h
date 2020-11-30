//
//  PollfishNetworkExtras.h
//
//  Created by Pollfish, Inc on 21/11/19.
//  Copyright © 2019 Pollfish, Inc. All rights reserved.
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

/*!
* @brief Controls whether Pollfish will run in Offerwall mode
*/
@property (nonatomic, assign) bool offerwallMode;


@end
