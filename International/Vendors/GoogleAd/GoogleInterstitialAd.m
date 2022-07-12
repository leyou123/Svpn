//
//  GoogleInterstitialAd.m
//  International
//
//  Created by hzg on 2021/9/28.
//  Copyright © 2021 com. All rights reserved.
//

#import "GoogleInterstitialAd.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "GoogleAdConstant.h"
#import "UIUtils.h"

@interface GoogleInterstitialAd() <GADFullScreenContentDelegate>

@property(nonatomic, strong) GADInterstitialAd *interstitial;

@end

@implementation GoogleInterstitialAd


+ (GoogleInterstitialAd *) shared {
    static dispatch_once_t onceToken;
    static GoogleInterstitialAd *instance;
    dispatch_once(&onceToken, ^{
        instance = [GoogleInterstitialAd new];
        [instance setup];
    });
    return instance;
}

- (void) setup {
   
}

- (void)loadAd {
    self.interstitial = nil;
    
#if DEBUG
    NSString* unitID = kGoogleDevInsertAdId;
#else
    NSString* unitID = kGoogleDisInsertAdId;
#endif
    [GADInterstitialAd loadWithAdUnitID:unitID
                              request:[GADRequest request]
                    completionHandler:^(GADInterstitialAd *ad, NSError *error) {
        if (error) {
          NSLog(@"Failed to load interstitial ad with error: %@", [error localizedDescription]);
          return;
        }
        self.interstitial = ad;
        self.interstitial.fullScreenContentDelegate = self;
    }];
}

- (BOOL) canPresent {
    NSError* err;
    UIViewController *vc = [UIUtils getCurrentVC];
    BOOL canPresent = [self.interstitial canPresentFromRootViewController:vc error:&err];
    NSLog(@"canPresent = %@", err);
    return canPresent;
}

- (void) show {
    _isShow = YES;
    UIViewController* vc = [UIUtils getCurrentVC];
    NSError* err;
    
    NSLog(@"fullScreenContentDelegate:%@",self.interstitial.fullScreenContentDelegate);
    
    BOOL canPresent = [self.interstitial canPresentFromRootViewController:vc error:&err];
    if (canPresent) {
        [self.interstitial presentFromRootViewController:vc];
    } else {
        _isShow = NO;
        [self loadAd];
    }
}

/// Tells the delegate that the ad failed to present full screen content.
- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad
didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
    [self loadAd];
    _isShow = NO;
}

/// Tells the delegate that the ad presented full screen content.
- (void)adDidPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    NSLog(@"Ad did present full screen content.");
    _isShow = YES;
}

/// Tells the delegate that the ad dismissed full screen content.
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    NSLog(@"Ad did dismiss full screen content.");
    [self loadAd];
    _isShow = NO;
}

@end
