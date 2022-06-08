//
//  TZBaseNavigationViewController.m
//  vpn
//
//  Created by hzg on 2020/12/22.
//

#import "QDBaseNavigationViewController.h"

@interface QDBaseNavigationViewController () <UIGestureRecognizerDelegate>

@end

@implementation QDBaseNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.childViewControllers.count > 1) {
        return YES;
    }
    return NO;
}

@end
