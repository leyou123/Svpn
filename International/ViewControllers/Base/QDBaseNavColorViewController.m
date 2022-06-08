//
//  QDBaseNavColorViewController.m
//  International
//
//  Created by LC on 2022/4/27.
//  Copyright © 2022 com. All rights reserved.
//

#import "QDBaseNavColorViewController.h"

@interface QDBaseNavColorViewController ()

@end

@implementation QDBaseNavColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setImage:[UIImage imageNamed:@"line_nav_back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)dismissAction {
    [self.navigationController popViewControllerAnimated:YES];
}

// 设置标题
- (void) setupTitle:(NSString*) title {
    UILabel* titleLabel = [UILabel new];
    titleLabel.text = NSLocalizedString(title, nil);
    titleLabel.textAlignment = NSTextAlignmentCenter;

    titleLabel.font = kSFUIDisplayFont(28);
    titleLabel.textColor = RGB_HEX(0x000000);
    self.navigationItem.titleView = titleLabel;
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
