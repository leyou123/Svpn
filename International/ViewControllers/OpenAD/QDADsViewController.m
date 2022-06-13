//
//  QDADsViewController.m
//  International
//
//  Created by 杜国锋 on 2022/5/9.
//  Copyright © 2022 com. All rights reserved.
//

#import "QDADsViewController.h"

@interface QDADsViewController ()

@property (nonatomic, strong) UIImageView * imageView;

@end

@implementation QDADsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self showOpenAd];
//    [self closeADs];
    [self.view addSubview:self.imageView];
    
//    [QDAdManager.shared setup:YES];
//    [QDAdManager.shared showInterstitial];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _imageView.image = [UIImage imageNamed:@"icon-1"];
    }
    return _imageView;
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
