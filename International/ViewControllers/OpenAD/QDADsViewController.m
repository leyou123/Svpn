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
#import "QDAnimation.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "QDHomeViewController.h"
#import "QDUserViewController.h"
#import "QDBaseNavigationViewController.h"
#import "QDDeviceActiveResultModel.h"
#import "AppDelegate.h"

@interface QDADsViewController ()

@property (nonatomic, strong) UIImageView * imageView;

@property (nonatomic, strong) QDAnimation * animation;

@property(nonatomic,strong) MMDrawerController * drawerController;

@end

@implementation QDADsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.animation = [[QDAnimation alloc] init];
    [self requestUserInfo];
    [self requestNodes];
    [self initSubviews];
}

- (void) requestNodes {
    [QDModelManager requestNodes:^(NSDictionary * _Nonnull dictionary) {
        QDNodesResultModel* resultModel = [QDNodesResultModel mj_objectWithKeyValues:dictionary];
        if (resultModel.code == kHttpStatusCode200) {
            // 默认第一条线路
            QDConfigManager.shared.nodes = resultModel.data;
            QDConfigManager.shared.lineHide = resultModel.node_hide_switch;
            QDConfigManager.shared.testNodes = resultModel.test_nodes;
//            int open_anim_ping = [[[NSUserDefaults standardUserDefaults] objectForKey:@"open_anim_ping"] intValue];
//            if (open_anim_ping == 1) {
                [QDConfigManager.shared startPing:^{
                    [self setRootVC];
                }];
//            }else {
//                [self setRootVC];
//            }
            
        } else {
            NSLog(@"requestNodes request failed %@", resultModel.message);
            // 请求失败
            [self setRootVC];
        }
    }];
}

- (void)requestUserInfo {
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
//            [self responseRequestUserInfo:YES result:dictionary];
        }];
    }
}

- (void) responseRequestUserInfo:(BOOL)isRegister result:(NSDictionary*) dictionary {
    QDDeviceActiveResultModel* resultModel = [QDDeviceActiveResultModel mj_objectWithKeyValues:dictionary];
    
    if (resultModel.code == kHttpStatusCode200) {
        
        QDConfigManager.shared.activeModel = resultModel.data;

        if (isRegister) {
            QDConfigManager.shared.local_UID = QDConfigManager.shared.activeModel.uid;
        }
        
        // 刷新用户信息
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserActive object:nil];
    }else if (resultModel.code == kHttpStatusCode404) {
        QDConfigManager.shared.email    = nil;
        QDConfigManager.shared.password = nil;
        
        // 跳转至用户选择界面
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserGoLoginSelectView object:nil];
    } else {
        // 请求失败
        [QDDialogManager showDialog:nil message:resultModel.message ok:NSLocalizedString(@"Dialog_Retry", nil) cancel:nil okBlock:^{
            [self requestUserInfo];
        } cancelBlock:^{
            
        }];
    }
}

- (void)setRootVC {

    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationAnimationStopGoHome object:nil];
    //    QDHomeViewController *homeVC = [[QDHomeViewController alloc]init];
//    homeVC.isUserSelectEnter = NO;
//    QDUserViewController *leftVC = [[QDUserViewController alloc] init];
//
//    QDBaseNavigationViewController *homeNavigation = [[QDBaseNavigationViewController alloc]initWithRootViewController:homeVC];
//    QDBaseNavigationViewController *leftNavigation = [[QDBaseNavigationViewController alloc] initWithRootViewController:leftVC];
//
//    //3、使用MMDrawerController
//    self.drawerController = [[MMDrawerController alloc]initWithCenterViewController:homeNavigation leftDrawerViewController:leftNavigation];
//
//    self.drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
//    self.drawerController.maximumLeftDrawerWidth = [UIScreen mainScreen].bounds.size.width;
////
////    [UIApplication sharedApplication].keyWindow.rootViewController = self.drawerController;
//    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
////    [app changeRootVC:NO];
//    app.window.rootViewController = self.drawerController;
}

- (void)initSubviews {
    [self.view addSubview:self.imageView];
    
    UIImageView * shieldIv = [[UIImageView alloc] init];
    shieldIv.image = [UIImage imageNamed:@"open_shield"];
    [self.view addSubview:shieldIv];
    [shieldIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(kScreenHeight*0.3);
        make.size.mas_equalTo(CGSizeMake(90, 100));
    }];
    
    UIImageView * earthIv = [[UIImageView alloc] init];
    earthIv.image = [UIImage imageNamed:@"open_earth"];
    [self.view addSubview:earthIv];
    [earthIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_right);
        make.top.equalTo(self.view).offset(kScreenHeight*0.3);
        make.size.mas_equalTo(CGSizeMake(150, 150));
    }];
    
    UILabel * nameLb = [[UILabel alloc] init];
    nameLb.text = @"Super VPN";
    nameLb.textColor = [UIColor whiteColor];
    nameLb.textAlignment = NSTextAlignmentCenter;
    nameLb.font = [UIFont systemFontOfSize:40.0 weight:UIFontWeightHeavy];
    nameLb.alpha = 0.0;
    [self.view addSubview:nameLb];
    [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-50);
    }];

    CABasicAnimation * earthAnimation = [self.animation moveFromValue:CGPointMake(-100, kScreenHeight*0.3) toValue:CGPointMake(kScreenWidth/2.0, kScreenHeight*0.3) duration:1.0 repeat:0];
    CABasicAnimation * earthZoomAnimation = [self.animation zoomFromValue:1.0 toValue:1.5 duration:1.0 repeat:0];
    [earthIv.layer addAnimation:earthAnimation forKey:@"move"];
    [earthIv.layer addAnimation:earthZoomAnimation forKey:@"zoom"];
    
    CABasicAnimation * shieldAnimation = [self.animation moveFromValue:CGPointMake(kScreenWidth, kScreenHeight*0.3) toValue:CGPointMake(kScreenWidth/2.0, kScreenHeight*0.3) duration:1.0 repeat:0];
    CABasicAnimation * shieldZoomAnimation = [self.animation zoomFromValue:1.0 toValue:1.5 duration:1.0 repeat:0];
    [shieldIv.layer addAnimation:shieldAnimation forKey:@"move"];
    [shieldIv.layer addAnimation:shieldZoomAnimation forKey:@"zoom"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 需要延迟执行的代码
        CABasicAnimation * rotateAnimation = [self.animation rotateFromValue:0.0 toValue:2*M_PI duration:9 repeat:10000];
        [earthIv.layer addAnimation:rotateAnimation forKey:@"rotate"];
        
        CALayer * layer = [self.animation animationWithGroup:earthIv];
        [earthIv.layer addSublayer:layer];
    });
        
    [UIView animateWithDuration:1.5 animations:^{
        nameLb.alpha = 1.0;
    }];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _imageView.image = [UIImage imageNamed:[self MN_getLaunchImageName]];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (NSString*)MN_getLaunchImageName {
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    // 竖屏
    NSString*viewOrientation =@"Portrait";
    NSString*launchImageName =nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for(NSDictionary* dict in imagesDict) {
        CGSize imageSize =CGSizeFromString(dict[@"UILaunchImageSize"]);
        if(CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            launchImageName = dict[@"UILaunchImageName"];
        }
    }
    return launchImageName;
}

- (void)dealloc {
    
    NSLog(@"aaaaaa");
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
