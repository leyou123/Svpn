//
//  QDSuperPingManager.h
//  International
//
//  Created by LC on 2022/6/21.
//  Copyright © 2022 com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CompletionHandler)(NSString *_Nonnull, NSArray *_Nullable);
NS_ASSUME_NONNULL_BEGIN

@interface QDSuperPingManager : NSObject

- (void)getFatestAddress:(NSArray *)addressList requestTimes:(int)times completionHandler:(CompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
