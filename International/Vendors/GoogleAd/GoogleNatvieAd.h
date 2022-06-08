//
//  GoogleNatvieAd.h
//  International
//
//  Created by hzg on 2021/7/13.
//  Copyright © 2021 com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "GADTTemplateView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GoogleNatvieAd : NSObject

+ (GoogleNatvieAd *) shared;

// 初始化并预加载广告
- (void) setup;
// 显示原生广告
- (void) showByView:(GADTTemplateView*)view;
// 刷新原生广告
- (void) reloadAd;

@end

NS_ASSUME_NONNULL_END
