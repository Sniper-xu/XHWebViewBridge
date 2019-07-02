//
//  XHUtils.h
//  editordemo
//
//  Created by icochu on 2018/6/22.
//  Copyright © 2018年 icochu. All rights reserved.
//
#import <tgmath.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif
    
    // Utility functions for JSON object <-> string serialization/deserialization
    NSString *XHJSONStringify(id jsonObject, NSError **error);
    id XHJSONParse(NSString *jsonString, NSError **error);
    
    // Get MD5 hash of a string (TODO: currently unused. Remove?)
    NSString *XHMD5Hash(NSString *string);
    
    // Get screen metrics in a thread-safe way
    CGFloat XHScreenScale(void);
    CGSize XHScreenSize(void);
    
    // Round float coordinates to nearest whole screen pixel (not point)
    CGFloat XHRoundPixelValue(CGFloat value);
    CGFloat XHCeilPixelValue(CGFloat value);
    CGFloat XHFloorPixelValue(CGFloat value);
    
    // Get current time, for precise performance metrics
    NSTimeInterval XHTGetAbsoluteTime(void);
    
    // Method swizzling
    void XHSwapClassMethods(Class cls, SEL original, SEL replacement);
    void XHSwapInstanceMethods(Class cls, SEL original, SEL replacement);
    
    // Module subclass support
    BOOL XHClassOverridesClassMethod(Class cls, SEL selector);
    BOOL XHClassOverridesInstanceMethod(Class cls, SEL selector);
    
    // Enumerate all classes that conform to NSObject protocol
    void XHEnumerateClasses(void (^block)(Class cls));
    
    // Creates a standardized error object
    // TODO(#6472857): create NSErrors and automatically convert them over the bridge.
    NSDictionary *XHMakeError(NSString *message, id toStringify, NSDictionary *extraData);
    NSDictionary *XHMakeAndLogError(NSString *message, id toStringify, NSDictionary *extraData);
    
#ifdef __cplusplus
}
#endif
