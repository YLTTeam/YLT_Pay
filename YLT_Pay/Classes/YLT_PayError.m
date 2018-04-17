//
//  YLT_Error.m
//  FastCoding
//
//  Created by 项普华 on 2018/4/17.
//

#import "YLT_PayError.h"

@interface YLT_PayError() {
}
@property (nonatomic, strong) NSMutableDictionary *errorConfig;
@end

@implementation YLT_PayError

- (id)init {
    self = [super init];
    if (self) {
        _errorConfig = [[NSMutableDictionary alloc] init];
        [_errorConfig setObject:@"支付成功" forKey:@(YLT_PaySuccess)];
        [_errorConfig setObject:@"支付失败" forKey:@(YLT_PayFailed)];
        [_errorConfig setObject:@"支付渠道验证失败" forKey:@(YLT_PayCodeInvalidChannel)];
        [_errorConfig setObject:@"支付参数异常" forKey:@(YLT_PayCodeErrorParams)];
        [_errorConfig setObject:@"链接异常" forKey:@(YLT_PayCodeErrorConnection)];
        [_errorConfig setObject:@"请求超时" forKey:@(YLT_PayCodeErrorTimeOut)];
        [_errorConfig setObject:@"当前TARGET为空" forKey:@(YLT_PayCodeTargetIsNil)];
        [_errorConfig setObject:@"支付取消" forKey:@(YLT_PayCodeCanceled)];
        [_errorConfig setObject:@"未知异常" forKey:@(YLT_PayCodeErrorUnknown)];
        [_errorConfig setObject:@"微信未安装" forKey:@(YLT_PayCodeWxNoInstalled)];
        [_errorConfig setObject:@"微信Appid注册失败" forKey:@(YLT_PayCodeWxRegisterFailed)];
        [_errorConfig setObject:@"应用调起失败" forKey:@(YLT_PayCodeErrorCall)];
    }
    return self;
}

- (void)setErrorCode:(YLT_PayCode)errorCode {
    _errorCode = errorCode;
}

- (NSString *)errorMsg {
    return [_errorConfig objectForKey:@(_errorCode)];
}

@end


@implementation YLT_PayErrorUtils

/**
 异常信息的创建
 
 @param code 异常Code
 @return 异常信息
 */
+ (YLT_PayError *)create:(YLT_PayCode)code {
    YLT_PayError *error = [[YLT_PayError alloc] init];
    error.errorCode = code;
#if DEBUG
    switch (code) {
        case YLT_PayCodeInvalidChannel: {
            YLT_LogError(@"渠道信息验证失败");
        }
            break;
        case YLT_PayCodeErrorParams: {
            YLT_LogError(@"支付参数异常");
        }
            break;
        case YLT_PayCodeErrorTimeOut: {
            YLT_LogError(@"支付超时");
        }
            break;
        case YLT_PayCodeErrorConnection: {
            YLT_LogError(@"链接异常");
        }
            break;
        case YLT_PayCodeTargetIsNil: {
            YLT_LogError(@"target 为空");
        }
        case YLT_PayCodeErrorCall: {
            YLT_LogError(@"调起支付方式失败");
        }
            break;
        case YLT_PayCodeCanceled: {
            YLT_Log(@"取消支付");
        }
            break;
        case YLT_PaySuccess: {
            YLT_Log(@"支付成功");
        }
            break;
        case YLT_PayFailed: {
            YLT_LogError(@"支付失败");
        }
            break;
        case YLT_PayCodeWxNoInstalled: {
            YLT_LogInfo(@"微信未安装");
        }
            break;
        case YLT_PayCodeWxRegisterFailed: {
            YLT_LogError(@"微信appid注册失败");
        }
            break;
        case YLT_PayCodeErrorUnknown: {
            YLT_LogError(@"未知异常");
        }
            break;
            
        default:
            break;
    }
#endif
    return error;
}

/**
 支付订单信息校验
 
 @param orderInfo 订单信息
 @param complation 回调
 @return 校验是否成功
 */
+ (BOOL)invalidOrderInfo:(YLT_PayOrder *)orderInfo
              complation:(void (^)(id response, YLT_PayError *error))complation {
#warning 这里可以添加上很多对订单信息校验的错误 --后期完善
    
    switch (orderInfo.failCode) {
        case 1:
            return YES;
            break;
        case 2:
            complation(orderInfo, [YLT_PayErrorUtils create:YLT_PayCodeErrorParams]);
            return NO;
            break;
        case 3:
            complation(orderInfo, [YLT_PayErrorUtils create:YLT_PayCodeErrorParams]);
            return NO;
            break;
        case 4:
            complation(orderInfo, [YLT_PayErrorUtils create:YLT_PayCodeErrorParams]);
            return NO;
            break;
            
        default:
            break;
    }
    
    complation(orderInfo, [YLT_PayErrorUtils create:YLT_PayCodeErrorParams]);
    return NO;
}


@end
