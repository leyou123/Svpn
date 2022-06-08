//
//  ModelHelper.m
//  vpn
//
//  Created by hzg on 2020/12/17.
//

#import "QDModelManager.h"
#import "QDBaseRequestModel.h"
#import "QDLoginRequestModel.h"
#import "QDOrderRequestModel.h"
#import "QDQuestionRequestModel.h"
#import "QDPageBaseRequestModel.h"
#import "QDSSNodeRequestModel.h"
#import "QDQrcodeRequestModel.h"
#import <NSString+Base64.h>
#import "AESCipher.h"
#import "QDProductRequestModel.h"
#import "QDRestoreOrdersRequestModel.h"
#import "QDAdvertisingResultModel.h"
#import "QDDeviceUtils.h"

@implementation QDModelManager

// 请求节点列表
+ (void) requestNodes:(void (^)(NSDictionary *dictionary)) completed {
    [[QDHTTPManager shared] request:HTTPMethodTypePost type:kAPITypeNodes parameters:@{@"uid":@(QDConfigManager.shared.UID), @"key":QDConfigManager.shared.key} completed:completed];
}

// 注册节点
+ (void) requestRegisterNode:(NSString*)nodeIP completed:(void (^)(NSDictionary *dictionary)) completed {
    [[QDHTTPManager shared] request:HTTPMethodTypePost type:kAPITypeNodeRegister parameters:@{
        @"uid":@(QDConfigManager.shared.UID),
        @"uuid":QDConfigManager.shared.UUID,
        @"ip":nodeIP,
        @"key":QDConfigManager.shared.key
    } completed:completed];
}

// 获取用户信息
+ (void) requestUserInfo:(void (^)(NSDictionary *dictionary)) completed {
    // 用户名&密码登录
    if (QDConfigManager.shared.email
        &&![QDConfigManager.shared.email isEqual:@""]
        && QDConfigManager.shared.password
        &&![QDConfigManager.shared.password isEqual:@""]) {
        [QDModelManager requestLoginByEmail:QDConfigManager.shared.email password:QDConfigManager.shared.password completed:^(NSDictionary * _Nonnull dictionary) {
//            [self responseRequestUserInfo:NO result:dictionary];
        }];
    }
}

// 用户注册
+ (void) requestRegister:(void (^)(NSDictionary *dictionary)) completed {
    [[QDHTTPManager shared] request:HTTPMethodTypePost type:kAPITypeUserRegister parameters:@{
        @"uuid":QDConfigManager.shared.UUID,
        @"package_id":APP_BUNDLE_ID,
        @"platform_id":APP_PLATFORM_ID,
        @"key":QDConfigManager.shared.key} completed:completed];
}

// TODO: uid登录 待更新
+ (void) requestLoginByUid:(void (^)(NSDictionary *dictionary)) completed {
    [[QDHTTPManager shared] request:HTTPMethodTypePost type:kAPITypeUserLogin parameters:@{
        @"key":QDConfigManager.shared.key,
        @"uuid":QDConfigManager.shared.UUID,
        @"uid":@(QDConfigManager.shared.UID),
        @"platform_id":APP_PLATFORM_ID,
        @"package_id":APP_BUNDLE_ID} completed:completed];
}

// TODO: 邮箱登录 待更新
+ (void) requestLoginByEmail:(NSString*)email password:(NSString*)password completed:(void (^)(NSDictionary *dictionary)) completed {
    [[QDHTTPManager shared] request:HTTPMethodTypePost type:kAPITypeUserLogin parameters:@{
        @"email":email,
        @"password":password,
        @"key":QDConfigManager.shared.key,
        @"uuid":QDConfigManager.shared.UUID,
        @"platform_id":APP_PLATFORM_ID,
        @"package_id":APP_BUNDLE_ID} completed:completed];
}

+ (void) requestLoginByEmailAndUnbind:(long)unbundling_uid email:(NSString*)email password:(NSString*)password completed:(void (^)(NSDictionary *dictionary)) completed {
    [[QDHTTPManager shared] request:HTTPMethodTypePost type:kAPITypeUserLogin parameters:@{
        @"email":email,
        @"password":password,
        @"key":QDConfigManager.shared.key,
        @"uuid":QDConfigManager.shared.UUID,
        @"platform_id":APP_PLATFORM_ID,
        @"package_id":APP_BUNDLE_ID,
        @"unbundling_uid":@(unbundling_uid),
        @"unbundling_uuid":QDConfigManager.shared.UUID,
    } completed:completed];
}

// 请求加时长
+ (void) requestUserAddTime:(int)type completed:(void (^)(NSDictionary *dictionary)) completed {
    [[QDHTTPManager shared] request:HTTPMethodTypePost type:kAPITypeUserAddTime parameters:@{
        @"key":QDConfigManager.shared.key,
        @"uid":@(QDConfigManager.shared.UID),
        @"time_type":@(type)} completed:completed];
}

// 请求验证码(绑定邮箱/忘记密码) type: 类型 1.绑定邮箱 2.忘记密码
+ (void) requestEmailCode:(NSString*)email type:(int)type completed:(void (^)(NSDictionary *dictionary)) completed {
    [[QDHTTPManager shared] request:HTTPMethodTypePost type:kAPITypeSendEmailCode parameters:@{
        @"key":QDConfigManager.shared.key,
        @"uid":@(QDConfigManager.shared.UID),
        @"package_id":APP_BUNDLE_ID,
        @"platform_id":APP_PLATFORM_ID,
        @"email":email,
        @"email_type":@(type)} completed:completed];
}

// 验证CODE type: 类型 1.配置新密码 2.忘记密码
+ (void) requestVerifyEmailCode:(NSString*)code type:(int)type completed:(void (^)(NSDictionary *dictionary)) completed {
    [[QDHTTPManager shared] request:HTTPMethodTypePost type:kAPITypeVerifyCode parameters:@{
        @"key":QDConfigManager.shared.key,
        @"uid":@(QDConfigManager.shared.UID),
        @"code":code,
        @"package_id":APP_BUNDLE_ID,
        @"verify_type":@(type)} completed:completed];
}

// 更新密码 type: 类型 1.配置新密码 2.忘记密码 3.修改密码
+ (void) requestUpdatePassword: (NSString*)password type:(int)type completed:(void (^)(NSDictionary *dictionary)) completed {
    [[QDHTTPManager shared] request:HTTPMethodTypePost type:kAPITypeUpdatePassword parameters:@{
        @"key":QDConfigManager.shared.key,
        @"uid":@(QDConfigManager.shared.UID),
        @"password":password,
        @"package_id":APP_BUNDLE_ID,
        @"password_type":@(type)} completed:completed];
}

// 解绑
+ (void) requestDeleteDevice:(void (^)(NSDictionary *dictionary)) completed {
    [[QDHTTPManager shared] request:HTTPMethodTypePost type:kAPITypeDeleteDevice parameters:@{
        @"key":QDConfigManager.shared.key,
        @"uid":@(QDConfigManager.shared.UID),
        @"uuid":QDConfigManager.shared.UUID,
        @"package_id":APP_BUNDLE_ID,
        } completed:completed];
}

// 登出
+ (void) requestLogout:(void (^)(NSDictionary *dictionary)) completed {
    [[QDHTTPManager shared] request:HTTPMethodTypePost type:kAPITypeLogout parameters:@{
        @"key":QDConfigManager.shared.key,
        @"uid":@(QDConfigManager.shared.UID),
        @"uuid":QDConfigManager.shared.UUID,
        @"package_id":APP_BUNDLE_ID,
        } completed:completed];
}

// 解绑邮箱
+ (void) requestUnbind:(NSString*)password completed:(void (^)(NSDictionary *dictionary)) completed {
    [[QDHTTPManager shared] request:HTTPMethodTypePost type:kAPITypeUnbind parameters:@{
        @"key":QDConfigManager.shared.key,
        @"uid":@(QDConfigManager.shared.UID),
        @"email":QDConfigManager.shared.activeModel.email,
        @"password":password,
        @"uuid":QDConfigManager.shared.UUID,
        @"platform_id":APP_PLATFORM_ID,
        } completed:completed];
}

// 请求创建订单信息
+ (void) requestCreateOrder:(NSString*)money money_unit:(NSString*)money_unit transaction_id:(NSString*)transaction_id completed:(void (^)(NSDictionary *dictionary)) completed {
    
    NSString* receipt = [self base64receipt];
    if (!receipt || [receipt isEqual:@""] || QDConfigManager.shared.UID == -1) {
        completed(@{@"code":@(kHttpStatusCode400)});
        return;
    }
    
    if (!transaction_id) {
        completed(@{@"code":@(kHttpStatusCode400)});
        return;
    }
    
    NSString* version = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
    [[QDHTTPManager shared] request:HTTPMethodTypePost type:kApiTypeCreateOrder parameters:@{
        @"uid":@(QDConfigManager.shared.UID),
        @"uuid":QDConfigManager.shared.UUID,
        @"receipt_data": receipt,
        @"transaction_id":transaction_id,
        @"package_id":APP_BUNDLE_ID,
        @"version":version} completed:completed];
}

// 请求恢复订单信息
+ (void) requestRestoreOrders:(void (^)(NSDictionary *dictionary)) completed {
    
    NSString* receipt = [self base64receipt];
    if (!receipt || [receipt isEqual:@""]) {
        completed(@{@"code":@(kHttpStatusCode400)});
        return;
    }
    
    NSString* version = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
    [[QDHTTPManager shared] request:HTTPMethodTypePost type:kApiTypeRestoreOrders parameters:@{
        @"uid":@(QDConfigManager.shared.UID),
        @"uuid":QDConfigManager.shared.UUID,
        @"receipt_data": receipt,
        @"package_id":APP_BUNDLE_ID,
        @"version":version} completed:completed];
}

// 票据
+ (NSString *)base64receipt {
    NSData *receiptData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
    return [NSString base64StringFromData:receiptData length:[receiptData length]];
}

// 请求订单记录信息
+ (void) requestPurchaseRecords:(int)page completed:(void (^)(NSDictionary *dictionary)) completed {
    QDPageBaseRequestModel* requestModel = [[QDPageBaseRequestModel alloc] init];
    requestModel.uid = QDConfigManager.shared.UID;
    requestModel.package_id = APP_BUNDLE_ID;
    requestModel.page   = page;
    // 默认10
    requestModel.size   = 10;
    [[QDHTTPManager shared] request:HTTPMethodTypePost type:kApiTypeOrders parameters:requestModel.mj_keyValues completed:completed];
}

+ (void) requestRecommandAd:(void (^)(NSDictionary *dictionary)) completed {
    [[QDHTTPManager shared] request:HTTPMethodTypePost type:kAPIRecommandAd parameters:@{@"package_id":APP_BUNDLE_ID} completed:completed];
}

// 请求版本信息
+ (void) requestVersionInfo:(void (^)(NSDictionary *dictionary)) completed {
    [[QDHTTPManager shared] request:HTTPMethodTypePost type:kAPIVersionUpdate parameters:@{@"package_id":APP_BUNDLE_ID} completed:completed];
}

// 请求版本配置
+ (void) requestVersionConfig:(void (^)(NSDictionary *dictionary)) completed {
    NSString* version = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
    [[QDHTTPManager shared] request:HTTPMethodTypePost type:kAPIVersionConfig parameters:@{@"package_id":APP_BUNDLE_ID, @"version":version} completed:completed];
}

// 兑换奖励
+ (void) requestRedeemReward:(NSString*)code completed:(void (^)(NSDictionary *dictionary)) completed {
    [[QDHTTPManager shared] request:HTTPMethodTypePost type:kAPITypeUserRedeemReward parameters:@{
        @"key":QDConfigManager.shared.key,
        @"uid":@(QDConfigManager.shared.UID),
        @"code":code,
        @"package_id":APP_BUNDLE_ID} completed:completed];
}

// 扫码绑定
+ (void) requestScanCodeLogin:(NSString*)code uuid:(NSString*)uuid package_id:(NSString*)package_id completed:(void (^)(NSDictionary *dictionary)) completed {
    [[QDHTTPManager shared] request:HTTPMethodTypePost type:kAPITypeUserScanCode parameters:@{
        @"code":code,
        @"uuid":uuid,
        @"uid":@(QDConfigManager.shared.UID),
        @"package_id":package_id} completed:completed];
}

// 反馈
+ (void) requestFeedback:(NSString*)type email:(NSString*)email content:(NSString*)content completed:(void (^)(NSDictionary *dictionary)) completed {
    [[QDHTTPManager shared] request:HTTPMethodTypePost type:kAPITypeFeekBack parameters:@{
        @"key":QDConfigManager.shared.key,
        @"uid":@(QDConfigManager.shared.UID),
        @"email":email,
        @"content":content,
        @"type":type} completed:completed];
}

// 请求增加用户时间(NEW)
+ (void) requestUserAddTimeNew:(int)type time:(int)time completed:(void (^)(NSDictionary *dictionary)) completed {
    NSDictionary * dic = @{
        @"uid":@(QDConfigManager.shared.UID),
        @"key":QDConfigManager.shared.key,
        @"time":@(time),
        @"vip_type":@(type)};
    [[QDHTTPManager shared] request:HTTPMethodTypePost type:kAPITypeUserAddTimeNew parameters:@{
        @"uid":@(QDConfigManager.shared.UID),
        @"key":QDConfigManager.shared.key,
        @"time":@(time),
        @"vip_type":@(type)} completed:completed];
}

// 添加推送Token
+ (void) requestAddDeviceToken:(NSString*)token completed:(void (^)(NSDictionary *dictionary)) completed {
    if (!token) {
        completed(@{@"code":@(kHttpStatusCode400)});
        return;
    }
    [[QDHTTPManager shared] request:HTTPMethodTypePost type:kAPIDeviceToken parameters:@{
        @"uuid":QDConfigManager.shared.UUID,
        @"key":QDConfigManager.shared.key,
        @"device_token":token} completed:completed];
}

// 请求国家下的线路
+ (void) requestCountrySublinesCountry:(NSString *)country completed:(void (^)(NSDictionary *dictionary)) completed {
    [[QDHTTPManager shared] request:HTTPMethodTypePost type:kAPICountrySublines parameters:@{
        @"uid":@(QDConfigManager.shared.UID),
        @"key":QDConfigManager.shared.key,
        @"country":country} completed:completed];
}

// 连接记录
+ (void) requestConnectRecord:(NSString *)time pingResult:(BOOL)ping connectResult:(BOOL)connect completed:(void (^)(NSDictionary *dictionary)) completed {
    [[QDHTTPManager shared] request:HTTPMethodTypePost type:kAPIConnectRecord parameters:@{
        @"uuid":QDConfigManager.shared.UUID,
        @"node_ip":QDConfigManager.shared.node.ip,
        @"node_name":QDConfigManager.shared.node.name,
        @"ping_result":@(ping),
        @"connect_result":@(connect),
        @"connect_time":time,
        @"dev_name":[QDDeviceUtils platformString],
        @"network":[QDDeviceUtils deviceNetWork],
        @"operator":[QDDeviceUtils getCarrierInfo]
    } completed:completed];
}

// ping反馈
+ (void) requestFeedBackPing:(NSDictionary *)list Completed:(void (^)(NSDictionary *dictionary)) completed {
    [[QDHTTPManager shared] request:HTTPMethodTypePost type:kAPIFeedBackPing parameters:list completed:completed];
}


@end
