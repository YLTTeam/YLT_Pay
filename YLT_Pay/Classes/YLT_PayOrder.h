//
//  YLT_PayOrder.h
//  FastCoding
//
//  Created by 项普华 on 2018/4/17.
//

#import <YLT_BaseLib/YLT_BaseLib.h>

@interface YLT_PayOrder : YLT_BaseModel

#pragma - mark 共性问题

/**
 订单ID
 */
@property (nonatomic, strong) NSString *orderId;

/**
 支付创建时间 时间戳
 */
@property (nonatomic, strong) NSString *createdTime;

/**
 支付使用的第三方支付渠道
 */
@property (nonatomic, strong) NSString *channel;

/**
 商户订单号
 */
@property (nonatomic, strong) NSString *orderNo;

/**
 发起支付的客户端IP 可以本地校验一下IP是否正确
 */
@property (nonatomic, strong) NSString *clientIP;

/**
 订单总金额（必须大于0）
 单位为对应币种的最小货币单位，人民币单位：分
 */
@property (nonatomic, strong) NSString *amount;

/**
 商品标题:该参数最长为32个Unicode字符
 */
@property (nonatomic, strong) NSString *subject;

/**
 商品描述信息:该参数最长为128个Unicode字符
 */
@property (nonatomic, strong) NSString *body;

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

/**
 回调URL
 */
@property (nonatomic, strong) NSString *notifyURL;

/**
 商家名称
 */
@property (nonatomic, strong) NSString *shopName;

/**
 签名数据，如果有值就是直接支付，没有值就需要客户端自己做签名处理
 */
@property (nonatomic, strong) NSString *sign;

#pragma - mark 差异问题

/**
 支付凭证，用于客户端发起支付
 */
@property (nonatomic, strong) NSDictionary *credential;

@end
