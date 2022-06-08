//
//  QDLineSubViewController.h
//  International
//
//  Created by hzg on 2021/8/5.
//  Copyright © 2021 com. All rights reserved.
//

#import "QDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface QDLineSubViewController : QDBaseViewController

//传递过来已经组织好的数据（全量数据）
@property (nonatomic , strong) NSArray        *data;
@property (nonatomic , strong) NSString       *country;

@end

NS_ASSUME_NONNULL_END
