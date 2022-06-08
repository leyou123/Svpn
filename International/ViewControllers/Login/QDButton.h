//
//  QDButton.h
//  International
//
//  Created by hzg on 2021/9/3.
//  Copyright © 2021 com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface QDButton : UIControl

- (instancetype) initWithFrame:(CGRect)frame title:(NSString*)title clickBlock:(ClickBlock) block;

@property(nonatomic, assign) BOOL isButtonEnabled;

@end

NS_ASSUME_NONNULL_END
