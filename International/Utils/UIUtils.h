//
//  UIUtils.h
//
//  Created by hzg on 2021/6/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIUtils : NSObject

// $2.99 $8.99..
+ (void) showMoney:(UILabel*)label subcribePrice:(NSString*)subcribePrice subcribeName:(NSString*)subcribeName format:(NSString*)format;

// price
+ (void)showMoney:(UILabel*)label subcribePrice:(NSString*)subcribePrice subcribeName:(NSString*)subcribeName;

// Then %@ per month
+ (void) showThenBillingPerMonth:(UILabel*)label;

// $%@/MONTH
+ (void) showBillingPerMonth:(UILabel*)label;

// Then %@ per year
+ (void) showThenBillingPerYear:(UILabel*)label;

// $%@/YEAR
+ (void) showBillingPerYear:(UILabel*)label;

// Save #%@ now
+ (void) showSaveMoneyWithYear:(UILabel*)label;

// Save %0.2f%%・%@/mo
+ (void) showSaveMoneyWithQuarterDetail:(UILabel*)label;
// Save %0.2f%%・%@/mo
+ (void) showSaveMoneyWithHalfYearDetail:(UILabel*)label;
// Save %0.2f%%・%@/mo
+ (void) showSaveMoneyWithYearDetail:(UILabel*)label;

// show note
+ (void) showNote:(UILabel*)label;

// show title
+ (void) showAppTitle:(UILabel*)label;

// 邮箱验证
+ (BOOL)isValidateEmail:(NSString *)email;

// 纯数字验证
+ (BOOL) isPureInt:(NSString *)str;

// 分享
+ (void) shareApp:(UIViewController*) vc view:(UIView*)showViewForPad;

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC;

// 调转url
+ (void) openURLWithString:(NSString*)url;

// send mail
+ (void) sendMail:(NSString*) email;

// 圆角
+ (CAShapeLayer *)getRectCorner:(UIView *)view corners:(UIRectCorner)corners radii:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
