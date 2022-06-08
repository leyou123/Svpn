

#ifndef SystemConstant_h
#define SystemConstant_h

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - 设备、系统信息

/// 是否是 iPad

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

/// 是否是 iPhone

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

/// 是否竖直状态

#define IS_PORTRAIT ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || \
                     [[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortraitUpsideDown)

/// 设备类型（如：iPhone、iPad、iPod）

#define DEVICE_MODEL [[UIDevice currentDevice] model]

/// 设备名称（如：My iPhone）

#define DEVICE_NAME [[UIDevice currentDevice] name]

/// iOS 版本号（如：9.2）

#define IOS_VERSION ((float)[[[UIDevice currentDevice] systemVersion] floatValue])

/// APP 名称

#define APP_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];

/// APP 版本号（如：1.0.0）

#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

/// Build 号（如：1）

#define BUILD_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

/// 当前语言

#define LOCAL_LANGUAGE [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode]

/// 当前国家

#define LOCAL_COUNTRY [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode]

#define kScreenHeight  [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth   [[UIScreen mainScreen] bounds].size.width

#define kScreenScale  [UIScreen mainScreen].bounds.size.width/375.0
#define kScreenHScale  [UIScreen mainScreen].bounds.size.width/812.0
#define kStatusBarHeight  [UIApplication sharedApplication].statusBarFrame.size.height

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - 界面信息

static const CGFloat kAppStatusBarHeight              = 20.f;
static const CGFloat kAppNavigationBarHeight          = 44.f;
static const CGFloat kAppStatusAndNavigationBarHeight = 64.f;
static const CGFloat kAppTabBarHeight                 = 49.f;
static const CGFloat kAppNavigationBarIconSize        = 22.f;
static const CGFloat kAppTabBarIconSize               = 50.f;
static const CGFloat kAppKeyboardHeightEn             = 216.f;
static const CGFloat kAppKeyboardHeightCn             = 252.f;

////////////////////////////////////////////////////////////////////////////////////////////////////

#endif
