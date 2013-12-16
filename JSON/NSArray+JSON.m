//
//  NSArray+JSON.m
//  NSObjectJSON
//
//  Created by Benjamin on 12/16/13.
//
//

#import "NSArray+JSON.h"
#import "CommonHelper.h"

@implementation NSArray (JSON)

- (NSString *)toJSONString {
    NSArray *jsonObj = [self toJSONObject];
    NSString *jsonString = [[CommonHelper sharedSingleton] serializeObjectToString:jsonObj];
    return jsonString;
}

- (NSArray *)toJSONObject {
    NSMutableArray *array = [NSMutableArray array];
    for (id item in self) {
        if ([item isKindOfClass:[NSString class]]) {
            [array addObject:item];
        } else if ([item isKindOfClass:[NSNumber class]]) {
            [array addObject:item];
        } else if ([item isKindOfClass:[NSNull class]]) {
            [array addObject:item];
        } else {
            [array addObject:[item toJSONObject]];
        }
    }
    return array;
}

@end
