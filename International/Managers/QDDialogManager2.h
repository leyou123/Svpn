//
//  QDDialogManager2.h
//  International
//
//  Created by hzg on 2022/1/13.
//  Copyright © 2022 com. All rights reserved.
//

#import <Foundation/Foundation.h>

// 操作结果回调
typedef void(^OperateResultCallBack)(NSString* item);

//NS_ASSUME_NONNULL_BEGIN

@interface QDDialogManager2 : NSObject

// 单例
+ (QDDialogManager2 *) shared;

// 显示操作框 (count < 2)
- (void) show:(NSString*)title message:(NSString*)message items:(NSArray<NSString*>*)items hideWhenTouchOutside:(BOOL) hideWhenTouchOutside cancel:(NSString*)cancel callback:(OperateResultCallBack)callback;
// 显示操作框
- (void) show:(NSString*)title message:(NSString*)message items:(NSArray<NSString*>*)items backImages:(NSArray *)images  hideWhenTouchOutside:(BOOL) hideWhenTouchOutside cancel:(NSString*)cancel callback:(OperateResultCallBack)callback;

- (void) showTelegram:(NSString*)message
    items:(NSArray<NSString*>*)items
    hideWhenTouchOutside:(BOOL)hideWhenTouchOutside
    cancel:(NSString*)cancel
             callback:(OperateResultCallBack)callback;

- (void) showFeedback:(BOOL)hideWhenTouchOutside callback:(void (^)(NSString *email, NSString* content)) callback;

- (void) showTemplate1:(NSString*)message image:(NSString*)imageUrl items:(NSArray<NSString*>*)items hideWhenTouchOutside:(BOOL) hideWhenTouchOutside cancel:(NSString*)cancel callback:(OperateResultCallBack)callback;

@end


#define QDDialogView QDDialogManager2.shared
