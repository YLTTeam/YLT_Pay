//
//  YLT_PayOrder.h
//  FastCoding
//
//  Created by 项普华 on 2018/4/17.
//

#import <YLT_BaseLib/YLT_BaseLib.h>

@interface YLT_PayOrder : YLT_BaseModel

#pragma - mark 共性问题

#pragma mark -  物品相关

/**
 商品标题:该参数最长为32个Unicode字符
 */
@property (nonatomic, strong) NSString *subject;

/**
 商品描述信息:该参数最长为128个Unicode字符
 */
@property (nonatomic, strong) NSString *body;

/**
 订单总金额（必须大于0）
 单位为对应币种的最小货币单位，人民币单位：分
 */
@property (nonatomic, strong) NSString *amount;

#pragma mark - 商家相关

/**
 商户订单号
 */
@property (nonatomic, strong) NSString *orderNo;

/**
 商家名称
 */
@property (nonatomic, strong) NSString *shopName;

#pragma mark - 订单相关

/**
 订单ID
 */
@property (nonatomic, strong) NSString *orderId;

/**
 支付创建时间 时间戳
 */
@property (nonatomic, strong) NSString *createdTime;


#pragma mark - 买家相关

/**
 发起支付的客户端IP 可以本地校验一下IP是否正确
 */
@property (nonatomic, strong) NSString *clientIP;

/**
 应用程序的 scheme
 */
@property (nonatomic, strong) NSString *scheme;

/**
 订单的错误码
 */
@property (nonatomic, assign) NSInteger failCode;

/**
 订单的错误消息的描述
 */
@property (nonatomic, strong) NSString *failMsg;


#pragma - mark 差异问题

@end
