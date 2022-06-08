//
//  QDTimeView3.m
//  International
//
//  Created by LC on 2022/4/19.
//  Copyright © 2022 com. All rights reserved.
//

#import "QDTimeView3.h"
#import "QDTimerManager.h"

@interface QDTimeView3()

@property (nonatomic, strong) UILabel* timeLabel;

@property (nonatomic, assign) NSInteger totalTime;

@end

@implementation QDTimeView3

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup {
    // time label
    UILabel* timeLabel = [UILabel new];
    timeLabel.font = kSFUITextFont(22);
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:timeLabel];
    _timeLabel = timeLabel;
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
    }];
}

- (void) updateTime:(long)remainMins {
    [QDTimerManager shared].callBack = ^(NSInteger count) {
        long mins = remainMins - count;
        long d   = mins / (24*60*60);
        long h   = (mins - d * (24*60*60)) / 3600;
        long m   = (mins - d *(24*60*60) - h*60*60)/60;
        long s   = mins - d *(24*60*60) - h*60*60 - m*60;
        
        NSString * day    = @"---d";
        NSString * hour   = @"--h";
        NSString * minute = @"--min";
        NSString * second = @"00s";
        if (d >= 1) {
            day = [NSString stringWithFormat:@"%ldd",d];
            if (h >= 1) {
                hour = [NSString stringWithFormat:@"%02ldh",h];
                if (m >= 1) {
                    minute = [NSString stringWithFormat:@"%02ldmin",m];
                    if (s >= 1) {
                        second = [NSString stringWithFormat:@"%02lds",s];
                    }
                }else {
                    minute = @"00min";
                    if (s >= 1) {
                        second = [NSString stringWithFormat:@"%02lds",s];
                    }
                }
            }else {
                hour = @"00h";
                if (m >= 1) {
                    minute = [NSString stringWithFormat:@"%02ldmin",m];
                    if (s >= 1) {
                        second = [NSString stringWithFormat:@"%02lds",s];
                    }
                }else {
                    minute = @"00min";
                    if (s >= 1) {
                        second = [NSString stringWithFormat:@"%02lds",s];
                    }
                }
            }
        }else {
            if (h >= 1) {
                hour = [NSString stringWithFormat:@"%02ldh",h];
                if (m >= 1) {
                    minute = [NSString stringWithFormat:@"%02ldmin",m];
                    if (s >= 1) {
                        second = [NSString stringWithFormat:@"%02lds",s];
                    }
                }else {
                    minute = @"00min";
                    if (s >= 1) {
                        second = [NSString stringWithFormat:@"%02lds",s];
                    }
                }
            }else {
                hour = @"00h";
                if (m >= 1) {
                    minute = [NSString stringWithFormat:@"%02ldmin",m];
                    if (s >= 1) {
                        second = [NSString stringWithFormat:@"%02lds",s];
                    }
                }else {
                    minute = @"00min";
                    if (s >= 1) {
                        second = [NSString stringWithFormat:@"%02lds",s];
                    }
                }
            }
        }
        
        NSString * timeString = [NSString stringWithFormat:@"%@:%@:%@:%@",day,hour,minute,second];
        self.timeLabel.attributedText = [self getAttributeWithString:timeString attributeArray:@[@"d",@"h",@"min",@"s"]];
    };
}

- (NSMutableAttributedString *)getAttributeWithString:(NSString *)string attributeArray:(NSArray *)arr {
    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc] initWithString:string];
    for (NSString * text in arr) {
        NSRange range = [string rangeOfString:text];
        [attributeString addAttributes:@{NSFontAttributeName:kSFUIDisplayFont(12)} range:range];
    }
    [attributeString addAttributes:@{NSKernAttributeName:@(1)} range:NSMakeRange(0, [string length]-3)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length]-3)];
    return attributeString;
}


@end
