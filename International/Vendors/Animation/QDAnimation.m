//
//  QDAnimation.m
//  International
//
//  Created by LC on 2022/7/5.
//  Copyright © 2022 com. All rights reserved.
//

#import "QDAnimation.h"

@interface QDAnimation()

@end

@implementation QDAnimation

- (CABasicAnimation *)moveFromValue:(CGPoint)from toValue:(CGPoint)to duration:(CGFloat)duration repeat:(int)count {
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.beginTime = CACurrentMediaTime();
    animation.duration = duration;
    animation.repeatCount = count;
    animation.fromValue = [NSValue valueWithCGPoint:from];
    animation.toValue = [NSValue valueWithCGPoint:to];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

- (CABasicAnimation *)rotateFromValue:(CGFloat)from toValue:(CGFloat)to duration:(CGFloat)duration repeat:(int)count {
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.beginTime = CACurrentMediaTime();
    animation.duration = duration;
    animation.repeatCount = count;
    animation.fromValue = @(from);
    animation.toValue = @(to);
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

- (CABasicAnimation *)zoomFromValue:(CGFloat)from toValue:(CGFloat)to duration:(CGFloat)duration repeat:(int)count {
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.beginTime = CACurrentMediaTime();
    animation.duration = duration;
    animation.repeatCount = count;
    animation.fromValue = @(from);
    animation.toValue = @(to);
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

- (CALayer *)animationWithGroup:(UIView *)view {
    CALayer * layer = [CALayer layer];
    NSInteger repeatCount = 3;
    NSInteger keepTiming = 3;
    
    for (int i = 0; i < repeatCount; i++) {
        CALayer * animationLayer = [CALayer layer];
        animationLayer.borderColor = RGB_HEX(0x13c3f8).CGColor;
        animationLayer.borderWidth = 1;
        
        animationLayer.frame = view.bounds;
        animationLayer.cornerRadius = view.bounds.size.width/2;
        
        CABasicAnimation * baseAni = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        baseAni.fromValue = @1.0;
        baseAni.toValue = @1.5;
        
        CAKeyframeAnimation * keyAni = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        
        keyAni.values = @[@1,@0.9,@0.8,@0.7,@0.6,@0.5,@0.4,@0.3,@0.2,@0.1,@0];
        keyAni.keyTimes = @[@0,@0.1,@0.2,@0.3,@0.4,@0.5,@0.6,@0.7,@0.8,@0.9,@1];
        
        CAAnimationGroup * group = [CAAnimationGroup animation];
        group.fillMode = kCAFillModeBackwards;
        group.duration = keepTiming;
        group.repeatCount = HUGE;
        group.beginTime = CACurrentMediaTime()+i*keepTiming/repeatCount;
        group.removedOnCompletion = NO;
        
        group.animations = @[keyAni, baseAni];
        [animationLayer addAnimation:group forKey:@"plue"];
        [layer addSublayer:animationLayer];
    }
    return layer;
}

@end
