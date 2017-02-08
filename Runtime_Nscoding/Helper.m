//
//  Helper.m
//  Runtime_Nscoding
//
//  Created by 杨小兵 on 15/8/6.
//  Copyright (c) 2015年 杨小兵. All rights reserved.
//

#import "Helper.h"
#import <objc/runtime.h>

@implementation Helper

- (id)initWithCoder:(NSCoder *)aDecoder
{
    
    if (self = [super init]) {
        Class c = self.class;
        // 截取类和父类的成员变量
        while (c && c != [NSObject class]) {
            unsigned int count = 0;
            Ivar *ivars = class_copyIvarList(c, &count);
            for (int i = 0; i < count; i++) {
                
                NSString *key = [NSString stringWithUTF8String:ivar_getName(ivars[i])];
                
                id value = [aDecoder decodeObjectForKey:key];
                
                [self setValue:value forKey:key];
                
            }
            // 获得c的父类
            c = [c superclass];
            free(ivars);
        }
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    
    Class c = self.class;
    // 截取类和父类的成员变量
    while (c && c != [NSObject class]) {
        unsigned int count = 0;
        
        Ivar *ivars = class_copyIvarList(c, &count);
        
        for (int i = 0; i < count; i++) {
            Ivar ivar = ivars[i];
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            
            id value = [self valueForKey:key];
            
            [aCoder encodeObject:value forKey:key];
        }
        c = [c superclass];
        // 释放内存
        free(ivars);
    }
}
- (void)helperTest
{
    NSLog(@"I'am a helper   我的父类没有实现相应地方法 大懒使小懒");
}
@end
