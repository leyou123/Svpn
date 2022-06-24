//
//  QDDialogManager.m
//  vpn
//
//  Created by hzg on 2020/12/21.
//

#import "QDDialogManager.h"
#import "UIUtils.h"

@implementation QDDialogManager


+ (UIAlertController*) show:(NSString*)title message:(NSString*)message ok:(NSString*)okText cancel:(NSString*)cancelText okBlock:(OKBlock)okBlock cancelBlock:(OKBlock)cancelBlock {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (cancelText) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelText style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            cancelBlock();
        }];
        [cancelAction setValue:APP_COLOR_DIALOG_CANCEL forKey:@"titleTextColor"];
        [alert addAction:cancelAction];
    }
    
    if (okText) {
        UIAlertAction *okAction= [UIAlertAction actionWithTitle:okText style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            okBlock();
        }];
        [okAction setValue:APP_COLOR_BLACK forKey:@"titleTextColor"];
        [alert addAction:okAction];
    }
    
//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:^{
//    }];
    
    UIViewController* vc = [UIUtils getCurrentVC];
    
    NSLog(@"****************%@",vc);
    
    [vc presentViewController:alert animated:NO completion:nil];
    
    return alert;
}

// 显示VIP到期了
+ (void) showVIPExpired:(OKBlock)okBlock {
    [self show:@"" message:NSLocalizedString(@"Dialog_Premium_Expired", nil) ok:NSLocalizedString(@"Dialog_BeVip", nil) cancel:NSLocalizedString(@"Dialog_Cancel", nil) okBlock:^{
        okBlock();
    } cancelBlock:^{
        
    }];
}

// 显示对话框
+ (void) showDialog:(NSString*)title message:(NSString*)message ok:(NSString*)okText cancel:(NSString*)cancelText okBlock:(OKBlock)okBlock cancelBlock:(OKBlock)cancelBlock {
    [self show:title message:message ok:okText cancel:cancelText okBlock:^{
        okBlock();
    } cancelBlock:^{
        cancelBlock();
    }];
}

// 显示版本更新
+ (void) showVersionUpdate:(NSString*)title message:(NSString*)message ok:(NSString*)okText cancel:(NSString*)cancelText okBlock:(OKBlock)okBlock cancelBlock:(OKBlock)cancelBlock {
    UIAlertController* alert = [self show:title message:message ok:okText cancel:cancelText okBlock:^{
        okBlock();
    } cancelBlock:^{
        cancelBlock();
    }];
    
    NSArray* arr1 = alert.view.subviews;
    if (!arr1 || arr1.count == 0) return;
    UIView* subView = arr1[0];
    for (int i = 1; i < 5; i++) {
        NSArray* arr2 = subView.subviews;
        if (!arr2 || arr2.count == 0) return;
        subView = arr2[0];
    }
    NSArray* arr3 = subView.subviews;
    if (!arr3 || arr3.count < 3) return;
    
    UILabel *message1 = subView.subviews[2];
    if ([message1 isKindOfClass:[UILabel class]])
        message1.textAlignment = NSTextAlignmentLeft;
}

+ (void) showItemsDialog:(UIViewController*)vc title:(NSString*)title message:(NSString*)message actionItems:(NSArray<NSString*>*) items callback:(DialogCallback)callback {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    for (NSString* item in items) {
        UIAlertAction *action= [UIAlertAction actionWithTitle:item style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            callback(action.title);
        }];
        if ([item isEqual:NSLocalizedString(@"Dialog_Cancel", nil)]) {
            [action setValue:APP_COLOR_DIALOG_CANCEL forKey:@"titleTextColor"];
        }
        [alert addAction:action];
    }

    [vc presentViewController:alert animated:YES completion:^{
    }];
}

+ (void) showInputAlert:(NSString*)title message:(NSString*)message text:(NSString*)text  placeHolder:(NSString*)placeHolder ok:(NSString*)okText cancel:(NSString*)cancelText okBlock:(DialogCallback)okBlock cancelBlock:(OKBlock)cancelBlock {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = text;
        textField.placeholder = placeHolder;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    
    if (cancelText) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelText style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            cancelBlock();
        }];
        [cancelAction setValue:APP_COLOR_DIALOG_CANCEL forKey:@"titleTextColor"];
        [alert addAction:cancelAction];
    }
    
    if (okText) {
        __weak typeof(alert) weakAlert = alert;
        UIAlertAction *okAction= [UIAlertAction actionWithTitle:okText style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            okBlock(weakAlert.textFields.firstObject.text);
        }];
        [okAction setValue:APP_COLOR_BLACK forKey:@"titleTextColor"];
        [alert addAction:okAction];
    }
    
//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:^{
//    }];
    
    UIViewController* vc = [UIUtils getCurrentVC];
    [vc presentViewController:alert animated:NO completion:nil];
}

@end
