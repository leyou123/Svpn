//
//  QDSupSinglePinger.m
//  International
//
//  Created by LC on 2022/6/21.
//  Copyright © 2022 com. All rights reserved.
//

#import "QDSupSinglePinger.h"
#import "SimplePing.h"
#include <netdb.h>

//发送数据的间隙
#define PING_TIME_INTERVAL  1
//超时时间
#define PING_TIMEOUT 1.5
//发送的ping的总次数
#define kSequenceNumber  1

#define PING_TIMEOUT_DELAY  1000

@interface QDSupSinglePinger()<SimplePingDelegate>

@property (nonatomic, strong) SimplePing *simplePing;
@property (nonatomic, strong) NSTimer *timer;
/**目标域名的IP地址*/
@property (nonatomic, copy) NSString *iPAddress;
/**开始发送数据的时间*/
@property (nonatomic) NSTimeInterval startTimeInterval;
/**消耗的时间*/
@property (nonatomic) NSTimeInterval delayTime;
/**接收到数据或者丢失的数据的次数*/
@property (nonatomic, assign) NSInteger receivedOrDelayCount;
/**发出的数据包*/
@property (nonatomic) NSUInteger sendPackets;
/**收到的数据包*/
@property (nonatomic) NSUInteger receivePackets;
/**丢包率*/
@property (nonatomic, assign) double packetLoss;

@property (nonatomic, copy) PingCallBack pingCallBack;

@end

@implementation QDSupSinglePinger

- (instancetype)initWithHostName:(NSString *)hostName count:(NSInteger)count pingCallBack:(PingCallBack)pingCallBack
{
    if (self = [super init]) {
        self.simplePing = [[SimplePing alloc] initWithHostName:hostName];
        self.simplePing.addressStyle = SimplePingAddressStyleAny;
        self.simplePing.delegate = self;
        self.sendPackets = 0;
        self.receivePackets = 0;
        self.pingCallBack = pingCallBack;
        [self.simplePing start];
    }
    return self;
}

+ (instancetype)startWithHostName:(NSString *)hostName count:(NSInteger)count pingCallBack:(PingCallBack)pingCallBack
{
    return [[self alloc] initWithHostName:hostName count:count pingCallBack:pingCallBack];
}


#pragma mark - SimplePingDelegate

// [self.simplePing start] 成功之后
- (void)simplePing:(SimplePing *)pinger didStartWithAddress:(NSData *)address{
    self.iPAddress = [self displayIPFormAddress:address];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:PING_TIME_INTERVAL repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self sendPingData];
    }];
    
    QDPingItem *pingItem = [[QDPingItem alloc] init];
    pingItem.hostName = self.iPAddress;
    pingItem.status = NENSinglePingStatusDidStart;
    if(self.pingCallBack){
        self.pingCallBack(pingItem);
    }
}

- (void)sendPingData{
    //执行到指定次数后停止时间搓
    if (self.receivedOrDelayCount == kSequenceNumber) {
        [self stopPing];
    }
    
    self.startTimeInterval = [[NSDate date] timeIntervalSince1970]*1000;
    [self.simplePing sendPingWithData:nil];
    //超时问题处理
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.receivedOrDelayCount > 0) {
        }else {
            [self pingTimeout];
        }
    });
}

// [self.simplePing start] 失败
- (void)simplePing:(SimplePing *)pinger didFailWithError:(NSError *)error{
    
    NSString *failCreateLog = [NSString stringWithFormat:@"#%ld try create failed: %@", self.receivedOrDelayCount,[self shortErrorFromError:error]];
    NSLog(@"didFailWithError:%@",failCreateLog);
    //启动发送data失败
    [self failPing];
    [self cancelTimeOut];
}

//取消超时
- (void)cancelTimeOut{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(pingTimeout) object:nil];
}

//sendPingWithData 发送数据成功
- (void)simplePing:(SimplePing *)pinger didSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber{
    self.sendPackets++;
    [self cancelTimeOut];
}

// sendPingWithData 发送数据失败，并返回错误信息
- (void)simplePing:(SimplePing *)pinger didFailToSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber error:(NSError *)error{
    self.receivedOrDelayCount++;
    [self cancelTimeOut];
    NSString *sendFailLog = [NSString stringWithFormat:@"#%u send failed: %@",sequenceNumber,[self shortErrorFromError:error]];
    NSLog(@"didFailToSendPacket:%@",sendFailLog);
}

//发送数据后接收到主机返回应答数据的回调
- (void)simplePing:(SimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber{
    
    self.receivedOrDelayCount++;
    [self cancelTimeOut];
    
    self.receivePackets++;
    
    self.packetLoss = (double)((self.sendPackets - self.receivePackets) * 1.f / self.sendPackets * 100);
    
    self.delayTime = [[NSDate date] timeIntervalSince1970]*1000 - self.startTimeInterval;
    
    QDPingItem *pingItem = [[QDPingItem alloc] init];
    pingItem.hostName = self.iPAddress;
    pingItem.status = NENSinglePingStatusDidReceivePacket;
    pingItem.millSecondsDelay = self.delayTime;
    self.pingCallBack(pingItem);
    
    if (self.receivedOrDelayCount == kSequenceNumber) {
        [self stopPing];
    }
}

// 收到的未知的数据包
- (void)simplePing:(SimplePing *)pinger didReceiveUnexpectedPacket:(NSData *)packet{
    
}


- (void)failPing {
    QDPingItem *pingItem = [[QDPingItem alloc] init];
    pingItem.hostName = self.iPAddress;
    pingItem.status = NENSinglePingStatusDidError;
    self.pingCallBack(pingItem);
    
    [self.simplePing stop];
    self.simplePing = nil;
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.delayTime = 0;
    
    [self cancelTimeOut];
}

-(void)pingTimeout{
    
    NSLog(@"++++超时了+++");
    if (self.timer) {
        self.receivedOrDelayCount++;
        
        self.packetLoss = (double)((self.sendPackets - self.receivePackets) * 1.f / self.sendPackets * 100);
        
        QDPingItem *pingItem = [[QDPingItem alloc] init];
        pingItem.hostName = self.iPAddress;
        pingItem.status = NENSinglePingStatusDidTimeOut;
        if(self.pingCallBack){
            self.pingCallBack(pingItem);
        }
        
        if (self.receivedOrDelayCount == kSequenceNumber) {
            [self stopPing];
        }
    }
}

-(void)stopPing{
    
    QDPingItem *pingItem = [[QDPingItem alloc] init];
    pingItem.hostName = self.iPAddress;
    pingItem.status = NENSinglePingStatusDidFinished;
    self.pingCallBack(pingItem);
    
    [self.simplePing stop];
    self.simplePing = nil;
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.delayTime = 0;
}

/**
 * 将ping接收的数据转换成ip地址
 * @param address 接受的ping数据
 */
-(NSString *)displayIPFormAddress:(NSData *)address
{
    int err;
    NSString *result;
    char hostStr[NI_MAXHOST];
    
    result = nil;
    
    if (address != nil) {
        err = getnameinfo([address bytes], (socklen_t)[address length], hostStr, sizeof(hostStr),
                          NULL, 0, NI_NUMERICHOST);
        if (err == 0) {
            result = [NSString stringWithCString:hostStr encoding:NSASCIIStringEncoding];
            assert(result != nil);
        }
    }
    
    return result;
}


/*
 * 解析错误数据并翻译
 */
- (NSString *)shortErrorFromError:(NSError *)error
{
    NSString *result;
    NSNumber *failureNum;
    int failure;
    const char *failureStr;
    
    assert(error != nil);
    
    result = nil;
    
    // Handle DNS errors as a special case.
    
    if ([[error domain] isEqual:(NSString *)kCFErrorDomainCFNetwork] &&
        ([error code] == kCFHostErrorUnknown)) {
        failureNum = [[error userInfo] objectForKey:(id)kCFGetAddrInfoFailureKey];
        if ([failureNum isKindOfClass:[NSNumber class]]) {
            failure = [failureNum intValue];
            if (failure != 0) {
                failureStr = gai_strerror(failure);
                if (failureStr != NULL) {
                    result = [NSString stringWithUTF8String:failureStr];
                    assert(result != nil);
                }
            }
        }
    }
    
    // Otherwise try various properties of the error object.
    
    if (result == nil) {
        result = [error localizedFailureReason];
    }
    if (result == nil) {
        result = [error localizedDescription];
    }
    if (result == nil) {
        result = [error description];
    }
    assert(result != nil);
    return result;
}


@end
