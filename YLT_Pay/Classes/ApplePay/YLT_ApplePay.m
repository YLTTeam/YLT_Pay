//
//  YLT_ApplePay.m
//  FastCoding
//
//  Created by 项普华 on 2018/4/17.
//

#import "YLT_ApplePay.h"
#import "YLT_ApplePayOrder.h"
#import <PassKit/PassKit.h>

@interface YLT_ApplePay()<PKPaymentAuthorizationViewControllerDelegate> {
}

/**
 订单信息
 */
@property (nonatomic, strong) YLT_ApplePayOrder *payOrder;

/**
 回调
 */
@property (nonatomic, copy) void(^complation)(id response, YLT_PayError *error);

@end

@implementation YLT_ApplePay

/**
 检验订单信息的有效性
 
 @param order 订单信息
 @return 有效性 YES:有效  NO:无效
 */
- (BOOL)ylt_orderInvalid:(YLT_ApplePayOrder *)order {
    if (![order isKindOfClass:[YLT_ApplePayOrder class]]) {
        self.complation(order, [YLT_PayErrorUtils create:YLT_PayCodeErrorParams]);
        return NO;
    }
    if (order.items.count == 0 || !order.merchantIdentifier.ylt_isValid) {
        self.complation(order, [YLT_PayErrorUtils create:YLT_PayCodeErrorParams]);
        return NO;
    }
    return YES;
}

/**
 调用支付
 
 @param order 订单信息
 @param targetVC 目标VC
 @param complation 回调
 */
- (void)ylt_payOrder:(YLT_ApplePayOrder *)order
            targetVC:(UIViewController *)targetVC
          complation:(void(^)(id response, YLT_PayError *error))complation {
    self.complation = complation;
    if (@available(iOS 10.0, *)) {
        YLT_MAIN((^ {
            //检查用户是否可进行某种卡的支付，是否支持Amex、MasterCard、Visa与银联四种卡，根据自己项目的需要进行检测
            NSArray *supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard,PKPaymentNetworkVisa,PKPaymentNetworkChinaUnionPay];//判断用户是否绑定了支付卡
            if (![PKPaymentAuthorizationViewController canMakePayments] || ![PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:supportedNetworks]) {
                self.complation(order, [YLT_PayErrorUtils create:YLT_PayCodeErrorCall]);
                return ;
            }
            if (![self ylt_orderInvalid:self.payOrder]) {
                self.complation(order, [YLT_PayErrorUtils create:YLT_PayCodeErrorParams]);
                return;
            }
            self.payOrder = order;
            
            PKPaymentRequest *request = [[PKPaymentRequest alloc] init];
            request.requiredShippingAddressFields = PKAddressFieldNone;
            request.paymentSummaryItems = order.items;
            request.currencyCode = NSLocaleCurrencyCode;
            request.countryCode = NSLocaleCountryCode;
            request.merchantIdentifier = self.payOrder.merchantIdentifier;
            request.merchantCapabilities = PKMerchantCapability3DS | PKMerchantCapabilityEMV | PKMerchantCapabilityCredit | PKMerchantCapabilityDebit;
            request.supportedNetworks = @[PKPaymentNetworkChinaUnionPay];//支持的结算网关
            PKPaymentAuthorizationViewController *vc = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
            vc.delegate = self;
            [targetVC presentViewController:vc animated:YES completion:nil];
        }));
    } else {
        YLT_LogError(@"iOS 10 以下系统不支持");
    }
}

#pragma mark - Delegate

/** 地址信息 */
//-(void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didSelectShippingContact:(PKContact *)contact completion:(void (^)(PKPaymentAuthorizationStatus, NSArray<PKShippingMethod *> * _Nonnull, NSArray<PKPaymentSummaryItem *> * _Nonnull))completion  API_AVAILABLE(ios(9.0)) API_AVAILABLE(ios(9.0)) API_AVAILABLE(ios(9.0)){
//    YLT_Log(@"didSelectShippingContact");
//}

//- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
//                   didSelectShippingMethod:(PKShippingMethod *)shippingMethod
//                                completion:(void (^)(PKPaymentAuthorizationStatus, NSArray<PKPaymentSummaryItem *> * _Nonnull))completion {
//    YLT_Log(@"didSelectShippingMethod");
//}

- (void)paymentAuthorizationViewControllerWillAuthorizePayment:(PKPaymentAuthorizationViewController *)controller {
    YLT_Log(@"paymentAuthorizationViewControllerWillAuthorizePayment");
}

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus))completion {
    if (self.payOrder.callback(self.payOrder, payment.token)) {
        YLT_MAINDelay(3, ^{
            self.complation(self.payOrder, [YLT_PayErrorUtils create:YLT_PaySuccess]);
            completion(PKPaymentAuthorizationStatusSuccess);
        });
    }
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    [controller dismissViewControllerAnimated:controller completion:NULL];
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

@end
