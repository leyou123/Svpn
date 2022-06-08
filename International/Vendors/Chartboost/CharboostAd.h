//
//  CharboostAd.h
//  International
//
//  Created by hzg on 2021/7/27.
//  Copyright © 2021 com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Chartboost/Chartboost.h>

NS_ASSUME_NONNULL_BEGIN

@interface CharboostAd : NSObject

+ (CharboostAd *) shared;
- (void) setup;
- (void) show:(VideoFinishedCallback)callback;

@property (nonatomic, strong) CHBRewarded *rewarded;
// 插屏广告
@property (nonatomic, strong) CHBInterstitial *interstitial;

// banner
@property (nonatomic, strong) CHBBanner *banner;

// 加载视频
- (void) cacheVideo;

@property(nonatomic, assign) BOOL isShow;
- (void) showInsertAd;

- (void) showBannerAd:(UIViewController*)vc toBottom:(CGFloat)toBottom;
- (void) removeBanner;

@end

NS_ASSUME_NONNULL_END
