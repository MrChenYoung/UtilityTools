//
//  NSObject+Catefory.m
//  Deppon
//
//  Created by MrChen on 2017/12/1.
//  Copyright © 2017年 MrChen. All rights reserved.
//

#import "NSObject+Catefory.h"

@implementation NSObject (Catefory)

/**
 * 冒泡排序实现求最大数
 */
+ (CGFloat)maxWithItems:(NSNumber *)numbers,...
{
    CGFloat result = [numbers floatValue];
    // 定义一个指向个数可变的参数列表指针；
    va_list argList;
    // 用于存放取出的参数
    NSNumber *arg;
    // 初始化变量刚定义的va_list变量，这个宏的第二个参数是第一个可变参数的前一个参数，是一个固定的参数
    va_start(argList, numbers);
    // 遍历全部参数 va_arg返回可变的参数(a_arg的第二个参数是你要返回的参数的类型)
    while ((arg = va_arg(argList, NSNumber *))){
        if ([arg floatValue] > result) {
            result = [arg floatValue];
        }
    }
    
    va_end(argList);
    
    return result;
}

/**
 * 加载bundle文件
 * 文件名
 */
+ (NSData *)fileWithName:(NSString *)fileName
{
    NSString *path = [[NSBundle mainBundle]pathForResource:fileName ofType:nil];
    NSData *data = [[NSData alloc]initWithContentsOfFile:path];
    return data;
}

@end
