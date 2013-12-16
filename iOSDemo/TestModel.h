//
//  TestModel.h
//  NSObjectJSON
//
//  Created by Benjamin on 12/16/13.
//
//

#import <Foundation/Foundation.h>

@interface TestModel : NSObject

@property (nonatomic, assign) NSInteger articleId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;
@property (nonatomic, assign) NSInteger categoryId;

@end
