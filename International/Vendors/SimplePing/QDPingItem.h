//
//  QDPingItem.h
//  International
//
//  Created by LC on 2022/6/21.
//  Copyright © 2022 com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NENSinglePingStatus) {
    NENSinglePingStatusDidStart,
    NENSinglePingStatusDidFailToSendPacket,
    NENSinglePingStatusDidReceivePacket,
    NENSinglePingStatusDidReceiveUnexpectedPacket,
    NENSinglePingStatusDidTimeOut,
    NENSinglePingStatusDidError,
    NENSinglePingStatusDidFinished,
};

NS_ASSUME_NONNULL_BEGIN

@interface QDPingItem : NSObject

/// 主机名
@property (nonatomic, copy) NSString *hostName;
/// 单次耗时
@property (nonatomic, assign) double millSecondsDelay;
/// 当前ping状态
@property (nonatomic, assign) NENSinglePingStatus status;

@end

NS_ASSUME_NONNULL_END
