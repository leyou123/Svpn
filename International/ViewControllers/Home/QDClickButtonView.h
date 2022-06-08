//
//  QDClickButtonView.h
//  International
//
//  Created by LC on 2022/4/19.
//  Copyright © 2022 com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickAction)(void);

typedef void(^WatchAdAction)(void);

NS_ASSUME_NONNULL_BEGIN

@interface QDClickButtonView : UIView

- (instancetype)initWithFrame:(CGRect)frame image:(NSString *)imageName text:(NSString *)text attributeString:(NSString *)atring Action:(ClickAction)action;

@property (nonatomic, copy) ClickAction action;

@property (nonatomic, copy) WatchAdAction watch;

@property (nonatomic, copy) NSString * title;

@end

NS_ASSUME_NONNULL_END
