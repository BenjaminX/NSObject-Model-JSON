//
//  CommonHelper.h
//  NSObjectJSON
//
//  Created by Benjamin on 12/16/13.
//
//

#import <Foundation/Foundation.h>

@interface CommonHelper : NSObject

+ (CommonHelper *)sharedSingleton;

- (id)deserializeStringToObject:(NSString *)jsonString;
- (NSString *)serializeObjectToString:(id)data;

@end
