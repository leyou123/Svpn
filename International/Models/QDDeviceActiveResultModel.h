//
//  DeviceActiveResultModel.h
//  vpn
//
//  Created by hzg on 2020/12/17.
//

#import "QDBaseResultModel.h"
#import "QDDeviceActiveModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QDDeviceActiveResultModel : QDBaseResultModel

@property(nonatomic, strong) QDDeviceActiveModel* data;

@end

NS_ASSUME_NONNULL_END
