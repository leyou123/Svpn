//
//  QDCheckBoxButton.h
//  International
//
//  Created by hzg on 2022/1/10.
//  Copyright © 2022 com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 复选框
@interface QDCheckBoxButton : UIView

- (instancetype)initWithFrame:(CGRect)frame text:(NSString*)text;

@property(nonatomic, assign) BOOL isSelected;
@property(nonatomic, strong) NSString* text;

@end

NS_ASSUME_NONNULL_END
