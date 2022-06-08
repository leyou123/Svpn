//
//  LineTableViewBaseCell.m
//  vpn
//
//  Created by hzg on 2021/1/9.
//

#import "QDLineTableViewBaseCell.h"

@implementation QDLineTableViewBaseCell

+ (UIImage*) getDelayImage:(int)weights {
    NSString* imageNamed = @"line_speed_slow1";
    if (weights >= 60) {
        imageNamed = @"line_speed_normal";
    } else if (weights > 0) {
        imageNamed = @"line_speed_slow";
    }
    return [UIImage imageNamed:imageNamed];
}

@end
