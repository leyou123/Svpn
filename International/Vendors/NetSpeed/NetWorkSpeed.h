//
//  NetWorkSpeed.h
//  International
//
//  Created by LC on 2022/6/8.
//  Copyright © 2022 com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const NetworkDownloadSpeedNotificationKey;

extern NSString *const NetworkUploadSpeedNotificationKey;

extern NSString *const NetworkSpeedNotificationKey;

@interface NetWorkSpeed : NSObject

@property (nonatomic, copy, readonly) NSString *downloadNetworkSpeed;

@property (nonatomic, copy, readonly) NSString *uploadNetworkSpeed;

- (void)startNetworkSpeedMonitor;

- (void)stopNetworkSpeedMonitor;

@end

NS_ASSUME_NONNULL_END
