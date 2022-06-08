//
//  STTrafficMeter.m
//  acc
//
//  Created by one on 2019/11/19.
//  Copyright © 2019 one. All rights reserved.
//
#import "STTrafficMeter.h"
#include <arpa/inet.h>
#include <net/if.h>
#include <ifaddrs.h>
#include <net/if_dl.h>

static long startStatus = 0;
static long trafficThisTime = 0;
static int const monitorDuration = 10;
static NSString *const TOTAL_TRAFFIC_KEY = @"TOTAL_TRAFFIC_KEY";

@implementation STTrafficMeter


//获取当前总流量
+ (long)getTotalTraffic {
    BOOL success;
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    const struct if_data *networkStatisc;
    long WiFiSent = 0;
    long WiFiReceived = 0;
    long WWANSent = 0;
    long WWANReceived = 0;
    NSString *name=[[NSString alloc]init];
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != NULL) {
            name=[NSString stringWithFormat:@"%s",cursor->ifa_name];
            
            if (cursor->ifa_addr->sa_family == AF_LINK) {
                //wifi消耗流量
                if ([name hasPrefix:@"en"]) {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WiFiSent+=networkStatisc->ifi_obytes;
                    WiFiReceived+=networkStatisc->ifi_ibytes;
                }
                
                //移动网络消耗流量
                if ([name hasPrefix:@"pdp_ip0"]) {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WWANSent+=networkStatisc->ifi_obytes;
                    WWANReceived+=networkStatisc->ifi_ibytes;
                }
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return WiFiSent + WiFiReceived + WWANSent + WWANReceived;
}

//开始记录流量使用
+ (void)startRecordTraffic {
    startStatus = [self getTotalTraffic];
    NSLog(@"~~~starting status: %ld", startStatus);
    [self repeatRecord];
}

//循环记录
+ (void)repeatRecord {
    if (!startStatus) {
        return;
    }
    [self record];
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (monitorDuration*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self repeatRecord];
        });
    }];
}

+ (void)record {
    long end = [self getTotalTraffic];
    long single = end - startStatus;
    if (!startStatus || !end || (end < startStatus)) {
        NSLog(@"~~~~end recording");
        return;
    }
    startStatus = end;
    trafficThisTime += single;
    long total = [[NSUserDefaults standardUserDefaults] integerForKey:TOTAL_TRAFFIC_KEY];
    total += single;
    [[NSUserDefaults standardUserDefaults] setInteger:total forKey:TOTAL_TRAFFIC_KEY];
    NSLog(@"~~~~traffic per duration:%ld,trafficThisTime:%ld, total:%ld",single, trafficThisTime,total);
}

//停止记录流量并返回单次使用流量数
+ (long)stopRecordTraffic {
    [self record];

    long thisTime = trafficThisTime;
    trafficThisTime = 0;
    startStatus = 0;
    NSLog(@"~~~~this time: %ld", thisTime);
    return thisTime;
}

//获取记录流量的总数
+ (long)getTotalRecordedTraffic {
    return [[NSUserDefaults standardUserDefaults] integerForKey:TOTAL_TRAFFIC_KEY];
}

//记录数据清零
+ (void)clearRecordedTraffic {
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:TOTAL_TRAFFIC_KEY];
}

@end
