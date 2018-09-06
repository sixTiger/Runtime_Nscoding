//
//  XXBClassB.m
//  Runtime_Nscoding
//
//  Created by xiaobing5 on 2018/9/6.
//  Copyright © 2018年 杨小兵. All rights reserved.
//

#import "XXBClassB.h"
#import "XXBClassA.h"
#import <objc/runtime.h>

@implementation XXBClassB
//- (id)forwardingTargetForSelector:(SEL)aSelector {
//    return [XXBClassA new];
//}

- (void)test {
    NSLog(@"XXB | %s [Line %d] %@",__func__,__LINE__,[NSThread currentThread]);
}

- (void)test_test {
    NSLog(@"XXB | %s [Line %d] %@",__func__,__LINE__,[NSThread currentThread]);
}

@end
