//
//  QDLineButtonView.h
//  International
//
//  Created by hzg on 2021/6/8.
//  Copyright © 2021 com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NodeClickBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface QDLineButtonView : UIView

- (instancetype) initWithFrame:(CGRect)frame clickBlock:(NodeClickBlock) block;

// 更新节点
- (void) updateNode:(QDNodeModel*)model;

- (void) updateNode:(QDNodeModel*)model selectLines:(BOOL)select;

@property (nonatomic, strong) UIColor * nodeColor;
@property (nonatomic, strong) UIColor * descColor;
@property (nonatomic, copy) NSString * imageName;

@end

NS_ASSUME_NONNULL_END
