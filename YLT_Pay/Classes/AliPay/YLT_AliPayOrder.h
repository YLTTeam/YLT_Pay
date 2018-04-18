//
//  YLT_AliPayOrder.h
//  FastCoding
//
//  Created by 项普华 on 2018/4/18.
//

#import "YLT_PayOrder.h"

@interface YLT_AliPayOrder : YLT_PayOrder

/**
 签名数据，如果有值就是直接支付，没有值就需要客户端自己做签名处理
 */
@property (nonatomic, strong) NSString *sign;

/**
 Alipay 需要客户端做第二次签名的实例调用

 @param credential 需要加密的信息
 @param key 公钥
 @param notifyURL 回调地址
 @return 实例
 */
+ (YLT_AliPayOrder *)ylt_credential:(NSDictionary *)credential
                                key:(NSString *)key
                          notifyURL:(NSString *)notifyURL;

/**
 Alipay 不需要客户端做二次签名的实例调用

 @param sign 签名信息
 @return 实例
 */
+ (YLT_AliPayOrder *)ylt_sign:(NSString *)sign;

@end
