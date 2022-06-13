//
//  AppConstant.h
//  International
//
//  Created by hzg on 2021/6/7.
//  Copyright © 2021 com. All rights reserved.
//

#ifndef AppConstant_h
#define AppConstant_h

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - 主题颜色

// dialog
#define APP_COLOR_DIALOG_OK     RGB_HEX(0x37CBDD)
#define APP_COLOR_DIALOG_CANCEL RGB_HEX(0xc0b5b5)

#define APP_COLOR_BACKGROUND RGB_HEX(0x73D7A7)
#define APP_COLOR_THEME      RGB_HEX(0x000C11)
#define APP_COLOR_WHITE      RGB_HEX(0xffffff)
#define APP_COLOR_BLACK      RGB_HEX(0x000000)
#define APP_COLOR_GRAY_LIGHT RGB_HEX(0xCCCCCC)
#define APP_COLOR_GRAY_DARK  RGB_HEX(0x777777)
#define APP_COLOR_RED        RGB_HEX(0xe84e3c)
#define APP_COLOR_GREEN      RGB_HEX(0x26ad5f)
#define APP_COLOR_BLUE       RGB_HEX(0x085555)
#define APP_COLOR_YELLOW     RGB_HEX(0xF0D24B)
#define APP_COLOR_CLEAR      [UIColor clearColor]

#define APP_FONT_SYSTEM(s)   [UIFont systemFontOfSize:s]
#define APP_FONT_BOLD(s)     [UIFont boldSystemFontOfSize:s]
#define APP_FONT_LETTER(s)   [UIFont fontWithName:@"Courier" size:s]
#define kSFUITextFont(s)   [UIFont fontWithName:@"SF UI Text" size:s]
#define kSFUIDisplayFont(s)   [UIFont fontWithName:@"SF UI Display" size:s]

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - 网络请求

#if DEBUG
//    // 开发环境
    #define HOST_URLs @[@"https://api.9527.click"]
//#define HOST_URLs @[@"https://test.9527.click"]
//#define HOST_URLs @[@"http://54.177.55.54:10050"]


#else
//    #define HOST_URLs @[@"https://api.9527.click"]
//    // 生产环境
    #define HOST_URLs @[@"https://api.9527.click"]
#endif

// appleid
#define APPLE_ID      @"1490819262"
#define APP_BUNDLE_ID @"com.superoversea"
// 平台id
#define APP_PLATFORM_ID  @"super_vpn.2021"

// ase 加密key
#define ASE_KEY @"VXH2THdPBsHEp+TY"
#define ASE_SOLT @"leyou2021"

// 隐私地址、用户协议、会员服务
#define PRIVATE_POLICY_URL @"https://www.9527.click/static/html/ios_qd/PrivacyPolicy.html"
#define USER_AGREEMENT_URL @"https://www.9527.click/static/html/ios_qd/UserAgreement.html"
#define SUBSCRIBE_AGREEMENT_URL @"https://www.9527.click/static/html/ios_qd/TermsofService.html"
#define FAQ_URL @"https://vpnletgo.gitbook.io/faq/"
#define WEBSITE_URL @"https://www.1573.click"

// 应用版本号
#define APP_V @"v2"

typedef NS_ENUM(NSInteger, APIType) {
    // 设备注册
    kAPITypeUserRegister,
    // 设备登录
    kAPITypeUserLogin,
    // 看广告加时长
    kAPITypeUserAddTime,
    // 兑换奖励
    kAPITypeUserRedeemReward,
    // 扫码绑定
    kAPITypeUserScanCode,
    kAPITypeUserAddTimeNew,
    
    // 发送邮件验证码
    kAPITypeSendEmailCode,
    // 验证验证码
    kAPITypeVerifyCode,
    // 配置新密码，忘记密码/重置密码，修改密码
    kAPITypeUpdatePassword,
    // 删除用户设备&解绑
    kAPITypeDeleteDevice,
    // 用户登出
    kAPITypeLogout,
    // 邮箱解绑
    kAPITypeUnbind,
    
    // 上报订单/创建订单
    kApiTypeCreateOrder,
    // 订单记录
    kApiTypeOrders,
    // 恢复订单
    kApiTypeRestoreOrders,
    
    // 节点
    // 请求节点列表
    kAPITypeNodes,
    // 请求推荐节点
    kAPITypeNodesRecommend,
    // 请求断开
    kAPITypeNodesDisconnect,
    // 注册
    kAPITypeNodeRegister,

    
    // FAQ&Contact
    kAPITypeFeekBack,
    kAPITypeFAQ,

    // pc请求登录验证
    kAPIQRCode,
    
    // 统计特征
    kAPITrack,
    
    // 版本升级信息
    kAPIVersionUpdate,
    
    // 查看appstore信息
    kAPILookupApp,
    
    // 交叉推广
    kAPIRecommandAd,
    
    // 请求版本配置
    kAPIVersionConfig,
    
    // 推送token
    kAPIDeviceToken,
    
    // 国家下线路
    kAPICountrySublines,
    
    // 连接记录
    kAPIConnectRecord,
    
    // ping反馈
    kAPIFeedBackPing
};

// 声明全局的字典，用于将枚举APIType和对应的URL关联起来
#define API_PATH @{\
    [NSNumber numberWithInteger:kAPITypeUserRegister]:\
    @"/user/register",\
    [NSNumber numberWithInteger:kAPITypeUserLogin]:\
    @"/user/login",\
    [NSNumber numberWithInteger:kAPITypeUserAddTime]:\
    @"/user/add_time",\
    [NSNumber numberWithInteger:kAPITypeUserAddTimeNew]:\
    @"/user/add_vip_time",\
    [NSNumber numberWithInteger:kAPITypeUserRedeemReward]:\
    @"/user/verify_share_code",\
    [NSNumber numberWithInteger:kAPITypeSendEmailCode]:\
    @"/user/send_email",\
    [NSNumber numberWithInteger:kAPITypeVerifyCode]:\
    @"/user/verify_code",\
    [NSNumber numberWithInteger:kAPITypeUpdatePassword]:\
    @"/user/password",\
    [NSNumber numberWithInteger:kAPITypeDeleteDevice]:\
    @"/user/delete_device",\
    [NSNumber numberWithInteger:kAPITypeLogout]:\
    @"/user/logout",\
    [NSNumber numberWithInteger:kAPITypeUnbind]:\
    @"/user/email_unbinding",\
    [NSNumber numberWithInteger:kAPITypeUserScanCode]:\
    @"/user/qr_code",\
    [NSNumber numberWithInteger:kApiTypeCreateOrder]:\
    @"/orders/ios_subscriptions",\
    [NSNumber numberWithInteger:kApiTypeRestoreOrders]:\
    @"/orders/ios_recover_orders",\
    [NSNumber numberWithInteger:kApiTypeOrders]:\
    @"/orders/query",\
    [NSNumber numberWithInteger:kAPITypeNodes]:\
    @"/node/all", \
    [NSNumber numberWithInteger:kAPITypeNodesRecommend]:\
    @"/node/assign", \
    [NSNumber numberWithInteger:kAPITypeNodesDisconnect]:\
    @"/node/apart", \
    [NSNumber numberWithInteger:kAPITypeNodeRegister]:\
    @"/node/register", \
    [NSNumber numberWithInteger:kAPITypeFeekBack]:\
    @"/user/feed_back", \
    [NSNumber numberWithInteger:kAPITypeFAQ]:\
    @"/users/problem", \
    [NSNumber numberWithInteger:kAPIQRCode]:\
    @"/user/qr_code", \
    [NSNumber numberWithInteger:kAPITrack]:\
    @"/user/statistics", \
    [NSNumber numberWithInteger:kAPIVersionUpdate]:\
    @"/manage/version", \
    [NSNumber numberWithInteger:kAPIRecommandAd]:\
    @"/manage/advertising", \
    [NSNumber numberWithInteger:kAPIVersionConfig]:\
    @"/manage/induce_config", \
    [NSNumber numberWithInteger:kAPIDeviceToken]:\
    @"/user/add_device_token", \
    [NSNumber numberWithInteger:kAPICountrySublines]:\
    @"/node/country", \
    [NSNumber numberWithInteger:kAPIConnectRecord]:\
    @"/report/connect", \
    [NSNumber numberWithInteger:kAPIFeedBackPing]:\
    @"/report/ping"}


// 请求状态码
typedef NS_ENUM(NSInteger, HttpStatusCode) {
    // 无效请求
    kHttpStatusCodeInviald = -1,
    // 正常请求
    kHttpStatusCode200 = 200,
    // 正常请求，订阅状态发生改变
    kHttpStatusCode201 = 201,
    kHttpStatusCode400 = 400,
    kHttpStatusCode404 = 404,
};

// 会员类型
typedef NS_ENUM(NSInteger, VIPType) {
    kVIPTypeNone  = -1,
    kVIPTypeTrial = 1,
    kVIPTypeVIP   = 2
};

// 推广订阅的名称
#define Month_Subscribe_Name_Free @"com.supernofree.30"
#define Month_Subscribe_Name @"com.superoversea.30"
#define Quarter_Subscribe_Name @"com.superoversea.90"
#define HalfYear_Subscribe_Name @"com.superoversea.180"
#define Year_Subscribe_Name_Free @"com.supernofree.360"
#define Year_Subscribe_Name @"com.superoversea.360"
#define Week_Subscribe_Name @"com.superoverseaman.7"


#define Month_Subscribe_Price @"$9.99"
#define Quarter_Subscribe_Price @"$29.99"
#define HalfYear_Subscribe_Price  @"$59.99"
#define Year_Subscribe_Price @"$39.99"
#define Week_Subscribe_Price @"$4.99"


#define Month_Subscribe_Price_Value 9.99
#define Quarter_Subscribe_Price_Value  29.99
#define HalfYear_Subscribe_Price_Value 59.99
#define Year_Subscribe_Price_Value  39.99
#define Week_Subscribe_Price_Value 4.99

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - UserDefaults 键

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - 自定义常量
////////////////////////////////////////////////////////////////////////////////////////////////////
// 加载框延迟关闭时间
#define HUDDISMISSTIME 1.5

#pragma mark - 提示信息

static NSString * const kNoticeNetworkConnectError = @"服务器连接异常";
static NSString * const kNoticeLoginFailed         = @"登录失败";

////////////////////////////////////////////////////////////////////////////////////////////////////

#endif /* AppConstant_h */
