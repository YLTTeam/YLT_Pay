//
//  YLT_WeChatPay.m
//  FastCoding
//
//  Created by 项普华 on 2018/4/17.
//

#import "YLT_WeChatPay.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "YLT_WeChatPayOrder.h"

@interface YLT_WeChatPay()<WXApiDelegate> {
}

/**
 订单信息
 */
@property (nonatomic, strong) YLT_WeChatPayOrder *payOrder;

/**
 回调
 */
@property (nonatomic, copy) void(^complation)(id response, YLT_PayError *error);

@end

@implementation YLT_WeChatPay

/**
 检验订单信息的有效性
 
 @param order 订单信息
 @return 有效性 YES:有效  NO:无效
 */
- (BOOL)ylt_orderInvalid:(YLT_WeChatPayOrder *)order {
    if (![order isKindOfClass:[YLT_WeChatPayOrder class]]) {
        self.complation(order, [YLT_PayErrorUtils create:YLT_PayCodeErrorParams]);
        return NO;
    }
    if (!order.partnerId.ylt_isValid) {
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
- (void)ylt_payOrder:(YLT_WeChatPayOrder *)order
            targetVC:(UIViewController *)targetVC
          complation:(void(^)(id response, YLT_PayError *error))complation {
    self.complation = complation;
    YLT_MAIN(^{
        if (![self ylt_orderInvalid:order]) {
            return;
        }
        self.payOrder = order;
        if ([WXApi registerApp:self.payOrder.appId]) {
            PayReq *req = [[PayReq alloc] init];
            req.partnerId = self.payOrder.partnerId;
            req.prepayId = self.payOrder.prepayId;
            req.nonceStr = self.payOrder.nonceStr;
            req.timeStamp = self.payOrder.timeStamp;
            req.package = self.payOrder.package;
            req.sign = self.payOrder.sign;
            [WXApi sendReq:req];
        }
        else {
            self.complation(self.payOrder, [YLT_PayErrorUtils create:YLT_PayCodeWxRegisterFailed]);
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
    if ([url.host isEqualToString:@"pay"]) {
        [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

#pragma mark - 私有方法

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        switch (resp.errCode) {
            case WXSuccess: {
                self.complation(self.payOrder, [YLT_PayErrorUtils create:YLT_PaySuccess]);
            }
                break;
            case WXErrCodeUserCancel: {
                self.complation(self.payOrder, [YLT_PayErrorUtils create:YLT_PayCodeCanceled]);
            }
                break;
            case WXErrCodeSentFail: {
                self.complation(self.payOrder, [YLT_PayErrorUtils create:YLT_PayFailed]);
            }
                break;
            default: {
                self.complation(self.payOrder, [YLT_PayErrorUtils create:YLT_PayCodeErrorUnknown]);
            }
                break;
        }
    }
}

- (void)onReq:(BaseReq *)req {
}

@end
