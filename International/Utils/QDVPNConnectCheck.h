//
//  QDVPNConnectCheck.h
//  International
//
//  Created by hzg on 2021/7/14.
//  Copyright © 2021 com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QDVPNConnectCheck : NSObject

+ (void) canConnect:(NSString*)testUrl completed:(void (^)(BOOL result)) completed;

+ (NSString *)getDeviceIPAddresses;

+ (BOOL)isVPNOn;

@end

NS_ASSUME_NONNULL_END
