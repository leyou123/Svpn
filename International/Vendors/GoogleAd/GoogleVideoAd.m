//
//  GoogleVideoAd.m
//  StormVPN
//
//  Created by hzg on 2021/7/12.
//

#import "GoogleVideoAd.h"
#import "GoogleAdConstant.h"
#import "UIUtils.h"

@interface GoogleVideoAd()<GADFullScreenContentDelegate>

@property(nonatomic, copy) VideoFinishedCallback videoFinishedCallback;
@property(nonatomic, assign) BOOL isRewarded;
@property(nonatomic, assign) int playTimes;
@property(nonatomic, assign) int totalPlayTimes;
@property(nonatomic, assign) int tryFailTimes;

@end

@implementation GoogleVideoAd

+ (GoogleVideoAd *) shared {
    static dispatch_once_t onceToken;
    static GoogleVideoAd *instance;
    dispatch_once(&onceToken, ^{
        instance = [GoogleVideoAd new];
    });
    return instance;
}

- (void)show:(VideoFinishedCallback)callback{
    self.videoFinishedCallback = callback;
    self.playTimes = 1;
    self.totalPlayTimes = 1;
    self.tryFailTimes = 3;
    [self play];
}

- (void) play {
    NSError* err;
    UIViewController* vc = [UIUtils getCurrentVC];
    BOOL canPresent = [self.rewardedAd canPresentFromRootViewController:vc error:&err];
    NSLog(@"canPresent = %@", err);
    self.isRewarded = NO;
    if (canPresent) {
        WS(weakSelf);
        [self.rewardedAd presentFromRootViewController:vc
                                  userDidEarnRewardHandler:^{
            weakSelf.isRewarded = YES;
            weakSelf.playTimes -= 1;
            UIViewController* vc1 = [UIUtils getCurrentVC];
            if (weakSelf.playTimes <= 0) {
                [vc1 dismissViewControllerAnimated:NO completion:nil];
                weakSelf.videoFinishedCallback(YES);
            } else {
                [vc1 dismissViewControllerAnimated:NO completion:nil];
            }
        }];
    } else {
        if (self.playTimes > 0) [self loadRewardedAd:NO];
    }
}

- (void)preLoadRewardedAd {
    [self loadRewardedAd:YES];
}

- (void)loadRewardedAd:(BOOL) isPreLoad {
    GADRequest *request = [GADRequest request];

#if DEBUG
    NSString* adUnitID = kGoogleDevVideoAdId;
#else
    NSString* adUnitID = kGoogleDisVideoAdId;
#endif
    
    self.rewardedAd = nil;
    
    if (!isPreLoad) {
//        if (self.totalPlayTimes > 1) {
//            NSString* tip = [NSString stringWithFormat:NSLocalizedString(@"Ad_Reward_Tip", nil), self.playTimes];
//            [SVProgressHUD showWithStatus:tip];
//        } else {
//            [SVProgressHUD show];
//        }
        [SVProgressHUD show];
    }
    [GADRewardedAd loadWithAdUnitID:adUnitID request:request completionHandler:^(GADRewardedAd *ad, NSError *error) {
        if (!isPreLoad) {
            [SVProgressHUD dismiss];
        }
        if (error) {
            NSLog(@"Rewarded ad failed to load with error: %@", [error localizedDescription]);
            return;
        }
        self.rewardedAd = ad;
        NSLog(@"Rewarded ad loaded.");
        self.rewardedAd.fullScreenContentDelegate = self;
        if (!isPreLoad) {
            [self play];
        }
    }];
}

/// Tells the delegate that the ad failed to present full screen content.
- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad
didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
    NSLog(@"Ad did fail to present full screen content.");
}

/// Tells the delegate that the ad presented full screen content.
- (void)adDidPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    NSLog(@"Ad did present full screen content.");
}

/// Tells the delegate that the ad dismissed full screen content.
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    NSLog(@"Ad did dismiss full screen content.");
    if (self.playTimes > 0) {
        if (self.isRewarded) {
            [self play];
        } else {
            self.playTimes = -1;
            [SVProgressHUD dismiss];
            self.videoFinishedCallback(NO);
        }
    }
}



@end
