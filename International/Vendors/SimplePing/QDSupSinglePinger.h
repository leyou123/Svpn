//
//  QDSupSinglePinger.h
//  International
//
//  Created by LC on 2022/6/21.
//  Copyright © 2022 com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QDPingItem.h"

typedef void(^PingCallBack)(QDPingItem * _Nullable pingitem);

NS_ASSUME_NONNULL_BEGIN

@interface QDSupSinglePinger : NSObject

+ (instancetype)startWithHostName:(NSString *)hostName count:(NSInteger)count pingCallBack:(PingCallBack)pingCallBack;

- (instancetype)initWithHostName:(NSString *)hostName count:(NSInteger)count pingCallBack:(PingCallBack)pingCallBack;

@end

NS_ASSUME_NONNULL_END
