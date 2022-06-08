//
//  QDTimerManager.m
//  International
//
//  Created by LC on 2022/4/26.
//  Copyright © 2022 com. All rights reserved.
//

#import "QDTimerManager.h"

@interface QDTimerManager()

@property (nonatomic, strong) NSTimer * timer;

@property (nonatomic, assign) NSTimeInterval timestamp;

@end

@implementation QDTimerManager

// 单例
+ (QDTimerManager *) shared {
    static dispatch_once_t onceToken;
    static QDTimerManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [QDTimerManager new];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerStart) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        self.timeValue = 0;
        self.connectedTimeValue = 0;
        [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(applicationDidEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void)timerStart {
    self.timeValue += 1;
    if (self.callBack) {
        self.callBack(self.timeValue);
    }
    if (self.connectedCallBack) {
        if (self.startConnectTimer) {
            if (self.connectedTimeValue > 100000) {
                self.connectedTimeValue = 0;
            }
            self.connectedTimeValue += 1;
            self.connectedCallBack(self.connectedTimeValue);
        }
    }
    
}

- (void)stopTimer {
    self.timeValue = 0;
    self.connectedTimeValue = 0;
    [self.timer invalidate];
    self.timer = nil;
}

- (void)clearTime1 {
    self.connectedTimeValue = 0;
}

- (void)clearTime {
    self.timeValue = 0;
}

- (void)applicationDidBecomeActive {
    if (self.startConnectTimer && _timestamp > 0) {
        NSTimeInterval timeInterval = [NSDate date].timeIntervalSince1970-_timestamp; //进行时间差计算操作
        NSLog(@"----------%f--------%ld",timeInterval,self.connectedTimeValue);
        if (timeInterval > 5) {
            timeInterval -= 5;
            self.connectedTimeValue += round(timeInterval);
        }
//        _timer.fireDate = [NSDate date];
        _timestamp = 0;
    }
}

- (void)applicationDidEnterBackground {
    if (self.startConnectTimer) {
        _timestamp = 0;
        _timestamp = [NSDate date].timeIntervalSince1970;
//        _timer.fireDate = [NSDate distantFuture];
    }
}

@end
