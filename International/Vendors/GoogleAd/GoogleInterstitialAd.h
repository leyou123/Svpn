//
//  GoogleInterstitialAd.h
//  International
//
//  Created by hzg on 2021/9/28.
//  Copyright © 2021 com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoogleInterstitialAd : NSObject

+ (GoogleInterstitialAd *) shared;

@property(nonatomic, assign) BOOL isShow;

// 显示广告
- (void) show;

// 是否可以展示
- (BOOL) canPresent;

// 加载广告
- (void)loadAd;

@end

NS_ASSUME_NONNULL_END
