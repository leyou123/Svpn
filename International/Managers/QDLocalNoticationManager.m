//
//  QDLocalNoticationManager.m
//  International
//
//  Created by hzg on 2021/8/24.
//  Copyright © 2021 com. All rights reserved.
//

#import "QDLocalNoticationManager.h"
#import <UserNotifications/UserNotifications.h>
#import <Pushwoosh/Pushwoosh.h>
#import "QDBaseResultModel.h"
#import "QDReceiptManager.h"
#import "UIUtils.h"
#import "QDDateUtils.h"

@interface QDLocalNoticationManager()<UNUserNotificationCenterDelegate, PWMessagingDelegate>

@end

@implementation QDLocalNoticationManager

+ (QDLocalNoticationManager *) shared {
    static dispatch_once_t onceToken;
    static QDLocalNoticationManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [QDLocalNoticationManager new];
    });
    return instance;
}

- (void) setup {
//    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//    center.delegate = self;
    /*暂时关闭开启通知的弹窗*/
//    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
//
//        UNAuthorizationStatus status = settings.authorizationStatus;
//        switch (status) {
//            case UNAuthorizationStatusNotDetermined:
//            {
//                // 请求授权
//                [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert|UNAuthorizationOptionSound|UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
//                    if (!error) {
//                        NSLog(@"succeeded!");
//                    }}
//                 ];
//            }
//                break;
//            case UNAuthorizationStatusDenied:
//            {
//
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    NSString* title = NSLocalizedString(@"Dialog_Notify_title", nil);
//                    NSString* message = NSLocalizedString(@"Dialog_Notify_message", nil);
//                    NSString* ok = NSLocalizedString(@"Dialog_Getit", nil);
//                    [QDDialogManager showDialog:title message:message ok:ok cancel:NSLocalizedString(@"Dialog_Cancel", nil) okBlock:^{
//                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
//                    } cancelBlock:^{
//
//                    }];
//                });
//            }
//                break;
//            default:
//                break;
//        }
//    }];
    
//    [self initPushwoosh];
}

// 注册推送通知Pushwoosh
- (void) initPushwoosh {
    // set custom delegate for push handling, in our case AppDelegate
    [Pushwoosh sharedInstance].delegate = self;
    [Pushwoosh sharedInstance].showPushnotificationAlert = NO;
    
    //register for push notifications!
    [[Pushwoosh sharedInstance] registerForPushNotifications];
    
    // add device token
    [QDModelManager requestAddDeviceToken:[[Pushwoosh sharedInstance] getHWID] completed:^(NSDictionary * _Nonnull dictionary) {
        NSLog(@"Pushwoosh dictionary = %@", dictionary);
        
    }];
    
//    NSLog(@"PushToken = %@", [[Pushwoosh sharedInstance] getPushToken]);
}

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
                         Identifier:(NSString *)identifier {
     //获取通知中心用来激活新建的通知
    UNUserNotificationCenter * center  = [UNUserNotificationCenter currentNotificationCenter];
    
    UNMutableNotificationContent * content = [[UNMutableNotificationContent alloc]init];
    
    content.body = body;
    content.badge = @1;
    
    //通知的提示音
    if ([promptTone containsString:@"."]) {
        UNNotificationSound *sound = [UNNotificationSound soundNamed:promptTone];
        content.sound = sound;
    }
    
    __block UNNotificationAttachment *imageAtt;
    __block UNNotificationAttachment *movieAtt;
    __block UNNotificationAttachment *soundAtt;

    if ([imageName containsString:@"."]) {
        
        [self addNotificationAttachmentContent:content attachmentName:imageName options:nil withCompletion:^(NSError *error, UNNotificationAttachment *notificationAtt) {
           
            imageAtt = [notificationAtt copy];
        }];
    }
    
    if ([soundName containsString:@"."]) {
        
        
        [self addNotificationAttachmentContent:content attachmentName:soundName options:nil withCompletion:^(NSError *error, UNNotificationAttachment *notificationAtt) {
            soundAtt = [notificationAtt copy];
        }];
        
    }
    
    if ([movieName containsString:@"."]) {
        // 在这里截取视频的第10s为视频的缩略图 ：UNNotificationAttachmentOptionsThumbnailTimeKey
        [self addNotificationAttachmentContent:content attachmentName:movieName options:@{@"UNNotificationAttachmentOptionsThumbnailTimeKey":@10} withCompletion:^(NSError *error, UNNotificationAttachment *notificationAtt) {
            movieAtt = [notificationAtt copy];
        }];
        
    }

//    NSMutableArray * array = [NSMutableArray array];
//    [array addObject:soundAtt];
//    [array addObject:imageAtt];
//    [array addObject:movieAtt];
    
//    content.attachments = array;

    //添加通知下拉动作按钮
    NSMutableArray * actionMutableArray = [NSMutableArray array];
    UNNotificationAction * actionA = [UNNotificationAction actionWithIdentifier:@"identifierNeedUnlock" title:NSLocalizedString(@"Notificaiton_Enter", nil) options:UNNotificationActionOptionAuthenticationRequired];
    UNNotificationAction * actionB = [UNNotificationAction actionWithIdentifier:@"identifierRed" title:NSLocalizedString(@"Notificaiton_Cancel", nil) options:UNNotificationActionOptionDestructive];
    [actionMutableArray addObjectsFromArray:@[actionA,actionB]];
    
    if (actionMutableArray.count > 1) {
        
        UNNotificationCategory * category = [UNNotificationCategory categoryWithIdentifier:@"categoryNoOperationAction" actions:actionMutableArray intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
        [center setNotificationCategories:[NSSet setWithObjects:category, nil]];
        content.categoryIdentifier = @"categoryNoOperationAction";
    }
    
    //UNTimeIntervalNotificationTrigger   延时推送
    //UNCalendarNotificationTrigger       定时推送
    //UNLocationNotificationTrigger       位置变化推送
    NSTimeInterval one_day = 1 * 24 * 60 * 60;
    UNTimeIntervalNotificationTrigger * tirgger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:one_day repeats:NO];
    
   //建立通知请求
    UNNotificationRequest * request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:tirgger];
    
    //将建立的通知请求添加到通知中心
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"%@本地推送 :( 报错 %@",identifier,error);
    }];
}


/**
 增加通知附件

 @param content 通知内容
 @param attachmentName 附件名称
 @param options 相关选项
 @param completion 结果回调
 */
-(void)addNotificationAttachmentContent:(UNMutableNotificationContent *)content attachmentName:(NSString *)attachmentName  options:(NSDictionary *)options withCompletion:(void(^)(NSError * error , UNNotificationAttachment * notificationAtt))completion{
    
    NSArray * arr = [attachmentName componentsSeparatedByString:@"."];
    NSError * error;
    NSString * path = [[NSBundle mainBundle]pathForResource:arr[0] ofType:arr[1]];
    UNNotificationAttachment * attachment = [UNNotificationAttachment attachmentWithIdentifier:[NSString stringWithFormat:@"notificationAtt_%@",arr[1]] URL:[NSURL fileURLWithPath:path] options:options error:&error];
    
    if (error) {
        NSLog(@"attachment error %@", error);
    }
    
    completion(error,attachment);
    
    //获取通知下拉放大图片
    content.launchImageName = attachmentName;
}

// 取消所有的本地通知
- (void) cancelAllLocalNotifications {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
}

//handle token received from APNS
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[Pushwoosh sharedInstance] handlePushRegistration:deviceToken];
    NSLog(@"PushToken = %@", [[Pushwoosh sharedInstance] getPushToken]);
}

//handle token receiving error
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [[Pushwoosh sharedInstance] handlePushRegistrationFailure:error];
}

# pragma mark - UNUserNotificationCenterDelegate
//再实现UNUserNotificationCenterDelegate代理的方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    //应用在前台时候接收到本地推送通知、远程推送通知调用此方法
    NSLog(@"%@", notification);
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
    //应用程序在后台，用户通过点击本地推送、远程推送进入app时调用此方法
    NSLog(@"%@", response);
}

# pragma mark - pushwoosh
//this event is fired when the push gets received
- (void)pushwoosh:(Pushwoosh *)pushwoosh onMessageReceived:(PWMessage *)message {
    NSLog(@"onMessageReceived: %@", message.payload.description);
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        // 需要延迟执行的代码
//        [self doPushAction:message.payload];
//    });
}

//this event is fired when user taps the notification
- (void)pushwoosh:(Pushwoosh *)pushwoosh onMessageOpened:(PWMessage *)message {
    NSLog(@"onMessageOpened: %@", message.customData);
    
    [QDTrackManager track:QDTrackType_PushMessage data:@{}];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 需要延迟执行的代码
        [self doPushAction:message.payload];
    });
}

# pragma mark - action
- (void) doPushAction:(NSDictionary*) payload {
    if (!payload) return;
    if (![payload objectForKey:@"type"]) return;
    if (![payload objectForKey:@"viewType"]) return;
    if (![payload objectForKey:@"text"]) return;
    
    int type = [payload[@"type"] intValue];
    int viewType = [payload[@"viewType"] intValue];
    NSString* text = payload[@"text"];
    
    NSString* ok = NSLocalizedString(@"Dialog_Ok", nil);
    
    switch (type) {
        case 0: //推送一般消息
        {
            [self showType0:viewType payload:payload text:text ok:ok];
        }
            break;
        case 1: //推送领免费时长
        {
            [self showType1:viewType payload:payload text:text ok:ok];
        }
            break;
        case 2: //推送促销产品 年订阅
        {
            [self showType2:viewType payload:payload text:text ok:ok];
        }
            break;
        case 3: // 引导版本更新
        {
            [self showType3:viewType payload:payload text:text ok:ok];
        }
            break;
        case 4: // 引导客服反馈 邮件
        {
            [self showType4:viewType payload:payload text:text ok:ok];
        }
            break;
        case 5: // 跳转第三方APP
        {
            [self showType5:viewType payload:payload text:text ok:ok];
        }
            break;
        default:
            break;
    }
}

- (void) showType:(int)viewType payload:(NSDictionary*)payload text:(NSString*)text ok:(NSString*)ok callback:(OperateResultCallBack)callback {
    switch (viewType) {
        case 0:
            [QDDialogView show:nil message:text items:@[ok] hideWhenTouchOutside:NO cancel:NSLocalizedString(@"Dialog_Cancel", nil) callback:callback];
            break;
        default:
        {
            NSString* image = @"";
            if ([payload objectForKey:@"image"]) image = [payload objectForKey:@"image"];
            [QDDialogView showTemplate1:text image:image items:@[ok] hideWhenTouchOutside:NO cancel:NSLocalizedString(@"Dialog_Cancel", nil) callback:callback];
        }
            break;
    }
}

- (void) showType0:(int)viewType payload:(NSDictionary*)payload text:(NSString*)text ok:(NSString*)ok {
    
    OperateResultCallBack callback = ^(NSString *item) {
        if ([item isEqualToString:ok]) {
            [QDTrackManager track_button:QDTrackButtonType_37];
        }
    };
    
    [self showType:viewType payload:payload text:text ok:ok callback:callback];
    
}

- (void) showType1:(int)viewType payload:(NSDictionary*)payload text:(NSString*)text ok:(NSString*)ok {
    
    // 正式会员不需要
    if (QDConfigManager.shared.activeModel.member_type == 1) return;
    
    if (![payload objectForKey:@"awardTime"]) return;
    long time = [payload[@"awardTime"] longValue];
    if (time > INT_MAX) time = INT_MAX;
    if (time < 3600) time = 3600;
    
    
    OperateResultCallBack callback = ^(NSString *item) {
        if ([item isEqualToString:ok]) {
            
            [QDTrackManager track_button:QDTrackButtonType_37];
            
            [QDModelManager requestUserAddTimeNew:4 time:(int)time completed:^(NSDictionary * _Nonnull dictionary) {
                QDBaseResultModel* result1 = [QDBaseResultModel mj_objectWithKeyValues:dictionary];
                                
                if (result1.code == kHttpStatusCode200) {
                    
                    // 刷新用户信息
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserChange object:nil];
                    NSString* rewardTime = [QDDateUtils formatTimeWithSeconds:time];
                    NSString* toast = [NSString stringWithFormat:NSLocalizedString(@"Toast_Reward", nil), rewardTime];
                    [SVProgressHUD showErrorWithStatus:toast];
                } else {
                    [SVProgressHUD showErrorWithStatus:result1.message];
                }
            }];
        }
    };
    
    [self showType:viewType payload:payload text:text ok:ok callback:callback];
}

- (void) showType2:(int)viewType payload:(NSDictionary*)payload text:(NSString*)text ok:(NSString*)ok {
    
    if (![payload objectForKey:@"promotionID"]) return;
    NSString* productId = payload[@"promotionID"];
    
    if ([QDConfigManager.shared.activeModel.set_meal isEqualToString:Year_Subscribe_Name]||[QDConfigManager.shared.activeModel.set_meal isEqualToString:productId]) return;
    
    OperateResultCallBack callback = ^(NSString *item) {
        if ([item isEqualToString:ok]) {
            [QDTrackManager track_button:QDTrackButtonType_37];
            [QDReceiptManager.shared transaction_new:productId completion:^(BOOL success) {
            }];
        }
    };
    
    [self showType:viewType payload:payload text:text ok:ok callback:callback];
}

- (void) showType3:(int)viewType payload:(NSDictionary*)payload text:(NSString*)text ok:(NSString*)ok {
    
    OperateResultCallBack callback = ^(NSString *item) {
        if ([item isEqualToString:ok]) {
            [QDTrackManager track_button:QDTrackButtonType_37];
            [QDVersionManager.shared check:NO];
        }
    };
    
    [self showType:viewType payload:payload text:text ok:ok callback:callback];
}

- (void) showType4:(int)viewType payload:(NSDictionary*)payload text:(NSString*)text ok:(NSString*)ok {
    int feedbackType = 0;
    if ([payload objectForKey:@"feedbackType"]) {
        feedbackType = [payload[@"feedbackType"] intValue];
    }
    NSString* link = nil;
    if (feedbackType == 1) {
        if (![payload objectForKey:@"link"]) return;
        link = payload[@"link"];
        NSString* http = @"http";
        if (![link hasPrefix:http]) {
            link = [NSString stringWithFormat:@"https://%@", link];
        }
    }
    
    OperateResultCallBack callback = ^(NSString *item) {
        if ([item isEqualToString:ok]) {
            [QDTrackManager track_button:QDTrackButtonType_37];
            if (feedbackType == 1) {
                [UIUtils openURLWithString:link];
            } else {
                [UIUtils sendMail:@"vpnletgo@gmail.com"];
            }
        }
    };
    
    [self showType:viewType payload:payload text:text ok:ok callback:callback];
}

- (void) showType5:(int)viewType payload:(NSDictionary*)payload text:(NSString*)text ok:(NSString*)ok {
    if (![payload objectForKey:@"link_appid"]) return;
    NSString* appid = payload[@"link_appid"];
    
    OperateResultCallBack callback = ^(NSString *item) {
        if ([item isEqualToString:ok]) {
            [QDTrackManager track_button:QDTrackButtonType_37];
            // 请求appinfo
            [SVProgressHUD show];
            [QDHTTPManager.shared request:HTTPMethodTypeGet url:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", appid] parameters:@{} completed:^(NSDictionary * _Nonnull dictionary) {
                [SVProgressHUD dismiss];
                if (!dictionary || [dictionary[@"resultCount"] integerValue] <= 0) {
                    NSLog(@"dictionary = %@", dictionary);
                    return;
                }
                NSString* trackViewUrl = [dictionary[@"results"][0] objectForKey:@"trackViewUrl"];
                [UIUtils openURLWithString:trackViewUrl];
            }];
        }
    };
    
    [self showType:viewType payload:payload text:text ok:ok callback:callback];
}

@end
