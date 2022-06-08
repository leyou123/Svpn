//
//  QDLocalNoticationManager.h
//  International
//
//  Created by hzg on 2021/8/24.
//  Copyright © 2021 com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QDLocalNoticationManager : NSObject

+ (QDLocalNoticationManager *) shared;

// 请求授权通知
- (void) setup;

// 取消所有的本地通知
- (void) cancelAllLocalNotifications;

//handle token received from APNS
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

//handle token receiving error
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;


/**
  IOS 10的通知   推送消息 支持的音频 <= 5M(现有的系统偶尔会出现播放不出来的BUG)  图片 <= 10M  视频 <= 50M  ，这些后面都要带上格式；

 @param body 消息内容
 @param promptTone 提示音
 @param soundName 音频
 @param imageName 图片
 @param movieName 视频
 @param identifier 消息标识
 */
-(void)pushNotification:(NSString *)body
                         promptTone:(NSString *)promptTone
                          soundName:(NSString *)soundName
                          imageName:(NSString *)imageName
                          movieName:(NSString *)movieName
             Identifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
