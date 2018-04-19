//
//  YLT_AliPay.m
//  FastCoding
//
//  Created by 项普华 on 2018/4/17.
//

#import "YLT_AliPay.h"
#import <AlipaySDK/AlipaySDK.h>
#import "YLT_AliPayOrder.h"

@interface YLT_AliPay() {
}

/**
 订单信息
 */
@property (nonatomic, strong) YLT_AliPayOrder *payOrder;

/**
 回调
 */
@property (nonatomic, copy) void(^complation)(id response, YLT_PayError *error);

@end

@implementation YLT_AliPay

- (BOOL)ylt_orderInvalid:(YLT_AliPayOrder *)order {
    if (![order isKindOfClass:[YLT_AliPayOrder class]]) {
        self.complation(order, [YLT_PayErrorUtils create:YLT_PayCodeErrorParams]);
        return NO;
    }
    if (!order.sign.ylt_isValid) {
        self.complation(order, [YLT_PayErrorUtils create:YLT_PayCodeErrorParams]);
        return NO;
    }
    return YES;
}

- (void)ylt_payOrder:(YLT_AliPayOrder *)order targetVC:(UIViewController *)targetVC complation:(void (^)(id, YLT_PayError *))complation {
    self.complation = complation;
    YLT_MAIN(^{
        if (![self ylt_orderInvalid:order]) {
            return ;
        }
        self.payOrder = order;
        
        __weak typeof(self) weakSelf = self;
        [[AlipaySDK defaultService] payOrder:self.payOrder.sign fromScheme:(self.payOrder.scheme.ylt_isValid?self.payOrder.scheme:@"") callback:^(NSDictionary *resultDic) {
            __strong typeof(weakSelf) self = weakSelf;
            [self handleDictionary:resultDic];
        }];
    });
}

- (BOOL)ylt_handleOpenURL:(NSURL *)url options:(NSDictionary *)options {
    if ([url.host isEqualToString:@"safepay"] || [url.host isEqualToString:@"platformapi"]) {//支付宝回调
        __weak typeof(self) weakSelf = self;
        //这个是进程KILL掉之后也会调用，这个只是第一次授权回调，同时也会返回支付信息
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            __strong typeof(weakSelf) self = weakSelf;
            [self handleDictionary:resultDic];
        }];
        //跳转支付宝钱包进行支付，处理支付结果，这个只是辅佐订单支付结果回调
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            __strong typeof(weakSelf) self = weakSelf;
            [self handleDictionary:resultDic];
        }];
    }
    return YES;
}


#pragma mark - 私有方法

- (void)handleDictionary:(NSDictionary *)result {
    switch ([result[@"resultStatus"] integerValue]) {
        case 9000:
            self.complation(self.payOrder, [YLT_PayErrorUtils create:YLT_PaySuccess]);
            break;
        case 4000:
            self.complation(self.payOrder, [YLT_PayErrorUtils create:YLT_PayFailed]);
            break;
        case 6001:
            self.complation(self.payOrder, [YLT_PayErrorUtils create:YLT_PayCodeCanceled]);
            break;
        case 8000:
        case 6002:
        case 6004:
            self.complation(self.payOrder, [YLT_PayErrorUtils create:YLT_PayCodeErrorUnknown]);
            break;
        default:
            self.complation(self.payOrder, [YLT_PayErrorUtils create:YLT_PayCodeErrorUnknown]);
            break;
    }
}

@end
