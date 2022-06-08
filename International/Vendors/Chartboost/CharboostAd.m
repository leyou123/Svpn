//
//  CharboostAd.m
//  International
//
//  Created by hzg on 2021/7/27.
//  Copyright © 2021 com. All rights reserved.
//

#import "CharboostAd.h"
#import "UIUtils.h"
#import "QDSizeUtils.h"

static NSString * const kChartboostAppId = @"60ffb077f2a64107c03645df";
static NSString * const kChartboostAppSignature = @"2858a2a2f3e4c2bdebf58de3d9d9abf083fc90e0";


@interface CharboostAd() <CHBRewardedDelegate, CHBInterstitialDelegate, CHBBannerDelegate>

@property (nonatomic, assign) BOOL isEarnReward;
@property(nonatomic, copy) VideoFinishedCallback videoFinishedCallback;

@end

@implementation CharboostAd

+ (CharboostAd *) shared {
    static dispatch_once_t onceToken;
    static CharboostAd *instance;
    dispatch_once(&onceToken, ^{
        instance = [CharboostAd new];
    });
    return instance;
}

- (void) setup {
    [Chartboost addDataUseConsent:[CHBGDPRDataUseConsent gdprConsent:CHBGDPRConsentBehavioral]];
    [Chartboost addDataUseConsent:[CHBCCPADataUseConsent ccpaConsent:CHBCCPAConsentOptInSale]];
    
    [Chartboost setLoggingLevel:CBLoggingLevelInfo];
    
    [Chartboost startWithAppId:kChartboostAppId
                  appSignature:kChartboostAppSignature
                    completion:^(BOOL success) {
//        ViewController *vc = (ViewController *)self.window.rootViewController;
//        [vc log:success ? @"Chartboost initialized successfully!" : @"Chartboost failed to initialize."];
        if (success) {
            [self cacheAds];
        }
    }];
}

- (void) cacheAds {
    self.rewarded = [[CHBRewarded alloc] initWithLocation:CBLocationDefault delegate:self];
    [self.rewarded cache];
    
    self.interstitial = [[CHBInterstitial alloc] initWithLocation:CBLocationDefault delegate:self];
    [self.interstitial cache];
    
    self.banner = [[CHBBanner alloc] initWithSize:CHBBannerSizeStandard location:CBLocationDefault delegate:self];
}

- (BOOL) isCached {
    return (self.rewarded && self.rewarded.isCached);
}

- (void) cacheVideo {
    if (!self.rewarded.isCached) [self.rewarded cache];
}

// 显示广告
- (void) show:(VideoFinishedCallback)callback {
    self.isEarnReward = NO;
    self.videoFinishedCallback = callback;
    if (self.rewarded.isCached) {
        [self.rewarded showFromViewController:[UIUtils getCurrentVC]];
    } else {
        NSLog(@"Tried to show a rewarded ad before it is cached");
        self.videoFinishedCallback(NO);
    }
}

- (void) showInsertAd {
    _isShow = YES;
    if (self.interstitial.isCached) {
        [self.interstitial showFromViewController:[UIUtils getCurrentVC]];
    }
}

- (void) showBannerAd:(UIViewController*)vc toBottom:(CGFloat)toBottom {
    if (self.banner.isCached) {
        self.banner.backgroundColor = [UIColor whiteColor];
        self.banner.translatesAutoresizingMaskIntoConstraints = NO;
        [vc.view addSubview:self.banner];
        [self.banner mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(vc.view);
            make.bottom.equalTo(vc.view).offset(toBottom);
            make.width.equalTo(@([QDSizeUtils is_width] - 55));
            make.height.equalTo(@(50));
        }];
        [self.banner showFromViewController:vc];
    }
}

- (void) removeBanner {
    if (self.banner.superview != nil) {
        [self.banner removeFromSuperview];
    }
}

// MARK: - Ad Delegate (Interstitial & Rewarded)
- (void)didShowAd:(CHBShowEvent *)event error:(nullable CHBShowError *)error {
    if ([event.ad isEqual:self.interstitial]) {
        _isShow = YES;
    }
}

- (void)didDismissAd:(CHBDismissEvent *)event {
    if ([event.ad isEqual:self.interstitial]) {
        _isShow = NO;
    }
    NSLog(@"didDismissAd");
//    if (self.isEarnReward&&self.videoFinishedCallback) {
//        self.videoFinishedCallback(YES);
//    }
//    [self.rewarded cache];
}

// MARK: - Ad Delegate (Rewarded)
- (void)didEarnReward:(CHBRewardEvent *)event {
    NSLog(@"didEarnReward");
    [self.rewarded cache];
    self.isEarnReward = YES;
    UIViewController* vc = [UIUtils getCurrentVC];
    [vc dismissViewControllerAnimated:NO completion:nil];
    self.videoFinishedCallback(YES);
    
}


@end
