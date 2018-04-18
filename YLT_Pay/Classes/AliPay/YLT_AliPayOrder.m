//
//  YLT_AliPayOrder.m
//  FastCoding
//
//  Created by 项普华 on 2018/4/18.
//

#import "YLT_AliPayOrder.h"
#import "DataSigner.h"
#import "DataVerifier.h"
#include <sys/sysctl.h>
#import <CommonCrypto/CommonDigest.h>

@interface YLT_AliPayOrder() {
}

/**
 回调URL
 */
@property (nonatomic, strong) NSString *notifyURL;

/**
 信息
 */
@property (nonatomic, strong) NSDictionary *credential;

@end

@implementation YLT_AliPayOrder

/**
 Alipay 需要客户端做第二次签名的实例调用
 
 @param credential 需要加密的信息
 @param key 公钥
 @param notifyURL 回调地址
 @return 实例
 */
+ (YLT_AliPayOrder *)ylt_credential:(NSDictionary *)credential
                                key:(NSString *)key
                          notifyURL:(NSString *)notifyURL {
    YLT_AliPayOrder *result = [YLT_AliPayOrder new];
    result.credential = credential;
    result.sign = [result ylt_signWithKey:key];
    return result;
}

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

#pragma mark - 生成支付宝的二次签名

/**
 生成支付宝的二次签名
 
 @param key 公钥
 @return 二次签名结果
 */
- (NSString *)ylt_signWithKey:(NSString *)key {
    NSString *orderInfo = [self orderDescription];
    NSString *signString = [self doRsa:orderInfo key:key];
    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"", orderInfo, signString, @"RSA"];
    return orderString;
}


- (NSString*)doRsa:(NSString *)orderString key:(NSString *)key {
    id<DataSigner> signer;
    signer = CreateRSADataSigner(key);
    NSString *signedString = [signer signString:orderString];
    return signedString;
}

/**
 订单信息
 
 @return 订单信息
 */
- (NSString *)orderDescription {
    NSMutableString * discription = [NSMutableString string];
    [discription appendFormat:@"partner=\"%@\"", [self stringForKey:@"partner"]];
    [discription appendFormat:@"&seller_id=\"%@\"", [self stringForKey:@"seller"]];
    [discription appendFormat:@"&out_trade_no=\"%@\"", [self stringForKey:@"out_trade_no"]];
    [discription appendFormat:@"&subject=\"%@\"", [self stringForKey:@"subject"]];
    [discription appendFormat:@"&body=\"%@\"", [self stringForKey:@"body"]];
    [discription appendFormat:@"&total_fee=\"%@\"", @(((float)[[self stringForKey:@"amount"] intValue])/100.)];
    [discription appendFormat:@"&notify_url=\"%@\"", [self stringForKey:@"notifyURL"]];
    
    [discription appendFormat:@"&service=\"%@\"", @"mobile.securitypay.pay"];
    [discription appendFormat:@"&_input_charset=\"%@\"", @"utf-8"];
    [discription appendFormat:@"&payment_type=\"%@\"", @"1"];
    
    //下面的这些参数，如果没有必要（value为空），则无需添加
    //    [discription appendFormat:@"&return_url=\"%@\"", @""];
    //    [discription appendFormat:@"&it_b_pay=\"%@\"", @""];
    //    [discription appendFormat:@"&show_url=\"%@\"", @""];
    
    return discription;
}

- (NSString *)stringForKey:(NSString *)key {
    NSString *value = @"";
    if ([self.credential.allKeys containsObject:key] && [self.credential objectForKey:key]) {
        value = [self.credential objectForKey:key];
    }
    
    return value;
}

#pragma mark - settger getter

@end
