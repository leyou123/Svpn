//
//  GoogleVideoAd.h
//  StormVPN
//
//  Created by hzg on 2021/7/12.
//

#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>


@interface GoogleVideoAd : NSObject

+ (GoogleVideoAd *) shared;

// 显示广告
- (void) show:(VideoFinishedCallback)callback;

// 预加载广告
- (void)preLoadRewardedAd;

// 广告是否可用
@property(nonatomic, strong) GADRewardedAd *rewardedAd;


@end

