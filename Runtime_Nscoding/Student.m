//
//  Studet.m
//  Runtime_Nscoding
//
//  Created by 杨小兵 on 15/8/5.
//  Copyright (c) 2015年 杨小兵. All rights reserved.
//

#import "Student.h"
#import <objc/runtime.h>

@implementation Student
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
    
    NSMutableString *string = [NSMutableString stringWithFormat:@"<%@: %p>{",[self class],self];
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



#pragma mark- 动态的添加了一个方法

/**
 *  动态的添加的方法
 *
 */
void  newFunction1(__strong id self, SEL _cmd){
    NSLog(@"%@  是动态添加的方法", [self name]);
}
void  newFunction2(__strong id self, SEL _cmd ,NSString *conten){
    NSLog(@"%@  是动态添加的方法,参数是 %@", [self name],conten);
}
//动态添加方法：在resolve中添加相应的方法，注意是类方法还是对象方法。
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if ([NSStringFromSelector(sel) isEqualToString:@"newFunction1"])
    {
        class_addMethod(self, sel, (IMP)newFunction1, "v@:"); // 为sel指定实现为newFunction1
        return NO;
    }
    if ([NSStringFromSelector(sel) isEqualToString:@"newFunction2:"])
    {
        class_addMethod(self, sel, (IMP)newFunction2, "v@:@"); // 为sel指定实现为newFunction2
        return NO;
    }
    return NO;
}


#pragma mark - 类方法
void  newFunction(__strong id self, SEL _cmd){
    NSLog(@"%@  是动态添加的方法#########################", [self class]);
}
+ (BOOL)resolveClassMethod:(SEL)sel
{
    if ([NSStringFromSelector(sel) isEqualToString:@"newFunction"])
    {
        class_addMethod(self, sel, (IMP)newFunction, "v@:"); // 为sel指定实现为newFunction
        return YES;
    }
    return YES;
}
@end
