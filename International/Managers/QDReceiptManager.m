//
//  ReceiptHelper.m
//  vpn
//
//  Created by hzg on 2020/12/31.
//

#import "QDReceiptManager.h"
#import "QDReceiptResultModel.h"
#import "QDOrderResultModel.h"
#import "QDAdManager.h"

static NSString *const kReceiptKey = @"receipt";

@interface QDReceiptManager()

@end

@implementation QDReceiptManager

+ (QDReceiptManager *) shared {
    static dispatch_once_t onceToken;
    static QDReceiptManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [QDReceiptManager new];
        [instance setup];
    });
    return instance;
}

- (void) setup {
    _localPriceDictionary = [NSMutableDictionary new];
}

// 更新产品信息
- (void) updateProduct:(NSArray<NSString*>*)productIds completion:(void(^)(void)) completion {
    [self requestVerifyProduct:productIds completion:^(NSArray *products) {
        if (products&&products.count > 0) {
            for (SKProduct* product in products) {
                self.localPriceDictionary[product.productIdentifier] = product;
            }
        }
        completion();
    }];
}

// 请求确认产品信息
- (void) requestVerifyProduct:(NSArray<NSString*>*)productIds completion:(void(^)(NSArray* arr)) completion {
    [[RMStore defaultStore] requestProducts:[NSSet setWithArray:productIds] success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(products);
            });
        } failure:^(NSError *error) {
            NSLog(@"error = %@", error.localizedDescription);
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(@[]);
            });
    }];
}

// 请求创建订单信息
- (void) requestCreateOrder:(NSString*)productId transactionId:(NSString*)transactionId completed:(void (^)(NSDictionary *dictionary)) completed {

    [self requestVerifyProduct:@[productId] completion:^(NSArray *products) {
        if (products&&products.count > 0) {
            
            SKProduct* product = products.firstObject;
            NSNumberFormatter*numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
            numberFormatter.currencyDecimalSeparator = @".";
            numberFormatter.currencySymbol=@"";
            [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            [numberFormatter setLocale:product.priceLocale];
            NSString* price = [numberFormatter stringFromNumber:product.price];
            NSString* currencySymbol = product.priceLocale.currencySymbol;
            [QDModelManager requestCreateOrder:price money_unit:currencySymbol transaction_id:transactionId completed:^(NSDictionary * _Nonnull dictionary) {
                completed(dictionary);
            }];
        } else {
            completed(@{@"code":@(kHttpStatusCode400)});
        }
    }];
}

// 生成订单
- (void) generateOrder:(NSString*)productId transactionId:(NSString*)transactionIdentifier completion:(void(^)(BOOL success)) completion {
    // 订单生成
    [SVProgressHUD showWithStatus:NSLocalizedString(@"VIPCreateOrding", nil)];
    [self requestCreateOrder:productId transactionId:transactionIdentifier completed:^(NSDictionary * _Nonnull dictionary) {
        
        QDOrderResultModel* resultModel = [QDOrderResultModel mj_objectWithKeyValues:dictionary];
        
        NSString* message = NSLocalizedString(@"VIPCreateOrderSuccess", nil);
        if (resultModel.code == kHttpStatusCode200) {

            // 通知用户信息更新
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserChange object:nil];

        } else if (resultModel.code == kHttpStatusCode400) {
            message = NSLocalizedString(@"VIPCreateOrderFailed", nil);
        } else {
            message = resultModel.message;
        }
        [SVProgressHUD showWithStatus:message];
        [SVProgressHUD dismissWithDelay:HUDDISMISSTIME];
        NSLog(@"code = %d, transactionIdentifier = %@, message = %@", resultModel.code, transactionIdentifier, message);
        completion(resultModel.code == kHttpStatusCode200);
        QDAdManager.shared.forbidAd = NO;

    }];
}

# pragma mark - public methods
- (void) transaction_new:(NSString *)productId completion:(void(^)(BOOL success)) completion {
    [SVProgressHUD showWithStatus:NSLocalizedString(@"VIPPaying", nil)];
    [self requestVerifyProduct:@[productId] completion:^(NSArray *arr) {
        [[RMStore defaultStore] addPayment:productId success:^(SKPaymentTransaction *transaction) {
            [self generateOrder:productId transactionId:transaction.transactionIdentifier completion:completion];
            } failure:^(SKPaymentTransaction *transaction, NSError *error) {
                NSLog(@"error = %@", error.localizedDescription);
                [SVProgressHUD showWithStatus:NSLocalizedString(@"PayFailed", nil)];
                [SVProgressHUD dismissWithDelay:HUDDISMISSTIME];
                completion(NO);
            }];
    }];
}

// 交易
- (void) transaction:(NSString*)productId completion:(void(^)(BOOL success)) completion {
    [SVProgressHUD showWithStatus:NSLocalizedString(@"VIPPaying", nil)];
    [[RMStore defaultStore] addPayment:productId success:^(SKPaymentTransaction *transaction) {
        [self generateOrder:productId transactionId:transaction.transactionIdentifier completion:completion];
        } failure:^(SKPaymentTransaction *transaction, NSError *error) {
            NSLog(@"error = %@", error.localizedDescription);
            [SVProgressHUD showWithStatus:NSLocalizedString(@"PayFailed", nil)];
            [SVProgressHUD dismissWithDelay:HUDDISMISSTIME];
            completion(NO);
        }];
}

// 恢复交易
- (void) restore:(void(^)(BOOL success)) completion {
    [QDModelManager requestRestoreOrders:^(NSDictionary * _Nonnull dictionary) {
        QDBaseResultModel* resultModel = [QDBaseResultModel mj_objectWithKeyValues:dictionary];
        
        NSString* message = NSLocalizedString(@"VIPRestoreSuccess", nil);
        if (resultModel.code == kHttpStatusCode200) {

            // 通知用户信息更新
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserChange object:nil];

        } else {
            message = resultModel.message;
        }
        completion(resultModel.code == kHttpStatusCode200);
    }];
}

@end
