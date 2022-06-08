//
//  GoogleBannerAd.m
//  StormVPN
//
//  Created by hzg on 2021/7/12.
//

#import "GoogleBannerAd.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "GoogleAdConstant.h"
#import "QDSizeUtils.h"


@interface GoogleBannerAd()<GADBannerViewDelegate>

@property(nonatomic, strong) GADBannerView *bannerView;
@property(nonatomic, copy) VideoFinishedCallback videoFinishedCallback;

@end

@implementation GoogleBannerAd

+ (GoogleBannerAd *) shared {
    static dispatch_once_t onceToken;
    static GoogleBannerAd *instance;
    dispatch_once(&onceToken, ^{
        instance = [GoogleBannerAd new];
    });
    return instance;
}

- (BOOL) isShowBanner {
    return self.bannerView != nil && self.bannerView.superview != nil;
}

- (void)showBannerAd:(UIViewController*)vc toBottom:(CGFloat)toBottom callback:(VideoFinishedCallback)callback {
    
    self.videoFinishedCallback = callback;
    if (!self.bannerView) {
        self.bannerView = [GADBannerView new];
        self.bannerView.backgroundColor = [UIColor clearColor];
    } else {
        [self.bannerView removeFromSuperview];
    }
    [vc.view addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(vc.view);
        make.bottom.equalTo(vc.view).offset(toBottom);
        make.width.equalTo(@([QDSizeUtils is_width] - 55));
        make.height.equalTo(@(50));
    }];
    
    CGRect frame = vc.view.frame;
          // Here safe area is taken into account, hence the view frame is used after
  // the view has been laid out.
  if (@available(iOS 11.0, *)) {
    frame = UIEdgeInsetsInsetRect(vc.view.frame, vc.view.safeAreaInsets);
  }
  CGFloat viewWidth = frame.size.width;

  // Step 3 - Get Adaptive GADAdSize and set the ad view.
  // Here the current interface orientation is used. If the ad is being
  // preloaded for a future orientation change or different orientation, the
  // function for the relevant orientation should be used.
    self.bannerView.adSize = GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth);
    self.bannerView.rootViewController = vc;
    
#if DEBUG
    self.bannerView.adUnitID = kGoogleDevBannerAdId;
#else
    self.bannerView.adUnitID = kGoogleDisBannerAdId;
#endif
    
    self.bannerView.delegate = self;
    GADRequest *request = [GADRequest request];
    [self.bannerView loadRequest:request];
}

- (void)removeBannerAd {
    if (self.bannerView&&self.bannerView.superview) {
        [self.bannerView removeFromSuperview];
        self.bannerView = nil;
    }
}

/// Tells the delegate that an ad request successfully received an ad. The delegate may want to add
/// the banner view to the view hierarchy if it hasn't been added yet.
- (void)bannerViewDidReceiveAd:(nonnull GADBannerView *)bannerView {
    bannerView.alpha = 0;
    [UIView animateWithDuration:1.0 animations:^{
        bannerView.alpha = 1;
    }];
    if (self.videoFinishedCallback) self.videoFinishedCallback(YES);
}

/// Tells the delegate that an ad request failed. The failure is normally due to network
/// connectivity or ad availablility (i.e., no fill).
- (void)bannerView:(nonnull GADBannerView *)bannerView
didFailToReceiveAdWithError:(nonnull NSError *)error {
    NSLog(@"bannerView:didFailToReceiveAdWithError: %@", [error localizedDescription]);
    [self removeBannerAd];
    if (self.videoFinishedCallback) self.videoFinishedCallback(NO);
}

/// Tells the delegate that an impression has been recorded for an ad.
- (void)bannerViewDidRecordImpression:(nonnull GADBannerView *)bannerView {
    NSLog(@"bannerViewDidRecordImpression");
}

@end

