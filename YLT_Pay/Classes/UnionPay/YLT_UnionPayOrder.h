//
//  YLT_UnionPayOrder.h
//  FastCoding
//
//  Created by 项普华 on 2018/4/18.
//

#import "YLT_PayOrder.h"

@interface YLT_UnionPayOrder : YLT_PayOrder

/**
 支付tn
 */
@property (nonatomic, strong) NSString *tn;

/**
 支付环境
 */
@property (nonatomic, strong) NSString *mode;

/**
 银联支付订单生成

 @param tn tn
 @param mode 支付环境
 @return 实例
 */
+ (YLT_UnionPayOrder *)ylt_tn:(NSString *)tn
                         mode:(NSString *)mode;

@end
