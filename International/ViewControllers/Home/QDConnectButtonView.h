//
//  QDConnectButtonView.h
//  International
//
//  Created by hzg on 2021/6/8.
//  Copyright © 2021 com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ConnectButtonStatus) {
    status_button_connecting,
    status_button_connect,
    status_button_connected,
    status_button_disconnected,
    status_button_disconnecting,
    status_button_fail,
    status_button_loading,
};

typedef void(^ClickBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface QDConnectButtonView : UIView

- (instancetype) initWithFrame:(CGRect)frame clickBlock:(ClickBlock) block;
- (void) updateUI;
- (void) updateUIStatus:(ConnectButtonStatus)status;
- (void)makeAnimation;

@end

NS_ASSUME_NONNULL_END
