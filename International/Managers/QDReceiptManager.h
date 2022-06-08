//
//  ReceiptHelper.h
//  vpn
//
//  Created by hzg on 2020/12/31.
//

#import <Foundation/Foundation.h>
#import "QDReceiptModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface QDReceiptManager : NSObject

+ (QDReceiptManager *) shared;

// 本地化价格表
@property (nonatomic, strong) NSMutableDictionary* localPriceDictionary;

// 更新产品信息
- (void) updateProduct:(NSArray<NSString*>*)productIds completion:(void(^)(void)) completion;

// 请求确认产品信息
- (void) requestVerifyProduct:(NSArray<NSString*>*)productIds completion:(void(^)(NSArray* arr)) completion;

// 交易
- (void) transaction_new:(NSString*)productId completion:(void(^)(BOOL success)) completion;

// 交易
- (void) transaction:(NSString*)productId completion:(void(^)(BOOL success)) completion;

// 恢复交易
- (void) restore:(void(^)(BOOL success)) completion;

@end

NS_ASSUME_NONNULL_END
