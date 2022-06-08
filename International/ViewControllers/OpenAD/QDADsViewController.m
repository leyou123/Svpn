//
//  QDADsViewController.m
//  International
//
//  Created by 杜国锋 on 2022/5/9.
//  Copyright © 2022 com. All rights reserved.
//

#import "QDADsViewController.h"

@interface QDADsViewController ()

@end

@implementation QDADsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showOpenAd];
    [self closeADs];
}

// 显示开屏
- (void) showOpenAd {
    BOOL isVIP = (QDConfigManager.shared.activeModel && QDConfigManager.shared.activeModel.member_type == 1);
    if (QDConfigManager.shared.isNoneFirstEnterApp && !isVIP) {
        BOOL show_open_ad = [QDVersionManager.shared.versionConfig[@"show_open_ad"] intValue] == 1;
        if (show_open_ad) {
            [QDAdManager.shared showInterstitial];
            return;
        }
    }
}

- (void)closeADs {
    [QDAdManager.shared showVideo:^(BOOL result) {
        if (result) {
            
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
