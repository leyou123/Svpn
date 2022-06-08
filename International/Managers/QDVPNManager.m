//
//  VPNManager.m
//  vpnlib
//
//  Created by hzg on 2020/12/2.
//

#import "QDVPNManager.h"

static NSString* PACKET_TUNNEL_BUNDLE_ID = @"com.superoversea.PacketTunnel";

@interface QDVPNManager()

// 隧道
@property (nonatomic, strong) NETunnelProviderManager* tunnel;

@end

@implementation QDVPNManager

//在.m文件中声明静态的类实例，不放在.h中是为了让instance私有
static QDVPNManager* instance = nil;

//提供的类唯一实例的全局访问点
//跟C++中思路相似，判断instance是否为空
//如果为空，则创建，如果不是，则返回已经存在的instance
//不能保证线程安全
+(QDVPNManager *) shared {
    if (instance == nil) {
        instance = [[QDVPNManager alloc] init];//调用自己改写的”私有构造函数“
    }
    return instance;
}

//相当于将构造函数设置为私有，类的实例只能初始化一次
+ (id) allocWithZone:(struct _NSZone*)zone
{
    if (instance == nil) {
        instance = [super allocWithZone:zone];
        [instance setup];
    }
    return instance;
}

//重写copy方法中会调用的copyWithZone方法，确保单例实例复制时不会重新创建
- (id) copyWithZone:(struct _NSZone *)zone
{
    return instance;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NEVPNStatusDidChangeNotification object:nil];
}

// 初始化
- (void) setup {
    self.status = NEVPNStatusDisconnected;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateStatus)
                                                 name:NEVPNStatusDidChangeNotification
                                               object:nil];
    
    // 初始状态
//    __weak typeof(self) weakSelf = self;
//    [self refresh:^(NSError *error) {
//        __strong typeof(self) strongSelf = weakSelf;
//        if (error) {
//            return;
//        }
//        [strongSelf updateStatus];
//    }];
    
    // 初始化配置状态
    [NETunnelProviderManager loadAllFromPreferencesWithCompletionHandler:^(NSArray<NETunnelProviderManager *> * _Nullable managers, NSError * _Nullable error) {
        BOOL isExistConfig = NO;
        for (NETunnelProviderManager* manager in managers) {
            NETunnelProviderProtocol* protocol = (NETunnelProviderProtocol*)manager.protocolConfiguration;
            if (protocol&&[protocol.providerBundleIdentifier isEqual:PACKET_TUNNEL_BUNDLE_ID]) {
                isExistConfig = YES;
                break;
            }
        }
        self.isInstallerVPNConfig = isExistConfig;
    }];
}

#pragma  mark 接口

- (void) startInstallConfig:(void(^)(NSError* error)) completion {
    
    self.isReInstallerVPNConfig = NO;
    
    __weak typeof(self) weakSelf = self;
    [self refresh:^(NSError *error) {
        __strong typeof(self) strongSelf = weakSelf;
        if (error) {
            completion(error);
            return;
        }
        
        // 保存
        if (!self.isInstallerVPNConfig) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationConfigInstallStart object:nil];
            [QDTrackManager track:QDTrackType_install_config_start data:@{}];
        }
        [strongSelf saveToPreferences:^(NSError *error) {
            if (error) {
                if (!self.isInstallerVPNConfig) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationConfigInstallFail object:nil];
                    [QDTrackManager track:QDTrackType_install_config_fail data:@{}];
                }
                completion(error);
                return;
            }
            
            if (!self.isInstallerVPNConfig) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationConfigInstallEnd object:nil];
                [QDTrackManager track:QDTrackType_install_config_suc data:@{}];
                self.isInstallerVPNConfig = YES;
            }
            completion(nil);
        }];
    }];
}

- (void) reStartInstallConfig:(void(^)(NSError* error)) completion {
    self.isReInstallerVPNConfig = NO;
    __weak typeof(self) weakSelf = self;
    [self refresh:^(NSError *error) {
        __strong typeof(self) strongSelf = weakSelf;
        if (error) {
            completion(error);
            return;
        }
        [strongSelf removeToPreferences:^(NSError *error) {
            strongSelf.isInstallerVPNConfig = NO;
            // 保存
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationConfigInstallStart object:nil];
            [QDTrackManager track:QDTrackType_install_config_start data:@{}];
            [strongSelf saveToPreferences:^(NSError *error) {
                if (error) {
                    if (!self.isInstallerVPNConfig) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationConfigInstallFail object:nil];
                        [QDTrackManager track:QDTrackType_install_config_fail data:@{}];
                    }
                    completion(error);
                    return;
                }

                if (!self.isInstallerVPNConfig) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationConfigInstallEnd object:nil];
                    [QDTrackManager track:QDTrackType_install_config_suc data:@{}];
                    self.isInstallerVPNConfig = YES;
                    self.isReInstallerVPNConfig = YES;
                }
                completion(nil);
            }];
        }];
    }];
}


// 开启tunnel
- (void) start:(nullable NSDictionary<NSString *,NSObject *> *)options completion:(void(^)(NSError* error)) completion {
    __weak typeof(self) weakSelf = self;
    [self refresh:^(NSError *error) {
        __strong typeof(self) strongSelf = weakSelf;
        if (error) {
            completion(error);
            return;
        }

        // 保存
        [strongSelf saveToPreferences:^(NSError *error) {
            if (error) {
                completion(error);
                return;
            }

            [strongSelf.tunnel loadFromPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
                NSError *returnError;
                [strongSelf.tunnel.connection startVPNTunnelWithOptions:options andReturnError:&returnError];
                completion(returnError);
            }];
        }];
    }];
}

// 关闭隧道
- (void) stop {
    if (self.tunnel) {
        [self.tunnel.connection stopVPNTunnel];
    }
}

// 检查隧道, 并断开其它隧道
- (void) check {
    [NETunnelProviderManager loadAllFromPreferencesWithCompletionHandler:^(NSArray<NETunnelProviderManager *> * _Nullable managers, NSError * _Nullable error) {
        BOOL isExistConfig = NO;
        for (NETunnelProviderManager* manager in managers) {
            NETunnelProviderProtocol* protocol = (NETunnelProviderProtocol*)manager.protocolConfiguration;
            if (protocol&&[protocol.providerBundleIdentifier isEqual:PACKET_TUNNEL_BUNDLE_ID]) {
                self.tunnel = manager;
                isExistConfig = YES;
                break;
            }
        }
        self.isInstallerVPNConfig = isExistConfig;
        if (self.tunnel) {
            self.tunnel.enabled = YES;
            WS(weakSelf);
            [self.tunnel saveToPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
                [weakSelf updateStatus];
            }];
        }
    }];
}

#pragma mark 私有方法
// 保存配置文件
- (void) saveToPreferences:(void(^)(NSError* error))completion {
    [self.tunnel saveToPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
        completion(error);
    }];
}

- (void)removeToPreferences:(void(^)(NSError* error))completion {
    [self.tunnel removeFromPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
        completion(error);
    }];
}

// 下载配置
- (void) loadTunnelManager: (void(^)(NETunnelProviderManager *manager, NSError *error))completion {
    [NETunnelProviderManager loadAllFromPreferencesWithCompletionHandler:^(NSArray<NETunnelProviderManager *> * _Nullable managers, NSError * _Nullable error) {
        BOOL isExistConfig = NO;
        for (NETunnelProviderManager* manager in managers) {
            NETunnelProviderProtocol* protocol = (NETunnelProviderProtocol*)manager.protocolConfiguration;
            if (protocol&&[protocol.providerBundleIdentifier isEqual:PACKET_TUNNEL_BUNDLE_ID]) {
                self.tunnel = manager;
                isExistConfig = YES;
                break;
            }
        }
        self.isInstallerVPNConfig = isExistConfig;
        if (!self.tunnel) {
            self.tunnel = [self makeTunnelManager];
        }
        self.tunnel.enabled = YES;
        completion(self.tunnel, error);
    }];
}

// 生成NETunnelProviderManager
- (NETunnelProviderManager*) makeTunnelManager {
    NETunnelProviderManager* manager = [[NETunnelProviderManager alloc] init];
    NETunnelProviderProtocol* protocol = [[NETunnelProviderProtocol alloc] init];
    protocol.providerBundleIdentifier = PACKET_TUNNEL_BUNDLE_ID;
    protocol.serverAddress = @"VPN";
    manager.protocolConfiguration = protocol;
    manager.localizedDescription = @"VPN";
    manager.enabled = YES;
    return manager;
}

- (void) refresh:(void(^)(NSError* error))completion {
    [self loadTunnelManager:^(NETunnelProviderManager *manager, NSError *error) {
        completion(error);
    }];
}

- (void) updateStatus {
    NEVPNStatus old_status = self.status;
    if (self.tunnel) {
        self.status = self.tunnel.connection.status;
    }
    if (old_status != self.status) {
        if (self.statusChangedHandler) self.statusChangedHandler(self.status);
    }
}

@end

