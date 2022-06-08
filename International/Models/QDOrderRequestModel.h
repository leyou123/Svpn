//
//  OrderRequestModel.h
//  vpn
//
//  Created by hzg on 2020/12/28.
//

#import "QDBaseRequestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QDOrderRequestModel : QDBaseRequestModel

// 版本号
@property(nonatomic, copy) NSString* version;

// 订单金额
@property(nonatomic, copy) NSString* money;

// 金额单位
@property(nonatomic, copy) NSString* money_unit;

// 凭证
@property(nonatomic, copy) NSString* receipt_data;

// ios交易唯一凭证
@property(nonatomic, copy) NSString* transaction_id;

// package_id
@property(nonatomic, copy) NSString* package_id;

@end

NS_ASSUME_NONNULL_END
