//
//  Studet.h
//  Runtime_Nscoding
//
//  Created by 杨小兵 on 15/8/5.
//  Copyright (c) 2015年 杨小兵. All rights reserved.
//

#import "Person.h"

@interface Student : Person
/**
 *  年级
 */
@property(nonatomic , copy)NSString *studyAge;
@property(nonatomic ,assign) NSInteger  realAge;
@property(nonatomic ,strong) NSString   *realName;
+ (void)test1:(NSString *)string;
+ (void)test2:(NSString *)string;
- (void)test1:(NSString *)string;
- (void)test2:(NSString *)string;
- (void)test3:(NSString *)string;
- (void)test4:(NSString *)string;
@end
