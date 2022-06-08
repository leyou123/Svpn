//
//  VPNManager.h
//  vpn管理
//
//  Created by hzg on 2020/12/2.
//

#import <Foundation/Foundation.h>
#import <NetworkExtension/NetworkExtension.h>


NS_ASSUME_NONNULL_BEGIN


@interface QDVPNManager : NSObject

// 单例
+ (instancetype) shared;

// 开启隧道
- (void) start:(nullable NSDictionary<NSString *,NSObject *> *)options completion:(void(^)(NSError* error)) completion;

// 关闭隧道
- (void) stop;

// 检查隧道
- (void) check;

- (void) startInstallConfig:(void(^)(NSError* error)) completion;

- (void) reStartInstallConfig:(void(^)(NSError* error)) completion;

// 状态
@property (nonatomic, assign) NEVPNStatus status;

// VPN状态变化
@property (nonatomic, copy) void (^statusChangedHandler)(NEVPNStatus status);

// 是否已经安装了配置文件
@property (nonatomic, assign) BOOL isInstallerVPNConfig;

// 是否已经重新安装了配置文件
@property (nonatomic, assign) BOOL isReInstallerVPNConfig;

@end

NS_ASSUME_NONNULL_END
