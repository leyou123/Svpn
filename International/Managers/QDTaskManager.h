//
//  QDTaskManager.h
//  International
//
//  Created by hzg on 2021/7/23.
//  Copyright © 2021 com. All rights reserved.
//

#import <Foundation/Foundation.h>

// 任务类型
typedef NS_ENUM(NSInteger, QDTaskType) {
    QDTaskTypeInstallConfig,  // 配置安装
    QDTaskTypeNodeRegister,   // 节点注册
    QDTaskTypeDisconnected,   // 断开
    QDTaskTypeConnected,      // 连接
    QDTaskTypeNodeVerifyCode  // 节点验证
};

// 任务名称
#define QDTaskName @{\
    [NSNumber numberWithInteger:QDTaskTypeInstallConfig]:@"TaskTypeInstallConfig",\
    [NSNumber numberWithInteger:QDTaskTypeNodeRegister]:@"TaskTypeNodeRegister",\
    [NSNumber numberWithInteger:QDTaskTypeDisconnected]:@"TaskDisconnected",\
    [NSNumber numberWithInteger:QDTaskTypeConnected]:@"TaskConnected",\
    [NSNumber numberWithInteger:QDTaskTypeNodeVerifyCode]:@"TaskTypeNodeVerifyCode"}

NS_ASSUME_NONNULL_BEGIN

@interface QDTaskManager : NSObject

+ (QDTaskManager *) shared;

- (void) add:(QDTaskType) taskType;
- (NSInteger) taskCount;
- (void) remove:(QDTaskType) taskType;
- (void) removeAll;
- (BOOL) hasTaskByType:(QDTaskType) taskType;
- (BOOL) hasTask;

@end

NS_ASSUME_NONNULL_END
