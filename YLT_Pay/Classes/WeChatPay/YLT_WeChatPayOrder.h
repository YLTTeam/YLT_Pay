//
//  YLT_WeChatPayOrder.h
//  FastCoding
//
//  Created by 项普华 on 2018/4/18.
//

#import "YLT_PayOrder.h"

@interface YLT_WeChatPayOrder : YLT_PayOrder

/** 申请的ID */
@property (nonatomic, strong) NSString *appId;
/** 商家向财付通申请的商家id */
@property (nonatomic, strong) NSString *partnerId;
/** 预支付订单 */
@property (nonatomic, strong) NSString *prepayId;
/** 随机串，防重发 */
@property (nonatomic, strong) NSString *nonceStr;
/** 时间戳，防重发 */
@property (nonatomic, assign) UInt32 timeStamp;
/** 商家根据财付通文档填写的数据和签名 */
@property (nonatomic, strong) NSString *package;
/** 商家根据微信开放平台文档对数据做的签名 */
@property (nonatomic, strong) NSString *sign;

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
                             sign:(NSString *)sign;

@end
