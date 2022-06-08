//
//  QDTimerManager.h
//  International
//
//  Created by LC on 2022/4/26.
//  Copyright © 2022 com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HomeTimeCallBack) (NSInteger);

typedef void (^ConnectedCallBack) (NSInteger);

NS_ASSUME_NONNULL_BEGIN

@interface QDTimerManager : NSObject

+ (QDTimerManager *) shared;

- (void)stopTimer;

@property (nonatomic, copy) HomeTimeCallBack callBack;
@property (nonatomic, copy) ConnectedCallBack connectedCallBack;

@property (nonatomic, assign) NSInteger timeValue;
@property (nonatomic, assign) NSInteger connectedTimeValue;

@property (nonatomic, assign) BOOL startConnectTimer;

- (void)clearTime1;
- (void)clearTime;

@end

NS_ASSUME_NONNULL_END
