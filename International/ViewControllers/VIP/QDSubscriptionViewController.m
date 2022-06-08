//
//  SubscriptionViewController.m
//  International
//
//  Created by a on 2019/11/19.
//  Copyright © 2019 com. All rights reserved.
//

#import "QDSubscriptionViewController.h"
#import "QDSizeUtils.h"
#import "QDVIPView3.h"
#import "QDVIPBenifitView.h"
#import <sys/utsname.h>
#import "QDVIPView2.h"

@interface QDSubscriptionViewController ()

@property (nonatomic, strong) QDVIPView3 *vipView;
@property (nonatomic, strong) QDVIPView2 *vipView1;

@property (nonatomic, strong) QDVIPBenifitView *vipBenifitView;
@property (nonatomic, strong) NSString *typeStr;

@end

@implementation QDSubscriptionViewController

-(void)viewWillAppear:(BOOL)animated{
   _typeStr = [self platformString];
    if ([_typeStr isEqualToString:@"iPhone 6s"]||[_typeStr isEqualToString:@"iPhone 6"]||[_typeStr isEqualToString:@"iPhone 7"]||[_typeStr isEqualToString:@"iPhone 8"]) {
        [self setup];

    }else{
        [self setupOne];

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setup];
    [self registerNofification];
}

- (void)dealloc {
    [self unregisterNofification];
}

- (void) registerNofification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateVipViews) name:kNotificationUserActive object:nil];
}

- (void) unregisterNofification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationUserActive object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // banner广告显示
    if (self.vipView.isHidden) return;
//    if([QDSizeUtils isIphoneX]) {
//        [QDAdManager.shared showBanner:self toBottom:-[QDSizeUtils is_tabBarHeight]];
//    }
}

- (void) setup {
    self.vipView = [QDVIPView3 new];
    [self.view addSubview:self.vipView];
    [self.vipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.vipBenifitView = [QDVIPBenifitView new];
    [self.view addSubview:self.vipBenifitView];
    [self.vipBenifitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self updateVipViews];
}

-(void) setupOne {
    self.vipView1 = [QDVIPView2 new];
    [self.view addSubview:self.vipView1];
    [self.vipView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.vipBenifitView = [QDVIPBenifitView new];
    [self.view addSubview:self.vipBenifitView];
    [self.vipBenifitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self updateVipViews];

}

- (void) updateVipViews {
    BOOL isVIP = (QDConfigManager.shared.activeModel && QDConfigManager.shared.activeModel.member_type == 1);
    [self.vipView setHidden:isVIP];
    [self.vipBenifitView setHidden:!isVIP];
    [self.vipBenifitView updateStatus];
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
