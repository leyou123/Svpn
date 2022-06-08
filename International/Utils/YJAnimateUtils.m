//
//  YJAnimateUtils.m
//  vpn
//
//  Created by hzg on 2021/4/12.
//

#import "YJAnimateUtils.h"

@implementation YJAnimateUtils


//永久闪烁的动画
+(CABasicAnimation *)fadeAnimationForever:(float)time {
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue= [NSNumber numberWithFloat:1.0];
    animation.toValue= [NSNumber numberWithFloat:0.0];
    animation.autoreverses=YES;
    animation.duration=time;
    animation.repeatCount=FLT_MAX;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    return animation;
}

+(CABasicAnimation *)rotateAnimationForever {
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 0.8;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = FLT_MAX;
    rotationAnimation.removedOnCompletion = NO;
    return rotationAnimation;
}

+(CABasicAnimation *)translateAnimationForever:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    CABasicAnimation* animation;
    animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fillMode    = kCAFillModeForwards;
    animation.fromValue = [NSValue valueWithCGPoint:startPoint];
    animation.toValue = [NSValue valueWithCGPoint:endPoint];
    animation.duration     = 0.8;
    animation.autoreverses = YES;
    animation.repeatCount  = FLT_MAX;
    animation.removedOnCompletion = NO;
    return animation;
}

@end
