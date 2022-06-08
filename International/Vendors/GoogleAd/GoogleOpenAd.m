//
//  GoogleOpenAd.m
//  StormVPN
//
//  Created by hzg on 2021/7/12.
//

#import <GoogleMobileAds/GoogleMobileAds.h>
#import "GoogleOpenAd.h"
#import "GoogleAdConstant.h"

@interface GoogleOpenAd() <GADFullScreenContentDelegate>

@property(strong, nonatomic) GADAppOpenAd* appOpenAd;
@property(weak, nonatomic) NSDate *loadTime;

@end

@implementation GoogleOpenAd

+ (GoogleOpenAd *) shared {
    static dispatch_once_t onceToken;
    static GoogleOpenAd *instance;
    dispatch_once(&onceToken, ^{
        instance = [GoogleOpenAd new];
        [instance setup];
    });
    return instance;
}

- (void) setup {
}

- (void)requestAppOpenAd {
    self.appOpenAd = nil;
    
#if DEBUG
    NSString* unitID = kGoogleDevOpenAdId;
#else
    NSString* unitID = kGoogleDisOpenAdId;
#endif
    
    [GADAppOpenAd loadWithAdUnitID:unitID
                         request:[GADRequest request]
                     orientation:UIInterfaceOrientationPortrait
               completionHandler:^(GADAppOpenAd *_Nullable appOpenAd, NSError *_Nullable error) {
                 if (error) {
                   NSLog(@"Failed to load app open ad: %@", error);
                   return;
                 }
                 self.appOpenAd = appOpenAd;
                 self.appOpenAd.fullScreenContentDelegate = self;
                 self.loadTime = [NSDate date];
               }];
}

- (BOOL) canPresent {
    NSError* err;
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    BOOL canPresent = [self.appOpenAd canPresentFromRootViewController:vc error:&err];
    NSLog(@"canPresent = %@", err);
    return canPresent;
}

- (void)tryToPresentAd {
    _isShow = YES;
    if (self.appOpenAd && [self wasLoadTimeLessThanNHoursAgo:4]) {
          UIViewController *rootController = [UIApplication sharedApplication].keyWindow.rootViewController;
        [self.appOpenAd presentFromRootViewController:rootController];
    } else {
        _isShow = NO;
        // If you don't have an ad ready, request one.
        [self requestAppOpenAd];
    }
}

- (BOOL)wasLoadTimeLessThanNHoursAgo:(int)n {
  NSDate *now = [NSDate date];
  NSTimeInterval timeIntervalBetweenNowAndLoadTime = [now timeIntervalSinceDate:self.loadTime];
  double secondsPerHour = 3600.0;
  double intervalInHours = timeIntervalBetweenNowAndLoadTime / secondsPerHour;
  return intervalInHours < n;
}

#pragma mark - GADFullScreenContentDelegate
/// Tells the delegate that the ad failed to present full screen content.
- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad
    didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
  NSLog(@"didFailToPresentFullScreenContentWithError");
  [self requestAppOpenAd];
    _isShow = NO;
}

/// Tells the delegate that the ad presented full screen content.
- (void)adDidPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
  NSLog(@"adDidPresentFullScreenContent");
    _isShow = YES;
}

/// Tells the delegate that the ad dismissed full screen content.
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
  NSLog(@"adDidDismissFullScreenContent");
    _isShow = NO;
  [self requestAppOpenAd];

}

@end
