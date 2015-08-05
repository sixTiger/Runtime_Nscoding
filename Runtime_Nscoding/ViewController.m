//
//  ViewController.m
//  Runtime_Nscoding
//
//  Created by 杨小兵 on 15/8/5.
//  Copyright (c) 2015年 杨小兵. All rights reserved.
//

#import "ViewController.h"
#import "Studet.h"
#import "Person+More.h"
#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    Studet *stu = [[Studet alloc]init];
    stu.name = @"name";
    stu.age = 12;
    stu.studyAge = @"一年级";
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //将对象归档
    path = [NSString stringWithFormat:@"%@/stu.data",path];
    [NSKeyedArchiver archiveRootObject:stu toFile:path];
    //将对象解档
    Studet *stu2 = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    NSLog(@"%@",stu2);
    
    
    Person *person = [[Person alloc] init];
    person.bookName = @"book";
    person.books = @[@"book1",@"book2"];
    NSLog(@"%@,%@",person.bookName,person.books);
}
@end
