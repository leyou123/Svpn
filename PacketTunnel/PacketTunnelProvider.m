//
//  PacketTunnelProvider.m
//  PacketTunnel
//
//  Created by hzg on 2021/5/18.
//

#import "PacketTunnelProvider.h"
#import "libleaf/leaf.h"
#import "dns.h"
#import "PacketTunnel-Swift.h"

#define RL_ID 1999
#define GroupIdentifier @"group.com.superoversea"


@interface PacketTunnelProvider()

@property(nonatomic, assign) int leaf_id;
@property(nonatomic, copy) void (^completionHandler)(NSError *);
@property(nonatomic, copy) void (^stopCompletionHandler)(void);
@property(nonatomic, strong) NSTimer* timer;
@property(nonatomic, strong) NSDictionary *options;
@property(nonatomic, assign) NEProviderStopReason stopReason;

@end

@implementation PacketTunnelProvider

- (void)startTunnelWithOptions:(NSDictionary *)options completionHandler:(void (^)(NSError *))completionHandler {
    
    self.options = options;
    self.leaf_id = RL_ID;
    self.completionHandler = completionHandler;
    self.stopReason = NEProviderStopReasonNone;
    
    // 到期，自动关闭隧道
    int seconds = [options[@"remainMins"] intValue] * 60;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        leaf_shutdown(RL_ID);
        self.leaf_id = -1;
        exit(0);
    });
    
    // 开启隧道代理
    [self startTrojanProxy:options];
    

}

- (NSString*) getFD {
    if (@available(iOS 15.0, *)) {
        TunnelFD* fd = [TunnelFD new];
        long f = [fd getFD];
        return [NSString stringWithFormat:@"%ld", f];
    } else {
        return [self.packetFlow valueForKeyPath:@"socket.fileDescriptor"];
    }
}

- (void) startTrojanProxy:(NSDictionary *)options {
    NEPacketTunnelNetworkSettings* settings = [self createTunnelSettings];
    
    __weak typeof(self) weakSelf = self;
    [self setTunnelNetworkSettings:settings completionHandler:^(NSError * _Nullable error) {
        __strong typeof(self) strongSelf = weakSelf;
        if (!error) {
            
            NSString* tunFd = [strongSelf getFD];
            NSMutableString *dns = [NSMutableString string];
            NSArray* dnsArray = [DNSConfig getSystemDnsServers];
            if (dnsArray.count > 0) {
                for (NSString* data in [DNSConfig getSystemDnsServers]) {
                    [dns appendString:[NSString stringWithFormat:@"%@,", data]];
                }
                dns = (NSMutableString*)[dns substringToIndex:dns.length - 1];
            }
            NSLog(@"dns===>%@", dns);
            
            NSString * trojan = @"";
//            trojan = [NSString stringWithFormat:@"Trojan = trojan, %@, %@, password=%@, sni=%@, ws=true, ws-path=/etc/trojan/bin/example/, ws-host=%@, shadowsocks=true, method=AES-128-GCM, password=leyou20222, mux=true, concurrency=8, idle_timeout=60",options[@"host"], options[@"port"], /*options[@"password"]*/@"leyou20222",options[@"host"],options[@"host"]];
            
//            switch ([options[@"connectStatus"] intValue]) {
//                case 1:
//                    trojan = [NSString stringWithFormat:@"Trojan = trojan, %@, %@, password=%@, sni=%@", options[@"ip"], options[@"port"], options[@"password"], options[@"host"]];
//                    break;
//
//                case 2:
                    trojan = [NSString stringWithFormat:@"Trojan = trojan, %@, %@, password=%@ , mux=true", options[@"host"], options[@"port"], options[@"password"]];
//                    break;
//
//                case 3:
//                    trojan = [NSString stringWithFormat:@"Trojan = trojan, %@, %@, password=%@, sni=%@, ws=true, ws-path=/root/trojan/example/, host=%@",options[@"host"], options[@"port"],options[@"password"],options[@"host"],options[@"host"]];
//                    break;
//
//                case 4:
//                    trojan = [NSString stringWithFormat:@"Trojan = trojan, %@, %@, password=%@, sni=%@, ws=true, ws-path=/root/trojan/example/, host=%@, mux=true, concurrency=8, idle_timeout=60",options[@"host"], options[@"port"], options[@"password"],options[@"host"],options[@"host"]];
//                    break;
//
//                case 5:
//                    trojan = [NSString stringWithFormat:@"Trojan = trojan, %@, %@, password=%@ , mux=true", options[@"host"], options[@"port"], options[@"password"]];
//                    break;
//
//                case 6:
//                    trojan = [NSString stringWithFormat:@"Trojan = trojan, %@, %@, password=%@ , mux=true", options[@"host"], options[@"port"], options[@"password"]];
//                    break;
//
//                default:
//                    trojan = [NSString stringWithFormat:@"Trojan = trojan, %@, %@, password=%@ , mux=true", options[@"host"], options[@"port"], options[@"password"]];
//                    break;
//            }
            
            NSArray* array = @[
                @"\n[General]",
                @"loglevel = trace",
//                @"dns-server = 1.1.1.1, 223.5.5.5",
                [NSString stringWithFormat:@"dns-server = %@", dns],
                [NSString stringWithFormat:@"tun-fd = %@", tunFd],
                @"routing-domain-resolve = true",
                @"[Proxy]",
                @"Direct = direct",
                trojan,
                @"[Rule]",
//                @"DOMAIN-SUFFIX, api.9527.click, Direct",
                @"EXTERNAL, site:cn, Direct",
                @"EXTERNAL, mmdb:cn, Direct",
                @"FINAL, Trojan"
            ];
            
            NSMutableString *config = [NSMutableString string];
            for (NSString* data in array) {
                [config appendString:[NSString stringWithFormat:@"%@\n", data]];
            }
            
            NSLog(@"conig = %@", config);
            NSURL* url = [[NSFileManager.defaultManager containerURLForSecurityApplicationGroupIdentifier: GroupIdentifier]  URLByAppendingPathComponent:@"trojan_config.conf"];
            [config writeToURL:url atomically:NO encoding:NSUTF8StringEncoding error:nil];
            NSLog(@"url = %@", url);
        
            // The CA is used by OpenSSl.
            // You may download a CA from https://curl.se/docs/caextract.html
            NSURL* certPath = [NSBundle.mainBundle executableURL].URLByDeletingLastPathComponent;
            const char *cert_dir = [certPath.path cStringUsingEncoding:NSUTF8StringEncoding];
            setenv("SSL_CERT_DIR", cert_dir, 1);
            certPath = [certPath URLByAppendingPathComponent:@"cacert.pem"];
            const char *cert_file = [certPath.path cStringUsingEncoding:NSUTF8StringEncoding];
            setenv("SSL_CERT_FILE", cert_file, 1);
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
                signal(SIGPIPE, SIG_IGN);
                int32_t code = leaf_run_with_options(strongSelf.leaf_id, [url.path cStringUsingEncoding:NSUTF8StringEncoding], true, true, true, 2, 2048);
                NSLog(@"code = %d", code);
                dispatch_async(dispatch_get_main_queue(), ^{
                     //主线程的处理逻辑
                    [strongSelf stop];
                });
            });
            
            
        }

        if (strongSelf.completionHandler) {
            strongSelf.completionHandler(error);
        }
    }];
}


- (void) stop {
    if (self.stopCompletionHandler) self.stopCompletionHandler();
    if (self.leaf_id != -1) {
        leaf_shutdown(self.leaf_id);
        self.leaf_id = -1;
        exit(0);
    }
}

- (NEPacketTunnelNetworkSettings*) createTunnelSettings {
    NEPacketTunnelNetworkSettings* newSettings = [[NEPacketTunnelNetworkSettings alloc] initWithTunnelRemoteAddress:@"192.0.2.2"];
    newSettings.IPv4Settings = [[NEIPv4Settings alloc] initWithAddresses:@[@"192.0.2.1"] subnetMasks:@[@"255.255.255.0"]];
    newSettings.IPv4Settings.includedRoutes = @[[NEIPv4Route defaultRoute]];
    newSettings.proxySettings = nil;
    NEDNSSettings *dnsSettings = [[NEDNSSettings alloc] initWithServers:[DNSConfig getSystemDnsServers]];
    newSettings.DNSSettings = dnsSettings;
    newSettings.MTU = @(1500);
    return newSettings;
}


- (void)stopTunnelWithReason:(NEProviderStopReason)reason completionHandler:(void (^)(void))completionHandler {
    // Add code here to start the process of stopping the tunnel.'
    NSLog(@"stopTunnelWithReason----> %ld", reason);
    self.stopReason = reason;
    self.stopCompletionHandler = completionHandler;
    if (reason == NEProviderStopReasonUserInitiated) {
        [self stop];
    }
}

- (void)handleAppMessage:(NSData *)messageData completionHandler:(void (^)(NSData *))completionHandler {
    // Add code here to handle the message.
}

- (void)sleepWithCompletionHandler:(void (^)(void))completionHandler {
    // Add code here to get ready to sleep.
    completionHandler();
}

- (void)wake {
    // Add code here to wake up.
}

@end
