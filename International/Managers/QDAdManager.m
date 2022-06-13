//
//  LYAdHelper.m
//  vpn
//
//  Created by hzg on 2021/3/22.
//

#import "QDAdManager.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>
#import "GoogleOpenAd.h"
#import "GoogleVideoAd.h"
#import "GoogleBannerAd.h"
#import "GoogleNatvieAd.h"
//#import "CharboostAd.h"
#import "GoogleInterstitialAd.h"
#import "VungleAds.h"
#import "UnityOpenAds.h"
#import "GoogleRewardInterstitialAd.h"

typedef void(^ResultBlock)(void);

@interface QDAdManager()

@property (nonatomic, copy) ResultBlock resultBlock;

@end

@implementation QDAdManager

+ (QDAdManager *) shared {
    static dispatch_once_t onceToken;
    static QDAdManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [QDAdManager new];
    });
    return instance;
}

- (void) setup:(BOOL)showAuth {
    if (!showAuth) {
        [self loadAd];
        return;
    }
    if (@available(iOS 14, *)) {
        if (ATTrackingManager.trackingAuthorizationStatus != ATTrackingManagerAuthorizationStatusAuthorized) {
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                [self loadAd];
            }];
        } else {
            [self loadAd];
        }
    } else {
        [self loadAd];
    }
}

- (void) loadAd {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 提前加载广告
//        [GoogleOpenAd.shared requestAppOpenAd];
        [GoogleVideoAd.shared preLoadRewardedAd];
        [GoogleInterstitialAd.shared loadAd];
        [GoogleNatvieAd.shared setup];
        [GoogleRewardInterstitialAd.shared loadAd];
        [VungleAds.shared setup];
        [UnityOpenAds.shared setup];
//        [CharboostAd.shared setup];
    });
}

// 显示开屏
- (void) showOpenAd {
    [self showInterstitial];
    
//    if (QDAdManager.shared.forbidAd) return;
//    if (GoogleOpenAd.shared.isShow) return;
//    if (GoogleInterstitialAd.shared.isShow) return;
//    if (VungleAds.shared.isShow) return;
//
//    [GoogleRewardInterstitialAd.shared show];
    
//    if (QDAdManager.shared.forbidAd) return;
//    if (GoogleOpenAd.shared.isShow) return;
//    if (GoogleInterstitialAd.shared.isShow) return;
//    if (VungleAds.shared.isShow) return;
//    if (CharboostAd.shared.isShow) return;
//
//    if ([GoogleOpenAd.shared canPresent]) {
//        [GoogleOpenAd.shared tryToPresentAd];
//        return;
//    } else {
//        [GoogleOpenAd.shared requestAppOpenAd];
//    }
//
//    if ([GoogleInterstitialAd.shared canPresent]) {
//        [GoogleInterstitialAd.shared show];
//        return;
//    } else {
//        [GoogleInterstitialAd.shared loadAd];
//    }
//
//    if ([VungleAds.shared isCachedInsert]) {
//        [VungleAds.shared showInsertAd];
//        return;
//    } else {
//        [VungleAds.shared cacheInsert];
//    }
//
//    if (CharboostAd.shared.interstitial.isCached) {
//        [CharboostAd.shared showInsertAd];
//        return;
//    } else {
//        [CharboostAd.shared.interstitial cache];
//    }
}

- (BOOL) isShowBanner {
    return [GoogleBannerAd.shared isShowBanner];
}

// banner 显示
- (void)showBanner:(UIViewController*)vc toBottom:(CGFloat)toBottom {
    
    [GoogleBannerAd.shared showBannerAd:vc toBottom:toBottom callback:^(BOOL result) {
        if (result) {
            [VungleAds.shared removeBanner];
//            [CharboostAd.shared removeBanner];
        } else {
            if (UnityOpenAds.shared.isSupport) {
                [UnityOpenAds.shared showBannerAd:vc toBottom:toBottom];
                return;
            }else {
                [[UnityOpenAds shared] setup];
            }
            if ([VungleAds.shared isCachedBanner]) {
                [VungleAds.shared showBannerAd:vc toBottom:toBottom];
                return;
            } else {
                [VungleAds.shared cacheBanner];
            }
            
            
//
//            if ([CharboostAd.shared.banner isCached]) {
//                [CharboostAd.shared showBannerAd:vc toBottom:toBottom];
//                return;
//            } else {
//                [CharboostAd.shared.banner cache];
//            }
        }
    }];
}

// banner 销毁
- (void) removeBannerAd {
    [GoogleBannerAd.shared removeBannerAd];
    [VungleAds.shared removeBanner];
    [UnityOpenAds.shared unLoadBottomBanner];
//    [CharboostAd.shared removeBanner];
}

- (BOOL)isRVAvailable {
    return (GoogleVideoAd.shared.rewardedAd != nil || [VungleAds.shared isCachedVideo] || [UnityOpenAds shared].isSupport/* || CharboostAd.shared.rewarded.isCached*/);
}

// 加载视频
- (void) loadVideo {
    if (GoogleVideoAd.shared.rewardedAd != nil) [GoogleVideoAd.shared preLoadRewardedAd];
//    if (![VungleAds.shared isCachedVideo]) [VungleAds.shared cacheVideo];
//    if (!CharboostAd.shared.rewarded.isCached) [CharboostAd.shared cacheVideo];
}

// 显示视频广告
- (void) showVideo:(VideoFinishedCallback)callback {
    if (self.showVideoOrder == 0) {
        self.showVideoOrder = 1;
        if (GoogleVideoAd.shared.rewardedAd != nil) {
            [GoogleVideoAd.shared show:callback];
            return;;
        }
        else if (UnityOpenAds.shared.isSupport) {
            [UnityOpenAds.shared showRewardedAd:callback];
            return;
        }
        else if ([VungleAds.shared isCachedVideo]) {
            [VungleAds.shared show:callback];
            return;
        }

    }else {
        self.showVideoOrder = 0;
        if (UnityOpenAds.shared.isSupport) {
            [UnityOpenAds.shared showRewardedAd:callback];
            return;
        }
        else if (GoogleVideoAd.shared.rewardedAd != nil) {
            [GoogleVideoAd.shared show:callback];
            return;
        }
        else if ([VungleAds.shared isCachedVideo]) {
            [VungleAds.shared show:callback];
            return;
        }
    }
    
//    else if (CharboostAd.shared.rewarded.isCached) {
//        [CharboostAd.shared show:callback];
//    }
}

// 显示插屏
- (void) showInterstitial {
    
    if (QDAdManager.shared.forbidAd) return;
    if (GoogleOpenAd.shared.isShow) return;
    if (GoogleInterstitialAd.shared.isShow) return;
    if (VungleAds.shared.isShow) return;
//    if (CharboostAd.shared.isShow) return;

    
//    if (self.showOrder == 0) {
//        self.showOrder = 1;
//        if ([UnityOpenAds shared].isSupport && [UnityOpenAds shared].isInitialized) {
//            [UnityOpenAds.shared showInterstitialAd:^() {
//
//            }];
//            return;
//        }else {
//            [UnityOpenAds.shared setup];
//        }
//        if ([GoogleInterstitialAd.shared canPresent]) {
//            [GoogleInterstitialAd.shared show];
//            return;
//        } else {
//            [GoogleInterstitialAd.shared loadAd];
//        }
//        if ([VungleAds.shared isCachedInsert]) {
//            [VungleAds.shared showInsertAd];
//            return;
//        } else {
//            [VungleAds.shared cacheInsert];
//        }
//    }else if (self.showOrder == 1) {
//        self.showOrder = 0;
        if ([GoogleInterstitialAd.shared canPresent]) {
            [GoogleInterstitialAd.shared show];
            return;
        } else {
            [GoogleInterstitialAd.shared loadAd];
        }
        if ([UnityOpenAds shared].isSupport && [UnityOpenAds shared].isInitialized) {
            [UnityOpenAds.shared showInterstitialAd:^() {
                
            }];
            return;
        }else {
            [UnityOpenAds.shared setup];
        }
        if ([VungleAds.shared isCachedInsert]) {
            [VungleAds.shared showInsertAd];
            return;
        } else {
            [VungleAds.shared cacheInsert];
        }
//    }
    
//    else {
//        [self showVungle:^{
//            [self showGoogle:^{
//                [self showUnity:^{
//
//                }];
//            }];
//        }];
//        self.showOrder = 0;
//    }

//    if (CharboostAd.shared.interstitial.isCached) {
//        [CharboostAd.shared showInsertAd];
//        return;
//    } else {
//        [CharboostAd.shared.interstitial cache];
//    }
}


- (void) showNativeAd:(UIView*)view {
    [GoogleNatvieAd.shared showByView:(GADTTemplateView*)view];
}

- (void) reloadNativeAd {
    [GoogleNatvieAd.shared reloadAd];
}

@end
