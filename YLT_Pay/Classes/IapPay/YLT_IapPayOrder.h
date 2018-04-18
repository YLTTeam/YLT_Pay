//
//  YLT_IapPayOrder.h
//  FastCoding
//
//  Created by 项普华 on 2018/4/18.
//

#import "YLT_PayOrder.h"

@interface YLT_IapPayOrder : YLT_PayOrder

/**
 需要内购的商品列表
 */
@property (nonatomic, strong) NSMutableDictionary *items;

/**
 是否是恢复购买
 */
@property (nonatomic, assign) BOOL isReceipt;

/**
 构建内购订单

 @param isReceipt 是否是恢复购买
 @return 实例对象
 */
+ (YLT_IapPayOrder *)ylt_isReceipt:(BOOL)isReceipt;

/**
 内购实例

 @param transactionIdentifier 标志符
 @param count 数量
 */
- (void)ylt_transactionIdentifier:(NSString *)transactionIdentifier
                            count:(NSUInteger)count;

@end
