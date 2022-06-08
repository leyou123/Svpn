//
//  QDDialogManager.h
//  vpn
//
//  Created by hzg on 2020/12/21.
//

#import <Foundation/Foundation.h>

typedef void(^OKBlock)(void);
typedef void(^DialogCallback)(NSString* itemName);

@interface QDDialogManager : NSObject

// 显示VIP过期
+ (void) showVIPExpired:(OKBlock)okBlock;

// 显示版本更新
+ (void) showVersionUpdate:(NSString*)title message:(NSString*)message ok:(NSString*)okText cancel:(NSString*)cancelText okBlock:(OKBlock)okBlock cancelBlock:(OKBlock)cancelBlock;

// 显示对话框
+ (void) showDialog:(NSString*)title message:(NSString*)message ok:(NSString*)okText cancel:(NSString*)cancelText okBlock:(OKBlock)okBlock cancelBlock:(OKBlock)cancelBlock;

// 显示多条
+ (void) showItemsDialog:(UIViewController*)vc title:(NSString*)title message:(NSString*)message actionItems:(NSArray<NSString*>*) items callback:(DialogCallback)callback;

// 密码输入框
+ (void) showInputAlert:(NSString*)title message:(NSString*)message text:(NSString*)text placeHolder:(NSString*)placeHolder ok:(NSString*)okText cancel:(NSString*)cancelText okBlock:(DialogCallback)okBlock cancelBlock:(OKBlock)cancelBlock;

@end

