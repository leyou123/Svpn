//
//  CSLYPushViewHelper.h
//  StormVPN
//
//  Created by hzg on 2021/11/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QDPushViewManager : NSObject

+ (QDPushViewManager *) shared;

// 随机推送弹窗视图
- (void) popRandomView;

@end

NS_ASSUME_NONNULL_END
