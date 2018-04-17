//
//  YLT_Error.h
//  FastCoding
//
//  Created by 项普华 on 2018/4/17.
//

#import <YLT_BaseLib/YLT_BaseLib.h>
#import "YLT_PayOrder.h"

typedef NS_ENUM(NSUInteger, YLT_PayCode) {
    YLT_PayCodeInvalidChannel,//渠道信息验证失败,支付方式不支持
    YLT_PayCodeErrorParams,//支付参数异常
    YLT_PayCodeErrorTimeOut,//请求超时
    YLT_PayCodeTargetIsNil,//TARGET 为空
    YLT_PayCodeErrorConnection,//链接异常
    YLT_PayCodeErrorCall,//调起支付方式失败
    
    //取消支付
    YLT_PayCodeCanceled,
    //支付成功
    YLT_PaySuccess,
    //支付失败
    YLT_PayFailed,
    
    //微信未安装
    YLT_PayCodeWxNoInstalled,
    //微信appid注册失败
    YLT_PayCodeWxRegisterFailed,
    
    //未知异常
    YLT_PayCodeErrorUnknown,
};

@interface YLT_PayError : YLT_BaseModel

@property (nonatomic, assign) YLT_PayCode errorCode;

- (NSString *)errorMsg;

@end

@interface YLT_PayErrorUtils : NSObject

/**
 异常信息的创建
 
 @param code 异常Code
 @return 异常信息
 */
+ (YLT_PayError *)create:(YLT_PayCode)code;

/**
 支付订单信息校验
 
 @param orderInfo 订单信息
 @param complation 回调
 @return 校验是否成功
 */
+ (BOOL)invalidOrderInfo:(YLT_PayOrder *)orderInfo
              complation:(void (^)(id response, YLT_PayError *error))complation;


@end
