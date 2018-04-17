//
//  YLT_WeChatPay.m
//  FastCoding
//
//  Created by 项普华 on 2018/4/17.
//

#import "YLT_WeChatPay.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "YLT_PayOrder.h"

@interface YLT_WeChatPay()<WXApiDelegate> {
}

/**
 订单信息
 */
@property (nonatomic, strong) YLT_PayOrder *payOrder;

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
- (BOOL)ylt_orderInvalid:(YLT_PayOrder *)order {
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
    _payOrder = order;
    _complation = complation;
    YLT_MAIN(^{
        if ([WXApi registerApp:self.payOrder.credential[@"appid"]]) {
            NSDictionary *result = self.payOrder.credential;
            PayReq *req = [[PayReq alloc] init];
            req.partnerId = result[@"partnerid"];
            req.prepayId = result[@"prepayid"];
            req.nonceStr = result[@"noncestr"];
            req.timeStamp = (UInt32)[result[@"timestamp"] integerValue];
            req.package = result[@"package"];
            req.sign = result[@"sign"];
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
