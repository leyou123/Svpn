//
//  AppDelegate.m
//  ReturningHome
//
//  Created by a on 2019/11/7.
//  Copyright © 2019 com. All rights reserved.
//

#import "AppDelegate.h"
#import "QDHomeViewController.h"
#import "QDSubscriptionViewController.h"
#import "QDUserViewController.h"
#import "QDOrderResultModel.h"
#import "QDReceiptManager.h"
#import <Firebase/Firebase.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import "QDBaseNavigationViewController.h"
#import "QDLoginSelectViewController.h"
#import "UIUtils.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "QDPayViewController3.h"
#import "UnityOpenAds.h"
static BOOL isEnterBackground = NO;


@interface AppDelegate () <SKPaymentTransactionObserver, UITabBarControllerDelegate>

// 上一次显示开屏广告的时间
@property(nonatomic, assign) NSTimeInterval lastShowTimestamp;
@property(nonatomic, strong) NSString *deviceModelName;
@property(nonatomic,strong) MMDrawerController * drawerController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setup];
    return YES;
}




- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    isEnterBackground = YES;
    
    // 设置推送内容
    if (QDConfigManager.shared.activeModel && QDConfigManager.shared.activeModel.member_type != 1 ) {
        NSInteger remainDays = QDConfigManager.shared.remainMins / (60*24) - 1;
        NSString* body = NSLocalizedString(@"Notification_NoneVIP_Remind", nil);
        if (remainDays > 0) {
            body = [NSString stringWithFormat:NSLocalizedString(@"Notification_Expired_Remind", nil), remainDays];
        }
        [QDLocalNoticationManager.shared pushNotification:body promptTone:@"" soundName:@"" imageName:@"" movieName:@"" Identifier:@"international_notication_identifier"];
    }
}






- (void)applicationDidBecomeActive:(UIApplication *)application {
    
//    // 清理推送通知
//    [QDLocalNoticationManager.shared cancelAllLocalNotifications];

    // 通知用户界面刷新
    if(isEnterBackground) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserChange object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationAppBecomeActive object:nil];
        
        // 检查0点时间
        [QDActivityManager.shared checkZeroTime];
    }
    isEnterBackground = NO;
    
    [QDAdManager.shared setup:YES];
    
    BOOL isVIP = (QDConfigManager.shared.activeModel && QDConfigManager.shared.activeModel.member_type == 1);
    
    // 开屏广告
    if (QDVPNManager.shared.isInstallerVPNConfig&&QDConfigManager.shared.isNoneFirstEnterApp && !isVIP) {
        
        // 开屏广告
        BOOL show_open_ad = [QDVersionManager.shared.versionConfig[@"show_open_ad"] intValue] == 1;
        if (!show_open_ad) return;
        
        int interval = [QDVersionManager.shared.versionConfig[@"show_open_ad_interval"] intValue];
        if (interval < 0) interval = 0;
        NSTimeInterval currentTimestamp = [[NSDate date] timeIntervalSince1970];
        if (self.lastShowTimestamp == 0) self.lastShowTimestamp = currentTimestamp;
        if (currentTimestamp - self.lastShowTimestamp < interval) {
            return;
        }
        self.lastShowTimestamp = currentTimestamp;
        UIViewController * vc = [UIUtils getCurrentVC];
        if ([vc isKindOfClass:[QDPayViewController3 class]]) {
            return;
        }
        [QDAdManager.shared showOpenAd];
    }

}

//handle token received from APNS
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [QDLocalNoticationManager.shared application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

//handle token receiving error
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [QDLocalNoticationManager.shared application:application didFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)applicationWillTerminate:(UIApplication *)application {
//    [[RMStore defaultStore] removeStoreObserver:self];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver: self];

    [self stopMonitoring];
    [self unregisterNotification];
}

// 初始化
- (void) setup {
    
//    [QDAdManager.shared setup:YES];
    
    [self initWindow];
    
    // 标签栏
    [self initTabBar:NO];
    
    // 设置弹出框样式
    [self setupHUD];
    
    // 订单逻辑
    [self setupStore];
    
    // 开始监测
    [self startMonitoring];
    
    // 数据分析
    [self setupAnalysis];
    
    // 检查版本更新
    [self checkVersionUpdate];
    
    // 检查VPN 切换值
    [QDVPNManager.shared check];
    
    // 更新本地价格
    [self updateLocalPrice];
    
//    // 广告
//    [QDAdManager.shared setup];
    [self registerNotification];
    
    [QDLocalNoticationManager.shared setup];
//    [QDAdManager.shared setup:YES];
    // 初始化完成统计
    [QDTrackManager track:QDTrackType_app_inited data:@{}];
//    [QDLocalNoticationManager.shared setup];
}

// 注册通知
- (void) registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nofityGoHomeController) name:kNotificationUserGoHomeView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nofityGoLoginSelectController) name:kNotificationUserGoLoginSelectView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nofityTabbarChanged) name:kNotificationtabChanged object:nil];
}

// 注销通知
- (void) unregisterNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationUserGoHomeView object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationUserGoLoginSelectView object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationtabChanged object:nil];
}

// 更新本地价格
- (void) updateLocalPrice {
    [QDReceiptManager.shared updateProduct:@[Month_Subscribe_Name_Free, Month_Subscribe_Name, Quarter_Subscribe_Name, HalfYear_Subscribe_Name,Year_Subscribe_Name_Free, Year_Subscribe_Name] completion:^{
        
    }];
}

// 检查版本更新
- (void) checkVersionUpdate {
    [QDVersionManager.shared check:YES];
}

- (void) setupAnalysis {
    [FIRApp configure];
    [QDTrackManager track:QDTrackType_app_start data:@{}];
}


// 订单逻辑
- (void) setupStore {
    
    // 订阅监听、补单逻辑
    [[SKPaymentQueue defaultQueue] addTransactionObserver: self];
}

// HUD
- (void) setupHUD {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setMaximumDismissTimeInterval:1.5];
    [SVProgressHUD setErrorImage:[UIImage imageNamed:@""]];
}

// 开始网络检测
- (void) startMonitoring {
    
    // 开始网络检测
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];

    // 网络状态改变的回调
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
           switch (status) {
               case AFNetworkReachabilityStatusReachableViaWWAN:
                   NSLog(@"蜂窝网络");
                   break;
               case AFNetworkReachabilityStatusReachableViaWiFi:
                   NSLog(@"WIFI");
                   break;
               case AFNetworkReachabilityStatusNotReachable:
                   NSLog(@"没有网络");
                   break;
               case AFNetworkReachabilityStatusUnknown:
                   NSLog(@"未知");
                   break;
               default:
                   break;
           }
        
        // 网络状态发生变化
        if (QDConfigManager.shared.isNetworkReady) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNetworkChanged object:nil];
        }
        
        QDConfigManager.shared.isNetworkReady = YES;
    }];
}

// 停止网络检测
- (void) stopMonitoring {
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}


// Sent when a user initiates an IAP buy from the App Store
- (BOOL)paymentQueue:(SKPaymentQueue *)queue shouldAddStorePayment:(SKPayment *)payment forProduct:(SKProduct *)product {
    [QDReceiptManager.shared transaction_new:product.productIdentifier completion:^(BOOL success){
        if (success) {
            
        }
    }];
    return YES;
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchasing: // 0
                break;
            case SKPaymentTransactionStatePurchased: // 1
                 //订阅特殊处理
                 if(transaction.originalTransaction){
                      //如果是自动续费的订单originalTransaction会有内容
                 }else{
                      //普通购买，以及 第一次购买 自动订阅
                 }
                [queue finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed: // 2
                break;
            case SKPaymentTransactionStateRestored: // 3
                break;
            default:
                break;
        }
    }
}

// init window
- (void) initWindow {
    self.window = [[UIWindow alloc]init];
    // 不适配深色模式，统一采用浅色
    if (@available(iOS 13.0, *)) {
        self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    } else {
    }
    
    // 设置导航栏为黑色
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
    }
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    // scrollview去掉自动调整行为
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        // Fallback on earlier versions
    }
}

// 初始化TabBar
- (void) initTabBar:(BOOL) isUserSelectEnter {
    
    CGFloat offset = 5.0;
    if (IS_IPAD) offset = 0.0;

//    UITabBarController *initBar = [[UITabBarController alloc]init];
//    [initBar setDelegate:self];
//    initBar.tabBar.translucent = YES;
//    initBar.tabBar.tintColor = [UIColor colorWithRed:0.0/255.0 green:178.0/255.0 blue:239.0/255.0 alpha:1];
//    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
//
//    QDHomeViewController *homeView = [[QDHomeViewController alloc]init];
//    homeView.isUserSelectEnter = isUserSelectEnter;
//    QDBaseNavigationViewController *homeNavigation = [[QDBaseNavigationViewController alloc]initWithRootViewController:homeView];
//    UIImage *homeUnselectedImage = [[UIImage imageNamed:@"home_nor"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UIImage *homeSelectedImage = [[UIImage imageNamed:@"home_sel"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    homeNavigation.tabBarItem = [[UITabBarItem alloc]initWithTitle:nil image:homeUnselectedImage selectedImage:homeSelectedImage];
//    homeNavigation.tabBarItem.imageInsets = UIEdgeInsetsMake(offset, 0, -offset, 0);
//
//    QDSubscriptionViewController *buyView = [[QDSubscriptionViewController alloc]init];
//    QDBaseNavigationViewController *subscriptionNavigation = [[QDBaseNavigationViewController alloc]initWithRootViewController:buyView];
//    UIImage *buyUnselectedImage = [[UIImage imageNamed:@"buy_nor"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UIImage *buySelectedImage = [[UIImage imageNamed:@"buy_sel"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    subscriptionNavigation.tabBarItem = [[UITabBarItem alloc]initWithTitle:nil image:buyUnselectedImage selectedImage:buySelectedImage];
//    subscriptionNavigation.tabBarItem.imageInsets = UIEdgeInsetsMake(offset, 0, -offset, 0);
//
//    QDUserViewController *settingView = [[QDUserViewController alloc]init];
////    settingView.isHideNavagation = YES;
//    QDBaseNavigationViewController *settingNavigation = [[QDBaseNavigationViewController alloc]initWithRootViewController:settingView];
//    UIImage *settingUnselectedImage = [[UIImage imageNamed:@"me_nor"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UIImage *settingSelectedImage = [[UIImage imageNamed:@"me_sel"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    settingNavigation.tabBarItem = [[UITabBarItem alloc]initWithTitle:nil image:settingUnselectedImage selectedImage:settingSelectedImage];
//    settingNavigation.tabBarItem.imageInsets = UIEdgeInsetsMake(offset, 0, -offset, 0);
//
//    initBar.viewControllers = @[homeNavigation,subscriptionNavigation,settingNavigation];
//    initBar.selectedIndex = 0;
    
    QDHomeViewController *homeVC = [[QDHomeViewController alloc]init];
    QDUserViewController *leftVC = [[QDUserViewController alloc] init];
    
    QDBaseNavigationViewController *homeNavigation = [[QDBaseNavigationViewController alloc]initWithRootViewController:homeVC];
    QDBaseNavigationViewController *leftNavigation = [[QDBaseNavigationViewController alloc] initWithRootViewController:leftVC];
    
    //3、使用MMDrawerController
    self.drawerController = [[MMDrawerController alloc]initWithCenterViewController:homeNavigation leftDrawerViewController:leftNavigation];
    
    self.drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
    self.drawerController.maximumLeftDrawerWidth = [UIScreen mainScreen].bounds.size.width;
    
    self.window.rootViewController = self.drawerController;
    [self.window makeKeyAndVisible];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    QDBaseNavigationViewController* navigationController = (QDBaseNavigationViewController*)viewController;
    NSString* className = NSStringFromClass([navigationController.topViewController class]);
    if ([className isEqual:@"QDSubscriptionViewController"]) {
        [QDTrackManager track_button:QDTrackButtonType_11];
        return;
    }
    if ([className isEqual:@"QDHomeViewController"]) {
        [QDTrackManager track_button:QDTrackButtonType_10];
        // 显示插屏广告
        BOOL isVIP = (QDConfigManager.shared.activeModel && QDConfigManager.shared.activeModel.member_type == 1);
        if (QDConfigManager.shared.isNoneFirstEnterApp && !isVIP) {
            BOOL show_interstitial_ad = [QDVersionManager.shared.versionConfig[@"show_interstitial_ad"] intValue] == 1;
            if (!show_interstitial_ad) return;
            [QDAdManager.shared showInterstitial];
        }
        return;
    }
    if ([className isEqual:@"QDUserViewController"]) {
        [QDTrackManager track_button:QDTrackButtonType_12];
        return;
    }
}


// 跳转主界面
- (void) nofityGoHomeController {
    [self initTabBar:YES];
}

// 跳转登录选择界面
- (void) nofityGoLoginSelectController {
    QDLoginSelectViewController* ctl = [QDLoginSelectViewController new];
    self.window.rootViewController = ctl;
    [self.window makeKeyAndVisible];
}

- (void) nofityTabbarChanged {
    UIViewController* vc = [UIUtils getCurrentVC];
    if (vc) {
        NSString* className = NSStringFromClass([vc class]);
        if ([className isEqual:@"QDHomeViewController"]) {
            [QDTrackManager track_button:QDTrackButtonType_10];
            // 显示插屏广告
            BOOL isVIP = (QDConfigManager.shared.activeModel && QDConfigManager.shared.activeModel.member_type == 1);
            if (QDConfigManager.shared.isNoneFirstEnterApp && !isVIP) {
                BOOL show_interstitial_ad = [QDVersionManager.shared.versionConfig[@"show_interstitial_ad"] intValue] == 1;
                if (!show_interstitial_ad) return;
                [QDAdManager.shared showInterstitial];
            }
            return;
        }
    }
}

@end

