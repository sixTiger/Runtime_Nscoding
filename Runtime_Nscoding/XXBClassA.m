//
//  XXBClassA.m
//  Runtime_Nscoding
//
//  Created by xiaobing5 on 2018/9/6.
//  Copyright © 2018年 杨小兵. All rights reserved.
//

#import "XXBClassA.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation XXBClassA

- (instancetype)init {
    if (self = [super init]) {
        [self exchangeFunction];
    }
    return self;
}

- (void)exchangeFunction {
    Class class = NSClassFromString(@"XXBClassA");
    SEL oringleSelector = @selector(test);
    SEL swizzSelector = NSSelectorFromString(@"test_test");
    
    Method targetMethod = class_getInstanceMethod(class, oringleSelector);
    const char *typeEncoding = method_getTypeEncoding(targetMethod);
    class_addMethod(self.class, swizzSelector, method_getImplementation(targetMethod), typeEncoding);
    
    class_replaceMethod(class, oringleSelector, aspect_getMsgForwardIMP(self, oringleSelector), typeEncoding);
}

- (void)test {
    NSLog(@"XXB | %s [Line %d] %@",__func__,__LINE__,[NSThread currentThread]);
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL originalSelector = anInvocation.selector;
    NSString *selectString = [NSString stringWithFormat:@"%@_test",NSStringFromSelector(originalSelector)];
    SEL swzzSelector = NSSelectorFromString(selectString);
    NSLog(@"XXB: %@",@"方法执行前");
    anInvocation.selector = swzzSelector;
    Class klass = object_getClass(anInvocation.target);
    if ( [klass instancesRespondToSelector:swzzSelector]) {
        [anInvocation invoke];
    }
    NSLog(@"XXB: %@",@"方法执行后");
}

static IMP aspect_getMsgForwardIMP(NSObject *self, SEL selector) {
    IMP msgForwardIMP = _objc_msgForward;
#if !defined(__arm64__)
    // As an ugly internal runtime implementation detail in the 32bit runtime, we need to determine of the method we hook returns a struct or anything larger than id.
    // https://developer.apple.com/library/mac/documentation/DeveloperTools/Conceptual/LowLevelABI/000-Introduction/introduction.html
    // https://github.com/ReactiveCocoa/ReactiveCocoa/issues/783
    // http://infocenter.arm.com/help/topic/com.arm.doc.ihi0042e/IHI0042E_aapcs.pdf (Section 5.4)
    Method method = class_getInstanceMethod(self.class, selector);
    const char *encoding = method_getTypeEncoding(method);
    BOOL methodReturnsStructValue = encoding[0] == _C_STRUCT_B;
    if (methodReturnsStructValue) {
        @try {
            NSUInteger valueSize = 0;
            NSGetSizeAndAlignment(encoding, &valueSize, NULL);
            
            if (valueSize == 1 || valueSize == 2 || valueSize == 4 || valueSize == 8) {
                methodReturnsStructValue = NO;
            }
        } @catch (__unused NSException *e) {}
    }
    if (methodReturnsStructValue) {
        msgForwardIMP = (IMP)_objc_msgForward_stret;
    }
#endif
    return msgForwardIMP;
}

@end
