//
//  CSLYPingHelper.m
//  vpn
//
//  Created by hzg on 2021/5/7.
//

#import "QDPingManager.h"
#import "STDPingServices.h"

@interface QDPingManager()

// 延迟结果
@property (nonatomic, strong)NSMutableDictionary *delayServicesDict;

@end

@implementation QDPingManager

+ (QDPingManager *) shared {
    static dispatch_once_t onceToken;
    static QDPingManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [QDPingManager new];
    });
    return instance;
}

- (NSMutableDictionary *)pingServicesDict {
    if (!_pingServicesDict) {
        _pingServicesDict = [NSMutableDictionary dictionary];
    }
    return _pingServicesDict;
}

- (NSMutableDictionary *)delayServicesDict {
    if (!_delayServicesDict) {
        _delayServicesDict = [NSMutableDictionary dictionary];
    }
    return _delayServicesDict;
}

// ping
- (void) ping:(NSString*)ip {
    // vpn已连接或网络不可用，不进行ping
    if (QDVPNManager.shared.status == NEVPNStatusConnected || ![AFNetworkReachabilityManager sharedManager].isReachable) return;
    [STDPingServices startPingAddress:ip callbackHandler:^(STDPingItem * _Nonnull pingItem, NSArray * _Nonnull pingItems) {
        [self.pingServicesDict setObject:pingItem forKey:ip];
        // vpn已连接或网络不可用，不进行上报
        if (QDVPNManager.shared.status == NEVPNStatusConnected || ![AFNetworkReachabilityManager sharedManager].isReachable) return;
        if (pingItem.status != STDPingStatusFinished) {
            
            NSString* node_id = ip;
            for (QDNodeModel* node in QDConfigManager.shared.nodes) {
                if ([node.host isEqual:pingItem.originalAddress]) {
                    node_id = node.nodeid;
                    break;
                }
            }
            
//            // 上报延时 
//            [QDTrackManager track:QDTrackType_ping data:@{@"status":@(pingItem.status), @"delay":@(pingItem.timeMilliseconds), @"node_id":node_id}];
        }
    }];
}


@end
