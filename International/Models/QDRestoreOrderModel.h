//
//  CSLYRestoreOrderModel.h
//
//  Created by hzg on 2021/5/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QDRestoreOrderModel : NSObject

// 订单金额
@property(nonatomic, copy) NSString* money;

// 金额单位
@property(nonatomic, copy) NSString* money_unit;

// ios交易唯一凭证
@property(nonatomic, copy) NSString* transaction_id;

@end

NS_ASSUME_NONNULL_END
