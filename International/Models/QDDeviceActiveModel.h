//
//  DeviceActiveModel.h
//  vpn
//
//  Created by hzg on 2020/12/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QDDeviceActiveModel : NSObject

@property(nonatomic, assign) long uid;
@property(nonatomic, assign) long member_validity_time;

// 套餐等级 1 月套餐 2 季度套餐 3 半年套餐 4 一年套餐
@property(nonatomic, copy) NSString* set_meal;

// 1 正式会员 2 赠送会员 3 非会员
@property(nonatomic, assign) int member_type;

//0 正常 1 拦截
@property(nonatomic, assign) int white_type;

// 是否订阅 0表示否  1表示是
@property(nonatomic, assign) int subscription;
// 订阅状态 0表示否  1表示是
@property(nonatomic, assign) int subscription_status;
// 剩余广告次数
@property(nonatomic, assign) int adv_count;

@property(nonatomic, assign) int device_count;
@property(nonatomic, assign) int max_device_count;
// 邮箱
@property(nonatomic, copy) NSString* email;

// 分享码
@property(nonatomic, copy) NSString* code;

@end

NS_ASSUME_NONNULL_END
