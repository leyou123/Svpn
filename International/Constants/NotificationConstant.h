

#ifndef NotificationConstant_h
#define NotificationConstant_h

#pragma mark - 应用通知宏定义

// 用户信息更新
static NSString * const kNotificationUserLoginSuccess = @"NotificationUserLoginSuccess";
static NSString * const kNotificationUserGoHomeView = @"NotificationUserGoHomeView";
static NSString * const kNotificationUserGoLoginSelectView = @"NotificationUserGoLoginSelectView";
static NSString * const kNotificationUserChange = @"NotificationUserChange";
static NSString * const kNotificationUserActive = @"NotificationUserActive";
static NSString * const kNotificationLineChange = @"NotificationLineChange";
static NSString * const kNotificationLineRefresh = @"NotificationLineRefresh";
static NSString * const kNotificationConfigInstallStart = @"kNotificationConfigInstallStart";
static NSString * const kNotificationConfigInstallFail = @"NotificationConfigInstallFail";
static NSString * const kNotificationConfigInstallEnd = @"NotificationConfigInstallEnd";

// 页面切换
static NSString * const kNotificationtabChanged = @"NotificationtabChanged";

// banner加载成功
static NSString * const kNotificationBannnerLoad = @"NotificationBannnerLoad";

// 网络状态变化
static NSString * const kNotificationNetworkChanged = @"NotificationNetworkChanged";

// 配置更新
static NSString * const kNotificationConfigUpdate = @"NotificationConfigUpdate";

// 任务更新
static NSString * const kNotificationActivityUpdate = @"NotificationActivityUpdate";

// 推荐app通知
static NSString * const kNotificationRecommandApp = @"NotificationRecommandApp";

#endif
