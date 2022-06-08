//
//  NavigationBarHiddenViewController.m
//  vpn
//
//  Created by hzg on 2020/12/15.
//

#import "QDNavigationBarHiddenViewController.h"

@interface QDNavigationBarHiddenViewController () <UINavigationControllerDelegate>

@end

@implementation QDNavigationBarHiddenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
}

// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

-(BOOL) shouldAutorotate {
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
