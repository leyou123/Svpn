//
//  GoogleNatvieAd.m
//  International
//
//  Created by hzg on 2021/7/13.
//  Copyright © 2021 com. All rights reserved.
//

#import "GoogleNatvieAd.h"
#import "GoogleAdConstant.h"

@interface GoogleNatvieAd()<GADNativeAdLoaderDelegate>

@property(nonatomic, strong) GADAdLoader *adLoader;
@property(nonatomic, strong)GADNativeAd* nativeAd;
@property(nonatomic, weak)GADTTemplateView* templateView;

@end

@implementation GoogleNatvieAd

+ (GoogleNatvieAd *) shared {
    static dispatch_once_t onceToken;
    static GoogleNatvieAd *instance;
    dispatch_once(&onceToken, ^{
        instance = [GoogleNatvieAd new];
        [instance setup];
    });
    return instance;
}

- (void) setup {
    
    GADMultipleAdsAdLoaderOptions *multipleAdsOptions =
          [[GADMultipleAdsAdLoaderOptions alloc] init];
      multipleAdsOptions.numberOfAds = 5;
    
#if DEBUG
    NSString* adUnitID = kGoogleDevNativeAdId;
#else
    NSString* adUnitID = kGoogleDisNativeAdId;
#endif
    
    UIViewController* vc = UIApplication.sharedApplication.keyWindow.rootViewController;
    self.adLoader = [[GADAdLoader alloc] initWithAdUnitID:adUnitID
              rootViewController:vc
                                                  adTypes:@[GADAdLoaderAdTypeNative]
                         options:@[multipleAdsOptions]];
    self.adLoader.delegate = self;
    [self.adLoader loadRequest:[GADRequest request]];
}

- (void) showByView:(GADTTemplateView*)view {
    if (self.nativeAd) {
        view.nativeAd = self.nativeAd;
    } else {
        [self.adLoader loadRequest:[GADRequest request]];
    }
}

// 刷新原生广告
- (void) reloadAd {
    [self.adLoader loadRequest:[GADRequest request]];
}

- (void)adLoader:(GADAdLoader *)adLoader
    didReceiveNativeAd:(GADNativeAd *)nativeAd {
   // A native ad has loaded, and can be displayed.
    NSLog(@"didReceiveNativeAd");
    self.nativeAd = nativeAd;
    if (self.templateView&&self.templateView.superview) self.templateView.nativeAd = nativeAd;
}

- (void)adLoaderDidFinishLoading:(GADAdLoader *) adLoader {
  // The adLoader has finished loading ads, and a new request can be sent.
    NSLog(@"adLoaderDidFinishLoading");
    
}

- (void)adLoader:(nonnull GADAdLoader *)adLoader didFailToReceiveAdWithError:(nonnull NSError *)error {
    NSLog(@"didFailToReceiveAdWithError");
}

@end
