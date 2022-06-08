//
//  YJLoginRequestModel.h
//  vpn
//
//  Created by hzg on 2021/4/12.
//

#import "QDBaseRequestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QDLoginRequestModel : QDBaseRequestModel

@property(nonatomic, strong) NSString* package_id;
@property(nonatomic, strong) NSString* key;
@property(nonatomic, assign) int device_type;
@property(nonatomic, strong) NSString* version;

@end

NS_ASSUME_NONNULL_END
