//
//  SSNodeResultModel.h
//  vpn
//
//  Created by hzg on 2021/1/11.
//

#import "QDBaseResultModel.h"
#import "QDSSNodeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QDSSNodeResultModel : QDBaseResultModel

@property(nonatomic, strong) QDSSNodeModel* data;

@end

NS_ASSUME_NONNULL_END
