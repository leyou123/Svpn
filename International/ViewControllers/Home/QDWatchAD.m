//
//  QDWatchAD.m
//  International
//
//  Created by LC on 2022/4/19.
//  Copyright © 2022 com. All rights reserved.
//

#import "QDWatchAD.h"
#import "QDDateUtils.h"
#import "QDBaseResultModel.h"
#import "QDPayViewController3.h"
#import "QDPayViewController2.h"
#import <sys/utsname.h>

@interface QDWatchAD()

@property(nonatomic, strong) NSString* typeString;

@end

@implementation QDWatchAD

- (void)watchAd {
    [QDTrackManager track_button:QDTrackButtonType_31];
    
    if (QDActivityManager.shared.activityResultModel.watchAdTimes <= 0) {
        NSString* zeroTime = [QDDateUtils getTime:0 andMinute:0];
        NSString* limit1 = NSLocalizedString(@"Ad_Play_Limit", nil);
//        NSString* limit2 = [NSString stringWithFormat:NSLocalizedString(@"Home_Ad_RefreshTime", nil), zeroTime];
//        NSString* limit = [NSString stringWithFormat:@"%@\n%@", limit1, limit2];
        // 次数达到上限
        [SVProgressHUD showErrorWithStatus:limit1];
    } else {
        if (!QDAdManager.shared.isRVAvailable) {
            // 请求广告失败
            [QDDialogManager showDialog:NSLocalizedString(@"Ad_Request_Fail", nil) message:NSLocalizedString(@"Ad_Request_Text", nil) ok:NSLocalizedString(@"Dialog_Retry", nil) cancel:NSLocalizedString(@"Dialog_Cancel", nil) okBlock:^{
                [self watchAd];
            } cancelBlock:^{
                
            }];
            [QDAdManager.shared loadVideo];
        } else {
            [QDAdManager.shared showVideo:^(BOOL result) {
                if (result) [self doRewardAction];
            }];
        }
    }
}

// 奖励
- (void) doRewardAction {
    // 奖励
    [SVProgressHUD show];
    [QDModelManager requestUserAddTimeNew:4 time:30*60 completed:^(NSDictionary * _Nonnull dictionary) {
        NSLog(@"dictionary = %@", dictionary);
        QDBaseResultModel* result = [QDBaseResultModel mj_objectWithKeyValues:dictionary];
        if (result.code == kHttpStatusCode200) {
            
            [QDActivityManager.shared watchAdComplete];
            
            [SVProgressHUD dismiss];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserChange object:nil];
            
            NSString* watchAd = NSLocalizedString(@"Ad_reward_watch", nil);
            NSString* rmAd = NSLocalizedString(@"Ad_rm", nil);
            NSString* cancel = NSLocalizedString(@"Dialog_Cancel", nil);
            [QDDialogView show:NSLocalizedString(@"Ad_reward_suc", nil) message:NSLocalizedString(@"Ad_reward_text", nil) items:@[rmAd] backImages:@[@"home_premium"]  hideWhenTouchOutside:NO cancel:cancel callback:^(NSString *item) {
                if ([item isEqual:watchAd]) {
                    [self watchAd];
                } else if ([item isEqual:rmAd]) {
                    [self doPayAction];
                }
            }];
            
        } else {
            [SVProgressHUD showWithStatus:result.message];
            [SVProgressHUD dismissWithDelay:HUDDISMISSTIME];
        }
    }];
}

// 调转至支付界面
- (void) doPayAction {
    self->_typeString = [self platformString];
    if ([self->_typeString isEqualToString:@"iPhone 6s"]||[self->_typeString isEqualToString:@"iPhone 6"]||[self->_typeString isEqualToString:@"iPhone 7"]||[self->_typeString isEqualToString:@"iPhone 8"]) {
        QDPayViewController3* vc = [QDPayViewController3 new];
        UIViewController* rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [rootViewController presentViewController:vc animated:YES completion:nil];

    }else{
        QDPayViewController2* vc = [QDPayViewController2 new];
        UIViewController* rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [rootViewController presentViewController:vc animated:YES completion:nil];

    }
}

//获取ios设备号
- (NSString *)platformString {

    //需要导入头文件：#import <sys/utsname.h>
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];

    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"])   return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,4"])   return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    if ([deviceString isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([deviceString isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    if ([deviceString isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";

    if ([deviceString isEqualToString:@"iPhone12,1"])   return @"iPhone 11";
    if ([deviceString isEqualToString:@"iPhone12,3"])   return @"iPhone 11 Pro";
    if ([deviceString isEqualToString:@"iPhone12,5"])   return @"iPhone 11 Pro Max";

    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";

   
    if ([deviceString isEqualToString:@"AppleTV2,1"])    return @"Apple TV 2";
    if ([deviceString isEqualToString:@"AppleTV3,1"])    return @"Apple TV 3";
    if ([deviceString isEqualToString:@"AppleTV3,2"])    return @"Apple TV 3";
    if ([deviceString isEqualToString:@"AppleTV5,3"])    return @"Apple TV 4";

    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";

    return deviceString;


}


@end
