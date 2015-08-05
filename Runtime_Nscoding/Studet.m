//
//  Studet.m
//  Runtime_Nscoding
//
//  Created by 杨小兵 on 15/8/5.
//  Copyright (c) 2015年 杨小兵. All rights reserved.
//

#import "Studet.h"
#import <objc/runtime.h>

@implementation Studet
+ (void)load
{
    // 获取类方法
    Method m1 = class_getClassMethod([self class], @selector(test1:));
    Method m2 = class_getClassMethod([self class], @selector(test2:));
    method_exchangeImplementations(m1, m2);
    //获取对象方法
    Method m3 = class_getInstanceMethod([self class], @selector(test1:));
    Method m4 = class_getInstanceMethod([self class], @selector(test2:));
    method_exchangeImplementations(m3, m4);
}
- (instancetype)init
{
    if (self = [super init])
    {
        [self test1:@"test1"];
        [self test2:@"test2"];
    }
    return self;
}
+ (void)test1:(NSString *)string
{
    
    NSLog(@"我是+++++test1 %@ %@",NSStringFromSelector(_cmd),string);
}
+ (void)test2:(NSString *)string
{
    NSLog(@"我是-----test2 %@ %@",NSStringFromSelector(_cmd),string);
}

- (void)test1:(NSString *)string
{
    
    NSLog(@"我是+++++test1 %@ %@",NSStringFromSelector(_cmd),string);
}
- (void)test2:(NSString *)string
{
    NSLog(@"我是-----test2 %@ %@",NSStringFromSelector(_cmd),string);
}
- (NSString *)description
{
    NSMutableString *string = [NSMutableString stringWithFormat:@"<%@: %p>\n{",[self class],self];
    Class c = self.class;
    // 截取类和父类的成员变量
    while (c && c != [NSObject class])
    {
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList(c, &count);
        for (int i = 0; i < count; i++)
        {
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivars[i])];
            [string appendFormat:@"\n%@:%@ ",key,[self valueForKeyPath:key]];
        }
        // 获得c的父类
        c = [c superclass];
        free(ivars);
    }
    [string appendFormat:@"\n}"];
    return string;
}
@end
