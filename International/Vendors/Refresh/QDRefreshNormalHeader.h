//
//  CSLYRefreshNormalHeader.h
//
//  Created by hzg on 2021/5/24.
//

#import "MJRefreshStateHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface QDRefreshNormalHeader : MJRefreshStateHeader

@property (weak, nonatomic, readonly) UIImageView *arrowView;
@property (weak, nonatomic, readonly) UIActivityIndicatorView *loadingView;


/** 菊花的样式 */
@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle MJRefreshDeprecated("first deprecated in 3.2.2 - Use `loadingView` property");

@property (assign, nonatomic) BOOL showBack;

@end

NS_ASSUME_NONNULL_END
