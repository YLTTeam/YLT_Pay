//
//  YLT_PayProtocol.h
//  FastCoding
//
//  Created by 项普华 on 2018/4/17.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YLT_PayOrder.h"
#import "YLT_PayError.h"

#define PAY_WXPAY @"wxpay"
#define PAY_UNIONPAY @"unionpay"
#define PAY_ALIPAY @"alipay"
#define PAY_APPLE @"applepay"
#define PAY_IAP @"iappay"

@protocol YLT_PayProtocol <NSObject>

/**
 检验订单信息的有效性

 @param order 订单信息
 @return 有效性 YES:有效  NO:无效
 */
- (BOOL)ylt_orderInvalid:(YLT_PayOrder *)order;

/**
 调用支付

 @param order 订单信息
 @param targetVC 目标VC
 @param complation 回调
 */
- (void)ylt_payOrder:(YLT_PayOrder *)order
            targetVC:(UIViewController *)targetVC
          complation:(void(^)(id response, YLT_PayError *error))complation;

/**
 支付结果的回调

 @param url 回调的URL
 @param options 可选参数
 @return 回调结果
 */
- (BOOL)ylt_handleOpenURL:(NSURL *)url
                  options:(NSDictionary *)options;

@end
