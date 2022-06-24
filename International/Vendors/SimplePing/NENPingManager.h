//
//  NENPingManager.h
//  NENPingDemo
//
//  Created by minihao on 2019/1/4.
//  Copyright © 2019 minihao. All rights reserved.
//

#import "NENSinglePinger.h"

@interface NENAddressItem : NSObject

@property (nonatomic, copy, readonly) NSString * _Nonnull hostName;
/// average delay time
@property (nonatomic, assign, readonly) double delayMillSeconds;

@property (nonatomic, strong) NSMutableArray * _Nullable delayTimes;

- (instancetype _Nonnull )initWithHostName:(NSString *_Nullable)hostName;

@end

typedef void(^CompletionHandler)(NSString *_Nonnull, NSArray *_Nullable);

NS_ASSUME_NONNULL_BEGIN

@interface NENPingManager : NSObject

- (void)getFatestAddress:(NSArray *)addressList requestTimes:(int)times completionHandler:(CompletionHandler)completionHandler;

- (void)stopAllPing;

@end

NS_ASSUME_NONNULL_END
