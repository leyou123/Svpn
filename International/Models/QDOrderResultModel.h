//
//  OrderResultModel.h
//  vpn
//
//  Created by hzg on 2020/12/28.
//

#import "QDBaseResultModel.h"
#import "QDOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QDOrderResultModel : QDBaseResultModel

@property(nonatomic, strong) QDOrderModel* data;

@end

NS_ASSUME_NONNULL_END
