//
//  Person+More.h
//  Runtime_Nscoding
//
//  Created by 杨小兵 on 15/8/5.
//  Copyright (c) 2015年 杨小兵. All rights reserved.
//

#import "Person.h"
/**
 *  动态的添加属性
 */
@interface Person (More)

/**
 *  为每一个对象添加一个name属性
 */
@property (nonatomic,copy) NSString *bookName;
/**
 *  为每个对象添加一个数组属性
 */
@property (nonatomic,strong) NSArray *books;
@end
