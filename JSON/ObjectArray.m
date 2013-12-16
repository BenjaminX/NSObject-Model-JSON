//
//  ObjectArray.m
//  NSObjectJSON
//
//  Created by Benjamin on 12/16/13.
//
//

#import "ObjectArray.h"

#import "NSObject+JSON.h"


@interface ObjectArray()
@property (nonatomic, strong)   NSMutableArray      *internalDataArray;
@property (nonatomic, strong)   Class               objectType;
@end

@implementation ObjectArray

- (id)init {
    self = [super init];
    if (self) {
        self.internalDataArray = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (id)arrayWithObjectType:(Class)type {
    ObjectArray *array = [[ObjectArray alloc] init];
    array.objType = type;
    return array;
}

- (void)fillInJSONObject:(NSArray *)jsonObj {
    Class type = self.objType;
    for (id item in jsonObj) {
        if ([item isKindOfClass:[NSDictionary class]]) {
            NSObject *obj = [[type alloc] init];
            [obj fillInJSONObject:item];
            [self addObject:obj];
        } else {
            [self addObject:item];
        }
    }
}


/**
 *
 NSMutableArray, in a subclass, you must override all these methods.
 
 insertObject:atIndex:
 removeObjectAtIndex:
 addObject:
 removeLastObject
 replaceObjectAtIndex:withObject:
 
 */
#pragma mark - NSMutableArray override five primitive methods

- (void) insertObject:(id)anObject atIndex:(NSUInteger)index {
    [self.internalDataArray insertObject:anObject atIndex:index];
}

- (void) removeObjectAtIndex:(NSUInteger)index {
    [self.internalDataArray removeObjectAtIndex:index];
}

- (void) addObject:(id)anObject {
    [self.internalDataArray addObject:anObject];
}

- (void) removeLastObject {
    [self.internalDataArray removeLastObject];
}

- (void) replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    [self.internalDataArray replaceObjectAtIndex:index withObject:anObject];
}

/**
 *
 NSArray, in a subclass, you must override all these methods.
 
 count
 objectAtIndex:
 
 */
#pragma mark - NSArray override two primitive methods

- (NSUInteger)count {
    return self.internalDataArray.count;
}

- (id)objectAtIndex:(NSUInteger)index {
    return [self.internalDataArray objectAtIndex:index];
}

@end
