//
//  QDAccountViewController.m
//  International
//
//  Created by hzg on 2021/9/9.
//  Copyright © 2021 com. All rights reserved.
//

#import "QDAccountViewController.h"
#import "QDUserTableViewProxy.h"
#import "QDSizeUtils.h"
#import "QDBaseResultModel.h"
#import "QDForgetPasswordViewController.h"
#import "QDUserTableCell.h"

@interface QDAccountViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) QDUserTableViewProxy *tableViewProxy;
@property (nonatomic, strong) UITableView * accountTableView;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation QDAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.whiteBgIv.image = [UIImage imageNamed:@"user_bg"];
    [self setup];
    [self setTableViewData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CGFloat toBottom = [QDSizeUtils isIphoneX] ? -34 : 0;
    [QDAdManager.shared showBanner:self toBottom:toBottom];
}

# pragma mark - ui
- (void) setup {
//    [self setupTitle:@"User_Account"];
    
    UILabel* titleLabel = [UILabel new];
    titleLabel.text = NSLocalizedString(@"User_Account", nil);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:28.0f];
    titleLabel.textColor = [UIColor blackColor];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset([QDSizeUtils navigationHeight]);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(44);
    }];
    
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"line_nav_back"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel);
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.left.equalTo(self.view).offset(10);
    }];
  
    [self.view addSubview:self.accountTableView];
    [self.accountTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom);
        make.left.width.bottom.equalTo(self.view);
    }];
    
//    [self.view addSubview:self.tableViewProxy.tableView];
//    [self.tableViewProxy.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.width.bottom.equalTo(self.view);
//        make.top.equalTo(titleLabel.mas_bottom);
//    }];
//    self.tableViewProxy.tableView.backgroundColor = [UIColor whiteColor];
}

- (void) setTableViewData {
    self.dataArray = [NSMutableArray array];
    if (!QDConfigManager.shared.activeModel) return;
    
    NSString* devices =  [NSString stringWithFormat:@"%d/%d", QDConfigManager.shared.activeModel.device_count, QDConfigManager.shared.activeModel.max_device_count];
    NSArray* data = [NSArray new];
    NSString* uid = [NSString stringWithFormat:@"%ld", QDConfigManager.shared.UID];
    data = @[@[
        @{@"name":NSLocalizedString(@"User_uid", nil), @"type":@(20), @"content":uid, @"image":@"user"},
        @{@"name":NSLocalizedString(@"User_Devices", nil), @"type":@(21), @"content":devices, @"image":@"user_device"},
        @{@"name":NSLocalizedString(@"Reset_Password", nil), @"type":@(22), @"content":@"", @"image":@"user_reset"},
        @{@"name":NSLocalizedString(@"User_Unbind", nil), @"type":@(23), @"content":@"", @"image":@"user_link"},
        @{@"name":NSLocalizedString(@"User_Sign_Out", nil), @"type":@(24), @"content":@"", @"image":@"user_sginout"},
    ]];
//    self.tableViewProxy.dataArray = data;
//    [self.tableViewProxy.tableView reloadData];
    [self.dataArray addObjectsFromArray:data];
    [self.accountTableView reloadData];
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
        case 20: // uuid
        case 21: // devices
            break;
        case 22: // reset password
        {
            QDForgetPasswordViewController* vc = [QDForgetPasswordViewController new];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:vc animated:YES completion:nil];
        }
            break;
        case 23: // 解绑
        {
            [QDDialogManager showInputAlert:NSLocalizedString(@"Dialog_Disassociate_title", nil) message:NSLocalizedString(@"Dialog_Disassociate_message", nil)
                text:@""
                placeHolder:NSLocalizedString(@"Password", nil)
                ok:NSLocalizedString(@"Dialog_Ok", nil)
                cancel:NSLocalizedString(@"Dialog_Cancel", nil)
                okBlock:^(NSString *itemName) {
                if (!itemName&&[itemName isEqual:@""]) {
                    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error_Password_Empty", nil)];
                    return;
                }
                [SVProgressHUD show];
                [QDModelManager requestUnbind:itemName completed:^(NSDictionary * _Nonnull dictionary) {
                    QDBaseResultModel* resultModel = [QDBaseResultModel mj_objectWithKeyValues:dictionary];
                    [SVProgressHUD dismiss];
                    if (resultModel.code == kHttpStatusCode200) {
                        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Dialog_Disassociate_Success", nil)];
                        QDConfigManager.shared.email    = nil;
                        QDConfigManager.shared.password = nil;
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserChange object:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    } else {
                        [SVProgressHUD showErrorWithStatus:resultModel.message];
                    }
                }];
            } cancelBlock:^{

            }];
            break;
        }
        case 24: // sign out
        {
            [QDDialogManager showDialog:NSLocalizedString(@"Dialog_Sign_Out_Title", nil) message:NSLocalizedString(@"Dialog_Sign_Out_message", nil) ok:NSLocalizedString(@"Dialog_Ok", nil) cancel:NSLocalizedString(@"Dialog_Cancel", nil) okBlock:^{
                [SVProgressHUD show];
                [QDModelManager requestLogout:^(NSDictionary * _Nonnull dictionary) {
                    QDBaseResultModel* resultModel = [QDBaseResultModel mj_objectWithKeyValues:dictionary];
                    [SVProgressHUD dismiss];
                    if (resultModel.code == kHttpStatusCode200) {
                        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Dialog_Sign_Out_Success", nil)];
                        QDConfigManager.shared.email    = nil;
                        QDConfigManager.shared.password = nil;
                        QDConfigManager.shared.activeModel = nil;
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserGoLoginSelectView object:nil];
                    } else {
                        [SVProgressHUD showErrorWithStatus:resultModel.message];
                    }
                }];
            } cancelBlock:^{

            }];
        }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark properties
//- (QDUserTableViewProxy *)tableViewProxy {
//    if (!_tableViewProxy) {
////        WS(weakSelf);
//        _tableViewProxy = [[QDUserTableViewProxy alloc] initWithReuseIdentifier:@"QDUserTableViewCell" configuration:^(QDTableViewCell *cell, id cellData, NSIndexPath *indexPath) {
//            [cell configWithData:cellData];
//        } action:^(UITableViewCell *cell, id cellData, NSIndexPath *indexPath) {
//            NSDictionary* data = cellData;
//            int type = [data[@"type"] intValue];
//            NSLog(@"type == %d", type);
//            switch (type) {
//                case 20: // uuid
//                case 21: // devices
//                    break;
//                case 22: // reset password
//                {
//                    QDForgetPasswordViewController* vc = [QDForgetPasswordViewController new];
//                    vc.modalPresentationStyle = UIModalPresentationFullScreen;
//                    [self presentViewController:vc animated:YES completion:nil];
//                }
//                    break;
//                case 23: // 解绑
//                {
//                    [QDDialogManager showInputAlert:NSLocalizedString(@"Dialog_Disassociate_title", nil) message:NSLocalizedString(@"Dialog_Disassociate_message", nil)
//                        text:@""
//                        placeHolder:NSLocalizedString(@"Password", nil)
//                        ok:NSLocalizedString(@"Dialog_Ok", nil)
//                        cancel:NSLocalizedString(@"Dialog_Cancel", nil)
//                        okBlock:^(NSString *itemName) {
//                        if (!itemName&&[itemName isEqual:@""]) {
//                            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error_Password_Empty", nil)];
//                            return;
//                        }
//                        [SVProgressHUD show];
//                        [QDModelManager requestUnbind:itemName completed:^(NSDictionary * _Nonnull dictionary) {
//                            QDBaseResultModel* resultModel = [QDBaseResultModel mj_objectWithKeyValues:dictionary];
//                            [SVProgressHUD dismiss];
//                            if (resultModel.code == kHttpStatusCode200) {
//                                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Dialog_Disassociate_Success", nil)];
//                                QDConfigManager.shared.email    = nil;
//                                QDConfigManager.shared.password = nil;
//                                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserChange object:nil];
//                                [self.navigationController popViewControllerAnimated:YES];
//                            } else {
//                                [SVProgressHUD showErrorWithStatus:resultModel.message];
//                            }
//                        }];
//                    } cancelBlock:^{
//
//                    }];
//                    break;
//                }
//                case 24: // sign out
//                {
//                    [QDDialogManager showDialog:NSLocalizedString(@"Dialog_Sign_Out_Title", nil) message:NSLocalizedString(@"Dialog_Sign_Out_message", nil) ok:NSLocalizedString(@"Dialog_Ok", nil) cancel:NSLocalizedString(@"Dialog_Cancel", nil) okBlock:^{
//                        [SVProgressHUD show];
//                        [QDModelManager requestLogout:^(NSDictionary * _Nonnull dictionary) {
//                            QDBaseResultModel* resultModel = [QDBaseResultModel mj_objectWithKeyValues:dictionary];
//                            [SVProgressHUD dismiss];
//                            if (resultModel.code == kHttpStatusCode200) {
//                                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Dialog_Sign_Out_Success", nil)];
//                                QDConfigManager.shared.email    = nil;
//                                QDConfigManager.shared.password = nil;
//                                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserGoLoginSelectView object:nil];
//                            } else {
//                                [SVProgressHUD showErrorWithStatus:resultModel.message];
//                            }
//                        }];
//                    } cancelBlock:^{
//
//                    }];
//                }
//                    break;
//                default:
//                    break;
//            }
//        }];
//    }
//    return _tableViewProxy;
//}

- (void)backButtonClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UITableView *)accountTableView {
    if (!_accountTableView) {
        _accountTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _accountTableView.delegate = self;
        _accountTableView.dataSource = self;
        _accountTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _accountTableView.backgroundColor = [UIColor clearColor];
    }
    return _accountTableView;
}

@end
