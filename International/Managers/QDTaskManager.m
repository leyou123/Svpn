//
//  QDTaskManager.m
//  International
//
//  Created by hzg on 2021/7/23.
//  Copyright © 2021 com. All rights reserved.
//

#import "QDTaskManager.h"

@interface QDTaskManager()

// 任务队列
@property(nonatomic, strong) NSMutableArray* taskArray;

@end

@implementation QDTaskManager

+ (QDTaskManager *) shared {
    static dispatch_once_t onceToken;
    static QDTaskManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [QDTaskManager new];
        [instance setup];
    });
    return instance;
}

- (void) setup {
    _taskArray = [NSMutableArray new];
}

- (void) add:(QDTaskType) taskType {
    [_taskArray addObject:QDTaskName[[NSNumber numberWithInteger:taskType]]];
    NSLog(@"task======>  %ld", taskType);
}

- (void) remove:(QDTaskType) taskType {
    [_taskArray removeObject:QDTaskName[[NSNumber numberWithInteger:taskType]]];
}

- (void) removeAll {
    [_taskArray removeAllObjects];
}

- (BOOL) hasTaskByType:(QDTaskType)taskType {
    NSString* taskName = QDTaskName[[NSNumber numberWithInteger:taskType]];
    for (NSString* name in self.taskArray) {
        if ([name isEqual:taskName]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL) hasTask {
    return self.taskArray.count > 0;
}

- (NSInteger) taskCount {
    return self.taskArray.count;
}

@end
