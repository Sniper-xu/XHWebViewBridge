//
//  XHWebViewBridgeManager.h
//  XHWebViewBridgeDemo
//
//  Created by icochu on 2019/5/5.
//  Copyright © 2019 Sniper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XHFunctionModule.h"
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN
@protocol XHWebManagerProtocol <JSExport>
//注入js的方法，达到js调用oc目的
//无参数
- (void)jsCallOC;
//一个参数
JSExportAs(jsCallOC1, -(void)jsCallOC1 : (NSString *)content);
//多个参赛
JSExportAs(jsCallOC2, -(void)jsCallOC2 : (NSString *)content content2:(NSString *)content2);
//传递对象（在js里面字典就是对象）
JSExportAs(jsCallOC3, -(void)jsCallOC3 :(NSDictionary *)dic);
//传递对象，回调返回
JSExportAs(jsCallOC4, - (void)jsCallOC4:(NSDictionary *)dic callback :(JSValue *)callback);

@end
@interface XHWebViewBridgeManager : XHFunctionModule<XHWebManagerProtocol>

@end

NS_ASSUME_NONNULL_END
