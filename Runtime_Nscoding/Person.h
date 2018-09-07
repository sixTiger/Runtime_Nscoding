//
//  Person.h
//  Runtime_Nscoding
//
//  Created by 杨小兵 on 15/8/5.
//  Copyright (c) 2015年 杨小兵. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property(nonatomic , copy)NSString *name;
@property(nonatomic , assign)NSInteger age;
- (NSDictionary *)toDictionary;

+ (void)test1:(NSString *)string;

- (void)test1:(NSString *)string;

- (void)test3:(NSString *)string;

- (void)test4:(NSString *)string;
@end
