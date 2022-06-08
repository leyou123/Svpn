//
//  OrderRecordModel.h
//  vpn
//
//  Created by hzg on 2020/12/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QDOrderRecordModel : NSObject

// 套餐id
@property(nonatomic, copy) NSString* product_id;

// 套餐名称
@property(nonatomic, copy) NSString* product_name;

// 购买时间
@property(nonatomic, assign) long product_time;

// 购买价格
@property(nonatomic, copy) NSString* total_amount;

// 模版名字/cell使用
@property(nonatomic, copy) NSString* templateName;
@property(nonatomic, assign) BOOL showline;

@end

NS_ASSUME_NONNULL_END
