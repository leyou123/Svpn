//
//  VungleAd.m
//  International
//
//  Created by hzg on 2022/1/19.
//  Copyright © 2022 com. All rights reserved.
//

#import "VungleAds.h"
#import <VungleSDK/VungleSDK.h>
#import "UIUtils.h"
#import "QDSizeUtils.h"

static NSString * const kVungleAppId = @"60e40b96ae1d68c62c58358c";
// banner
static NSString * const kVungleBannerplacementID = @"SUPER_BANNER_AD-1665743";
// 插屏
static NSString * const kVungleInsertplacementID = @"INSERT_AD-9498823";
// 视频
static NSString * const kVungleVideoplacementID = @"REWARD_AD-3465036";

@interface VungleAds() <VungleSDKDelegate>

@property (nonatomic, assign) BOOL isEarnReward;
@property(nonatomic, copy) VideoFinishedCallback videoFinishedCallback;
@property (nonatomic, strong) UIView* bannerView;

@end

@implementation VungleAds

+ (VungleAds *) shared {
    static dispatch_once_t onceToken;
    static VungleAds *instance;
    dispatch_once(&onceToken, ^{
        instance = [VungleAds new];
    });
    return instance;
}

- (void) setup {
    NSError* error;
    NSString* appID = kVungleAppId;
    VungleSDK* sdk = [VungleSDK sharedSDK];
    sdk.delegate = self;
    if (![sdk startWithAppId:appID error:&error]) {
        if (error) {
            NSLog(@"Error encountered starting the VungleSDK: %@", error);
        }
    }
}

- (void)vungleSDKDidInitialize {
    [self cacheAd:kVungleVideoplacementID];
    [self cacheAd:kVungleInsertplacementID];
    [self cacheAd:kVungleBannerplacementID];
}

- (BOOL) isCachedVideo {
    VungleSDK* sdk = [VungleSDK sharedSDK];
    return sdk.isInitialized && [sdk isAdCachedForPlacementID:kVungleVideoplacementID];
}

- (void) cacheAd:(NSString*)placeId {
    NSError* error;
    NSString* placementID = placeId;
    VungleSDK* sdk = [VungleSDK sharedSDK];
    BOOL result = NO;
    if (placementID != kVungleBannerplacementID) {
        result = [sdk loadPlacementWithID:placementID error:&error];
    } else {
        result = [sdk loadPlacementWithID:placementID withSize:VungleAdSizeBanner error:&error];
    }
    if (!result) {
        if (error) {
            NSLog(@"Error occurred when loading placement: %@", error);
        }
    }
}

- (void) cacheVideo {
    [self cacheAd:kVungleVideoplacementID];
}

- (void) show:(VideoFinishedCallback)callback {
    self.videoFinishedCallback = callback;
    VungleSDK* sdk = [VungleSDK sharedSDK];
    NSError *error;
    self.isEarnReward = NO;
    if (![sdk playAd:[UIUtils getCurrentVC] options:nil placementID:kVungleVideoplacementID error:&error]) {
         if (error) {
             NSLog(@"Error encountered playing ad: %@", error);
             self.videoFinishedCallback(NO);
         }
    }
}

- (BOOL) isCachedInsert {
    VungleSDK* sdk = [VungleSDK sharedSDK];
    return sdk.isInitialized && [sdk isAdCachedForPlacementID:kVungleInsertplacementID];
}

- (void) cacheInsert {
    [self cacheAd:kVungleInsertplacementID];
}

- (void) showInsertAd {
    VungleSDK* sdk = [VungleSDK sharedSDK];
    NSError *error;
    _isShow = YES;
    if (![sdk playAd:[UIUtils getCurrentVC] options:nil placementID:kVungleInsertplacementID error:&error]) {
         if (error) {
             _isShow = NO;
             NSLog(@"Error encountered playing ad: %@", error);
         }
    }
}

- (void) cacheBanner {
    [self cacheAd:kVungleBannerplacementID];
}

- (BOOL) isCachedBanner {
    VungleSDK* sdk = [VungleSDK sharedSDK];
    return sdk.isInitialized && [sdk isAdCachedForPlacementID:kVungleBannerplacementID];
}

- (void) showBannerAd:(UIViewController*)vc toBottom:(CGFloat)toBottom {
    
    [self removeBanner];
    self.bannerView = [UIView new];
    [vc.view addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(vc.view);
        make.bottom.equalTo(vc.view).offset(toBottom);
        make.width.equalTo(@([QDSizeUtils is_width] - 55));
        make.height.equalTo(@(50));
    }];
    
    NSError *error;
    NSDictionary *options = @{};
    VungleSDK* sdk = [VungleSDK sharedSDK];
    if (![sdk addAdViewToView:self.bannerView withOptions:options placementID:kVungleBannerplacementID error:&error]) {
          if (error) {
              NSLog(@"Error encountered while playing an ad: %@", error);
          }
    }
}

- (void) removeBanner {
    if (!self.bannerView && self.bannerView.superview != nil) {
        [_bannerView removeFromSuperview];
        _bannerView = nil;
    }
}

- (void)vungleRewardUserForPlacementID:(nullable NSString *)placementID {
    if ([placementID isEqualToString:kVungleVideoplacementID]) {
        self.isEarnReward = YES;
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIViewController* vc = [UIUtils getCurrentVC];
//            [vc dismissViewControllerAnimated:NO completion:nil];
//            self.videoFinishedCallback(YES);
//        });
        
    }
}

- (void)vungleDidShowAdForPlacementID:(nullable NSString *)placementID {
    if ([placementID isEqualToString:kVungleInsertplacementID]) {
        _isShow = YES;
    }
}

- (void)vungleDidCloseAdForPlacementID:(nonnull NSString *)placementID {
    [self cacheAd:placementID];
    if ([placementID isEqualToString:kVungleVideoplacementID]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.videoFinishedCallback(self.isEarnReward);
        });
    }
    
    if ([placementID isEqualToString:kVungleInsertplacementID]) {
        _isShow = NO;
    }
}

- (void)vungleSDKFailedToInitializeWithError:(NSError *)error {
    
}

@end
