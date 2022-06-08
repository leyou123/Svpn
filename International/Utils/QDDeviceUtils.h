//
//  QDDeviceUtils.h
//  International
//
//  Created by a on 2019/11/19.
//  Copyright © 2019 com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QDDeviceUtils : NSObject

// 取值
+ (NSString*) getContentFromKeyChain:(NSString *)string;

// 存值
+ (BOOL) setContentFromKeyChain:(NSString *)content forKey:(NSString *) key;

// 删值
+ (BOOL) removeContentFromKeyChain:(NSString *) key;

// 获取设备号
+ (NSString *)platformString;

// 678判断
+ (BOOL)deviceIs678;

// pad判断
+ (BOOL)deviceIsPad;

// 网络判断
+ (NSString *)deviceNetWork;

// 获取运营商
+ (NSString *)getCarrierInfo;

@end

NS_ASSUME_NONNULL_END
