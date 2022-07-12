//
//  QDLineSubViewController.m
//  International
//
//  Created by hzg on 2021/8/5.
//  Copyright © 2021 com. All rights reserved.
//

#import "QDLineSubViewController.h"
#import "QDLineTableViewProxy.h"
#import "QDSizeUtils.h"
#import "QDTableViewCell.h"
#import "QDPayViewController2.h"
#import <sys/utsname.h>
#import "QDPayViewController3.h"
#import "UIImage+Utils.h"
#import "QDNodesResultModel.h"
#import "QDRefreshNormalHeader.h"
#import "GADTMediumTemplateView.h"

@interface QDLineSubViewController ()

@property (nonatomic, strong) QDLineTableViewProxy *tableViewProxy;
@property (nonatomic, strong) NSString *typeStr;

@end

@implementation QDLineSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self setupBanner];
}

- (void) setupBanner {
    CGFloat toBottom = [QDSizeUtils isIphoneX] ? -34 : 0;
    [QDAdManager.shared showBanner:self toBottom:toBottom];
}

- (void) setup {
    
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
        appearance.shadowColor = [UIColor whiteColor];
        appearance.shadowImage = [UIImage imageWithColor:[UIColor whiteColor]];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = self.navigationController.navigationBar.standardAppearance;
    } else {
        //导航栏
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1]] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    }
    
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIImageView* backImage = [UIImageView new];
    backImage.image = [UIImage imageNamed:@"line_nav_back"];
//    backImage.tintColor = [UIColor whiteColor];
    [button addSubview:backImage];
    [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(button);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    [button addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupBackFrame];
    [self setupTitle:self.country];
    
    GADTMediumTemplateView *templateView = [[GADTMediumTemplateView alloc] init];
    [self.backFrame addSubview:templateView];
    CGFloat height = 0.0;
    if (QDConfigManager.shared.activeModel.member_type != 1) {
        if ([QDVersionManager.shared.versionConfig[@"show_base_node_ad"] intValue] == 1) {
            height = 300*kScreenScale;
            templateView.hidden = NO;
        }else {
            templateView.hidden = YES;
        }
    }else {
        templateView.hidden = YES;
    }
    [templateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(10);
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(15);
        make.height.mas_equalTo(height);
    }];
    
    NSString *myBlueColor = @"#5C84F0";
    NSDictionary *styles = @{
        GADTNativeTemplateStyleKeyCallToActionFont : [UIFont systemFontOfSize:15.0],
        GADTNativeTemplateStyleKeyCallToActionFontColor : UIColor.whiteColor,
        GADTNativeTemplateStyleKeyCallToActionBackgroundColor :
            [GADTTemplateView colorFromHexString:myBlueColor],
        GADTNativeTemplateStyleKeySecondaryFont : [UIFont systemFontOfSize:15.0],
        GADTNativeTemplateStyleKeySecondaryFontColor : UIColor.grayColor,
        GADTNativeTemplateStyleKeySecondaryBackgroundColor : UIColor.whiteColor,
        GADTNativeTemplateStyleKeyPrimaryFont : [UIFont systemFontOfSize:15.0],
        GADTNativeTemplateStyleKeyPrimaryFontColor : UIColor.blackColor,
        GADTNativeTemplateStyleKeyPrimaryBackgroundColor : UIColor.whiteColor,
        GADTNativeTemplateStyleKeyTertiaryFont : [UIFont systemFontOfSize:15.0],
        GADTNativeTemplateStyleKeyTertiaryFontColor : UIColor.grayColor,
        GADTNativeTemplateStyleKeyTertiaryBackgroundColor : UIColor.whiteColor,
        GADTNativeTemplateStyleKeyMainBackgroundColor : UIColor.whiteColor,
        GADTNativeTemplateStyleKeyCornerRadius : [NSNumber numberWithFloat:7.0],
    };
    templateView.styles = styles;
    [QDAdManager.shared showNativeAd:templateView];
    
    // tableview
    [self.backFrame addSubview:self.tableViewProxy.tableView];
    [self.tableViewProxy.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(templateView.mas_bottom).offset(14);
        make.bottom.equalTo(self.backFrame).offset(-14);
        make.left.centerX.equalTo(self.backFrame);
        make.bottom.equalTo(self.backFrame).offset(-[QDSizeUtils is_tabBarHeight]);
    }];
    self.tableViewProxy.tableView.backgroundColor = [UIColor clearColor];

    if (self.requestData) {
        self.tableViewProxy.tableView.mj_header = [QDRefreshNormalHeader headerWithRefreshingBlock:^{
            [self requestCountryLines];
        }];
        [self.tableViewProxy.tableView.mj_header beginRefreshing];
    }else {
        [self setTableViewData];
    }
}

- (void) setTableViewData {
    self.tableViewProxy.dataArray = [self createTempData];
    [self.tableViewProxy.tableView reloadData];
}

- (NSMutableArray*) createTempData {
    NSMutableArray* array = [NSMutableArray new];
    QDNodeModel* virtureNode = [QDNodeModel new];
    virtureNode.cell_type = 4;
    [array addObject:virtureNode];
    if (self.data) [array addObjectsFromArray:self.data];
    return array;
}

- (void)requestCountryLines {
    [QDModelManager requestCountrySublinesCountry:self.country completed:^(NSDictionary * _Nonnull dictionary) {
        QDNodesResultModel* resultModel = [QDNodesResultModel mj_objectWithKeyValues:dictionary];
        for (QDNodeModel * node in resultModel.data) {
            node.cell_type = 2;
        }
        self.tableViewProxy.dataArray = [[QDConfigManager shared] getSortArray:resultModel.data hide:QDConfigManager.shared.lineHide];
        [self.tableViewProxy.tableView reloadData];
        [self.tableViewProxy.tableView.mj_header endRefreshing];
    }];
}

#pragma mark properties
- (QDLineTableViewProxy *)tableViewProxy {
    if (!_tableViewProxy) {
        WS(weakSelf);
        _tableViewProxy = [[QDLineTableViewProxy alloc] initWithReuseIdentifier:@"LineTableViewCell" configuration:^(QDTableViewCell *cell, id cellData, NSIndexPath *indexPath) {
            [cell configWithData:cellData];
        } action:^(UITableViewCell *cell, id cellData, NSIndexPath *indexPath) {
            
            QDNodeModel* node = cellData;
            [QDTrackManager track_node:node.name];
            
            // 判断cell_type
            // 节点类型：-1表示未分配 0表示自动推荐节点 1表示section, 2表示normal  3表示可展开收缩的
            switch (node.cell_type) {
                case 0:
                case 2:
                {
                    // 1 正式会员 2 赠送会员 3 非会员 4 时长会员
                    switch (QDConfigManager.shared.activeModel.member_type) {
                        case 1:
                            break;
                        case 2:
                        case 4:
                        {
                            // VIP线路，赠送会员没有权限
                            self->_typeStr = [self platformString];
                            if ([self->_typeStr isEqualToString:@"iPhone 6s"]||[self->_typeStr isEqualToString:@"iPhone 6"]||[self->_typeStr isEqualToString:@"iPhone 7"]||[self->_typeStr isEqualToString:@"iPhone 8"]) {
                                 // VIP线路，赠送会员没有权限
                                 if (node.node_type != 1) {
                                     QDPayViewController3* vc = [QDPayViewController3 new];
                                     UIViewController* rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
                                     vc.modalPresentationStyle = UIModalPresentationFullScreen;
                                     [rootViewController presentViewController:vc animated:YES completion:nil];
                                     return;
                                 }

                             }else{
                                 // VIP线路，赠送会员没有权限
                                 if (node.node_type != 1) {
                                     QDPayViewController2* vc = [QDPayViewController2 new];
                                     UIViewController* rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
                                     vc.modalPresentationStyle = UIModalPresentationFullScreen;
                                     [rootViewController presentViewController:vc animated:YES completion:nil];
                                     return;
                                 }

                             }                        }
                            break;
                        case 3:
                        {
                            self->_typeStr = [self platformString];
                            if ([self->_typeStr isEqualToString:@"iPhone 6s"]||[self->_typeStr isEqualToString:@"iPhone 6"]||[self->_typeStr isEqualToString:@"iPhone 7"]||[self->_typeStr isEqualToString:@"iPhone 8"]) {
                                [QDDialogManager showVIPExpired:^{
                                    QDPayViewController3* vc = [[QDPayViewController3 alloc]init];
                                    UIViewController* rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
                                    vc.modalPresentationStyle = UIModalPresentationFullScreen;
                                    [rootViewController presentViewController:vc animated:YES completion:nil];

                                }];

                             }else{
                                 [QDDialogManager showVIPExpired:^{
                                     QDPayViewController2* vc = [[QDPayViewController2 alloc]init];
                                     UIViewController* rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
                                     vc.modalPresentationStyle = UIModalPresentationFullScreen;
                                     [rootViewController presentViewController:vc animated:YES completion:nil];

                                 }];

                             }
                            return;
                        }
                        default:
                            break;
                    }
                    
                    if (![node isEqual:QDConfigManager.shared.node]) {
                        QDConfigManager.shared.node = node;
                    }
//                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLineChange object:nil];
                    QDConfigManager.shared.lineChanged = YES;
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                }
                    return;
                case 3:
                case 1:
                default:
                    return;
            }

        }];
    }
    return _tableViewProxy;
}

// close action
- (void) dismissAction {
    [self.navigationController popViewControllerAnimated:YES];
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
