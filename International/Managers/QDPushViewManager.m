//
//  CSLYPushViewHelper.m
//  StormVPN
//
//  Created by hzg on 2021/11/30.
//

#import "QDPushViewManager.h"

static NSString *const kPushViewTimeKey = @"key_pushview_time";
static NSInteger IntervalTime = 1 * 24 * 60 * 60;

@interface QDPushViewManager()

@property(nonatomic, assign) NSTimeInterval lastShowTimestamp;

@end

// 界面推送助手
@implementation QDPushViewManager

+ (QDPushViewManager *) shared {
    static dispatch_once_t onceToken;
    static QDPushViewManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [QDPushViewManager new];
        [instance setup];
    });
    return instance;
}

- (void) setup {
    self.lastShowTimestamp = [[NSUserDefaults standardUserDefaults] doubleForKey:kPushViewTimeKey];
    if (self.lastShowTimestamp < 0) self.lastShowTimestamp = 0;
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
   ///下文中有分析
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
}

- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }

    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    
    return currentVC;
}

//
//- (UIViewController *)theTopViewController{
//
//    //获取根控制器
//    UIViewController *rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
//
//    UIViewController *parent = rootVC;
//    //遍历 如果是presentViewController
//    while ((parent = rootVC.presentedViewController) != nil ) {
//        rootVC = parent;
//    }
//
//    while ([rootVC isKindOfClass:[UINavigationController class]]) {
//        rootVC = [(UINavigationController *)rootVC topViewController];
//    }
//    return rootVC;
//}

// 随机推送弹窗视图, 每天弹一次
- (void) popRandomView {
    
    // 顶层视图
    UIViewController* topVC = [self getCurrentVC];
    NSString* topVCName = NSStringFromClass([topVC class]);
    
    if (![topVCName isEqualToString:@"QDHomeViewController"]
        && ![topVCName isEqualToString:@"QDUserViewController"]
        && ![topVCName isEqualToString:@"QDSubscriptionViewController"]) {
        return;
    }
    
    NSTimeInterval currentTimestamp = [[NSDate date] timeIntervalSince1970];
    if (self.lastShowTimestamp == 0) self.lastShowTimestamp = currentTimestamp;
    if (currentTimestamp - self.lastShowTimestamp < IntervalTime) {
        return;
    }
    self.lastShowTimestamp = currentTimestamp;
    [[NSUserDefaults standardUserDefaults] setDouble:currentTimestamp forKey:kPushViewTimeKey];
    
    // %50概率弹分享界面，%50概率弹购买界面
    NSArray* pushControllers = @[@"QDPurchaseNotifyViewController", @"QDShareNofifyViewController"];
    
    NSInteger index = arc4random()%100 >= 50 ? 0 : 1;
    UIViewController* beingPushViewController = [[NSClassFromString(pushControllers[index]) alloc] init];
    beingPushViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [topVC presentViewController:beingPushViewController animated:YES completion:nil];
}

@end
