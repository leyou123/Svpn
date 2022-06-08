//
//  QDConnectStatusView.h
//  International
//
//  Created by LC on 2022/4/20.
//  Copyright © 2022 com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ConnectStatus) {
    status_connecting,
    status_connect,
    status_connected,
    status_disconnected,
    status_disconnecting,
    status_fail
};

NS_ASSUME_NONNULL_BEGIN

@interface QDConnectStatusView : UIView

-(void)updateConnectStatus;
-(void)updateConnectStatus:(ConnectStatus)status;

@end

NS_ASSUME_NONNULL_END
