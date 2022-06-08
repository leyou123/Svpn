//
//  QDTimeView.m
//  International
//
//  Created by hzg on 2021/7/6.
//  Copyright © 2021 com. All rights reserved.
//

#import "QDTimeView.h"
#import "QDSizeUtils.h"
#import "QDBaseResultModel.h"
#import "QDPayViewController2.h"
#import "QDDateUtils.h"
#import <sys/utsname.h>
#import "QDPayViewController3.h"
@interface QDTimeView()

//@property(nonatomic, strong) UILabel* timeLabel;
@property(nonatomic, strong) UILabel* dateLabel;
@property(nonatomic, strong) UIButton* clickButton;
@property(nonatomic, strong) NSString* typeString;

@end

@implementation QDTimeView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup {
    
    // button
    UIButton* button = [UIButton new];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [button addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    
//    // select
//    UIImageView* backImageView = [UIImageView new];
//    UIImage* image = [UIImage imageNamed:@"line_back"];
//    backImageView.image = [image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.5];
//    [button addSubview:backImageView];
//    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(button);
//    }];
    
    // ad icon
    UIImageView* adIconImageView = [UIImageView new];
    adIconImageView.image = [UIImage imageNamed:@"watch"];
    [button addSubview:adIconImageView];
    [adIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(24);
        make.centerY.equalTo(self);
    }];
    
    // Add time label
    UILabel* timeLabel = [UILabel new];
    timeLabel.font = [UIFont systemFontOfSize:14];
    timeLabel.textColor = [UIColor blackColor];
    timeLabel.text = NSLocalizedString(@"Home_Time_Add", nil);
    [button addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(button);
        make.left.equalTo(adIconImageView.mas_right).offset(12);
    }];
    
    
//    // time
//    _timeLabel = [UILabel new];
//    _timeLabel.font = [UIFont systemFontOfSize:12];
//    _timeLabel.textColor = RGB(133, 133, 133);
//    NSString* zeroTime = [QDDateUtils getTime:0 andMinute:0];
//    _timeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Home_Ad_RefreshTime", nil), zeroTime];
//    [button addSubview:_timeLabel];
//    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(button);
//        make.top.equalTo(button.mas_bottom).offset(5);
//    }];
    
    // line
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = RGB_HEX(0xe5eff0);
    [button addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(button).offset(24);
        make.trailing.equalTo(button).offset(-24);
        make.height.equalTo(@(0.5));
        make.bottom.equalTo(button);
    }];
    
    
    UIImageView* adIconImageView1 = [UIImageView new];
    adIconImageView1.frame = CGRectMake(25, 95, 24, 24);
    adIconImageView1.image = [UIImage imageNamed:@"组 77"];
    [button addSubview:adIconImageView1];
//    [adIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(24);
//        make.centerY.equalTo(self);
//    }];
    
    // time
    _dateLabel = [UILabel new];
    
    _dateLabel.frame = CGRectMake(180, 97, 200, 20);
    _dateLabel.textAlignment = NSTextAlignmentLeft;
    _dateLabel.font = [UIFont boldSystemFontOfSize:14];
//    NSString *str= [NSString stringWithFormat:@"@",];
    _dateLabel.textColor = [UIColor blackColor];
    [button addSubview:_dateLabel];

    // Add time label
    UILabel* addTimeLabel = [UILabel new];
    addTimeLabel.frame = CGRectMake(65, 97, 200, 20);
    addTimeLabel.font = [UIFont systemFontOfSize:14];
    addTimeLabel.textColor = [UIColor blackColor];
    addTimeLabel.text = NSLocalizedString(@"Home_Time", nil);
    [button addSubview:addTimeLabel];
//    [addTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(adIconImageView1);
//        make.bottom.equalTo(button);
//    }];
    
    UIView* lineView1 = [[UIView alloc] initWithFrame:CGRectZero];
    lineView1.backgroundColor = RGB_HEX(0xe5eff0);
//    lineView1.frame = CGRectMake(24, 125, button.frame.size.width-48, 1);
    [button addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(button).offset(24);
        make.trailing.equalTo(button).offset(-24);
        make.height.equalTo(@(0.5));
        make.bottom.equalTo(@(75));
    }];


    
//    UIImageView* adIconImageView1 = [UIImageView new];
//    adIconImageView1.image = [UIImage imageNamed:@"watch"];
//    [button addSubview:adIconImageView1];
//    [adIconImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(24);
//        make.centerY.equalTo(self);
//    }];
//
//    // Add time label
//    UILabel* timeLabel1 = [UILabel new];
//    timeLabel1.font = [UIFont systemFontOfSize:14];
//    timeLabel1.textColor = [UIColor blackColor];
//    timeLabel1.text = NSLocalizedString(@"Home_Time", nil);
//    [button addSubview:timeLabel1];
//    [timeLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(button);
//        make.left.equalTo(adIconImageView1.mas_right).offset(12);
//    }];
//
    
    
    
    // button
    self.clickButton = button;
}


- (void) clickAction {
    
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
                [self clickAction];
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
            [QDDialogView show:NSLocalizedString(@"Ad_reward_suc", nil) message:NSLocalizedString(@"Ad_reward_text", nil) items:@[rmAd]  backImages:@[@"home_premium"] hideWhenTouchOutside:NO cancel:cancel callback:^(NSString *item) {
                if ([item isEqual:watchAd]) {
                    [self clickAction];
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
//    if(QDVersionManager.shared.versionConfig&&[QDVersionManager.shared.versionConfig[@"induce_pay"] intValue]) {
//        NSString* productName = QDConfigManager.shared.activeModel.member_type != 1 ? Month_Subscribe_Name_Free : Year_Subscribe_Name_Free;
//        [QDReceiptManager.shared transaction_new:productName completion:^(BOOL success) {
//        }];
//        return;
//    }
    
//    switch (QDConfigManager.shared.activeModel.member_type) {
//        case 1:
//            break;
//        case 2:
//        case 3:
//        {
//            // 是否订阅过
//            QDPayViewController2* vc = [QDPayViewController2 new];
//            UIViewController* rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
//            vc.modalPresentationStyle = UIModalPresentationFullScreen;
//            [rootViewController presentViewController:vc animated:YES completion:nil];
//        }
//            break;
//        default:
//            break;
//    }
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



- (void) updateTime:(long)remainMins {
    
    long mins = remainMins;
    long y   = mins / (365*24*60);
    long mon = (mins - y * (365*24*60))/(30*24*60);
    long d   = (mins - y * (365*24*60) - mon * (30*24*60)) / (24*60);
    long h   = (mins - y * (365*24*60) - mon * (30*24*60) - d * (24*60)) / 60;
    long m   = mins - y * (365*24*60) - mon * (30*24*60) - d * (24*60) - h * 60;
    NSString* text = @"00:00";
    BOOL isExpired = NO;

    NSString* year = NSLocalizedString(@"Time_Years", nil);
    if (y < 2) year = NSLocalizedString(@"Time_Year", nil);
    NSString* month = NSLocalizedString(@"Time_Months", nil);
    if (mon < 2) month = NSLocalizedString(@"Time_Month", nil);
    NSString* day = NSLocalizedString(@"Time_Days", nil);
    if (d < 2) day = NSLocalizedString(@"Time_Day", nil);
    NSString* hour = NSLocalizedString(@"Time_Hours", nil);
    if (h < 2) hour = NSLocalizedString(@"Time_Hour", nil);
    
    // 分情况显示
    if (y >= 1) {
//        text = [NSString stringWithFormat:@"%ld %@ %ld %@", y, year, mon, month];
//        if (mon < 1) text = [NSString stringWithFormat:@"%ld %@", y, year];
        text = [NSString stringWithFormat:@"%ld %@", y, year];
    } else if (mon >= 1){
//        text = [NSString stringWithFormat:@"%ld %@ %ld %@", mon, month, d, day];
//        if (d < 1) text = [NSString stringWithFormat:@"%ld %@", mon, month];
        text = [NSString stringWithFormat:@"%ld %@", mon, month];
    } else if (d >= 1) {
        text = [NSString stringWithFormat:@"%ld %@ %ld %@", d, day, h, hour];
        if (h < 1) text = [NSString stringWithFormat:@"%ld %@", d, day];
    } else if (m > 0){
        text = [NSString stringWithFormat:@"%02ld:%02ld", h, m];
    } else {
        // 过期
        isExpired = YES;
    }
    
    self.dateLabel.text = text;
    self.dateLabel.textColor = isExpired ? [UIColor redColor] : [UIColor blackColor];
}

@end
