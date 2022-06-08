//
//  QDGetPremiumView.h
//  International
//
//  Created by LC on 2022/4/20.
//  Copyright © 2022 com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickActionBlock)(NSInteger);

NS_ASSUME_NONNULL_BEGIN

@interface QDGetPremiumView : UIView

- (instancetype)initWithFrame:(CGRect)frame leftImage:(NSString *)imageName title:(NSString *)title clickAction:(ClickActionBlock)block;

- (instancetype)initWithFrame:(CGRect)frame clickAction:(ClickActionBlock)block;

- (void)updateStatus;

@end

NS_ASSUME_NONNULL_END
