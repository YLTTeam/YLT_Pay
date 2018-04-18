//
//  YLT_ApplePayOrder.m
//  FastCoding
//
//  Created by 项普华 on 2018/4/18.
//

#import "YLT_ApplePayOrder.h"

@interface YLT_ApplePayOrder() {
}

@end

@implementation YLT_ApplePayOrder

/**
 创建对象
 
 @param merchantIdentifier 标志符
 @param callback 支付获得TOKEN后的回调 可以用于上传服务器校验
 @return 对象
 */
+ (YLT_ApplePayOrder *)ylt_merchantIdentifier:(NSString *)merchantIdentifier
                                     callback:(BOOL (^)(YLT_ApplePayOrder *order, PKPaymentToken *token))callback {
    YLT_ApplePayOrder *result = [[YLT_ApplePayOrder alloc] init];
    result.merchantIdentifier = merchantIdentifier;
    result.callback = callback;
    return result;
}

/**
 Apple Pay 支付实例生成
 
 @param name 显示名称
 @param amount 金额 单位：元
 @return 实例
 */
- (PKPaymentSummaryItem *)ylt_name:(NSString *)name
                            amount:(CGFloat)amount {
    NSDecimalNumber *amountNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f", amount]];
    NSString *itemName = name.ylt_isValid?name:(self.shopName.ylt_isValid?self.shopName:(self.subject.ylt_isValid?self.subject:@""));
    PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel:itemName amount:amountNumber];
    [self.items addObject:total];
    return total;
}

#pragma mark - setter getter

- (NSMutableArray<PKPaymentSummaryItem *> *)items {
    if (!_items) {
        _items = [NSMutableArray new];
    }
    return _items;
}

@end
