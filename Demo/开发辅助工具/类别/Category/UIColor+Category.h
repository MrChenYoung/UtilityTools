//
//  UIColor+Category.h
//  Test
//
//  Created by MrChen on 2018/3/17.
//  Copyright © 2018年 MrChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Category)
/**
 * 用十六进制颜色值设置颜色
 * color 十六进制颜色值
 * alpha 透明度
 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

/**
 * 设置十六进制颜色值,默认alpha值为1
 * 十六进制颜色值
 */
+ (UIColor *)colorWithHexString:(NSString *)color;
@end
