//
//  PageBaseRequestModel.h
//  vpn
//
//  Created by hzg on 2020/12/30.
//

#import "QDBaseRequestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QDPageBaseRequestModel : QDBaseRequestModel

// 当前页码，从1开始
@property(nonatomic, copy) NSString* package_id;

// 当前页码，从1开始
@property(nonatomic, assign) int page;

// 每页请求大小，默认10
@property(nonatomic, assign) int size;

@end

NS_ASSUME_NONNULL_END
