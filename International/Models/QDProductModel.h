//
//  ProductModel.h
//  vpn
//
//  Created by hzg on 2020/12/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QDProductModel : NSObject

@property(nonatomic, copy) NSString* name;
@property(nonatomic, assign) float money;
@property(nonatomic, copy) NSString* goods;
@property(nonatomic, assign) int goods_type;

// 价格
@property(nonatomic, copy) NSString* price;
// 货币符号
@property(nonatomic, copy) NSString* currencySymbol;


@end

NS_ASSUME_NONNULL_END
