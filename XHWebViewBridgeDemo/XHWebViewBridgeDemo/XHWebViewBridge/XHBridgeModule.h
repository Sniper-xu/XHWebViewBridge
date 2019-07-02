//
//  XHBridgeModule.h
//  editordemo
//
//  Created by icochu on 2018/6/21.
//  Copyright © 2018年 icochu. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol XHBridgeModule
@optional

+ (NSString *)moduleName;

+ (NSArray *)JSMethods;

@end
