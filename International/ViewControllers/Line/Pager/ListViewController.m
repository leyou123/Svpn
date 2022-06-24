//
//  ListViewController.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2019/12/30.
//  Copyright © 2019 jiaxin. All rights reserved.
//

#import "ListViewController.h"
//#import "DetailViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "UIWindow+JXSafeArea.h"
#import "QDPayViewController2.h"
#import "QDSizeUtils.h"
#import "QDLineSubViewController.h"
#import "QDPayViewController3.h"
#import <sys/utsname.h>

@interface ListViewController ()
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) NSString *typeStr;

@end

@implementation ListViewController

- (void)dealloc {
    NSLog(@"ListViewController dealloced");
}




- (void)viewDidLoad {
    [super viewDidLoad];

  
//    //列表的contentInsetAdjustmentBehavior失效，需要自己设置底部inset
//    self.tableViewProxy.tableView.contentInset = UIEdgeInsetsMake(0, 0, UIApplication.sharedApplication.keyWindow.jx_layoutInsets.bottom, 0);
//    [self.view addSubview:self.tableViewProxy.tableView];
    
    
    [self setup];

    __weak typeof(self)weakSelf = self;
    if (self.isNeedHeader) {
        self.tableViewProxy.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.tableViewProxy.tableView.mj_header endRefreshing];
            });
        }];
    }

    [self beginFirstRefresh];
}

- (void) setup {
    self.tableViewProxy.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableViewProxy.tableView];
    CGFloat toBottom = [QDSizeUtils isIphoneX] ? 34 : 0;
    BOOL isVIP = QDConfigManager.shared.activeModel&&QDConfigManager.shared.activeModel.member_type == 1;
    BOOL isAnnualMeal = [QDConfigManager.shared.activeModel.set_meal isEqualToString:Year_Subscribe_Name];
//    toBottom += 140;
//    if (isVIP&&isAnnualMeal)
    toBottom += 46;
    [self.tableViewProxy.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-toBottom);
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

//    self.tableView.frame = self.view.bounds;
}

- (void)beginFirstRefresh {
    if (!self.isHeaderRefreshed) {
        [self beginRefreshImmediately];
    }
}

- (void)beginRefreshImmediately {
    if (self.isNeedHeader) {
        [self.tableViewProxy.tableView.mj_header beginRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isHeaderRefreshed = YES;
            [self.tableViewProxy.tableView reloadData];
            [self.tableViewProxy.tableView.mj_header endRefreshing];
        });
    }else {
        self.isHeaderRefreshed = YES;
        [self.tableViewProxy.tableView reloadData];
    }
}



#pragma mark properties
- (QDLineTableViewProxy *)tableViewProxy {
    if (!_tableViewProxy) {
        WS(weakSelf);
        _tableViewProxy = [[QDLineTableViewProxy alloc] initWithReuseIdentifier:@"LineTableViewCell" configuration:^(QDTableViewCell *cell, id cellData, NSIndexPath *indexPath) {
            [cell configWithData:cellData];
        } action:^(UITableViewCell *cell, id cellData, NSIndexPath *indexPath) {
            
            QDNodeModel* node = cellData;
            
            // 判断cell_type
            // 节点类型：-1表示未分配 0表示自动推荐节点 1表示section, 2表示normal  3表示可展开收缩的
            switch (node.cell_type) {
                case 0:
                case 2:
                {
                    [QDTrackManager track_node:node.name];
                    
                    // 1 正式会员 2 赠送会员 3 非会员
                    switch (QDConfigManager.shared.activeModel.member_type) {
                        case 1:
                            break;
                        case 2:
                        case 4:
                        {
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

                             }

                            
                        }
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
                }
                    break;
                case 3:
                {
                    // 展开/收缩逻辑
                    //先修改数据源
                    QDLineSubViewController* vc = [QDLineSubViewController new];
                    vc.data = node.subNodes;
                    vc.country = node.country;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
                    return;
                case 5:
                {
                    QDAdManager.shared.forbidAd = YES;
                    NSString* productName = Month_Subscribe_Name;
                    [QDReceiptManager.shared transaction_new:productName completion:^(BOOL success){
                        QDAdManager.shared.forbidAd = NO;
                    }];
                }
                    return;
                case 1:
                default:
                    return;
            }
            
            if (![node isEqual:QDConfigManager.shared.node]) {
                QDConfigManager.shared.node = node;
            }
//            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLineChange object:nil];
            QDConfigManager.shared.lineChanged = YES;
            [weakSelf.navigationController popToRootViewControllerAnimated:NO];
        }];
    }
    return _tableViewProxy;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}

#pragma mark - JXPagingViewListViewDelegate

- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.tableViewProxy.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)listWillAppear {
    NSLog(@"%@:%@", self.title, NSStringFromSelector(_cmd));
}

- (void)listDidAppear {
    NSLog(@"%@:%@", self.title, NSStringFromSelector(_cmd));
}

- (void)listWillDisappear {
    NSLog(@"%@:%@", self.title, NSStringFromSelector(_cmd));
}

- (void)listDidDisappear {
    NSLog(@"%@:%@", self.title, NSStringFromSelector(_cmd));
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
