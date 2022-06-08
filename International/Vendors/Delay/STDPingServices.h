//
//  STDPingServices.h
//  SimplePingTest
//
//  Created by ZBO on 2019/4/8.
//  Copyright © 2019 zbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "STSimplePing.h"

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, STDPingStatus) {
    STDPingStatusDidStart,
    STDPingStatusDidFailToSendPacket,
    STDPingStatusDidReceivePacket,
    STDPingStatusDidReceiveUnexpectedPacket,
    STDPingStatusDidTimeout,
    STDPingStatusError,
    STDPingStatusFinished,
};

@interface STDPingItem : NSObject

@property(nonatomic) NSString *originalAddress;
@property(nonatomic, copy) NSString *IPAddress;

@property(nonatomic) NSUInteger dateBytesLength;
@property(nonatomic) double     timeMilliseconds;
@property(nonatomic) NSInteger  timeToLive;
@property(nonatomic) NSInteger  ICMPSequence;

@property(nonatomic) STDPingStatus status;

+ (NSString *)statisticsWithPingItems:(NSArray *)pingItems;

@end

@interface STDPingServices : NSObject

/// 超时时间, default 500ms
@property(nonatomic) double timeoutMilliseconds;

+ (void)startPingAddress:(NSString *)address
                      callbackHandler:(void(^)(STDPingItem *pingItem, NSArray *pingItems))handler;

@property(nonatomic) NSInteger  maximumPingTimes;

- (void)cancel;

@end


NS_ASSUME_NONNULL_END
