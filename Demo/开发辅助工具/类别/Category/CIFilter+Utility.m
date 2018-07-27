//
//  CIFilter+Utility.m
//  CategoryDemo
//
//  Created by sphere on 2017/10/27.
//  Copyright © 2017年 sphere. All rights reserved.
//

#import "CIFilter+Utility.h"

@implementation CIFilter (Utility)
/**
 *  获取所有的滤镜名字
 *
 *  @return 所有支持的滤镜名字
 */
- (NSArray<NSString *> *)filterNames
{
    return [CIFilter filterNamesInCategory:kCICategoryBuiltIn];
}

@end
