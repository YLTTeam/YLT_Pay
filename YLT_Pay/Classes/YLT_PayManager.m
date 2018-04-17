//
//  YLT_PayManager.m
//  Pods-YLT_Pay_Example
//
//  Created by 项普华 on 2018/4/17.
//

#import "YLT_PayManager.h"
#import "YLT_AliPay.h"
#import "YLT_ApplePay.h"
#import "YLT_IapPay.h"
#import "YLT_UnionPay.h"
#import "YLT_WeChatPay.h"

@interface YLT_PayManager()

/**
 支付渠道信息
 */
@property (nonatomic, strong) NSDictionary *channelInfo;

/**
 订单信息
 */
@property (nonatomic, strong) YLT_PayOrder *payOrder;

@end

@implementation YLT_PayManager

YLT_ShareInstance(YLT_PayManager);

- (void)ylt_init {
    self.channelInfo = @{
                         PAY_UNIONPAY:[[YLT_UnionPay alloc] init],
                         PAY_WXPAY:[[YLT_WeChatPay alloc] init],
                         PAY_ALIPAY:[[YLT_AliPay alloc] init],
                         PAY_APPLE:[[YLT_ApplePay alloc] init],
                         PAY_IAP:[[YLT_IapPay alloc] init]
                         };
}

/**
 调用支付
 
 @param order 订单信息
 @param targetVC 目标VC
 @param complation 回调
 */
- (void)ylt_payOrder:(YLT_PayOrder *)order
            targetVC:(UIViewController *)targetVC
          complation:(void(^)(id response, YLT_PayError *error))complation {
    if (complation == nil) {
        complation = ^(id response, YLT_PayError *error) {
            if (error) {
                YLT_LogError(@"支付失败 %@ %@", response, error);
            } else {
            }
        };
    }
    //订单参数异常
    if (order == nil) {
        complation(@"订单参数异常", [YLT_PayErrorUtils create:YLT_PayCodeErrorParams]);
        return;
    }
    //支付渠道不存在
    if (![self.channelInfo.allKeys containsObject:order.channel]) {
        complation(order, [YLT_PayErrorUtils create:YLT_PayCodeInvalidChannel]);
        return;
    }
    //找不到依附的VC
    if (targetVC == nil) {
        targetVC = self.ylt_currentVC;
        if (targetVC == nil) {
            complation(order, [YLT_PayErrorUtils create:YLT_PayCodeTargetIsNil]);
            return;
        }
    }
    //支付参数的校验 粗略校验，非常规范的校验 在每个支付方式里面单独校验
    if (![YLT_PayErrorUtils invalidOrderInfo:order complation:complation]) {
        return;
    }
    
    _payOrder = order;
    id<YLT_PayProtocol> pay = [self.channelInfo objectForKey:_payOrder.channel];
    if (pay == nil) {
        complation(_payOrder, [YLT_PayErrorUtils create:YLT_PayCodeInvalidChannel]);
        return;
    }
    
    if (![pay ylt_orderInvalid:_payOrder]) {
        complation(_payOrder, [YLT_PayErrorUtils create:YLT_PayCodeErrorParams]);
        return;
    }
    
    @try {
        [pay ylt_payOrder:_payOrder targetVC:targetVC complation:complation];
    } @catch (NSException *e) {
    } @finally {
    }
}

/**
 支付结果的回调
 
 @param url 回调的URL
 @param options 可选参数
 */
- (BOOL)ylt_handleOpenURL:(NSURL *)url
                  options:(NSDictionary *)options {
    return [[self.channelInfo objectForKey:self.payOrder.channel] ylt_handleOpenURL:url options:options];
}

@end
