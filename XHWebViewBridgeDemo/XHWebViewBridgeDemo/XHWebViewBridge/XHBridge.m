//
//  XHBridge.m
//  XHWebViewBridgeDemo
//
//  Created by icochu on 2019/4/29.
//  Copyright © 2019 Sniper. All rights reserved.
//

#import "XHBridge.h"
#import <dlfcn.h>
#import <objc/message.h>
#import <objc/runtime.h>
#import <mach-o/dyld.h>
#import <mach-o/getsect.h>

static NSString *XHModuleNameForClass(Class cls) {
    return [cls respondsToSelector:@selector(moduleName)] ? [cls moduleName] : NSStringFromClass(cls);
}

static NSArray *XHModuleNamesByID;

static NSArray *XHBridgeModuleClassesByModuleID(void)
{
    static NSArray *modules;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        modules = [NSMutableArray array];
        XHModuleNamesByID = [NSMutableArray array];
        XHEnumerateClasses(^(__unsafe_unretained Class cls) {
            if ([cls conformsToProtocol:@protocol(XHBridgeModule)]) {
                [(NSMutableArray *)modules addObject:cls];
                NSString *moduleName = XHModuleNameForClass(cls);
                [(NSMutableArray *)XHModuleNamesByID addObject:moduleName];
            }
        });
        modules = [modules copy];
        XHModuleNamesByID = [XHModuleNamesByID copy];
    });
    return modules;
}

@implementation XHBridge {
    
    XHSparseArray *_modulesByID;
    NSDictionary *_modulesByName;
    JSContext *_context;
}

- (XHBridge *)init {
    self = [super init];
    if(self) {
        [self setUp];
    }
    return self;
}

- (XHBridge *)initWithContext:(JSContext *)context {
    self = [super init];
    if (self) {
        [self setUp];
        [self setBridgeModulesForContext:context];
        [self setExceptionHandleWithContext:context];
    }
    return self;
}

-(void)setExceptionHandleWithContext :(JSContext *)context{
    context.exceptionHandler = ^(JSContext *con,JSValue *exception){
        NSLog(@"-----exception------:%@",exception);
        con.exception = exception;
    };
}


- (void)setBridgeModulesForContext:(JSContext *)context{
    if (context && _context != context) {
        _context = context;
        [self registModulesToContext];
    }
}

- (void)registModulesToContext{
    NSArray *moduleNames = [_modulesByName allKeys];
    [moduleNames enumerateObjectsUsingBlock:^(NSString* moduleName, NSUInteger idx, BOOL *stop) {
        id<XHBridgeModule> module = _modulesByName[moduleName];
        _context[moduleName] = module;
    }];
}

- (void)setUp {
    
    _modulesByID = [[XHSparseArray alloc] init];
    NSMutableDictionary *modulesByName = [[NSMutableDictionary alloc] init];
    [XHBridgeModuleClassesByModuleID() enumerateObjectsUsingBlock:^(Class moduleClass, NSUInteger moduleID, BOOL * _Nonnull stop) {
        NSString *moduleName = XHModuleNamesByID[moduleID];
        id<XHBridgeModule> module = [[moduleClass alloc] init];
        if (module) {
            _modulesByID[moduleID] = modulesByName[moduleName] = module;
        }
    }];
    _modulesByName = [modulesByName copy];
}

- (NSDictionary *)modules
{
    return _modulesByName;
}

- (void)dealloc
{
    _modulesByID = nil;
    _modulesByName = nil;
}
@end

