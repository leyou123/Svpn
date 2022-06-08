//
//  QDPayButtonView.m
//  International
//
//  Created by hzg on 2021/7/1.
//  Copyright © 2021 com. All rights reserved.
//

#import "QDPayButtonView.h"
#import "QDPayViewController2.h"
#import "UIUtils.h"
#import <sys/utsname.h>
#import "QDPayViewController3.h"
@interface QDPayButtonView()

@property(nonatomic, strong) UILabel* promotionDesc;
@property(nonatomic, strong) UILabel* promotionText;
@property(nonatomic, strong) NSString* typeString;

@end

@implementation QDPayButtonView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup {
    
    // back
    UIButton* button = [UIButton new];
    [button setBackgroundImage:[UIImage imageNamed:@"home_premium"] forState:UIControlStateNormal];
    [self addSubview:button];
    [button addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.height.equalTo(self);
    }];
    
//    // bk
//    UIImageView* bk = [UIImageView new];
//    bk.image = [UIImage imageNamed:@"line_pay_bk"];
//    [button addSubview:bk];
//    [bk mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(button);
//    }];
    
    UIImageView * leftIv = [[UIImageView alloc] initWithFrame:CGRectZero];
    leftIv.image = [UIImage imageNamed:@"home_crown"];
    [button addSubview:leftIv];
    [leftIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(button).offset(25);
        make.centerY.equalTo(button);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    UIImageView * arrowIv = [[UIImageView alloc] initWithFrame:CGRectZero];
    arrowIv.image = [UIImage imageNamed:@"home_premium_arrow"];
    [button addSubview:arrowIv];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(button).offset(-20);
        make.centerY.equalTo(button);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];

    
    // label1
    self.promotionText = [UILabel new];
    self.promotionText.font = kSFUITextFont(13);
    self.promotionText.textColor = [UIColor whiteColor];
    [button addSubview:self.promotionText];
    [self.promotionText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftIv.mas_right).offset(14);
        make.top.equalTo(button).offset(7);
        make.right.equalTo(arrowIv.mas_left);
        if (IS_IPAD) {
            make.height.mas_equalTo(18);
        }else {
            make.height.mas_equalTo(18*kScreenScale);
        }
    }];
    
    // label2
    self.promotionDesc = [UILabel new];
    self.promotionDesc.font = kSFUITextFont(11);
    self.promotionDesc.textColor = [UIColor whiteColor];
    [button addSubview:self.promotionDesc];
    [self.promotionDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftIv.mas_right).offset(14);
        make.top.equalTo(self.promotionText.mas_bottom).offset(0);
        make.right.equalTo(arrowIv.mas_left);
        if (IS_IPAD) {
            make.height.mas_equalTo(18);
        }else {
            make.height.mas_equalTo(18*kScreenScale);
        }
    }];
    

    
}

- (void) payAction {

    [QDTrackManager track_button:QDTrackButtonType_30];
    
//    if(QDVersionManager.shared.versionConfig&&[QDVersionManager.shared.versionConfig[@"induce_pay"] intValue]) {
//        NSString* productName = Year_Subscribe_Name;
//        [QDReceiptManager.shared transaction_new:productName completion:^(BOOL success){
//        }];
//        return;
//    }
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

- (void) updateText {
    
    NSString* promotionDesc = @"Start 7-days free trial";
    NSString* promotionText = @"Get Premium";
    self.promotionDesc.text = promotionDesc;
    self.promotionText.text = promotionText;
//    if (!QDConfigManager.shared.activeModel) return;
//
//    // 会员 1 正式会员 2 赠送会员 3 非会员
//    NSString* promotionDesc = NSLocalizedString(@"VIPPromotionDesc1", nil);
//    NSString* promotionText = NSLocalizedString(@"VIPPromotionText1", nil);
//    switch (QDConfigManager.shared.activeModel.member_type) {
//        case 1:
//        {
//            // 月度会员升级诱导
//            promotionDesc = NSLocalizedString(@"VIPPromotionDesc3", nil);
//            self.promotionDesc.text = promotionDesc;
//            [UIUtils showSaveMoneyWithYear:self.promotionText];
//        }
//            break;
//        case 2:
//        case 3:
//        case 4:
//        {
//            // 是否订阅过
//            BOOL isSubscribed = QDConfigManager.shared.activeModel.subscription == 1;
//            if (isSubscribed) {
//                promotionDesc = NSLocalizedString(@"VIPPromotionDesc2", nil);
//                promotionText = NSLocalizedString(@"VIPPromotionText2", nil);
//            } else {
//                promotionDesc = NSLocalizedString(@"VIPPromotionDesc1", nil);
//                promotionText = NSLocalizedString(@"VIPPromotionText1", nil);
//            }
//            self.promotionDesc.text = promotionDesc;
//            self.promotionText.text = promotionText;
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


@end
