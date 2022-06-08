//
//  QDLineHeaderView.h
//  International
//
//  Created by hzg on 2021/6/30.
//  Copyright © 2021 com. All rights reserved.
//

#import <UIKit/UIKit.h>

// type类型： 0表示试用， 1表示vip
typedef void(^LineHeaderClickBlock)(int type);

NS_ASSUME_NONNULL_BEGIN

@interface QDLineHeaderView : UIView

- (instancetype) initWithFrame:(CGRect)frame clickBlock:(LineHeaderClickBlock) block;

@end

NS_ASSUME_NONNULL_END
