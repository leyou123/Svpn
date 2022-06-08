//
//  CSLYRestoreOrdersRequestModel.h
//
//  Created by hzg on 2021/5/24.
//

#import "QDBaseRequestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QDRestoreOrdersRequestModel : QDBaseRequestModel

// 版本号
@property(nonatomic, copy) NSString* version;

// 凭证
@property(nonatomic, copy) NSString* receipt_data;

// 凭证
@property(nonatomic, copy) NSString* package_id;

@end

NS_ASSUME_NONNULL_END
