//
//  CommonHelper.m
//  NSObjectJSON
//
//  Created by Benjamin on 12/16/13.
//
//

#import "CommonHelper.h"

@implementation CommonHelper

+ (CommonHelper *)sharedSingleton {
    static CommonHelper *_sharedSingleton = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedSingleton = [[self alloc] initSingleton];
    });
    return _sharedSingleton;
}

- (id)init {
    // Forbid calls to –init or +new
    NSAssert(NO, @"Cannot create instance of Singleton");
    // You can return nil or [self initSingleton] here,
    // depending on how you prefer to fail.
    return nil;
}

//Real (private) init method
- (id)initSingleton {
    self = [super init];
    if (self) {
    }
    return self;
}

- (id)deserializeStringToObject:(NSString *)jsonString {
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
}

- (NSString *)serializeObjectToString:(id)data{
    NSData *result = [NSJSONSerialization dataWithJSONObject:data options:NSJSONReadingAllowFragments | NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
}

@end
