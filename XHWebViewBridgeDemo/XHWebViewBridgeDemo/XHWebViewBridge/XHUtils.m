//
//  XHUtils.m
//  editordemo
//
//  Created by icochu on 2018/6/22.
//  Copyright © 2018年 icochu. All rights reserved.
//

#import "XHUtils.h"
#import <mach/mach_time.h>
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonCrypto.h>

NSString *XHJSONStringify(id jsonObject, NSError **error)
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject options:0 error:error];
    return jsonData ? [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] : nil;
}

id XHJSONParse(NSString *jsonString, NSError **error)
{
    if (!jsonString) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    if (!jsonData) {
        jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        if (jsonData) {
            NSLog(@"XHJSONParse received the following string, which could not be losslessly converted to UTF8 data: '%@'", jsonString);
        } else {
            // If our backup conversion fails, log the issue so we can see what strings are causing this (t6452813)
            NSLog(@"XHJSONParse received the following string, which could not be converted to UTF8 data: '%@'", jsonString);
            return nil;
        }
    }
    return [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:error];
}

NSString *XHMD5Hash(NSString *string)
{
    const char *str = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

CGFloat XHScreenScale()
{
    static CGFloat scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (![NSThread isMainThread]) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                scale = [UIScreen mainScreen].scale;
            });
        } else {
            scale = [UIScreen mainScreen].scale;
        }
    });
    
    return scale;
}

CGSize XHScreenSize()
{
    static CGSize size;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (![NSThread isMainThread]) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                size = [UIScreen mainScreen].bounds.size;
            });
        } else {
            size = [UIScreen mainScreen].bounds.size;
        }
    });
    
    return size;
}

CGFloat XHRoundPixelValue(CGFloat value)
{
    CGFloat scale = XHScreenScale();
    return round(value * scale) / scale;
}

CGFloat XHCeilPixelValue(CGFloat value)
{
    CGFloat scale = XHScreenScale();
    return ceil(value * scale) / scale;
}

CGFloat XHFloorPixelValue(CGFloat value)
{
    CGFloat scale = XHScreenScale();
    return floor(value * scale) / scale;
}

NSTimeInterval XHTGetAbsoluteTime(void)
{
    static struct mach_timebase_info tb_info = {0};
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        int ret = mach_timebase_info(&tb_info);
        assert(0 == ret);
    });
    
    uint64_t timeInNanoseconds = (mach_absolute_time() * tb_info.numer) / tb_info.denom;
    return ((NSTimeInterval)timeInNanoseconds) / 1000000;
}

void XHSwapClassMethods(Class cls, SEL original, SEL replacement)
{
    Method originalMethod = class_getClassMethod(cls, original);
    IMP originalImplementation = method_getImplementation(originalMethod);
    const char *originalArgTypes = method_getTypeEncoding(originalMethod);
    
    Method replacementMethod = class_getClassMethod(cls, replacement);
    IMP replacementImplementation = method_getImplementation(replacementMethod);
    const char *replacementArgTypes = method_getTypeEncoding(replacementMethod);
    
    if (class_addMethod(cls, original, replacementImplementation, replacementArgTypes))
    {
        class_replaceMethod(cls, replacement, originalImplementation, originalArgTypes);
    }
    else
    {
        method_exchangeImplementations(originalMethod, replacementMethod);
    }
}

void XHSwapInstanceMethods(Class cls, SEL original, SEL replacement)
{
    Method originalMethod = class_getInstanceMethod(cls, original);
    IMP originalImplementation = method_getImplementation(originalMethod);
    const char *originalArgTypes = method_getTypeEncoding(originalMethod);
    
    Method replacementMethod = class_getInstanceMethod(cls, replacement);
    IMP replacementImplementation = method_getImplementation(replacementMethod);
    const char *replacementArgTypes = method_getTypeEncoding(replacementMethod);
    
    if (class_addMethod(cls, original, replacementImplementation, replacementArgTypes))
    {
        class_replaceMethod(cls, replacement, originalImplementation, originalArgTypes);
    }
    else
    {
        method_exchangeImplementations(originalMethod, replacementMethod);
    }
}

BOOL XHClassOverridesClassMethod(Class cls, SEL selector)
{
    return XHClassOverridesInstanceMethod(object_getClass(cls), selector);
}

BOOL XHClassOverridesInstanceMethod(Class cls, SEL selector)
{
    unsigned int numberOfMethods;
    Method *methods = class_copyMethodList(cls, &numberOfMethods);
    for (unsigned int i = 0; i < numberOfMethods; i++)
    {
        if (method_getName(methods[i]) == selector)
        {
            free(methods);
            return YES;
        }
    }
    free(methods);
    return NO;
}

void XHEnumerateClasses(void (^block)(Class cls))
{
    static Class *classes;
    static unsigned int classCount;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //创建并返回一个指向所有已注册类定义的指针列表。
        classes = objc_copyClassList(&classCount);
    });
    
    for (unsigned int i = 0; i < classCount; i++)
    {
        Class cls = classes[i];
        Class superclass = cls;
        while (superclass)
        {
            if (class_conformsToProtocol(superclass, @protocol(NSObject)))
            {
                block(cls);
                break;
            }
            superclass = class_getSuperclass(superclass);
        }
    }
}

NSDictionary *XHMakeError(NSString *message, id toStringify, NSDictionary *extraData)
{
    if (toStringify) {
        message = [NSString stringWithFormat:@"%@%@", message, toStringify];
    }
    NSMutableDictionary *error = [@{@"message": message} mutableCopy];
    if (extraData) {
        [error addEntriesFromDictionary:extraData];
    }
    return error;
}

NSDictionary *XHMakeAndLogError(NSString *message, id toStringify, NSDictionary *extraData)
{
    id error = XHMakeError(message, toStringify, extraData);
    NSLog(@"\nError: %@", error);
    return error;
}
