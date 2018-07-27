//
//  CIFilter+Utility.h
//  CategoryDemo
//
//  Created by sphere on 2017/10/27.
//  Copyright © 2017年 sphere. All rights reserved.
//
/**
 * 功能列表
 * 1> 获取所有支持的滤镜
 */


#import <CoreImage/CoreImage.h>

@interface CIFilter (Utility)
/**
 *  获取所有的滤镜名字
 *
 *  @return 所有支持的滤镜名字
 */
- (NSArray<NSString *> *)filterNames;

@end
