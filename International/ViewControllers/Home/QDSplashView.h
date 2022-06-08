//
//  QDSplashView.h
//  International
//
//  Created by hzg on 2021/9/6.
//  Copyright © 2021 com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickBlock)(void);

NS_ASSUME_NONNULL_BEGIN

// 启动页
@interface QDSplashView : UIView

@property (nonatomic, copy) ClickBlock callback;

@end

NS_ASSUME_NONNULL_END

