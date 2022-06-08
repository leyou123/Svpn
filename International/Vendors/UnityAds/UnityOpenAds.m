//
//  UnityAds.m
//  International
//
//  Created by 杜国锋 on 2022/5/26.
//  Copyright © 2022 com. All rights reserved.
//

#import "UnityOpenAds.h"
#import <UnityAds/UnityAds.h>
#import "QDSizeUtils.h"
#import "UIUtils.h"

static NSString * const kUnityAppId = @"4785952";
// banner
static NSString * const kUnityProjectID = @"19cb032c-36ad-4f7c-bed3-8cad68da3d64";

@interface UnityOpenAds ()<UnityAdsInitializationDelegate,UnityAdsLoadDelegate,UnityAdsShowDelegate,UADSBannerViewDelegate>

@property (assign, nonatomic) BOOL testMode;

@property (strong, nonatomic) UADSBannerView *bottomBannerView;

@end

@implementation UnityOpenAds

+ (UnityOpenAds *) shared {
    static dispatch_once_t onceToken;
    static UnityOpenAds *instance;
    dispatch_once(&onceToken, ^{
        instance = [UnityOpenAds new];
    });
    return instance;
}

- (void) setup {
#if DEBUG
    self.testMode = YES;
#else
    self.testMode = NO;
#endif
    [UnityAds initialize:kUnityAppId testMode:self.testMode initializationDelegate:self];
}

- (void)showInterstitialAd:(InterstitialFinishedBlock)callback {
    UIViewController* vc = [UIUtils getCurrentVC];
    [UnityAds show:vc placementId:@"Interstitial_iOS" showDelegate:self];
    self.interstitialCallback = callback;
}

- (void)showRewardedAd:(VideoFinishedCallback)callback; {
    UIViewController* vc = [UIUtils getCurrentVC];
    [UnityAds show:vc placementId:@"Rewarded_iOS" showDelegate:self];
    self.videoCallback = callback;
}

- (void) showBannerAd:(UIViewController*)vc toBottom:(CGFloat)toBottom; {
    [self unLoadBottomBanner];
    self.bottomBannerView = [[UADSBannerView alloc] initWithPlacementId:@"Banner_IOS" size: CGSizeMake(320, 50)];
    self.bottomBannerView.delegate = self;
    [vc.view addSubview:self.bottomBannerView];
    [_bottomBannerView load];
    [self.bottomBannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(vc.view);
        make.bottom.equalTo(vc.view).offset(toBottom);
        make.width.equalTo(@([QDSizeUtils is_width] - 55));
        make.height.equalTo(@(50));
    }];
}

- (void)unLoadBottomBanner{
    [self.bottomBannerView removeFromSuperview];
    _bottomBannerView = nil;
}

- (BOOL)isSupport {
    return UnityAds.isSupported;
}

- (BOOL)isInitialized {
    return UnityAds.isInitialized;
}


#pragma mark : UnityAdsInitializationDelegate
- (void)initializationComplete {
    NSLog(@" - UnityAdsInitializationDelegate initializationComplete" );
    // Pre-load an ad when initialization succeeds, so it is ready to show:
    [UnityAds load:@"Interstitial_iOS" loadDelegate:self];
}
 
- (void)initializationFailed:(UnityAdsInitializationError)error withMessage:(NSString *)message {
    NSLog(@" - UnityAdsInitializationDelegate initializationFailed with message: %@", message );
}
 
// Implement load callbacks to handle success or failure after initialization:
#pragma mark: UnityAdsLoadDelegate
- (void)unityAdsAdLoaded:(NSString *)placementId {
    NSLog(@" - UnityAdsLoadDelegate unityAdsAdLoaded %@", placementId);
}
 
- (void)unityAdsAdFailedToLoad:(NSString *)placementId
                     withError:(UnityAdsLoadError)error
                   withMessage:(NSString *)message {
    NSLog(@" - UnityAdsLoadDelegate unityAdsAdFailedToLoad %@", placementId);
}

#pragma mark: UnityAdsShowDelegate
- (void)unityAdsShowComplete:(NSString *)placementId withFinishState:(UnityAdsShowCompletionState)state {
    NSLog(@" - UnityAdsShowDelegate unityAdsShowComplete %@ %ld", placementId, state);
    if ([placementId isEqualToString:@"Interstitial_iOS"]) {
        self.interstitialCallback();
    }else
    if ([placementId isEqualToString:@"Rewarded_iOS"]) {
        self.videoCallback(state);
    }
}

- (void)unityAdsShowClick:(nonnull NSString *)placementId {
    
}


- (void)unityAdsShowFailed:(nonnull NSString *)placementId withError:(UnityAdsShowError)error withMessage:(nonnull NSString *)message {
}


- (void)unityAdsShowStart:(nonnull NSString *)placementId {
    
}


#pragma mark : UADSBannerViewDelegate

- (void)bannerViewDidLoad:(UADSBannerView *)bannerView {
    // Called when the banner view object finishes loading an ad.
    NSLog(@"Banner loaded for Ad Unit or Placement: %@", bannerView.placementId);
}
 
- (void)bannerViewDidClick:(UADSBannerView *)bannerView {
    // Called when the banner is clicked.
    NSLog(@"Banner was clicked for Ad Unit or Placement: %@", bannerView.placementId);
}
 
- (void)bannerViewDidLeaveApplication:(UADSBannerView *)bannerView {
    // Called when the banner links out of the application.
}
 
 
- (void)bannerViewDidError:(UADSBannerView *)bannerView error:(UADSBannerError *)error{
    // Called when an error occurs showing the banner view object.
    NSLog(@"Banner encountered an error for Ad Unit or Placement: %@ with error message %@", bannerView.placementId, [error localizedDescription]);
    // Note that the UADSBannerError can indicate no fill (see API documentation).
}


@end
