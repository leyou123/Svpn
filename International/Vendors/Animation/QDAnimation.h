//
//  QDAnimation.h
//  International
//
//  Created by LC on 2022/7/5.
//  Copyright © 2022 com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    MoveAnimation,
    RotateAnimation,
    ZoomAnimation,
} AnimationType;

NS_ASSUME_NONNULL_BEGIN

@interface QDAnimation : NSObject

- (CABasicAnimation *)moveFromValue:(CGPoint)from toValue:(CGPoint)to duration:(CGFloat)duration repeat:(int)count;

- (CABasicAnimation *)rotateFromValue:(CGFloat)from toValue:(CGFloat)to duration:(CGFloat)duration repeat:(int)count;

- (CABasicAnimation *)zoomFromValue:(CGFloat)from toValue:(CGFloat)to duration:(CGFloat)duration repeat:(int)count;

- (CALayer *)animationWithGroup:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
