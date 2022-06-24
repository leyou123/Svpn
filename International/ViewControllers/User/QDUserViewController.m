//
//  QDUserViewController.m
//  International
//
//  Created by hzg on 2021/6/8.
//  Copyright © 2021 com. All rights reserved.
//

#import "QDUserViewController.h"
#import "QDRecordViewController.h"
#import "QDUserTableViewProxy.h"
#import "QDRefreshNormalHeader.h"
#import "QDDeviceActiveResultModel.h"
#import "QDDateUtils.h"
#import "QDSizeUtils.h"
#import "QDLoginViewController.h"
#import "QDAccountViewController.h"
#import "QDShareNofifyViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "QDUserTableCell.h"
#import "UIUtils.h"

#define QDUserTableViewCellHeight 50

@interface QDUserViewController ()<UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic, strong) QDUserTableViewProxy *tableViewProxy;
@property (nonatomic, strong) UITableView * tableview;
@property (nonatomic, assign) int  clickTimes;
@property (nonatomic, assign) long lastClickTime;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation QDUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.whiteBgIv.image = [UIImage imageNamed:@"user_bg"];
    [self setup];
    [self setupData];
    [self registerNofification];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [QDAdManager.shared showBanner:self toBottom:-[QDSizeUtils is_tabBarHeight]];
    CGFloat toBottom = [QDSizeUtils isIphoneX] ? -34 : 0;
    [QDAdManager.shared showBanner:self toBottom:toBottom];
}

- (void) registerNofification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTableViewData) name:kNotificationUserLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTableViewData) name:kNotificationUserActive object:nil];
}

- (void) unregisterNofification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationUserLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationUserActive object:nil];
}

- (void)dealloc {
    [self unregisterNofification];
}

# pragma mark - ui
- (void) setup {
//    self.view.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:164.0/255.0 blue:247.0/255.0 alpha:1];
    [self setupTitle];
    [self setupTableView];
}

- (void) setupTitle {
    
    UIButton* testButton = [UIButton new];
    [self.view addSubview:testButton];
    [testButton addTarget:self action:@selector(onTestButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [testButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo([QDSizeUtils navigationHeight] + 10);
    }];
    
    UILabel* titleLabel = [UILabel new];
    titleLabel.text = NSLocalizedString(@"UserTitleName", nil);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:28.0f];
    titleLabel.textColor = [UIColor blackColor];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset([QDSizeUtils navigationHeight] + 10);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(25);
    }];
    
    UIButton* menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [self.view addSubview:menuButton];
    [menuButton addTarget:self action:@selector(onMenuButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [menuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.right.equalTo(self.view.mas_right).offset(-10);
    }];
}

- (void) setupTableView {
//    [self.view addSubview:self.tableViewProxy.tableView];
//    [self.tableViewProxy.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset([QDSizeUtils navigationHeight]+44);
//        make.left.right.bottom.equalTo(self.view);
//    }];
//    self.tableViewProxy.tableView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
//    WS(weakSelf);
//    self.tableViewProxy.tableView.mj_header = [QDRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf requestUserInfo];
//    }];
//
//    self.clickTimes = 0;
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset([QDSizeUtils navigationHeight]+44);
        make.left.right.bottom.equalTo(self.view);
    }];
    self.tableview.backgroundColor = [UIColor clearColor];
    WS(weakSelf);
    self.tableview.mj_header = [QDRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestUserInfo];
    }];
    self.clickTimes = 0;
}

-(void)onTestButtonClicked {
    
    long now = [[NSDate date] timeIntervalSince1970];
    if (self.lastClickTime == 0) self.lastClickTime = now;
    if (now - self.lastClickTime <= 1) self.clickTimes += 1;
    else self.clickTimes = 0;
    self.lastClickTime = now;
    
    // 2s内点击次数10次，强制切换测试服
    if (self.clickTimes > 10) {
        self.clickTimes = 0;
        [UIPasteboard generalPasteboard].string = QDConfigManager.shared.UUID;
        [SVProgressHUD showErrorWithStatus:@"uuid copyed"];
    }
}

- (void)onMenuButtonClicked {
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        //设置打开抽屉模式为MMOpenDrawerGestureModeNone，也就是没有任何效果。
        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    }];
}


# pragma mark - data
- (void) setupData {
    if (QDConfigManager.shared.activeModel) {
        [self setTableViewData];
    } else {
        [self.tableview.mj_header beginRefreshing];
    }
}

- (void) responseRequestUserInfo:(BOOL)isRegister result:(NSDictionary*) dictionary {
    if (self.tableview.mj_header.isRefreshing)[self.tableview.mj_header endRefreshing];
    
    QDDeviceActiveResultModel* resultModel = [QDDeviceActiveResultModel mj_objectWithKeyValues:dictionary];
    
    if (resultModel.code == kHttpStatusCode200) {
        
        QDConfigManager.shared.activeModel = resultModel.data;
        if (isRegister) {
            QDConfigManager.shared.local_UID = QDConfigManager.shared.activeModel.uid;
        }
        
        // 刷新用户信息
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserActive object:nil];
        
    } else if (resultModel.code == kHttpStatusCode404) {
        QDConfigManager.shared.email    = nil;
        QDConfigManager.shared.password = nil;
        // 请求失败
        [QDDialogManager showDialog:nil message:resultModel.message ok:NSLocalizedString(@"Dialog_Retry", nil) cancel:nil okBlock:^{
            [self requestUserInfo];
        } cancelBlock:^{
            
        }];
    }
}

// 请求用户或激活用户信息
- (void) requestUserInfo {
    [QDTrackManager track:QDTrackType_connect_cms_start data:@{}];
    if (QDConfigManager.shared.email
        &&![QDConfigManager.shared.email isEqual:@""]
        && QDConfigManager.shared.password
        &&![QDConfigManager.shared.password isEqual:@""]) {
        [QDModelManager requestLoginByEmail:QDConfigManager.shared.email password:QDConfigManager.shared.password completed:^(NSDictionary * _Nonnull dictionary) {
            [self responseRequestUserInfo:NO result:dictionary];
        }];
    } else {
        [QDModelManager requestRegister:^(NSDictionary * _Nonnull dictionary) {
            QDDeviceActiveResultModel* resultModel = [QDDeviceActiveResultModel mj_objectWithKeyValues:dictionary];
            if (resultModel.code == kHttpStatusCode200 && resultModel.data) {
                QDConfigManager.shared.UID = resultModel.data.uid;
                [QDModelManager requestLoginByUid:^(NSDictionary * _Nonnull dictionary) {
                    [self responseRequestUserInfo:YES result:dictionary];
                }];
            } else {
                [self responseRequestUserInfo:YES result:dictionary];
            }
            [self responseRequestUserInfo:YES result:dictionary];
        }];
    }
}

- (void) setTableViewData {
    if (!QDConfigManager.shared.activeModel) return;
    self.dataArray = [NSMutableArray array];
    
    NSString* variety = [self getVIPVariety];
    NSString* expire = [QDDateUtils getLocalDateFormateUTCTimestamp:QDConfigManager.shared.activeModel.member_validity_time];
    if (QDConfigManager.shared.activeModel.member_type == 3) {
        expire = NSLocalizedString(@"Expired", nil);
    }
    NSString* uid = @"None";
    NSArray* data = [NSArray new];
    NSString* v = [NSString stringWithFormat:@"v%@", APP_VERSION];
    if (QDConfigManager.shared.activeModel) {
        NSString* guestOrUser = @"";
        if (!QDConfigManager.shared.activeModel.email ||[QDConfigManager.shared.activeModel.email isEqual:@""]) {
            guestOrUser = [NSString stringWithFormat:@"(%@)", NSLocalizedString(@"User_Guest", nil)];
            uid = [NSString stringWithFormat:@"%ld%@", QDConfigManager.shared.activeModel.uid, guestOrUser];
            data = @[
                @[@{@"name":NSLocalizedString(@"User_uid", nil), @"type":@(0), @"content":uid, @"image":@"user"},
                  @{@"name":NSLocalizedString(@"User_VIPVariety", nil), @"type":@(1), @"content":variety, @"image":@"status"},
                  @{@"name":NSLocalizedString(@"User_ExpireDate", nil), @"type":@(2), @"content":expire, @"image":@"expiration"},
                  @{@"name":NSLocalizedString(@"User_Email", nil), @"type":@(7), @"content":@"", @"image":@"email"},
//                  @{@"name":NSLocalizedString(@"User_Notice", nil), @"type":@(7), @"content":@"", @"image":@"notice"}
                ],
                
//                @{@"name":NSLocalizedString(@"User_Record", nil), @"type":@(3), @"content":@""},
                @[@{@"name":NSLocalizedString(@"User_FAQ", nil), @"type":@(4), @"content":@"", @"image":@"faq"},
                  @{@"name":NSLocalizedString(@"User_RateUs", nil), @"type":@(5), @"content":@"", @"image":@"rate"},
                  @{@"name":NSLocalizedString(@"User_Share", nil), @"type":@(9), @"content":@"", @"image":@"share"},
                  @{@"name":NSLocalizedString(@"User_Version", nil), @"type":@(6), @"content":v, @"image":@"version"},
                ]
//                @{@"name":NSLocalizedString(@"Redeem_reward", nil), @"type":@(10), @"content":@""}
            ];
        } else {
            data = @[
                @[@{@"name":NSLocalizedString(@"User_Account", nil), @"type":@(8), @"content":QDConfigManager.shared.activeModel.email, @"image":@"user"},
                  @{@"name":NSLocalizedString(@"User_VIPVariety", nil), @"type":@(1), @"content":variety, @"image":@"status"},
                  @{@"name":NSLocalizedString(@"User_ExpireDate", nil), @"type":@(2), @"content":expire, @"image":@"expiration"},
//                  @{@"name":NSLocalizedString(@"User_Notice", nil), @"type":@(7), @"content":@"", @"image":@"notice"}
                ],
                @[
                    @{@"name":NSLocalizedString(@"User_FAQ", nil), @"type":@(4), @"content":@"", @"image":@"faq"},
                    @{@"name":NSLocalizedString(@"User_RateUs", nil), @"type":@(5), @"content":@"", @"image":@"rate"},
                    @{@"name":NSLocalizedString(@"User_Share", nil), @"type":@(9), @"content":@"", @"image":@"share"},
                    @{@"name":NSLocalizedString(@"User_Version", nil), @"type":@(6), @"content":v, @"image":@"version"},
                ]
            
//                @{@"name":NSLocalizedString(@"User_Record", nil), @"type":@(3), @"content":@""},
                
//                @{@"name":NSLocalizedString(@"Redeem_reward", nil), @"type":@(10), @"content":@""}
            ];
        }
        
    }
    
//    self.tableViewProxy.dataArray = data;
//    [self.tableViewProxy.tableView reloadData];
    [self.dataArray addObjectsFromArray:data];
    [self.tableview reloadData];
}

- (NSString*) getVIPVariety {
    NSString* variety = NSLocalizedString(@"VIP_None_VIP", nil);
    // 1 正式会员 2 赠送会员 3 非会员
    switch (QDConfigManager.shared.activeModel.member_type) {
        case 1:
            variety = NSLocalizedString(@"VIP_VIP", nil);
            break;
        case 2:
        case 4:
            variety = NSLocalizedString(@"VIP_Free_Trial", nil);
            break;
        case 3:
        default:
            break;
    }
    return variety;
}

#pragma mark notifications
// 更新用户剩余时间
-(void)notifyUserActive {
    [self setTableViewData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray * array = self.dataArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QDUserTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"QDUserTableCell"];
    if (!cell) {
        cell = [[QDUserTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QDUserTableCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary * dic = self.dataArray[indexPath.section][indexPath.row];
    [cell configWithData:dic];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 44.0;
    }
    return 30.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* data = self.dataArray[indexPath.section][indexPath.row];
    int type = [data[@"type"] intValue];
    NSLog(@"type == %d", type);
    switch (type) {
        case 0:
        case 1:
        case 2:
            break;
        case 3:
        {
            [QDTrackManager track_button:QDTrackButtonType_28];
            QDRecordViewController* vc = [QDRecordViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:
        {
            [QDTrackManager track_button:QDTrackButtonType_32];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:FAQ_URL] options:@{} completionHandler:nil];
        }
            break;
        case 5:
        {
            [QDTrackManager track_button:QDTrackButtonType_29];
            NSString* urlString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?action=write-review", APPLE_ID];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
        }
            break;
        case 6:
        {
            [QDTrackManager track_button:QDTrackButtonType_33];
            [QDVersionManager.shared check:NO];
            break;
        }
        case 7: // 绑定邮箱
        {
            QDLoginViewController* vc = [QDLoginViewController new];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:vc animated:YES completion:nil];
            break;
        }
        case 8: // 获取账户信息
        {
            QDAccountViewController* vc = [QDAccountViewController new];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:vc animated:YES completion:nil];
            break;
        }
        case 9:
        {
            [QDTrackManager track_button:QDTrackButtonType_34];
//            QDShareNofifyViewController* vc = [QDShareNofifyViewController new];
//            vc.modalPresentationStyle = UIModalPresentationFullScreen;
//            [self.navigationController presentViewController:vc animated:YES completion:nil];
            [UIUtils shareApp:self view:[tableView cellForRowAtIndexPath:indexPath]];
            break;
        }
        case 10:
        {
            [QDTrackManager track_button:QDTrackButtonType_35];
            NSString* text = [UIPasteboard generalPasteboard].string;
            [QDDialogManager showInputAlert:NSLocalizedString(@"Redeem_placeholder", nil) message:NSLocalizedString(@"Redeem_reward_text", nil) text:text placeHolder:NSLocalizedString(@"Redeem_placeholder", nil) ok:NSLocalizedString(@"Dialog_Submit", nil) cancel:NSLocalizedString(@"Dialog_Cancel", nil) okBlock:^(NSString *itemName) {
                if (!itemName&&[itemName isEqual:@""]) {
                    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Redeem_Error_Empty", nil)];
                    return;
                }
                [SVProgressHUD show];
                [QDModelManager requestRedeemReward:itemName completed:^(NSDictionary * _Nonnull dictionary) {
                    [SVProgressHUD dismiss];
                    QDBaseResultModel* resultModel = [QDBaseResultModel mj_objectWithKeyValues:dictionary];
                    if (resultModel.code == kHttpStatusCode200) {
                        [QDTrackManager track:QDTrackType_redmeem_success data:@{}];
                        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Redeem_Success", nil)];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserChange object:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    } else {
                        [QDTrackManager track:QDTrackType_redmeem_fail data:@{}];
                        [SVProgressHUD showErrorWithStatus:resultModel.message];
                    }
                }];
            } cancelBlock:^{

            }];
            break;
        }
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return QDUserTableViewCellHeight;
}

- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableview;
}

@end
