//
//  XHBridge.h
//  XHWebViewBridgeDemo
//
//  Created by icochu on 2019/4/29.
//  Copyright © 2019 Sniper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "XHBridgeModule.h"
#import "XHSparseArray.h"
#import "XHUtils.h"
NS_ASSUME_NONNULL_BEGIN

@class XHBridge;

@interface XHBridge : NSObject

- (XHBridge*)init;

- (XHBridge*)initWithContext:(JSContext *)context;

- (void)setBridgeModulesForContext:(JSContext *)context;

@property (nonatomic, copy, readonly) NSDictionary *modules;


@end


NS_ASSUME_NONNULL_END
