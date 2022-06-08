//
//  FFSimplePingHelper.h
//  SimplePingDemo
//
//  Created by wangzhe on 2019/2/18.
//  Copyright © 2019年 MoGuJie. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ResultBlock)(NSInteger);// 1成功 2失败
typedef void(^PingResultBlock)(long);

NS_ASSUME_NONNULL_BEGIN

@interface FFSimplePingHelper : NSObject

- (instancetype)initWithHostName:(NSString*)hostName;
@property(nonatomic, readonly) NSString *hostName;
- (void)startPing;
- (void)stopPing;
@property (nonatomic, copy) ResultBlock resultStatus;

@end

NS_ASSUME_NONNULL_END
