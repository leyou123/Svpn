//
//  ModelHelper.h
//  vpn
//
//  Created by hzg on 2020/12/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QDModelManager : NSObject

// 请求节点列表
+ (void) requestNodes:(void (^)(NSDictionary *dictionary)) completed;

// 注册节点
+ (void) requestRegisterNode:(NSString*)nodeIP completed:(void (^)(NSDictionary *dictionary)) completed;

// 获取用户信息
+ (void) requestUserInfo:(void (^)(NSDictionary *dictionary)) completed;

// 用户注册
+ (void) requestRegister:(void (^)(NSDictionary *dictionary)) completed;

// uid登录
+ (void) requestLoginByUid:(void (^)(NSDictionary *dictionary)) completed;

// 邮箱登录
+ (void) requestLoginByEmail:(NSString*)email password:(NSString*)password completed:(void (^)(NSDictionary *dictionary)) completed;

+ (void) requestLoginByEmailAndUnbind:(long)unbundling_uid email:(NSString*)email password:(NSString*)password completed:(void (^)(NSDictionary *dictionary)) completed;

// 请求加时长
+ (void) requestUserAddTime:(int)type completed:(void (^)(NSDictionary *dictionary)) completed;

// 请求验证码(绑定邮箱/忘记密码) type: 类型 1.绑定邮箱 2.忘记密码
+ (void) requestEmailCode:(NSString*)email type:(int)type completed:(void (^)(NSDictionary *dictionary)) completed;

// 验证CODE type: 类型 1.配置新密码 2.忘记密码
+ (void) requestVerifyEmailCode:(NSString*)code type:(int)type completed:(void (^)(NSDictionary *dictionary)) completed;

// 更新密码 type: 类型 1.配置新密码 2.忘记密码 3.修改密码
+ (void) requestUpdatePassword:(NSString*)password type:(int)type completed:(void (^)(NSDictionary *dictionary)) completed;

// 删除设备
+ (void) requestDeleteDevice:(void (^)(NSDictionary *dictionary)) completed;

// 登出
+ (void) requestLogout:(void (^)(NSDictionary *dictionary)) completed;

// 解绑邮箱
+ (void) requestUnbind:(NSString*)password completed:(void (^)(NSDictionary *dictionary)) completed;

// 请求创建订单信息
+ (void) requestCreateOrder:(NSString*)money money_unit:(NSString*)money_unit transaction_id:(NSString*)transaction_id completed:(void (^)(NSDictionary *dictionary)) completed;

// 请求恢复订单信息
+ (void) requestRestoreOrders:(void (^)(NSDictionary *dictionary)) completed;

// 请求订单记录信息
+ (void) requestPurchaseRecords:(int)page completed:(void (^)(NSDictionary *dictionary)) completed;

// 请求交易凭证
+ (NSString *)base64receipt;

// 请求recommand ad
+ (void) requestRecommandAd:(void (^)(NSDictionary *dictionary)) completed;

// 请求版本信息
+ (void) requestVersionInfo:(void (^)(NSDictionary *dictionary)) completed;

// 请求版本诱导配置
+ (void) requestVersionConfig:(void (^)(NSDictionary *dictionary)) completed;

+ (void) requestRedeemReward:(NSString*)code completed:(void (^)(NSDictionary *dictionary)) completed;

// 扫码绑定
+ (void) requestScanCodeLogin:(NSString*)code uuid:(NSString*)uuid package_id:(NSString*)package_id completed:(void (^)(NSDictionary *dictionary)) completed;

// 反馈
+ (void) requestFeedback:(NSString*)type email:(NSString*)email content:(NSString*)content completed:(void (^)(NSDictionary *dictionary)) completed;

// 请求增加用户时间(NEW)
+ (void) requestUserAddTimeNew:(int)type time:(int)time completed:(void (^)(NSDictionary *dictionary)) completed;

// 添加推送Token
+ (void) requestAddDeviceToken:(NSString*)token completed:(void (^)(NSDictionary *dictionary)) completed;

// 请求国家下的线路
+ (void) requestCountrySublinesCountry:(NSString *)country completed:(void (^)(NSDictionary *dictionary)) completed;

// 连接记录
+ (void) requestConnectRecord:(NSString *)time pingResult:(BOOL)ping connectResult:(BOOL)connect completed:(void (^)(NSDictionary *dictionary)) completed;

// ping反馈
+ (void) requestFeedBackPing:(NSDictionary *)list Completed:(void (^)(NSDictionary *dictionary)) completed;

@end

NS_ASSUME_NONNULL_END
