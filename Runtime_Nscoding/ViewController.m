//
//  ViewController.m
//  Runtime_Nscoding
//
//  Created by 杨小兵 on 15/8/5.
//  Copyright (c) 2015年 杨小兵. All rights reserved.
//

#import "ViewController.h"
#import "Student.h"
#import "Person+More.h"
#import "XXBClassA.h"
#import "XXBClassB.h"
#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [self test1];
//    [self test2];
//    [self test3];
//    [self test4];
    [self test5];
}
- (void)test1
{
    
    Student *stu = [[Student alloc]init];
    stu.name = @"name";
    stu.age = 12;
    [stu setValue:@(14) forKeyPath:@"age"];
    stu.studyAge = @"一年级";
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //将对象归档
    path = [NSString stringWithFormat:@"%@/stu.data",path];
    [NSKeyedArchiver archiveRootObject:stu toFile:path];
    //将对象解档
    Student *stu2 = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    NSLog(@"*******%@",stu2);
    
    Person *person = [[Person alloc] init];
    person.bookName = @"book";
    person.books = @[@"book1",@"book2"];
    NSLog(@"%@,%@",person.bookName,person.books);
}
static void printSchool(id temp, SEL _cmd) {
    NSLog(@"我的学校是%@", [temp valueForKey:@"schoolName"]);
    NSLog(@"名字是%@", [temp valueForKey:@"name"]);
}
/**
 *  动态的添加一个类，动态的实现一些类的方法
 */
- (void)test2
{
    static dispatch_once_t onceToken;
    
    __block Class  classStudent = objc_getClass("NewStudent");
    if (classStudent == nil)
    {
        dispatch_once(&onceToken, ^{
            
            classStudent = objc_allocateClassPair(Person.class, "NewStudent", 0);
            // 添加一个NSString的变量，第四个参数是对其方式，第五个参数是参数类型
            if (class_addIvar(classStudent, "schoolName", sizeof(NSString *), 0, "@")) {
                NSLog(@"添加成员变量schoolName成功");
            }
            
            // 为Student类添加方法 "v@:"这种写法见参数类型连接
            if (class_addMethod(classStudent, @selector(printSchool), (IMP)printSchool, "v@:")) {
                NSLog(@"添加方法printSchool:成功");
            }
            
            // 注册这个类到runtime系统中就可以使用他了
            objc_registerClassPair(classStudent); // 返回void
            
        });

    }
    
    
    // 使用创建的类
    id student = [[classStudent alloc] init];
    NSString *schoolName = @"鲁东大学";
    // 给刚刚添加的变量赋值
    // object_setInstanceVariable(student, "schoolName", (void *)&str);在ARC下不允许使用
    [student setValue:schoolName forKey:@"schoolName"];
    
    [student setValue:@"名字" forKey:@"name"];
    // 调用printSchool方法，也就是给student这个接受者发送printSchool:这个消息
    //    objc_msgSend(student, "printSchool"); // 我尝试用这种方法调用但是没有成功
    [student performSelector:@selector(printSchool) withObject:nil]; // 动态调用未显式在类中声明的方法
}
- (void)printSchool
{
    
    NSLog(@"我的学校是");
}
/**
 *  动态的添加方法
 */
- (void)test3
{
    [Student test1:@"test1"];
    [Student test2:@"test2"];

    [Student respondsToSelector:@selector(newFunction)];
    Student * student = [[Student alloc] init];
    
    student.name = @"test3";
    
    [student performSelector:@selector(newFunction1)];
    [student performSelector:@selector(newFunction2:) withObject:@"world"];
    NSLog(@"%@",student);
    
}

- (void)test4 {
    Student * student = [[Student alloc] init];
    student.name = @"test3";
    NSLog(@"%@",[student toDictionary]);
}

- (void)test5 {
    XXBClassA *classA = [XXBClassA new];
    [classA test];
}
@end
