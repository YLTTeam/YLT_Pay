//
//  YLT_ApplePayOrder.h
//  FastCoding
//
//  Created by 项普华 on 2018/4/18.
//

#import "YLT_PayOrder.h"
#import <Passkit/Passkit.h>

@interface YLT_ApplePayOrder : YLT_PayOrder

/**
 商品列表信息
 */
@property (nonatomic, strong) NSMutableArray<PKPaymentSummaryItem *> *items;

/**
 标志符
 */
@property (nonatomic, strong) NSString *merchantIdentifier;

/**
 支付获得支付凭证的校验
 */
@property (nonatomic, copy) BOOL (^callback)(YLT_ApplePayOrder *order, PKPaymentToken *token);

/**
 创建对象

 @param merchantIdentifier 标志符
 @param callback 支付获得TOKEN后的回调 可以用于上传服务器校验
 @return 对象
 */
+ (YLT_ApplePayOrder *)ylt_merchantIdentifier:(NSString *)merchantIdentifier
                                     callback:(BOOL (^)(YLT_ApplePayOrder *order, PKPaymentToken *token))callback;

/**
 Apple Pay 支付实例生成

 @param name 显示名称
 @param amount 金额 单位：元
 @return 实例
 */
- (PKPaymentSummaryItem *)ylt_name:(NSString *)name
                            amount:(CGFloat)amount;

@end
