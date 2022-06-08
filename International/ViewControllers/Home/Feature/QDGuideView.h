//
//  QDGuideView.h
//
//  Created by hzg on 2021/5/14.
//

#import <UIKit/UIKit.h>

typedef void(^GuideFinishCallback)(void);

@interface QDGuideView : UIView
@property (nonatomic, strong) UIColor *pageControlCurrentColor; /**< 指示器选中颜色 默认greenColor */
@property (nonatomic, strong) UIColor *pageControlNomalColor;   /**< 指示器颜色 默认whiteColor */
@property (nonatomic, assign) BOOL pageControlHidden;           /**< 指示器隐藏 默认NO */
@property (nonatomic, assign) BOOL enterButtonHidden;           /**< 进入按钮隐藏 默认NO 如果隐藏就在最后一页左滑进入 */
@property (nonatomic, copy) GuideFinishCallback callback;

+ (instancetype)showGuide:(GuideFinishCallback)callback;

@end
