//
//  HostNodeRequestModel.h
//  vpn
//
//  Created by hzg on 2021/1/11.
//

#import "QDBaseRequestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QDSSNodeRequestModel : QDBaseRequestModel

// 主机地址
@property(nonatomic, copy) NSString* host;

@end

NS_ASSUME_NONNULL_END
