//
//  YLT_WeChatPayOrder.m
//  FastCoding
//
//  Created by 项普华 on 2018/4/18.
//

#import "YLT_WeChatPayOrder.h"

@implementation YLT_WeChatPayOrder

/**
 创建微信支付订单信息
 
 @param appId 申请的ID
 @param partnerId 拥有者ID
 @param prepayId 预付ID
 @param nonceStr 随机子串
 @param timestamp 时间戳
 @param package 包信息
 @param sign 签名信息
 @return 实例
 */
+ (YLT_WeChatPayOrder *)ylt_appId:(NSString *)appId
                        partnerId:(NSString *)partnerId
                         prepayId:(NSString *)prepayId
                         nonceStr:(NSString *)nonceStr
                        timestamp:(NSString *)timestamp
                          package:(NSString *)package
                             sign:(NSString *)sign {
    YLT_WeChatPayOrder *result = [[YLT_WeChatPayOrder alloc] init];
    result.appId = appId;
    result.partnerId = partnerId;
    result.prepayId = prepayId;
    result.nonceStr = nonceStr;
    result.timeStamp = (UInt32)[timestamp integerValue];
    result.package = package;
    result.sign = sign;
    return result;
}

@end
