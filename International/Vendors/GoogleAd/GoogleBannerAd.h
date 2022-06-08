//
//  GoogleBannerAd.h
//  StormVPN
//
//  Created by hzg on 2021/7/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoogleBannerAd : NSObject

+ (GoogleBannerAd *) shared;

- (BOOL) isShowBanner;
- (void)showBannerAd:(UIViewController*)vc toBottom:(CGFloat)toBottom callback:(VideoFinishedCallback)callback;
- (void)removeBannerAd;

@end

NS_ASSUME_NONNULL_END
