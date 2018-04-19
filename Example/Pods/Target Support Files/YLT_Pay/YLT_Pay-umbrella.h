#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "YLT_Pay.h"
#import "YLT_PayError.h"
#import "YLT_PayManager.h"
#import "YLT_PayOrder.h"
#import "YLT_PayProtocol.h"
#import "YLT_ApplePay.h"
#import "YLT_ApplePayOrder.h"
#import "YLT_IapPay.h"
#import "YLT_IapPayOrder.h"
#import "YLT_Pay.h"
#import "YLT_PayError.h"
#import "YLT_PayManager.h"
#import "YLT_PayOrder.h"
#import "YLT_PayProtocol.h"

FOUNDATION_EXPORT double YLT_PayVersionNumber;
FOUNDATION_EXPORT const unsigned char YLT_PayVersionString[];

