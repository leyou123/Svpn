//
//  QDVersionConfigResultModel.h
//  International
//
//  Created by hzg on 2021/6/29.
//  Copyright © 2021 com. All rights reserved.
//

#import "QDBaseResultModel.h"
#import "QDVersionConfigModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QDVersionConfigResultModel : QDBaseResultModel

@property(nonatomic, strong) QDVersionConfigModel* data;


@end

NS_ASSUME_NONNULL_END
