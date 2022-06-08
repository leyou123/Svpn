//
//  VungleAd.h
//  International
//
//  Created by hzg on 2022/1/19.
//  Copyright © 2022 com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VungleAds : NSObject

+ (VungleAds *) shared;

- (void)showInterstitial;

- (void) setup;

- (void) cacheVideo;
- (BOOL) isCachedVideo;
- (void) show:(VideoFinishedCallback)callback;

@property(nonatomic, assign) BOOL isShow;
- (void) cacheInsert;
- (BOOL) isCachedInsert;
- (void) showInsertAd;

- (void) cacheBanner;
- (BOOL) isCachedBanner;
- (void) showBannerAd:(UIViewController*)vc toBottom:(CGFloat)toBottom;
- (void) removeBanner;

@end

NS_ASSUME_NONNULL_END
