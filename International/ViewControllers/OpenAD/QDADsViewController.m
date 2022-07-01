//
//  QDADsViewController.m
//  International
//
//  Created by 杜国锋 on 2022/5/9.
//  Copyright © 2022 com. All rights reserved.
//

#import "QDADsViewController.h"
#import "QDDeviceUtils.h"
#import "QDNodesResultModel.h"


@interface QDADsViewController ()

@property (nonatomic, strong) UIImageView * imageView;

//@property (nonatomic, strong) UIProgressView * progressView;

@end

@implementation QDADsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestNodes];
    [self.view addSubview:self.imageView];
//    [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        self.progressView.progress += 0.04;
//        NSLog(@"%f",self.progressView.progress);
//        if (self.progressView.progress >= 1) {
//            [timer invalidate];
//            timer = nil;
//        }
//    }];
}

- (void) requestNodes {
    [QDModelManager requestNodes:^(NSDictionary * _Nonnull dictionary) {
        QDNodesResultModel* resultModel = [QDNodesResultModel mj_objectWithKeyValues:dictionary];
        if (resultModel.code == kHttpStatusCode200) {
            // 默认第一条线路
            QDConfigManager.shared.nodes = resultModel.data;
            QDConfigManager.shared.lineHide = resultModel.node_hide_switch;
            [QDConfigManager.shared preprogressNodes];
            [QDConfigManager.shared setDefaultNode];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLineRefresh object:nil];
        } else {
            NSLog(@"requestNodes request failed %@", resultModel.message);
        }
    }];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        NSString * imageName;
//        if ([QDDeviceUtils deviceIsPad]) {
//            imageName = @"ipad_open_loading";
//        }else {
            imageName = @"open_loading";
//        }
        NSString *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]]pathForResource:imageName ofType:@"gif"];
        NSData *imageData = [NSData dataWithContentsOfFile:filePath];
        UIImage * image = [UIImage sd_imageWithGIFData:imageData];
        _imageView.image = image;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}
//-(UIProgressView *)progressView {
//    if (!_progressView) {
//        _progressView = [[UIProgressView alloc]init];
//        _progressView.progressViewStyle = UIProgressViewStyleDefault;
//        _progressView.progress = 0;
//        //走过的颜色
//        _progressView.progressTintColor = RGB_HEX(0x27a3ef);
//        //本身的颜色
//        _progressView.trackTintColor = [UIColor whiteColor];
//        _progressView.layer.cornerRadius = 5;
//        _progressView.layer.masksToBounds = YES;
//        [self.view addSubview:_progressView];
//        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(210);
//            make.height.mas_equalTo(10);
//            make.centerX.equalTo(self.view);
//            make.bottom.equalTo(self.view.mas_bottom).offset(-50);
//        }];
//    }
//    return _progressView;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
