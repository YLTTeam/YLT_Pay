//
//  YLT_AliPayOrder.m
//  FastCoding
//
//  Created by 项普华 on 2018/4/18.
//

#import "YLT_AliPayOrder.h"

@interface YLT_AliPayOrder() {
}

@end

@implementation YLT_AliPayOrder

/**
 Alipay 不需要客户端做二次签名的实例调用
 
 @param sign 签名信息
 @return 实例
 */
+ (YLT_AliPayOrder *)ylt_sign:(NSString *)sign {
    YLT_AliPayOrder *result = [YLT_AliPayOrder new];
    result.sign = sign;
    return result;
}

#pragma mark - settger getter

@end
