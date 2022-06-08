//
//  QDConnectSuccessView.h
//  International
//
//  Created by LC on 2022/4/25.
//  Copyright © 2022 com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger {
    StatusConnect,
    StatusRate,
    StatusRateResult,
} Status;

typedef void(^FeedbackCallBack)(void);
typedef void(^ShareCallBack)(void);

NS_ASSUME_NONNULL_BEGIN

@interface QDConnectSuccessView : UIView

@property (nonatomic, copy) FeedbackCallBack feedbackCallback;

@property (nonatomic, copy) ShareCallBack shareCallback;

@property (nonatomic, assign) Status status;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)updateTime:(long)times;

@end

NS_ASSUME_NONNULL_END
