//
//  AppDelegate.m
//  ExamplePollfishAdMob
//
//  Copyright © 2020 Pollfish, Inc. All rights reserved.
//

#import "AppDelegate.h"
@import GoogleMobileAds;


@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[GADMobileAds sharedInstance] startWithCompletionHandler:nil];
    return YES;
}

#pragma mark - UISceneSession lifecycle

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options  API_AVAILABLE(ios(13.0)){
    if (@available(iOS 13.0, *)) {
        return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
    } else {
        return nil;
    }
}

@end
