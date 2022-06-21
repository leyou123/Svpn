//
//  QDAddressItem.m
//  International
//
//  Created by LC on 2022/6/21.
//  Copyright © 2022 com. All rights reserved.
//

#import "QDAddressItem.h"

@interface QDAddressItem()

@property (nonatomic, copy, readwrite) NSString *hostName;
@property (nonatomic, assign, readwrite) double delayMillSeconds;

@end

@implementation QDAddressItem

- (instancetype)initWithHostName:(NSString *)hostName
{
    if (self = [super init]) {
        self.hostName = hostName;
        self.delayTimes = [NSMutableArray array];
    }
    return self;
}

- (double)delayMillSeconds
{
    if (self.delayTimes.count) {
        double allDelayTime = 0;
        for (NSNumber *delayTime in self.delayTimes) {
            allDelayTime += delayTime.doubleValue;
        }
        return allDelayTime / self.delayTimes.count;
    }
    return 1000.0;
}


@end
