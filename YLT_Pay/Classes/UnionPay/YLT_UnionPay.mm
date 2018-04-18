//
//  YLT_UnionPay.m
//  FastCoding
//
//  Created by 项普华 on 2018/4/17.
//

#import "YLT_UnionPay.h"
#import "UPPaymentControl.h"
#import "YLT_UnionPayOrder.h"

@interface YLT_UnionPay () {
}

/**
 订单信息
 */
@property (nonatomic, strong) YLT_UnionPayOrder *payOrder;

/**
 回调
 */
@property (nonatomic, copy) void(^complation)(id response, YLT_PayError *error);

@end

@implementation YLT_UnionPay

/**
 检验订单信息的有效性
 
 @param order 订单信息
 @return 有效性 YES:有效  NO:无效
 */
- (BOOL)ylt_orderInvalid:(YLT_UnionPayOrder *)order {
    if (![order isKindOfClass:[YLT_UnionPayOrder class]]) {
        self.complation(order, [YLT_PayErrorUtils create:YLT_PayCodeErrorParams]);
        return NO;
    }
    if (!order.tn.ylt_isValid) {
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
- (void)ylt_payOrder:(YLT_UnionPayOrder *)order
            targetVC:(UIViewController *)targetVC
          complation:(void(^)(id response, YLT_PayError *error))complation {
    self.complation = complation;
    YLT_MAIN(^{
        if ([self ylt_orderInvalid:order]) {
            return ;
        }
        self.payOrder = order;
        BOOL isSuccess = [[UPPaymentControl defaultControl] startPay:self.payOrder.tn fromScheme:self.payOrder.scheme mode:self.payOrder.mode viewController:targetVC];
        if (!isSuccess) {
            self.complation(self.payOrder, [YLT_PayErrorUtils create:YLT_PayCodeErrorCall]);
        }
    });
}

/**
 支付结果的回调
 
 @param url 回调的URL
 @param options 可选参数
 @return 回调结果
 */
- (BOOL)ylt_handleOpenURL:(NSURL *)url
                  options:(NSDictionary *)options {
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        if ([code isEqualToString:@"success"]) {
            self.complation(self.payOrder, [YLT_PayErrorUtils create:YLT_PaySuccess]);
        }
        else if ([code isEqualToString:@"fail"]) {
            self.complation(self.payOrder, [YLT_PayErrorUtils create:YLT_PayFailed]);
        }
        else if ([code isEqualToString:@"cancel"]) {
            self.complation(self.payOrder, [YLT_PayErrorUtils create:YLT_PayCodeCanceled]);
        }
        else {
            self.complation(self.payOrder, [YLT_PayErrorUtils create:YLT_PayCodeErrorUnknown]);
        }
    }];
    return YES;
}

@end
