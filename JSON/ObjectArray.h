//
//  ObjectArray.h
//  NSObjectJSON
//
//  Created by Benjamin on 12/16/13.
//
//

#import <UIKit/UIKit.h>

@interface ObjectArray : NSMutableArray

@property (nonatomic, assign) Class   objType;

+ (id)arrayWithObjectType:(Class)type;

- (void)fillInJSONObject:(NSArray *)jsonObj;

@end
