//
//  QDActivityManager.h
//  International
//
//  Created by hzg on 2022/1/17.
//  Copyright © 2022 com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QDActivityResultModel.h"

@interface QDActivityManager : NSObject

+ (QDActivityManager *) shared;

// 检查0点时间
- (void) checkZeroTime;

// 活动配置
@property(nonatomic, strong) QDActivityResultModel* activityResultModel;

- (void) watchAdComplete;
- (void) bindEmailComplete;

@end

