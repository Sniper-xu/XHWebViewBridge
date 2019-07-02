//
//  XHSparseArray.m
//  editordemo
//
//  Created by icochu on 2018/6/22.
//  Copyright © 2018年 icochu. All rights reserved.
//

#import "XHSparseArray.h"

@implementation XHSparseArray

{
    NSMutableDictionary *_storage;
}

- (instancetype)init
{
    return [self initWithCapacity:0];
}

- (instancetype)initWithCapacity:(NSUInteger)capacity
{
    if ((self = [super init])) {
        _storage = [NSMutableDictionary dictionaryWithCapacity:capacity];
    }
    return self;
}

- (instancetype)initWithSparseArray:(XHSparseArray *)sparseArray
{
    if ((self = [super init])) {
        _storage = [sparseArray->_storage copy];
    }
    return self;
}

+ (instancetype)sparseArray
{
    return [[self alloc] init];
}

+ (instancetype)sparseArrayWithCapacity:(NSUInteger)capacity
{
    return [[self alloc] initWithCapacity:capacity];
}

+ (instancetype)sparseArrayWithSparseArray:(XHSparseArray *)sparseArray
{
    return [[self alloc] initWithSparseArray:sparseArray];
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
    return _storage[@(idx)];
}

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx
{
    self[@(idx)] = obj;
}

- (id)objectForKeyedSubscript:(NSNumber *)key
{
    return _storage[key];
}

- (void)setObject:(id)obj forKeyedSubscript:(NSNumber *)key
{
    if (obj) {
        _storage[key] = obj;
    } else {
        [_storage removeObjectForKey:key];
    }
}

- (NSUInteger)count
{
    return _storage.count;
}

- (NSArray *)allIndexes
{
    return _storage.allKeys;
}

- (NSArray *)allObjects
{
    return _storage.allValues;
}

- (void)enumerateObjectsUsingBlock:(void (^)(id obj, NSNumber *idx, BOOL *stop))block
{
    NSParameterAssert(block != nil);
    [_storage enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, id obj, BOOL *stop) {
        block(obj, key, stop);
    }];
}

- (void)enumerateObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id obj, NSNumber *idx, BOOL *stop))block
{
    NSParameterAssert(block != nil);
    [_storage enumerateKeysAndObjectsWithOptions:opts usingBlock:^(NSNumber *key, id obj, BOOL *stop) {
        block(obj, key, stop);
    }];
}

- (void)removeAllObjects
{
    [_storage removeAllObjects];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [[[self class] allocWithZone:zone] initWithSparseArray:self];
}

- (NSString *)description
{
    return [[super description] stringByAppendingString:[_storage description]];
}

@end
