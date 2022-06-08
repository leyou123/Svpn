//
//  YJAnimateUtils.h
//  vpn
//
//  Created by hzg on 2021/4/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YJAnimateUtils : NSObject

+(CABasicAnimation *)fadeAnimationForever:(float)time;
+(CABasicAnimation *)rotateAnimationForever;
+(CABasicAnimation *)translateAnimationForever:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

@end

NS_ASSUME_NONNULL_END
