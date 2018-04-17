//
//  YLT_AliPay.m
//  FastCoding
//
//  Created by 项普华 on 2018/4/17.
//

#import "YLT_AliPay.h"
#import <sys/sysctl.h>
#import <CommonCrypto/CommonDigest.h>
#import "YLT_PayOrder.h"
#import <AlipaySDK.h>

@interface YLT_AliPay() {
}

/**
 订单信息
 */
@property (nonatomic, strong) YLT_PayOrder *payOrder;

/**
 回调
 */
@property (nonatomic, copy) void(^complation)(id response, YLT_PayError *error);

@end

@implementation YLT_AliPay

- (BOOL)ylt_orderInvalid:(YLT_PayOrder *)order {
    return YES;
}

- (void)ylt_payOrder:(YLT_PayOrder *)order targetVC:(UIViewController *)targetVC complation:(void (^)(id, YLT_PayError *))complation {
    _payOrder = order;
    _complation = complation;
    YLT_MAIN(^{
        __weak typeof(self) weakSelf = self;
        if (!self.payOrder.sign.ylt_isValid) {
            self.complation(self.payOrder, [YLT_PayErrorUtils create:YLT_PayFailed]);
            return ;
        }
        
        [[AlipaySDK defaultService] payOrder:self.payOrder.sign fromScheme:self.payOrder.scheme callback:^(NSDictionary *resultDic) {
            __strong typeof(weakSelf) self = weakSelf;
            [self handleDictionary:resultDic];
        }];
    });
}

- (BOOL)ylt_handleOpenURL:(NSURL *)url options:(NSDictionary *)options {
    
    return YES;
}


#pragma mark - 私有方法

- (void)handleDictionary:(NSDictionary *)result {
    switch ([result[@"resultStatus"] integerValue]) {
        case 9000:
            self.complation(self.payOrder, [YLT_PayErrorUtils create:YLT_PaySuccess]);
            break;
        case 4000:
            self.complation(self.payOrder, [YLT_PayErrorUtils create:YLT_PayFailed]);
            break;
        case 6001:
            self.complation(self.payOrder, [YLT_PayErrorUtils create:YLT_PayCodeCanceled]);
            break;
        case 8000:
        case 6002:
        case 6004:
            self.complation(self.payOrder, [YLT_PayErrorUtils create:YLT_PayCodeErrorUnknown]);
            break;
        default:
            self.complation(self.payOrder, [YLT_PayErrorUtils create:YLT_PayCodeErrorUnknown]);
            break;
    }
}

//- (NSString*)doRsa:(NSString *)orderInfo {
//    id<DataSigner> signer;
//    signer = CreateRSADataSigner(@"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAKLfMdEnNOcwi8ExwhO9Qp9uhU2uUeSi8XPZBd5Ub24E3eCCpwy9Ye0v9NVUBQWbUpNIho7KIsDCQCrYnk2ktZ+df1aNJn0Xz9E6D7cB+USlN5slwm1eXbMg5081skFJiQKapQKDPf9r2DSMBkcpvHeGdILb6ISExP09k2Nu7EXjAgMBAAECgYBXkhPx9dee+l4aGQvVmywIFt97nd+QQ//4ntZl7RYgnGNDxFvXILhXVDKaxNsSYanrYNJgUdSPuaHQp7mt24J/HRXnUNLJNZ2sMu0cN+K8oJiWVgLW6dHSFPNc9LboPBB0EkRlAwe+SY1eOoiFi1rie+SaYmB0itKM5Scp5yXgqQJBAMzRo0RHU6Wr5+qLGJMHWpwo+SkgxNabx+rTnQkbo63mWDFTanmiLL80oaIpZPEbTSxu+5N42ULhQp7KjK3r+N8CQQDLki88gXxO/hzJZRvwFu0VlKNKS0UJkJbsXo5g5eKrjFiozDZKOAq47xp1g6OEYSlBmIGo8IfNPZfLJuoEx199AkAsenoSIcswdxxt+rbjdv1eXCd/nvYgBMRtYnb/u1jYMuWEELFWqLk+7JcNOCALm/ouZAuOAvhrZa+p/CKAwnXRAkBGNZ3bBWGlMNkm0JtpG88bEU+cEQe3e8nBrf73BnI97kKpvPzAbkGsdLKwcv1Ta9s5x2p4pLSBocuXgk1V5plVAkBQte+JmbqBY3D44N4D3QlRR4fcTW4oB14eLYnpM/enBB3z4zExlyxA3kCw65XE/6vgWpfYOaj4li7xXEB849kW");
//    NSString *signedString = [signer signString:orderInfo];
//    return signedString;
//}
//
//- (NSString *)orderDescription {
//    NSMutableString * discription = [NSMutableString string];
//    [discription appendFormat:@"partner=\"%@\"", [self stringForKey:@"partner"]];
//    [discription appendFormat:@"&seller_id=\"%@\"", [self stringForKey:@"seller"]];
//    [discription appendFormat:@"&out_trade_no=\"%@\"", [self stringForKey:@"out_trade_no"]];
//    [discription appendFormat:@"&subject=\"%@\"", [self stringForKey:@"subject"]];
//    [discription appendFormat:@"&body=\"%@\"", [self stringForKey:@"body"]];
//    [discription appendFormat:@"&total_fee=\"%@\"", @(((float)[[self stringForKey:@"amount"] intValue])/100.)];
//    [discription appendFormat:@"&notify_url=\"%@\"", [self stringForKey:@"notifyURL"]];
//
//    [discription appendFormat:@"&service=\"%@\"", @"mobile.securitypay.pay"];
//    [discription appendFormat:@"&_input_charset=\"%@\"", @"utf-8"];
//    [discription appendFormat:@"&payment_type=\"%@\"", @"1"];
//
//    //下面的这些参数，如果没有必要（value为空），则无需添加
//    //    [discription appendFormat:@"&return_url=\"%@\"", @""];
//    //    [discription appendFormat:@"&it_b_pay=\"%@\"", @""];
//    //    [discription appendFormat:@"&show_url=\"%@\"", @""];
//
//    return discription;
//}
//
//- (NSString *)stringForKey:(NSString *)key {
//    NSString *value = @"";
//    if ([_payOrder.credential.allKeys containsObject:key] && [_payOrder.credential objectForKey:key]) {
//        value = [_payOrder.credential objectForKey:key];
//    }
//
//    return value;
//}

@end
