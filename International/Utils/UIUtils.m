//
//  UIUtils.m
//
//  Created by hzg on 2021/6/23.
//

#import "UIUtils.h"
#import "QDReceiptManager.h"

@implementation UIUtils

+ (NSString*) formatProduct:(SKProduct*)product {
    NSNumberFormatter*numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    numberFormatter.currencyDecimalSeparator = @".";
    numberFormatter.currencySymbol=@"";
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:product.priceLocale];
    NSString* price = [numberFormatter stringFromNumber:product.price];
    NSString* currency = product.priceLocale.currencySymbol;
    if (price.length > 5) {
        if ([product.productIdentifier isEqual:Month_Subscribe_Name]
            || [product.productIdentifier isEqual:Month_Subscribe_Name_Free]) {
            return Month_Subscribe_Price;
        } else if ([product.productIdentifier isEqual:Quarter_Subscribe_Name]) {
            return Quarter_Subscribe_Price;
        } else if ([product.productIdentifier isEqual:HalfYear_Subscribe_Name]) {
            return HalfYear_Subscribe_Price;
        } else if ([product.productIdentifier isEqual:Year_Subscribe_Name]
                   || [product.productIdentifier isEqual:Year_Subscribe_Name_Free]) {
            return Year_Subscribe_Price;
        }else if ([product.productIdentifier isEqual:Week_Subscribe_Name]) {
           return Week_Subscribe_Price;
       }
    }
    return [NSString stringWithFormat:@"%@%@", currency, price];
}

// $2.99 $8.99..
+ (void) showMoney:(UILabel*)label subcribePrice:(NSString*)subcribePrice subcribeName:(NSString*)subcribeName format:(NSString*)format {
    label.text = [NSString stringWithFormat:format, subcribePrice];;
    SKProduct* product = QDReceiptManager.shared.localPriceDictionary[subcribeName];
    if (product) {
        NSString* price = [self formatProduct:product];
        label.text = [NSString stringWithFormat:format, price];
    } else {
        [QDReceiptManager.shared updateProduct:@[subcribeName] completion:^{
            SKProduct* product = QDReceiptManager.shared.localPriceDictionary[subcribeName];
            if (product) {
                NSString* price = [self formatProduct:product];
                label.text = [NSString stringWithFormat:format, price];
            } else {
                label.text = [NSString stringWithFormat:format, subcribePrice];
            }
        }];
    }
}

// get price
+ (void)showMoney:(UILabel*)label subcribePrice:(NSString*)subcribePrice subcribeName:(NSString*)subcribeName {
    label.text = subcribePrice;
    SKProduct* product = QDReceiptManager.shared.localPriceDictionary[subcribeName];
    if (product) {
        NSString* price = [self formatProduct:product];
        label.text = price;
    } else {
        [QDReceiptManager.shared updateProduct:@[subcribeName] completion:^{
            SKProduct* product = QDReceiptManager.shared.localPriceDictionary[subcribeName];
            if (product) {
                NSString* price = [self formatProduct:product];
                label.text = price;
            } else {
                label.text = subcribePrice;
            }
        }];
    }
}

// Then %@ per month
+ (void) showThenBillingPerMonth:(UILabel*)label {
    label.text = [NSString stringWithFormat:NSLocalizedString(@"VIPPrice1", nil), Month_Subscribe_Price];
    SKProduct* product = QDReceiptManager.shared.localPriceDictionary[Month_Subscribe_Name];
    if (product) {
        NSString* price = [self formatProduct:product];
        label.text = [NSString stringWithFormat:NSLocalizedString(@"VIPPrice1", nil), price];
    } else {
        [QDReceiptManager.shared updateProduct:@[Month_Subscribe_Name] completion:^{
            SKProduct* product = QDReceiptManager.shared.localPriceDictionary[Month_Subscribe_Name];
            if (product) {
                NSString* price = [self formatProduct:product];
                label.text = [NSString stringWithFormat:NSLocalizedString(@"VIPPrice1", nil), price];
            } else {
                label.text = [NSString stringWithFormat:NSLocalizedString(@"VIPPrice1", nil), Month_Subscribe_Price];
            }
        }];
    }
}

+ (void) showBillingPerMonth:(UILabel*)label {
    label.text = [NSString stringWithFormat:NSLocalizedString(@"VIPPrice2", nil), Month_Subscribe_Price];
    SKProduct* product = QDReceiptManager.shared.localPriceDictionary[Month_Subscribe_Name];
    if (product) {
        NSString* price = [self formatProduct:product];
        label.text = [NSString stringWithFormat:NSLocalizedString(@"VIPPrice2", nil), price];
    } else {
        [QDReceiptManager.shared updateProduct:@[Month_Subscribe_Name] completion:^{
            SKProduct* product = QDReceiptManager.shared.localPriceDictionary[Month_Subscribe_Name];
            if (product) {
                NSString* price = [self formatProduct:product];
                label.text = [NSString stringWithFormat:NSLocalizedString(@"VIPPrice2", nil), price];
            } else {
                label.text = [NSString stringWithFormat:NSLocalizedString(@"VIPPrice2", nil), Month_Subscribe_Price];
            }
        }];
    }
}



// Then %@ per week
+ (void) showThenBillingPerWeek:(UILabel*)label {
    label.text = [NSString stringWithFormat:NSLocalizedString(@"VIPPriceL21", nil), Week_Subscribe_Price];
    SKProduct* product = QDReceiptManager.shared.localPriceDictionary[Week_Subscribe_Name];
    if (product) {
        NSString* price = [self formatProduct:product];
        label.text = [NSString stringWithFormat:NSLocalizedString(@"VIPPriceL21", nil), price];
    } else {
        [QDReceiptManager.shared updateProduct:@[Week_Subscribe_Name] completion:^{
            SKProduct* product = QDReceiptManager.shared.localPriceDictionary[Week_Subscribe_Name];
            if (product) {
                NSString* price = [self formatProduct:product];
                label.text = [NSString stringWithFormat:NSLocalizedString(@"VIPPriceL21", nil), price];
            } else {
                label.text = [NSString stringWithFormat:NSLocalizedString(@"VIPPriceL21", nil), Week_Subscribe_Price];
            }
        }];
    }
}

+ (void) showBillingPerWeek:(UILabel*)label {
    label.text = [NSString stringWithFormat:NSLocalizedString(@"VIPPriceL22", nil), Week_Subscribe_Price];
    SKProduct* product = QDReceiptManager.shared.localPriceDictionary[Week_Subscribe_Name];
    if (product) {
        NSString* price = [self formatProduct:product];
        label.text = [NSString stringWithFormat:NSLocalizedString(@"VIPPriceL22", nil), price];
    } else {
        [QDReceiptManager.shared updateProduct:@[Week_Subscribe_Name] completion:^{
            SKProduct* product = QDReceiptManager.shared.localPriceDictionary[Week_Subscribe_Name];
            if (product) {
                NSString* price = [self formatProduct:product];
                label.text = [NSString stringWithFormat:NSLocalizedString(@"VIPPriceL22", nil), price];
            } else {
                label.text = [NSString stringWithFormat:NSLocalizedString(@"VIPPriceL22", nil), Week_Subscribe_Price];
            }
        }];
    }
}


+ (void) showThenBillingPerYear:(UILabel*)label {
    label.text = [NSString stringWithFormat:NSLocalizedString(@"VIPPrice31", nil), Year_Subscribe_Price];
    SKProduct* product = QDReceiptManager.shared.localPriceDictionary[Year_Subscribe_Name];
    if (product) {
        NSString* price = [self formatProduct:product];
        label.text = [NSString stringWithFormat:NSLocalizedString(@"VIPPrice31", nil), price];
    } else {
        [QDReceiptManager.shared updateProduct:@[Year_Subscribe_Name] completion:^{
            SKProduct* product = QDReceiptManager.shared.localPriceDictionary[Year_Subscribe_Name];
            if (product) {
                NSString* price = [self formatProduct:product];
                label.text = [NSString stringWithFormat:NSLocalizedString(@"VIPPrice31", nil), price];
            } else {
                label.text = [NSString stringWithFormat:NSLocalizedString(@"VIPPrice31", nil), Year_Subscribe_Price];
            }
        }];
    }
}

+ (void) showBillingPerYear:(UILabel*)label {
    label.text = [NSString stringWithFormat:NSLocalizedString(@"VIPPrice3", nil), Year_Subscribe_Price];
    SKProduct* product = QDReceiptManager.shared.localPriceDictionary[Year_Subscribe_Name];
    if (product) {
        NSString* price = [self formatProduct:product];
        label.text = [NSString stringWithFormat:NSLocalizedString(@"VIPPrice3", nil), price];
    } else {
        [QDReceiptManager.shared updateProduct:@[Year_Subscribe_Name] completion:^{
            SKProduct* product = QDReceiptManager.shared.localPriceDictionary[Year_Subscribe_Name];
            if (product) {
                NSString* price = [self formatProduct:product];
                label.text = [NSString stringWithFormat:NSLocalizedString(@"VIPPrice3", nil), price];
            } else {
                label.text = [NSString stringWithFormat:NSLocalizedString(@"VIPPrice3", nil), Year_Subscribe_Price];
            }
        }];
    }
}

// Save #%@ now
+ (void) showSaveMoneyWithYear:(UILabel*)label {
    
    // default
    double avg_month = Year_Subscribe_Price_Value/12;
    double discount  = (Month_Subscribe_Price_Value - avg_month) * 100 / Month_Subscribe_Price_Value;
    label.text = [NSString stringWithFormat:NSLocalizedString(@"VIPPrice4", nil), discount];
    [label setHidden:avg_month >= Month_Subscribe_Price_Value];
    
    // fact
    SKProduct* product = QDReceiptManager.shared.localPriceDictionary[Year_Subscribe_Name];
    SKProduct* monthProduct = QDReceiptManager.shared.localPriceDictionary[Month_Subscribe_Name];
    if (product&&monthProduct&&product.price.doubleValue < 1000000) {
        double avg_month = product.price.doubleValue/12;
        double discount  = (monthProduct.price.doubleValue - avg_month) * 100 / monthProduct.price.doubleValue;
        label.text = [NSString stringWithFormat:NSLocalizedString(@"VIPPrice4", nil), discount];
        [label setHidden:avg_month >= monthProduct.price.doubleValue];
    } else {
        [QDReceiptManager.shared updateProduct:@[Month_Subscribe_Name, Year_Subscribe_Name] completion:^{
            SKProduct* product = QDReceiptManager.shared.localPriceDictionary[Year_Subscribe_Name];
            SKProduct* monthProduct = QDReceiptManager.shared.localPriceDictionary[Month_Subscribe_Name];
            if (product&&monthProduct&&product.price.doubleValue < 1000000) {
                double avg_month = product.price.doubleValue/12;
                double discount  = (monthProduct.price.doubleValue - avg_month) * 100 / monthProduct.price.doubleValue;
                label.text = [NSString stringWithFormat:NSLocalizedString(@"VIPPrice4", nil), discount];
                [label setHidden:avg_month >= monthProduct.price.doubleValue];
            } else {
                double avg_month = Year_Subscribe_Price_Value/12;
                double discount  = (Month_Subscribe_Price_Value - avg_month) * 100 / Month_Subscribe_Price_Value;
                label.text = [NSString stringWithFormat:NSLocalizedString(@"VIPPrice4", nil), discount];
                [label setHidden:avg_month >= Month_Subscribe_Price_Value];
            }
        }];
    }
}

// Save %0.2f%%・%@/mo
+ (void) showSaveMoneyDetail:(UILabel *)label subscribeName:(NSString*)subscribeName price:(double)price months:(int)months {
    
    // default
    double avg_month = price / months;
    double discount  = (Month_Subscribe_Price_Value - avg_month) * 100 / Month_Subscribe_Price_Value;
    label.text = [NSString stringWithFormat:NSLocalizedString(@"VIPPrice5", nil), discount, [NSString stringWithFormat:@"$%0.2f", avg_month]];
    [label setHidden:YES];
    
    // fact
    SKProduct* product = QDReceiptManager.shared.localPriceDictionary[subscribeName];
    SKProduct* monthProduct = QDReceiptManager.shared.localPriceDictionary[Month_Subscribe_Name];
    if (product&&monthProduct&&product.price.doubleValue < 1000000) {
        double avg_month = product.price.doubleValue/months;
        double discount  = (monthProduct.price.doubleValue - avg_month) * 100 / monthProduct.price.doubleValue;
        label.text = [NSString stringWithFormat:NSLocalizedString(@"VIPPrice5", nil), discount, [NSString stringWithFormat:@"%@%0.2f", product.priceLocale.currencySymbol, avg_month]];
        [label setHidden:avg_month >= monthProduct.price.doubleValue];
    } else {
        [QDReceiptManager.shared updateProduct:@[Month_Subscribe_Name, subscribeName] completion:^{
            SKProduct* product = QDReceiptManager.shared.localPriceDictionary[subscribeName];
            SKProduct* monthProduct = QDReceiptManager.shared.localPriceDictionary[Month_Subscribe_Name];
            if (product&&monthProduct&&product.price.doubleValue < 1000000) {
                double avg_month = product.price.doubleValue/months;
                double discount  = (monthProduct.price.doubleValue - avg_month) * 100 / monthProduct.price.doubleValue;
                label.text = [NSString stringWithFormat:NSLocalizedString(@"VIPPrice5", nil), discount, [NSString stringWithFormat:@"%@%0.2f", product.priceLocale.currencySymbol, avg_month]];
                [label setHidden:avg_month >= monthProduct.price.doubleValue];
            } else {
                double discount  = (Month_Subscribe_Price_Value - avg_month) * 100 / Month_Subscribe_Price_Value;
                label.text = [NSString stringWithFormat:NSLocalizedString(@"VIPPrice5", nil), discount, [NSString stringWithFormat:@"$%0.2f", avg_month]];
                [label setHidden:avg_month >= Month_Subscribe_Price_Value];
            }
        }];
    }
}

// Save %0.2f%%・%@/mo
+ (void) showSaveMoneyWithQuarterDetail:(UILabel*)label {
    [self showSaveMoneyDetail:label subscribeName:Quarter_Subscribe_Name price:Quarter_Subscribe_Price_Value months:3];
}

// Save %0.2f%%・%@/mo
+ (void) showSaveMoneyWithHalfYearDetail:(UILabel*)label {
    [self showSaveMoneyDetail:label subscribeName:HalfYear_Subscribe_Name price:HalfYear_Subscribe_Price_Value months:6];
}

// Save %0.2f%%・%@/mo
+ (void) showSaveMoneyWithYearDetail:(UILabel*)label {
    [self showSaveMoneyDetail:label subscribeName:Year_Subscribe_Name price:Year_Subscribe_Price_Value months:12];
}

// show note
+ (void) showNote:(UILabel*)label {
    NSString* noteText = NSLocalizedString(@"VIPNoteText", nil);
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = RGB_HEX(0xb3b3b3);
    label.text = noteText;
    [label sizeToFit];
    
    SKProduct* product = QDReceiptManager.shared.localPriceDictionary[Year_Subscribe_Name];
    if (product) {
        NSString* price = [self formatProduct:product];
        label.text = [NSString stringWithFormat:noteText, price];
        [label sizeToFit];
    } else {
        [QDReceiptManager.shared updateProduct:@[Year_Subscribe_Name] completion:^{
            SKProduct* product = QDReceiptManager.shared.localPriceDictionary[Year_Subscribe_Name];
            if (product) {
                NSString* price = [self formatProduct:product];
                label.text = [NSString stringWithFormat:noteText, price];
            } else {
                label.text = [NSString stringWithFormat:noteText, Year_Subscribe_Price];
            }
            [label sizeToFit];
        }];
    }
}

+ (void)showAppTitle:(UILabel *)label {
    if (!QDConfigManager.shared.activeModel) return;
    NSString* title = NSLocalizedString(@"HomeTitleName", nil);
    NSString* type  = @"";
    NSDictionary *attrs = NULL;
    NSString * str = title;
//    NSString *str = @"";
//    switch (QDConfigManager.shared.activeModel.member_type) {
//        case 1:
//        {
//            type = NSLocalizedString(@"Premium", nil);
//            str = [NSString stringWithFormat:@"%@ %@", title, type];
//        }
//            break;
//        case 2:
//        case 4:
//        {
//            type = NSLocalizedString(@"Basic", nil);
//            str = [NSString stringWithFormat:@"%@ %@", title, type];
//            attrs = [NSDictionary dictionaryWithObjectsAndKeys:
//                     RGB_HEX(0xef44ac), NSForegroundColorAttributeName,nil];
//        }
//            break;
//        case 3:
//            str = [NSString stringWithFormat:@"%@%@", title, type];
//            break;
//        default:
//            break;
//    }

    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    if (attrs) {
        [attrStr addAttributes:attrs range:[str rangeOfString:type]];
    }
    label.attributedText = attrStr;
}

// 邮箱验证
+ (BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest =
    [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL) isPureInt:(NSString *)str {
   if (str.length == 0) {
        return NO;
    }
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}

// 分享
+ (void) shareApp:(UIViewController*) vc view:(UIView*)showViewForPad {
    
    NSString* code = @"";
    if (QDConfigManager.shared.activeModel) {
        code = QDConfigManager.shared.activeModel.code;
    }
    
    // 分享内容
    NSMutableArray *activityItems = [NSMutableArray array];
    UIImage *imageItem = [UIImage imageNamed:@"AppIcon"];
    NSString *textItem = [NSString stringWithFormat:NSLocalizedString(@"Share_Text", nil), code];
    NSURL *urlItem = [NSURL URLWithString:@"https://itunes.apple.com/us/app/id1490819262"];
    [activityItems addObject:textItem];
    [activityItems addObject:urlItem];
    [activityItems addObject:imageItem];
    
    // 分享页面
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    if (@available(iOS 11.0, *)) {//UIActivityTypeMarkupAsPDF是在iOS 11.0 之后才有的
        activityViewController.excludedActivityTypes = @[UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypeOpenInIBooks,UIActivityTypeMarkupAsPDF, UIActivityTypeSaveToCameraRoll,UIActivityTypePrint,UIActivityTypeAddToReadingList,UIActivityTypeAssignToContact];
    } else if (@available(iOS 9.0, *)) {//UIActivityTypeOpenInIBooks是在iOS 9.0 之后才有的
        activityViewController.excludedActivityTypes = @[UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypeOpenInIBooks, UIActivityTypeSaveToCameraRoll,UIActivityTypePrint,UIActivityTypeAddToReadingList,UIActivityTypeAssignToContact];
    }
    activityViewController.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            if ([activityType isEqual:UIActivityTypeCopyToPasteboard]) {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Copy_Success", nil)];
                return;
            }
            [QDTrackManager track:QDTrackType_share_success data:@{}];
            [QDDialogManager showItemsDialog:vc title:NSLocalizedString(@"Share_Success", nil) message:nil actionItems:@[NSLocalizedString(@"Dialog_Ok", nil)] callback:^(NSString *itemName) {
//                [vc dismissViewControllerAnimated:NO completion:nil];
            }];
        }
    };
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        activityViewController.popoverPresentationController.sourceView = showViewForPad;
        [vc presentViewController:activityViewController animated:YES completion:nil];
    } else {
        [vc presentViewController:activityViewController animated:YES completion:nil];
    }
}

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC {
    //下文中有分析
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC {
    UIViewController *currentVC;
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }

    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    
    return currentVC;
}

// 调转url
+ (void) openURLWithString:(NSString*)url {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
}

// send mail
+ (void) sendMail:(NSString*) email {
    NSString *openUrl = [NSString stringWithFormat:@"mailto:%@", email];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:openUrl] options:@{} completionHandler:nil];
}

+ (CAShapeLayer *)getRectCorner:(UIView *)view corners:(UIRectCorner)corners radii:(CGSize)size {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
    byRoundingCorners:corners cornerRadii:size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    return maskLayer;
}

@end
