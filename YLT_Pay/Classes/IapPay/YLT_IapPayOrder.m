//
//  YLT_IapPayOrder.m
//  FastCoding
//
//  Created by 项普华 on 2018/4/18.
//

#import "YLT_IapPayOrder.h"

@implementation YLT_IapPayOrder

/**
 构建内购订单
 
 @param isReceipt 是否是恢复购买
 @return 实例对象
 */
+ (YLT_IapPayOrder *)ylt_isReceipt:(BOOL)isReceipt {
    YLT_IapPayOrder *result = [[YLT_IapPayOrder alloc] init];
    result.isReceipt = isReceipt;
    return result;
}
/**
 内购实例
 
 @param transactionIdentifier 标志符
 @param count 数量
 */
- (void)ylt_transactionIdentifier:(NSString *)transactionIdentifier
                            count:(NSUInteger)count {
    if (!transactionIdentifier.ylt_isValid) {
        return;
    }
    [self.items setObject:@(count) forKey:transactionIdentifier];
}

- (NSMutableDictionary *)items {
    if (!_items) {
        _items = [NSMutableDictionary new];
    }
    return _items;
}

@end
