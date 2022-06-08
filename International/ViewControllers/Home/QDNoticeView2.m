//
//  QDNoticeView2.m
//  International
//
//  Created by LC on 2022/4/20.
//  Copyright © 2022 com. All rights reserved.
//

#import "QDNoticeView2.h"

@implementation QDNoticeView2

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    UIImageView * noticeIv = [[UIImageView alloc] init];
    noticeIv.image = [UIImage imageNamed:@"home_notice"];
    [self addSubview:noticeIv];
    [noticeIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.width.height.equalTo(self);
    }];
    
    UILabel * countLB = [[UILabel alloc] init];
    countLB.textColor = [UIColor whiteColor];
    countLB.backgroundColor = RGB_HEX(0xF04646);
    countLB.font = kFont(10);
    countLB.layer.cornerRadius = 7;
    countLB.layer.masksToBounds = YES;
    countLB.textAlignment = NSTextAlignmentCenter;
    countLB.text = @"··";
    [noticeIv addSubview:countLB];
    [countLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(noticeIv.mas_bottom).offset(-8);
        make.right.equalTo(noticeIv.mas_right).offset(-7);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
}

- (void)updateNoticeCount {
    
}

@end
