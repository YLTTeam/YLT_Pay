//
//  YLT_IapPay.m
//  FastCoding
//
//  Created by 项普华 on 2018/4/17.
//

#import "YLT_IapPay.h"
#import "YLT_IapPayOrder.h"
#import <StoreKit/StoreKit.h>

@interface YLT_IapPay()<SKPaymentTransactionObserver, SKProductsRequestDelegate, SKRequestDelegate> {
}

/**
 订单信息
 */
@property (nonatomic, strong) YLT_IapPayOrder *payOrder;

/**
 回调
 */
@property (nonatomic, copy) void(^complation)(id response, YLT_PayError *error);

/**
 支付状态的处理
 */
@property (nonatomic, strong) SKPaymentTransaction *paymentTransaction;

@end

@implementation YLT_IapPay

/**
 检验订单信息的有效性
 
 @param order 订单信息
 @return 有效性 YES:有效  NO:无效
 */
- (BOOL)ylt_orderInvalid:(YLT_IapPayOrder *)order {
    return YES;
}

/**
 调用支付
 
 @param order 订单信息
 @param targetVC 目标VC
 @param complation 回调
 */
- (void)ylt_payOrder:(YLT_IapPayOrder *)order
            targetVC:(UIViewController *)targetVC
          complation:(void(^)(id response, YLT_PayError *error))complation {
    self.complation = complation;
    
    if (![SKPaymentQueue canMakePayments]) {
        self.complation(order, [YLT_PayErrorUtils create:YLT_PayCodeErrorCall]);
        return ;
    }
    if (order.isReceipt) {//恢复购买模式
        self.payOrder = order;
        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
        return;
    }
    
    if (![self ylt_orderInvalid:order]) {
        self.complation(order, [YLT_PayErrorUtils create:YLT_PayCodeErrorParams]);
        return;
    }
    self.payOrder = order;
    //添加观察
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    NSMutableArray *items = [NSMutableArray new];
    [self.payOrder.items enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [items addObject:key];
    }];
    NSSet *products = [NSSet setWithArray:items];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:products];
    request.delegate = self;
    [request start];
}

/**
 支付结果的回调
 
 @param url 回调的URL
 @param options 可选参数
 @return 回调结果
 */
- (BOOL)ylt_handleOpenURL:(NSURL *)url
                  options:(NSDictionary *)options {
    return YES;
}

#pragma mark - SKPaymentTransactionObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing: {//购买进行中
            }
                break;
            case SKPaymentTransactionStateDeferred: {//状态待确认
            }
                break;
            case SKPaymentTransactionStateRestored: {//恢复购买成功
                self.complation(transaction.transactionIdentifier, [YLT_PayErrorUtils create:YLT_PaySuccess]);
            }
                break;
            case SKPaymentTransactionStatePurchased: {//购买成功
                self.complation(transaction.transactionIdentifier, [YLT_PayErrorUtils create:YLT_PaySuccess]);
            }
                break;
            case SKPaymentTransactionStateFailed: {//购买失败
                self.complation(transaction.transactionIdentifier, [YLT_PayErrorUtils create:YLT_PayFailed]);
            }
                break;
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray<SKDownload *> *)downloads {
}

- (BOOL)paymentQueue:(SKPaymentQueue *)queue shouldAddStorePayment:(SKPayment *)payment forProduct:(SKProduct *)product {
    return YES;
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    if (response.products.count == 0) {
        self.complation(self.payOrder, [YLT_PayErrorUtils create:YLT_PayCodeErrorParams]);
        return;
    }
    NSMutableArray *products = [NSMutableArray new];
    
    for (SKProduct *pro in response.products) {
        [products addObject:pro];
        SKMutablePayment *payment = [[SKMutablePayment alloc] init];
        payment.quantity = [self.payOrder.items[pro.productIdentifier] integerValue];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}

#pragma mark - SKRequestDelegate

- (void)requestDidFinish:(SKRequest *)request {
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
}

- (void)dealloc {
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

@end
