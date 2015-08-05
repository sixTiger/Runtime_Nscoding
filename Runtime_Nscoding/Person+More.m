//
//  Person+More.m
//  Runtime_Nscoding
//
//  Created by 杨小兵 on 15/8/5.
//  Copyright (c) 2015年 杨小兵. All rights reserved.
//

#import "Person+More.h"
#import <objc/runtime.h>

@implementation Person (More)
// 用一个字节来存储key值，设置为静态私有变量，避免外界修改
static char bookNameKey;
- (void)setBookName:(NSString *)bookName
{
    
    // 将某个值与某个对象关联起来，将某个值存储到某个对象中
        objc_setAssociatedObject(self, &bookNameKey, bookName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)bookName
{
    return objc_getAssociatedObject(self, &bookNameKey);
}

static char booksKey;
- (void)setBooks:(NSArray *)books
{
    objc_setAssociatedObject(self, &booksKey, books, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)books
{
    return objc_getAssociatedObject(self, &booksKey);
}

@end
