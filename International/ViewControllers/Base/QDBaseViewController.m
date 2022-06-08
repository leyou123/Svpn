//
//  TZBaseViewController.m
//  vpn
//
//  Created by hzg on 2020/12/22.
//

#import "QDBaseViewController.h"
#import "QDSizeUtils.h"
#import "UIImage+Utils.h"

@interface QDBaseViewController ()
@end

@implementation QDBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if (!self.isHideNavagation) {
        
        if (@available(iOS 13.0, *)) {
            UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
            [appearance configureWithOpaqueBackground];
            appearance.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:164.0/255.0 blue:247.0/255.0 alpha:1];
            appearance.shadowColor = [UIColor whiteColor];
            appearance.shadowImage = [UIImage imageWithColor:[UIColor whiteColor]];
            self.navigationController.navigationBar.standardAppearance = appearance;
            self.navigationController.navigationBar.scrollEdgeAppearance = self.navigationController.navigationBar.standardAppearance;
        } else {
            self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.0/255.0 green:164.0/255.0 blue:247.0/255.0 alpha:1];
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.0/255.0 green:164.0/255.0 blue:247.0/255.0 alpha:1]] forBarMetrics:UIBarMetricsDefault];
            [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        }
        
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        UIImageView* backImage = [UIImageView new];
        backImage.image = [[UIImage imageNamed:@"common_btn_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        backImage.tintColor = [UIColor whiteColor];
        [button addSubview:backImage];
        [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(button).offset(0);
            make.centerY.equalTo(button);
            make.width.equalTo(@(10));
            make.height.equalTo(@(17));
        }];
        [button addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.view.backgroundColor = [UIColor whiteColor];
    } else {
        // nav
        self.navigationController.navigationBar.translucent = YES;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        self.view.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:164.0/255.0 blue:247.0/255.0 alpha:1];
    }

    // back white color
    
}

// 设置背景
- (void) setupBack {
//    UIImageView* back = [UIImageView new];
//    back.image = [UIImage imageNamed:@"common_back"];
//    back.userInteractionEnabled = YES;
//    [self.view addSubview:back];
//    [back mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
    
//    UIView* line = [UIView new];
//    line.backgroundColor = [UIColor whiteColor];
//    [back addSubview:line];
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(back);
//        make.height.equalTo(@(0.5));
//        make.top.equalTo(@([CSLYSizeUtils navigationHeight] + 44));
//    }];
}

// close action
- (void) dismissAction {
    [self.navigationController popViewControllerAnimated:YES];
}

// 设置标题
- (void) setupTitle:(NSString*) title {
    UILabel* titleLabel = [UILabel new];
    titleLabel.text = NSLocalizedString(title, nil);
    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.font = [UIFont boldSystemFontOfSize:21.0f];
//    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = kSFUIDisplayFont(28);
    titleLabel.textColor = RGB_HEX(0x000000);
    if (self.isHideNavagation) {
        [self.view addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view).offset(0);
            make.top.equalTo(self.view).offset([QDSizeUtils navigationHeight] + 10);
            make.width.mas_equalTo(300);
            make.height.mas_equalTo(25);
        }];
    } else {
        self.navigationItem.titleView = titleLabel;
    }
}

// 设置背景框
- (void) setupBackFrame {
    _backFrame = [UIView new];
    _backFrame.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_backFrame];
    [_backFrame mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
}

-(BOOL) shouldAutorotate {
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
