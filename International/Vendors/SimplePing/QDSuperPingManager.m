//
//  QDSuperPingManager.m
//  International
//
//  Created by LC on 2022/6/21.
//  Copyright © 2022 com. All rights reserved.
//

#import "QDSuperPingManager.h"
#import "QDSupSinglePinger.h"
#import "QDAddressItem.h"

@interface QDSuperPingManager()

@property (nonatomic, strong) NSMutableArray *singlePingerArray;

@end

@implementation QDSuperPingManager

- (void)getFatestAddress:(NSArray *)addressList requestTimes:(int)times completionHandler:(CompletionHandler)completionHandler
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (addressList.count == 0) {
            NSLog(@"addressList can't be empty");
            return;
        }
        NSMutableArray *singlePingerArray = [NSMutableArray array];
        self.singlePingerArray = singlePingerArray;
        NSMutableArray *needRemoveAddressArray = [NSMutableArray array];
        NSMutableArray *resultArray = [NSMutableArray array];
        NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
        for (NSString *address in addressList) {
            [resultDict setObject:[NSNull null] forKey:address];
        }
        dispatch_group_t group = dispatch_group_create();
        
        for (NSString *address in addressList) {
            dispatch_group_enter(group);
            QDSupSinglePinger * pinger = [QDSupSinglePinger startWithHostName:address count:1 pingCallBack:^(QDPingItem * _Nullable pingitem) {
                switch (pingitem.status) {
                    case NENSinglePingStatusDidStart:
                        break;
                    case NENSinglePingStatusDidFailToSendPacket:
                    {
                        [needRemoveAddressArray addObject:pingitem.hostName];
                        break;
                    }
                    case NENSinglePingStatusDidReceivePacket:
                    {
                        QDAddressItem *item = [resultDict objectForKey:pingitem.hostName];
                        if ([item isEqual:[NSNull null]]) {
                            item = [[QDAddressItem alloc] initWithHostName:pingitem.hostName];
                        }
                        [item.delayTimes addObject:@(pingitem.millSecondsDelay)];
                        [resultDict setObject:item forKey:pingitem.hostName];
                        if (![resultArray containsObject:item]) {
                            [resultArray addObject:item];
                        }
                        break;
                    }
                    case NENSinglePingStatusDidReceiveUnexpectedPacket:
                        break;
                    case NENSinglePingStatusDidTimeOut:
                    {
                        // 超时按1s计算
                        QDAddressItem *item = [resultDict objectForKey:pingitem.hostName];
                        if (!item||[item isEqual:[NSNull null]]) {
                            item = [[QDAddressItem alloc] initWithHostName:pingitem.hostName];
                        }
                            [item.delayTimes addObject:@(1000.0)];
                            [resultDict setObject:item forKey:pingitem.hostName];
                            if (![resultArray containsObject:item]) {
                                [resultArray addObject:item];
                        }

                        break;
                    }
                    case NENSinglePingStatusDidError:
                    {
                        [needRemoveAddressArray addObject:pingitem.hostName];
                        dispatch_group_leave(group);
                        break;
                    }
                    case NENSinglePingStatusDidFinished:
                    {
                        NSLog(@"%@ 完成",pingitem.hostName);
                        dispatch_group_leave(group);
                        break;
                    }
                    default:
                        break;
                }
            }];
            [singlePingerArray addObject:pinger];
        }
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            NSLog(@"计算延迟");
            for (QDAddressItem *item in resultArray) {
                if ( (item.delayTimes.count == 0 && ![needRemoveAddressArray containsObject:item.hostName]) ||
                    item.delayMillSeconds == 0) {
                    [needRemoveAddressArray addObject:item.hostName];
                }
            }
            
            for (NSString *removeHostName in needRemoveAddressArray) {
                [resultArray filterUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.hostName != %@",removeHostName]];
            }
            
            if (resultArray.count == 0) {
                completionHandler(nil,nil);
                return;
            }
            
            [resultArray sortUsingComparator:^NSComparisonResult(QDAddressItem * item1, QDAddressItem * item2) {
                return item1.delayMillSeconds > item2.delayMillSeconds;
            }];
            
            NSMutableArray *array = [NSMutableArray array];
            for (QDAddressItem *item in resultArray) {
                NSMutableDictionary * dic = [NSMutableDictionary dictionary];
                [dic setObject:item.delayTimes forKey:item.hostName];
                [array addObject:dic];
            }
            QDAddressItem *item = resultArray.firstObject;
            NSLog(@"最快的地址速度是: %.2f ms",item.delayMillSeconds);
            completionHandler(item.hostName, [array copy]);
        });
    }];
}

@end
