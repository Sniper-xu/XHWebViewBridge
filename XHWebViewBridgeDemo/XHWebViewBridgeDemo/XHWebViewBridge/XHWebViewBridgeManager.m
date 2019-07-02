//
//  XHWebViewBridgeManager.m
//  XHWebViewBridgeDemo
//
//  Created by icochu on 2019/5/5.
//  Copyright © 2019 Sniper. All rights reserved.
//

#import "XHWebViewBridgeManager.h"

@implementation XHWebViewBridgeManager
//这个方法必须实现，用于往js注入对象XHWebViewBridgeManager，实现的代理方法就是XHWebViewBridgeManager对象的方法
+(NSString *)moduleName{
    return @"XHWebViewBridgeManager";
}
//无参数
- (void)jsCallOC {
    NSLog(@"-------JS正在调用OC的方法------");
}
//一个参数
-(void)jsCallOC1 : (NSString *)content {
    NSLog(@"-------JS正在调用OC的方法传递参数content:%@------",content);
}
//多个参赛
-(void)jsCallOC2 : (NSString *)content content2:(NSString *)content2 {
    NSLog(@"-------JS正在调用OC的方法传递参数content:%@ content2:%@------",content,content2);

}
//传递对象（在js里面字典就是对象）
-(void)jsCallOC3 :(NSDictionary *)dic {
    NSLog(@"-------JS正在调用OC的方法传递对象dic:%@------",dic);
}
//传递对象，回调返回
- (void)jsCallOC4:(NSDictionary *)dic callback :(JSValue *)callback {
    NSLog(@"-------JS正在调用OC的方法传递对象dic:%@------",dic);
    NSString *string = @"把OC处理后的结果回传给js";
    [callback callWithArguments:[NSArray arrayWithObject:string]];
}

@end
