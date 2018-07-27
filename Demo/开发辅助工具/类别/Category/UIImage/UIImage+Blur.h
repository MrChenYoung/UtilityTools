//
//  UIImage+Blur.h
//  BlurDemo
//
//  Created by sphere on 2017/10/16.
//  Copyright © 2017年 sphere. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Blur)
#pragma mark - 高斯模糊效果
/**
 *  CoreImage图片高斯模糊CoreImage图片高斯模糊(模糊后图片周围会有白框)
 *
 *  @param blurLevel  模糊数值(默认是10,范围0-100)
 *
 *  @return 重新绘制的新图片
 */
- (UIImage *)coreBlurWithLevel:(CGFloat)blurLevel imageSize:(CGSize)size;

/**
 *  CoreImage图片VariableBlur
 *
 *  @param mask  蒙版图片
 *  @param blurLevel  模糊数值(默认是10,范围0-100)
 *
 *  @return 重新绘制的新图片
 */
- (UIImage *)coreVariableBlurWithMask:(UIImage *)mask level:(CGFloat)blurLevel imageSize:(CGSize)size;

/**
 *  vImage模糊图片(模糊后图片周围没有白框,效率高,优先选择)
 *
 *  @param blur  模糊数值(0-1)
 *
 *  @return 重新绘制的新图片
 */
- (UIImage *)boxblurWithBlurNumber:(CGFloat)blur;

#pragma mark - 毛玻璃效果
/**
 *  iOS8.0以后苹果推出的控件,相当于在imageView上加了一个模糊视图
 *
 *  @param imageView 需要模糊的imageView
 *  @param level 模糊度(0-1)
 *
 */
+ (void)blurWithImageView: (UIImageView *)imageView blurLevel:(CGFloat)level;

/**
 *  用UIToolbar实现模糊,和UIBlurEffect相似,在imageView上添加模糊视图(效果也一样)
 *
 *  @param imageView 需要模糊的imageView
 *
 *  @param level 模糊度
 */
+ (void)blurToolbarWithImageVew:(UIImageView *)imageView blurLevel:(CGFloat)level;

@end
