//
//  YJQrcodeRequestModel.h
//  vpn
//
//  Created by hzg on 2021/3/26.
//

#import "QDBaseRequestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QDQrcodeRequestModel : QDBaseRequestModel

@property(nonatomic, copy) NSString* code;
@property(nonatomic, copy) NSString* uuid;

@end

NS_ASSUME_NONNULL_END
