//
//  SizeUtils.m
//  International
//
//  Created by a on 2019/11/19.
//  Copyright © 2019 com. All rights reserved.
//

#import "QDSizeUtils.h"
#import <UIKit/UIKit.h>
@interface QDSizeUtils ()
@end
@implementation QDSizeUtils
//+ (BOOL)isIphoneX {
//
//    return ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? ( CGSizeEqualToSize(CGSizeMake(375, 812),[UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(812, 375),[UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(414, 896),[UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(896, 414),[UIScreen mainScreen].bounds.size)) : NO);
//}

+ (BOOL)isIphoneX {
    BOOL iPhoneX = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {//判断是否是手机
        return iPhoneX;
    }
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneX = YES;
        }
    }
    return iPhoneX;
}

+ (float)navigationHeight{
    
    return [[UIApplication sharedApplication] statusBarFrame].size.height;
}

+ (float)is_width{
    return [UIScreen mainScreen].bounds.size.width;
}

+ (float)is_iphone6{
    NSString *iphoneSize = [NSString stringWithFormat:@"%.2f",[UIScreen mainScreen].bounds.size.width];
    return [iphoneSize floatValue];
}

+ (float)is_height{
    return [UIScreen mainScreen].bounds.size.height;
}

+ (float)is_tabBarHeight{
    return [self isIphoneX]?(49.0 + 34.0):(49.0);
}


@end
