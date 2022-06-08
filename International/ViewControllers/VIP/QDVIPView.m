//
//  QDVIPView.m
//  International
//
//  Created by hzg on 2021/12/7.
//  Copyright © 2021 com. All rights reserved.
//

#import "QDVIPView.h"
#import "QDProductResultModel.h"
#import "QDProductCollectionViewProxy.h"
#import "QDProductCollectionViewCell.h"
#import "QDSizeUtils.h"
#import "QDPayViewController2.h"
#import "QDPayViewController3.h"
#import "UIUtils.h"
#import <sys/utsname.h>
@interface QDVIPView()

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) QDProductCollectionViewProxy *collectionViewProxy;
@property(nonatomic, assign) NSInteger index;
@property(nonatomic, strong) NSString *typeStr;

@end

@implementation QDVIPView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self doInit];
    }
    return self;
}

- (void) doInit {
    [self setup];
    [self setupData];
    
//    // 非会员第一次打开，会打开说明
//    if (QDConfigManager.shared.activeModel&&QDConfigManager.shared.activeModel.member_type != 1) {
//        [self instructionButtonAction];
//    }
}

#pragma mark - data
- (void) setupData {
    NSArray* arr = @[
        @{@"product_id":Month_Subscribe_Name, @"price":Month_Subscribe_Price, @"days":@"vip_30", @"isHot":@(NO)},
        @{@"product_id":Quarter_Subscribe_Name, @"price":Quarter_Subscribe_Price, @"days":@"vip_90", @"isHot":@(NO)},
        @{@"product_id":HalfYear_Subscribe_Name, @"price":HalfYear_Subscribe_Price,
          @"days":@"vip_180", @"isHot":@(NO)},
        @{@"product_id":Year_Subscribe_Name, @"price":Year_Subscribe_Price,@"days":@"vip_360", @"isHot":@(YES)}
    ];
    self.collectionViewProxy.dataArray = arr;
    [self.collectionViewProxy.collectionView reloadData];
}

# pragma mark - ui
- (void) setup {
    
    // back
    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
    
    // top
    [self setupTopView];
    
    // bottom
    [self setupBottomView];
}

- (void) setupTopView {
    
    // back image
    self.backImageView = [UIImageView new];
    NSString* imageName = @"FeeltheExtraordinarySpeed";
    CGFloat width = 690/2;
    CGFloat height = 777/2;
    if (IS_IPAD) {
        width = 1154/2;
        height = 1137/2;
        if (IS_IPAD) imageName = @"vip_ipad_bk";
    }
    self.backImageView.image = [UIImage imageNamed:imageName];
    self.backImageView.userInteractionEnabled = YES;
    [self addSubview:self.backImageView];
    
    CGFloat scaleWidth = [QDSizeUtils is_width] < [QDSizeUtils is_height] ? [QDSizeUtils is_width] : [QDSizeUtils is_height];
    CGFloat scaleHeight = (height/width)*scaleWidth;
    
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.width.mas_equalTo(scaleWidth);
        make.height.mas_equalTo(scaleHeight);
    }];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onVipTap:)];
    [self.backImageView addGestureRecognizer:singleTap];
    
    // text
    // title
    UILabel* titleLabel = [UILabel new];
    titleLabel.text = NSLocalizedString(@"VIPStoreTitle", nil);
    titleLabel.font = [UIFont boldSystemFontOfSize:30];
    titleLabel.textColor = [UIColor whiteColor];
    [self.backImageView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(35);
        make.top.equalTo(self).offset(60);
    }];
    
    // title desc
    UILabel* titleDescLabel = [UILabel new];
    titleDescLabel.text = NSLocalizedString(@"VIPStoreDesc0", nil);
    titleDescLabel.font = [UIFont systemFontOfSize:18];
    titleDescLabel.textColor = [UIColor whiteColor];
    [self.backImageView addSubview:titleDescLabel];
    [titleDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(35);
        make.top.equalTo(titleLabel.mas_bottom);
    }];
    
    // instruction
    UIButton* instructionButton = [UIButton new];
    [instructionButton addTarget:self action:@selector(instructionButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [instructionButton setBackgroundImage:[UIImage imageNamed:@"kuang"] forState:UIControlStateNormal];
    [instructionButton setTitle:NSLocalizedString(@"Instruction", nil) forState:UIControlStateNormal];
    instructionButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    instructionButton.backgroundColor = [UIColor clearColor];
    [self.backImageView addSubview:instructionButton];
    [instructionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-140);
        make.bottom.equalTo(@(-20));
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(25);
    }];

    // restore
    UIButton* restoreButton = [UIButton new];
    [restoreButton addTarget:self action:@selector(restoreButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.backImageView addSubview:restoreButton];
    [restoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-25);
        make.centerY.equalTo(instructionButton);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
    }];
    
    // title&title back
    UIImageView* restoreBack = [UIImageView new];
    restoreBack.image = [UIImage imageNamed:@"kuang"];
    [restoreButton addSubview:restoreBack];
    [restoreBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(restoreButton);
    }];
    UILabel* restoreLabel = [UILabel new];
    restoreLabel.text = NSLocalizedString(@"VIPRestore", nil);
    restoreLabel.font = [UIFont systemFontOfSize:15.0f];
    restoreLabel.textColor = [UIColor whiteColor];
    [restoreButton addSubview:restoreLabel];
    [restoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(restoreButton);
    }];
    
    
    NSArray* descArr = @[NSLocalizedString(@"VIPStoreDesc1", nil), NSLocalizedString(@"VIPStoreDesc2", nil), NSLocalizedString(@"VIPStoreDesc3", nil)];
    
    CGFloat descHeight = 15;
    CGFloat descGap = 12;
    CGFloat bottom = -40 - descHeight*3 - descGap*2;
    CGFloat left = kScreenWidth - 250;
    for (NSString* desc in descArr) {
        UILabel* titleDescLabel1 = [UILabel new];
        titleDescLabel1.text = desc;
        titleDescLabel1.font = [UIFont systemFontOfSize:15];
        titleDescLabel1.textColor = [UIColor whiteColor];
        [self.backImageView addSubview:titleDescLabel1];
        [titleDescLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backImageView).offset(left);
            make.bottom.equalTo(self.backImageView).offset(bottom);
        }];
        bottom += (descHeight + descGap);
    }

}

- (void) setupBottomView {
    
    [self addSubview:self.collectionViewProxy.collectionView];
    [self.collectionViewProxy.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.backImageView.mas_bottom).offset(20);
        make.bottom.equalTo(self).offset(-([QDSizeUtils is_tabBarHeight]));
    }];
}

#pragma mark - properties
- (QDProductCollectionViewProxy *)collectionViewProxy {
    WS(weakSelf);
    if (!_collectionViewProxy) {
        _collectionViewProxy = [[QDProductCollectionViewProxy alloc] initWithReuseIdentifier:@"QDProductCollectionViewCell" configuration:^(UICollectionViewCell *cell, id cellData, NSIndexPath *indexPath) {
            [((QDProductCollectionViewCell*)cell) configCellWithModel:cellData isSelected:weakSelf.index == indexPath.row];
        } action:^(UICollectionViewCell *cell, id cellData, NSIndexPath *indexPath) {
            weakSelf.index = indexPath.row;
            [weakSelf.collectionViewProxy.collectionView reloadData];
            [weakSelf payAction:cellData];
        }];
    }
    return _collectionViewProxy;
}

#pragma mark -- button actions
- (void) payAction:(id)data {
    NSDictionary* dict = data;
    NSString* productId = dict[@"product_id"];
    QDTrackButtonType trackType = QDTrackButtonType_15;
    if ([productId isEqual:Quarter_Subscribe_Name]) {
        trackType = QDTrackButtonType_16;
    } else if ([productId isEqual:HalfYear_Subscribe_Name]) {
        trackType = QDTrackButtonType_17;
    } else if ([productId isEqual:Year_Subscribe_Name_Free]) {
        trackType = QDTrackButtonType_18;
    }
    [QDTrackManager track_button:trackType];
    QDAdManager.shared.forbidAd = YES;
    [QDReceiptManager.shared transaction_new:productId completion:^(BOOL success) {
        QDAdManager.shared.forbidAd = NO;
    }];
}

- (void)onVipTap:(UIGestureRecognizer *)gestureRecognizer {
    [self instructionButtonAction];
}

- (void)instructionButtonAction {
    _typeStr = [self platformString];
    if ([_typeStr isEqualToString:@"iPhone 6s"]||[_typeStr isEqualToString:@"iPhone 6"]||[_typeStr isEqualToString:@"iPhone 7"]||[_typeStr isEqualToString:@"iPhone 8"]) {
        [QDTrackManager track_button:QDTrackButtonType_13];
        QDPayViewController3* vc = [[QDPayViewController3 alloc]init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        UIViewController* nav = [UIUtils getCurrentVC];
        [nav presentViewController:vc animated:YES completion:nil];

    }else{
        [QDTrackManager track_button:QDTrackButtonType_13];
        QDPayViewController2* vc = [[QDPayViewController2 alloc]init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        UIViewController* nav = [UIUtils getCurrentVC];
        [nav presentViewController:vc animated:YES completion:nil];

    }
}

- (void)restoreButtonAction {
    [QDTrackManager track_button:QDTrackButtonType_14];
    [SVProgressHUD showWithStatus:NSLocalizedString(@"VIPRestoreStart", nil)];
    UIViewController* nav = [UIUtils getCurrentVC];
    [QDReceiptManager.shared restore:^(BOOL success) {
        NSLog(@"success = %d", success);
        [SVProgressHUD dismiss];
        if (!success) {
            NSString* getPremium = NSLocalizedString(@"VIPPromotionText2", nil);
            NSString* retry  = NSLocalizedString(@"Dialog_Retry", nil);
            NSString* cancel = NSLocalizedString(@"Dialog_Cancel", nil);
            [QDDialogManager showItemsDialog:nav title:NSLocalizedString(@"VIPRestoreFail", nil) message:NSLocalizedString(@"VIPRestoreFailDesc", nil) actionItems:@[getPremium, retry, cancel] callback:^(NSString *itemName) {
                if ([itemName isEqual:getPremium]) {
//                    [QDReceiptManager.shared transaction_new:Month_Subscribe_Name completion:^(BOOL success) {
//                    }];
                    [self instructionButtonAction];
                    return;
                }
                
                if ([itemName isEqual:retry]) {
                    [self restoreButtonAction];
                    return;
                }
            }];
        } else {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"VIPRestoreSuccess", nil)];
        }
    }];
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
