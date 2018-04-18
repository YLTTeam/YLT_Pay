//
//  YLT_UnionPayOrder.m
//  FastCoding
//
//  Created by 项普华 on 2018/4/18.
//

#import "YLT_UnionPayOrder.h"

@implementation YLT_UnionPayOrder


/**
 银联支付订单生成
 
 @param tn tn
 @param mode 支付环境
 @return 实例
 */
+ (YLT_UnionPayOrder *)ylt_tn:(NSString *)tn
                         mode:(NSString *)mode {
    YLT_UnionPayOrder *result = [[YLT_UnionPayOrder alloc] init];
    result.tn = tn;
    result.mode = mode;
    return result;
}

@end
