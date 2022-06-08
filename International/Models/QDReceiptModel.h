//
//  ReceiptModel.h
//  vpn
//
//  Created by hzg on 2020/12/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QDReceiptModel : NSObject

// 商品id
@property(nonatomic, copy) NSString* productId;
// 交易id
@property(nonatomic, copy) NSString* transactionIdentifier;

// 交易处理状态 0未处理 1处理中 2已处理
@property(nonatomic, assign) NSInteger status;

// 处理消息
@property(nonatomic, copy) NSString* message;

@end

NS_ASSUME_NONNULL_END
