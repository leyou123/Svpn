//
//  QDActivityManager.m
//  International
//
//  Created by hzg on 2022/1/17.
//  Copyright © 2022 com. All rights reserved.
//



#import "QDActivityManager.h"
#import "QDDateUtils.h"

#define kActivityKey  @"key_activity"
#define MAX_WATCHAD_TIMES  10


@implementation QDActivityManager

+ (QDActivityManager *) shared {
    static dispatch_once_t onceToken;
    static QDActivityManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [QDActivityManager new];
        [instance setup];
    });
    return instance;
}

- (void) setup {
    
    NSString* activityContent = [[NSUserDefaults standardUserDefaults] stringForKey:kActivityKey];
    
    if (activityContent) {
        self.activityResultModel = [QDActivityResultModel mj_objectWithKeyValues:[activityContent mj_JSONObject]];
    }
    
    // 检查0点时间
    [self checkZeroTime];
    
}

// 检查0点时间
- (void) checkZeroTime {
    long zeroTimestamp = [QDDateUtils getLocalZeroTimestamp];
    if (self.activityResultModel) {
    
        
        // 是否需要清零数据（每日数据清零）
        BOOL isNeedClearData = zeroTimestamp != self.activityResultModel.todayZeroTime;

        if (isNeedClearData) {
            
            // 今日数据清零
            self.activityResultModel.todayZeroTime = zeroTimestamp;
            
            // 最大广告
            self.activityResultModel.watchAdTimes = QDConfigManager.shared.activeModel.adv_count ? QDConfigManager.shared.activeModel.adv_count : MAX_WATCHAD_TIMES;
            
            // 更新数据
            [self saveToLocal];
        }
        
    } else {
        self.activityResultModel = [QDActivityResultModel mj_objectWithKeyValues:@{
            @"todayZeroTime":@(zeroTimestamp),
            @"isBindEmail":@(NO),
            @"watchAdTimes":@(QDConfigManager.shared.activeModel.adv_count ? QDConfigManager.shared.activeModel.adv_count : MAX_WATCHAD_TIMES)}];
    }
}


// 序列化存储
- (void) saveToLocal {
    if (!self.activityResultModel) return;
    
    [[NSUserDefaults standardUserDefaults] setValue:[self.activityResultModel mj_JSONString]  forKey:kActivityKey];
    
    // 通知数据更新
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationActivityUpdate object:nil];
}

- (void) watchAdComplete {
    if (!self.activityResultModel) return;
    self.activityResultModel.watchAdTimes -= 1;
    if (self.activityResultModel.watchAdTimes < 0) self.activityResultModel.watchAdTimes = 0;
    [self saveToLocal];
}

- (void) bindEmailComplete {
    if (!self.activityResultModel) return;
    self.activityResultModel.isBindEmail = YES;
    [self saveToLocal];
}

@end
