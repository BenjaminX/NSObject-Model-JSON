//
//  NSObject+JSON.m
//  NSObjectJSON
//
//  Created by Benjamin on 12/16/13.
//
//

#import "NSObject+JSON.h"

#import <objc/runtime.h>
#import "ObjectArray.h"
#import "CommonHelper.h"

#define TYPE_PREFIX @"@\""

@implementation NSObject (JSON)

static const NSString *S_VALUE_TYPES = @"cislqCISLQfdB";

+ (id)objectWithJSONString:(NSString *)jsonString {
    id jsonObj = [[CommonHelper sharedSingleton] deserializeStringToObject:jsonString];
    id obj = [self objectWithJSONObject:jsonObj];
    return obj;
}

- (void)fillInJSONObject:(NSDictionary *)jsonObj {
    Class class = [self class];
    NSArray *allKeys = [jsonObj allKeys];
    
    for (NSString *key in allKeys) {
        objc_property_t property = class_getProperty(class, [key UTF8String]);
        if (property != nil) {
            NSString *typeName = [self getTypeNameByAttribute:property];
            
            id value = [jsonObj objectForKey:key];
            id newValue = nil;
            
            if ([typeName hasPrefix:TYPE_PREFIX]) {
                
                Class class = [self createObjectByTypeName:typeName];
                
                if ([class isSubclassOfClass:[NSDecimalNumber class]]) {
                    if ([value isKindOfClass:[NSDecimalNumber class]]) {
                        newValue = value;
                    } else if ([value isKindOfClass:[NSNumber class]]) {
                        newValue = [NSDecimalNumber decimalNumberWithDecimal:[value decimalValue]];
                    }
                } else if ([class isSubclassOfClass:[NSNumber class]]) {
                    if ([value isKindOfClass:[NSNumber class]]) {
                        newValue = value;
                    }
                } else if ([class isSubclassOfClass:[NSString class]]) {
                    if ([value isKindOfClass:[NSString class]]) {
                        newValue = value;
                    }
                } else if ([class isSubclassOfClass:[NSDictionary class]]) {
                    if ([value isKindOfClass:[NSDictionary class]]) {
                        newValue = value;
                    }
                } else if ([class isSubclassOfClass:[NSArray class]]) {
                    newValue = [self valueForKey:key];
                    if ([value isKindOfClass:[NSArray class]] && [newValue isKindOfClass:[ObjectArray class]]) {
                        [(ObjectArray *)newValue fillInJSONObject:value];
                    }
                } else {
                    if ([value isKindOfClass:[NSDictionary class]]) {
                        newValue = [[class alloc] init];
                        [newValue fillInJSONObject:value];
                    }
                }
            } else if ([S_VALUE_TYPES rangeOfString:typeName].location != NSNotFound) {
                newValue = value;
            } else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
                newValue = value;
            }
            [self setValue:newValue forKey:key];
        }
    }
}

- (NSString *)toJSONString {
    NSDictionary *jsonObjDic = [self toJSONObject];
    NSString     *jsonString = [[CommonHelper sharedSingleton] serializeObjectToString:jsonObjDic];

    return jsonString;
}
- (NSDictionary *)toJSONObject {
    NSMutableDictionary *jsonDictionary = [NSMutableDictionary dictionary];
    
    Class class = [self class];
    NSUInteger  counter;
    
    //To root classes.
    while (class != [NSObject class]) {
        objc_property_t *properties = class_copyPropertyList(class, &counter);
        
        //Copy properties.
        for (NSUInteger i = 0; i < counter; i++) {
            NSString *key = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
            id value = [self valueForKey:key];
            id newValue = nil;
            
            if ([value isKindOfClass:[NSString class]]) {
                newValue = value;
            } else if ([value isKindOfClass:[NSNumber class]]) {
                newValue = value;
            } else if ([value isKindOfClass:[NSNull class]]) {
                newValue = value;
            } else if ([value isKindOfClass:[NSArray class]]) {
                newValue = [(NSArray *)value toJSONObject];
            } else {
                newValue = [value toJSONObject];
            }
            if (newValue == nil) {
                newValue = [NSNull null];
            }
            
            [jsonDictionary setObject:newValue forKey:key];
        }
        class = class_getSuperclass(class);
    }
    return jsonDictionary;
}

#pragma mark - Private methods

+ (id)objectWithJSONObject:(id)jsonObj {
    id objsArray = nil;
    Class type = [self class];
    
    if ([jsonObj isKindOfClass:[NSArray class]]) {
        ObjectArray *array = [ObjectArray arrayWithObjectType:type];
        [array fillInJSONObject:jsonObj];
        objsArray = array;
    } else if([jsonObj isKindOfClass:[NSDictionary class]]) {
        NSObject *objItem = [[type alloc] init];
        [objItem fillInJSONObject:jsonObj];
        objsArray = objItem;
    }
    return objsArray;
}

- (NSString *)getTypeNameByAttribute:(objc_property_t) property {
    NSString *attribute = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
    NSRange range = NSMakeRange(1, [attribute rangeOfString:@","].location - 1);
    NSString *attrType = [attribute substringWithRange:range];
    return attrType;
}

- (Class)createObjectByTypeName:(NSString *)name {
    name = [name substringWithRange:NSMakeRange(2, [name length] - 3)];
    Class class = NSClassFromString(name);
    return class;
}

@end
