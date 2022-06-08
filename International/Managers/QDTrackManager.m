//
//  QDTrackManager.m
//  vpn
//
//  Created by hzg on 2021/5/7.
//

#import "QDTrackManager.h"
#import <Firebase/Firebase.h>
//#import "Interop/Analytics/Public/FIRAnalyticsInterop.h"

@implementation QDTrackManager

// 新用户事件
+ (NSString*) format_user:(NSString*)eventName {
    if (QDConfigManager.shared.isNewUser) {
        return [NSString stringWithFormat:@"%@_New", eventName];
    }
    return eventName;
}

// 统计事件
+ (void) track:(QDTrackType)trackType data:(NSDictionary*)dict {
    
    NSMutableDictionary* parameters = [NSMutableDictionary new];
    [parameters addEntriesFromDictionary:dict];
    NSString* eventName = QDTrackName[[NSNumber numberWithInteger:trackType]];
    eventName = [self format_user:eventName];
    parameters[@"__u"] = [QDConfigManager.shared UUID];
    parameters[@"__p"] = @"ios";
    parameters[@"__k"] = eventName;

    // cms
    [self sendLogEventToCMS:eventName parameters:parameters];
    
    // google
    [FIRAnalytics logEventWithName:eventName parameters:dict];
}

+ (void) track_node:(NSString*)nodeName {
    NSString* new_node_name = [nodeName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSMutableDictionary* parameters = [NSMutableDictionary new];
    parameters[@"__u"] = [QDConfigManager.shared UUID];
    parameters[@"__p"] = @"ios";
    NSString* eventName = [NSString stringWithFormat:@"%@_%@", QDTrackName[[NSNumber numberWithInteger:QDTrackType_select_node]], new_node_name];
    eventName = [self format_user:eventName];
    parameters[@"__k"] = eventName;
    
    // cms
    [self sendLogEventToCMS:eventName parameters:parameters];
    
    // google
    [FIRAnalytics logEventWithName:eventName parameters:@{}];
}

+ (void) track_rate_node:(NSString*)nodeName rate:(int)rate {
    NSString* new_node_name = [nodeName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSMutableDictionary* parameters = [NSMutableDictionary new];
    parameters[@"__u"] = [QDConfigManager.shared UUID];
    parameters[@"__p"] = @"ios";
    NSString* eventName = [NSString stringWithFormat:@"%@_%@_%d", QDTrackName[[NSNumber numberWithInteger:QDTrackType_select_node]], new_node_name, rate];
    eventName = [self format_user:eventName];
    parameters[@"__k"] = eventName;
    
    // cms
    [self sendLogEventToCMS:eventName parameters:parameters];
    
    // google
    [FIRAnalytics logEventWithName:eventName parameters:@{}];
}

+ (void) track_button:(QDTrackButtonType)buttonType {
    NSMutableDictionary* parameters = [NSMutableDictionary new];
    parameters[@"__u"] = [QDConfigManager.shared UUID];
    parameters[@"__p"] = @"ios";
    NSString* eventName = [NSString stringWithFormat:@"%@_%ld", QDTrackName[[NSNumber numberWithInteger:QDTrackType_app_button]], buttonType];
    eventName = [self format_user:eventName];
    parameters[@"__k"] = eventName;
    
    // cms
    [self sendLogEventToCMS:eventName parameters:parameters];
   
    
    // google
    [FIRAnalytics logEventWithName:eventName parameters:@{}];
}

+ (void) sendLogEventToCMS:(NSString*) eventName parameters:(NSMutableDictionary *)parameters {
    
    // 新用户事件
    if (QDConfigManager.shared.isNewUser&&!QDConfigManager.shared.userEventDict[eventName]) {
        QDConfigManager.shared.userEventDict[eventName] = @(YES);
        
        parameters[@"version"] = APP_VERSION;
        parameters[@"package_id"]  = APP_BUNDLE_ID;
        parameters[@"platform_id"] = APP_PLATFORM_ID;
        [[QDHTTPManager shared] request:HTTPMethodTypePost type:kAPITrack parameters:parameters completed:^(NSDictionary * _Nonnull dictionary) {
            NSLog(@"track = %@", dictionary);
        }];
    }
}

@end
