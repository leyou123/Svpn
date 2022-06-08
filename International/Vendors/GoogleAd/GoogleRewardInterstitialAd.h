//
//  GoogleRewardInterstitialAd.h
//  International
//
//  Created by LC on 2022/6/7.
//  Copyright © 2022 com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoogleRewardInterstitialAd : NSObject

+ (GoogleRewardInterstitialAd *) shared;

@property(nonatomic, assign) BOOL isShow;

// 显示广告
- (void) show;

// 是否可以展示
- (BOOL) canPresent;

// 加载广告
- (void)loadAd;

@end

NS_ASSUME_NONNULL_END
