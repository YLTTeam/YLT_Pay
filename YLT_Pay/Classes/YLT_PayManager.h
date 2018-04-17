//
//  YLT_PayManager.h
//  Pods-YLT_Pay_Example
//
//  Created by 项普华 on 2018/4/17.
//

#import <Foundation/Foundation.h>
#import <YLT_BaseLib/YLT_BaseLib.h>
#import "YLT_PayProtocol.h"

@interface YLT_PayManager : NSObject<YLT_PayProtocol>

YLT_ShareInstanceHeader(YLT_PayManager);

@end
