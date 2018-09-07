//
//  Studet.m
//  Runtime_Nscoding
//
//  Created by 杨小兵 on 15/8/5.
//  Copyright (c) 2015年 杨小兵. All rights reserved.
//

#import "Student.h"
#import "Helper.h"
#import <objc/runtime.h>

@interface Student ()

@property(nonatomic , strong)Helper *helper;
@end

@implementation Student
+ (void)load
{
    Class class = [self class];
    
    // 获取类方法
    Method m1 = class_getClassMethod(class, @selector(test1:));
    Method m2 = class_getClassMethod(class, @selector(test2:));
    //直接交换两个方法的实现，如果test1 在父类中实现， test2 在子类中实现，
    //这样会直到时父类中调用test1 方法的时候直接变成调用子类的test2 方法
    method_exchangeImplementations(m1, m2);
    //获取对象方法
    Method m3 = class_getInstanceMethod(class, @selector(test1:));
    Method m4 = class_getInstanceMethod(class, @selector(test2:));
    method_exchangeImplementations(m3, m4);
    
    //正确的交换方法的实现《这样不会影响父类的相关方法，只影响当前的类》
    SEL originalSelector = @selector(test3:);
    SEL swizzledSelector = @selector(test4:);
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    //获取对象方法 如果对应的方法在父类中实现的话可以添加成功，如果只在当前类实现的话直接交换就行了
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        //当前的类没有实现对应的方法，会添加成功《test3方法在父类中实现的话会走到这里》
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
- (instancetype)init
{
    if (self = [super init])
    {
        [self test1:@"test1"];
        [self test2:@"test2"];
        _helper = [[Helper alloc] init];
    }
    return self;
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


- (void)test3:(NSString *)string {
    NSLog(@"XXB | %s [Line %d] %@",__func__,__LINE__,[NSThread currentThread]);
}

- (void)test4:(NSString *)string {
    NSLog(@"XXB | %s [Line %d] %@",__func__,__LINE__,[NSThread currentThread]);
}

- (NSString *)description
{
    
    [self performSelector:@selector(helperTest)];
    
    
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
    }
    if ([NSStringFromSelector(sel) isEqualToString:@"newFunction2:"])
    {
        class_addMethod(self, sel, (IMP)newFunction2, "v@:@"); // 为sel指定实现为newFunction2
    }
    return [super resolveClassMethod:sel];
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
    }
    return [super resolveClassMethod:sel];
}


#pragma mark - 消息发送


- (id)forwardingTargetForSelector:(SEL)aSelector {
    
    
    NSString *selectorString = NSStringFromSelector(aSelector);
    
    // 将消息转发给_helper来处理 <前提是本类中没有响应的方法的实现>
    if ([selectorString isEqualToString:@"helperTest"]) {
        return _helper;
    }
    return [super forwardingTargetForSelector:aSelector];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL selector = [anInvocation selector];
    if ([self.helper respondsToSelector:selector])
    {
        [anInvocation invokeWithTarget:self.helper];
    }
}



- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    
    if (!signature)
    {
        if ([Helper instancesRespondToSelector:aSelector]) {
            signature = [Helper instanceMethodSignatureForSelector:aSelector];
        }
    }
    
    return signature;
}

@end
