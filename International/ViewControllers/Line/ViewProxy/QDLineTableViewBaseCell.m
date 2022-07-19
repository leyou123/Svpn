//
//  LineTableViewBaseCell.m
//  vpn
//
//  Created by hzg on 2021/1/9.
//

#import "QDLineTableViewBaseCell.h"

@implementation QDLineTableViewBaseCell

+ (UIImage*) getDelayImage:(int)weights {
    NSString* imageNamed = @"line_speed_bad";
    if (weights >= 60) {
        imageNamed = @"line_speed_normal";
    } else if (weights > 0) {
        imageNamed = @"line_speed_slow";
    }
    return [UIImage imageNamed:imageNamed];
}

// 根据ping结果，来判断拥挤
+ (UIImage*) getSpeedImage:(int)pingResult {
    NSString* imageNamed;
    if (pingResult == 1) {
        imageNamed = @"line_speed_normal";
    }else {
        imageNamed = @"line_speed_more_slow";
    }
    return [UIImage imageNamed:imageNamed];
}

@end
