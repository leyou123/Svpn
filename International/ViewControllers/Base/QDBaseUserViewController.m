//
//  QDBaseUserViewController.m
//  International
//
//  Created by LC on 2022/4/21.
//  Copyright © 2022 com. All rights reserved.
//

#import "QDBaseUserViewController.h"

@interface QDBaseUserViewController ()

@end

@implementation QDBaseUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.whiteBgIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.whiteBgIv.image = [UIImage imageNamed:@"user_info_bg"];
    self.whiteBgIv.userInteractionEnabled = NO;
    [self.view addSubview:self.whiteBgIv];
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
