//
//  UnityAds.h
//  International
//
//  Created by 杜国锋 on 2022/5/26.
//  Copyright © 2022 com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^InterstitialFinishedBlock)(void);

typedef void(^VideoFinishedCallback)(BOOL result);

NS_ASSUME_NONNULL_BEGIN

@interface UnityOpenAds : NSObject

+ (UnityOpenAds *) shared;

- (void) setup;

- (void)showInterstitialAd:(InterstitialFinishedBlock)callback;

- (void)showRewardedAd:(VideoFinishedCallback)callback;

- (void) showBannerAd:(UIViewController*)vc toBottom:(CGFloat)toBottom;

- (void)unLoadBottomBanner;

- (BOOL)isSupport;

- (BOOL)isInitialized;

@property (nonatomic, copy) VideoFinishedCallback videoCallback;
@property (nonatomic, copy) InterstitialFinishedBlock interstitialCallback;

@end

NS_ASSUME_NONNULL_END
