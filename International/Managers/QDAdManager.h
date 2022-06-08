//
//  LYAdHelper.h
//  vpn
//
//  Created by hzg on 2021/3/22.
//

#import <Foundation/Foundation.h>

typedef void(^VideoFinishedCallback)(BOOL result);

NS_ASSUME_NONNULL_BEGIN

@interface QDAdManager : NSObject

+ (QDAdManager *) shared;

// 禁止广告
@property(nonatomic, assign) BOOL forbidAd;

// 视频广告
@property (nonatomic, assign, readonly) BOOL isRVAvailable;

// 插页广告
@property (nonatomic, assign) int showOrder;
// 激励广告
@property (nonatomic, assign) int showVideoOrder;

// 初始化配置
- (void) setup:(BOOL)showAuth;

// 显示&销毁banner
- (BOOL) isShowBanner;
- (void) showBanner:(UIViewController*)vc toBottom:(CGFloat)toBottom;
- (void) removeBannerAd;

// 显示开屏
- (void) showOpenAd;

// 显示video
- (void) showVideo:(VideoFinishedCallback)callback;
// 加载视频
- (void) loadVideo;


// 显示插屏
- (void) showInterstitial;

// 显示原生广告
- (void) showNativeAd:(UIView*)view;
- (void) reloadNativeAd;

@end

NS_ASSUME_NONNULL_END
