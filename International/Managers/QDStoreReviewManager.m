//
//  QDStoreReviewManager.m
//  International
//
//  Created by hzg on 2021/8/24.
//  Copyright © 2021 com. All rights reserved.
//

#import "QDStoreReviewManager.h"

static NSString *const kReviewTimeKey = @"key_review_time";
static NSInteger IntervalTime = 1 * 24 * 60 * 60;

@interface QDStoreReviewManager()

@property(nonatomic, assign) NSTimeInterval lastShowTimestamp;

@end

@implementation QDStoreReviewManager

+ (QDStoreReviewManager *) shared {
    static dispatch_once_t onceToken;
    static QDStoreReviewManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [QDStoreReviewManager new];
        [instance setup];
    });
    return instance;
}

- (void) setup {
    self.lastShowTimestamp = [[NSUserDefaults standardUserDefaults] integerForKey:kReviewTimeKey];
    if (self.lastShowTimestamp < 0) self.lastShowTimestamp = 0;
}

- (void) show {
    NSTimeInterval currentTimestamp = [[NSDate date] timeIntervalSince1970];
    if (self.lastShowTimestamp == 0) self.lastShowTimestamp = currentTimestamp;
    if (currentTimestamp - self.lastShowTimestamp < IntervalTime) {
        return;
    }
    if (@available(iOS 10.3, *)) {
        [SKStoreReviewController requestReview];
    } else {
        // Fallback on earlier versions
    }
}

@end
