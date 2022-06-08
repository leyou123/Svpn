//
//  GoogleRewardInterstitialAd.m
//  International
//
//  Created by LC on 2022/6/7.
//  Copyright © 2022 com. All rights reserved.
//

#import "GoogleRewardInterstitialAd.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "GoogleAdConstant.h"
#import "UIUtils.h"

@interface GoogleRewardInterstitialAd ()<GADFullScreenContentDelegate>

@property(nonatomic, strong) GADRewardedInterstitialAd *rewardedInterstitialAd;

@end

@implementation GoogleRewardInterstitialAd

+ (GoogleRewardInterstitialAd *) shared {
    static dispatch_once_t onceToken;
    static GoogleRewardInterstitialAd *instance;
    dispatch_once(&onceToken, ^{
        instance = [GoogleRewardInterstitialAd new];
        [instance setup];
    });
    return instance;
}

- (void) setup {
   
}

- (void)loadAd {
    self.rewardedInterstitialAd = nil;
    
#if DEBUG
    NSString* unitID = kGoogleDevRewardInsertAdId;
#else
    NSString* unitID = kGoogleDevRewardInsertAdId;
#endif

    [GADRewardedInterstitialAd
           loadWithAdUnitID:unitID
                    request:[GADRequest request]
          completionHandler:^(
              GADRewardedInterstitialAd *_Nullable rewardedInterstitialAd,
              NSError *_Nullable error) {
            if (!error) {
              self.rewardedInterstitialAd = rewardedInterstitialAd;
              self.rewardedInterstitialAd.fullScreenContentDelegate = self;
            }
          }];
    
}

- (BOOL) canPresent {
    NSError* err;
    UIViewController *vc = [UIUtils getCurrentVC];
    BOOL canPresent = [self.rewardedInterstitialAd canPresentFromRootViewController:vc error:&err];
    NSLog(@"canPresent = %@", err);
    return canPresent;
}

- (void) show {
    _isShow = YES;
    UIViewController* vc = [UIUtils getCurrentVC];
    NSError* err;
    BOOL canPresent = [self.rewardedInterstitialAd canPresentFromRootViewController:vc error:&err];
    if (canPresent) {
        [self.rewardedInterstitialAd presentFromRootViewController:vc userDidEarnRewardHandler:^{
            
        }];
    } else {
        _isShow = NO;
        [self loadAd];
    }
}

/// Tells the delegate that the ad failed to present full screen content.
- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad
didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
    NSLog(@"Ad did fail to present full screen content.");
    [self loadAd];
    _isShow = NO;
}

/// Tells the delegate that the ad will present full screen content.
- (void)adWillPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {

    NSLog(@"Ad will present full screen content.");
    _isShow = YES;
}

/// Tells the delegate that the ad dismissed full screen content.
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
   NSLog(@"Ad did dismiss full screen content.");
    [self loadAd];
    _isShow = NO;
}

@end
