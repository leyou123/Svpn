//
//  STTrafficMeter.h
//  acc
//
//  Created by one on 2019/11/19.
//  Copyright © 2019 one. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface STTrafficMeter : NSObject
+ (void)startRecordTraffic;
+ (long)stopRecordTraffic;
+ (long)getTotalRecordedTraffic;
+ (void)clearRecordedTraffic;
@end

NS_ASSUME_NONNULL_END
