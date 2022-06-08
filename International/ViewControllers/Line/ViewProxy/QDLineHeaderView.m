//
//  QDLineHeaderView.m
//  International
//
//  Created by hzg on 2021/6/30.
//  Copyright © 2021 com. All rights reserved.
//

#import "QDLineHeaderView.h"

@interface QDLineHeaderView()

@end

@implementation QDLineHeaderView

- (instancetype) initWithFrame:(CGRect)frame clickBlock:(LineHeaderClickBlock) block {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup:frame clickBlock:block];
    }
    return self;
}

- (void) setup:(CGRect)frame clickBlock:(LineHeaderClickBlock)block {
    self.backgroundColor = [UIColor redColor];
}


@end
