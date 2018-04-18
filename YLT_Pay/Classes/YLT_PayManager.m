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


#define PAY_WXPAY @"YLT_WeChatPayOrder"
#define PAY_UNIONPAY @"YLT_UnionPayOrder"
#define PAY_ALIPAY @"YLT_AliPayOrder"
#define PAY_APPLE @"YLT_ApplePayOrder"
#define PAY_IAP @"YLT_IapPayOrder"

@interface YLT_PayManager()

/**
 支付渠道信息
 */
@property (nonatomic, strong) NSDictionary *channelInfo;

/**
 回调
 */
@property (nonatomic, copy) void(^complation)(id response, YLT_PayError *error);

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
 检验订单信息的有效性
 
 @param order 订单信息
 @return 有效性 YES:有效  NO:无效
 */
- (BOOL)ylt_orderInvalid:(YLT_PayOrder *)order {
    //订单参数异常
    if (order == nil) {
        self.complation(@"订单参数异常", [YLT_PayErrorUtils create:YLT_PayCodeErrorParams]);
        return NO;
    }
    //支付渠道不存在
    if (![self.channelInfo.allKeys containsObject:NSStringFromClass([order class])]) {
        self.complation(order, [YLT_PayErrorUtils create:YLT_PayCodeInvalidChannel]);
        return NO;
    }
    
    //支付参数的校验 粗略校验，非常规范的校验 在每个支付方式里面单独校验
    if (![YLT_PayErrorUtils invalidOrderInfo:order complation:self.complation]) {
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
    
    //找不到依附的VC
    if (targetVC == nil) {
        targetVC = self.ylt_currentVC;
        if (targetVC == nil) {
            complation(order, [YLT_PayErrorUtils create:YLT_PayCodeTargetIsNil]);
            return;
        }
    }
    
    self.payOrder = order;
    self.complation = complation;
    
    //基础参数校验
    if (![self ylt_orderInvalid:self.payOrder]) {
        return;
    }
    
    id<YLT_PayProtocol> pay = [self.channelInfo objectForKey:NSStringFromClass([self.payOrder class])];
    if (pay == nil) {
        complation(_payOrder, [YLT_PayErrorUtils create:YLT_PayCodeInvalidChannel]);
        return;
    }
    //针对每种支付方式单独校验
    if (![pay ylt_orderInvalid:self.payOrder]) {
        return;
    }
    
    @try {
        [pay ylt_payOrder:self.payOrder targetVC:targetVC complation:complation];
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
    return [[self.channelInfo objectForKey:NSStringFromClass([self.payOrder class])] ylt_handleOpenURL:url options:options];
}

@end
