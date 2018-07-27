//
//  UIImage+Blur.m
//  BlurDemo
//
//  Created by sphere on 2017/10/16.
//  Copyright © 2017年 sphere. All rights reserved.
//

#import "UIImage+Blur.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage (Blur)

#pragma mark - 高斯模糊
/**
 *  CoreImage图片高斯模糊CoreImage图片高斯模糊(模糊后图片周围会有白框)
 *
 *  @param blurLevel  模糊数值(默认是10,范围0-100)
 *
 *  @return 重新绘制的新图片
 */
- (UIImage *)coreBlurWithLevel:(CGFloat)blurLevel imageSize:(CGSize)size
{
    //博客园-FlyElephant
    CIImage  *inputImage=[CIImage imageWithCGImage:self.CGImage];
    
    //设置filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:@(blurLevel) forKey: @"inputRadius"];
    
    //模糊图片
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef outImage=[context createCGImage:result fromRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *blurImage=[UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    
    return blurImage;
}

/**
 *  CoreImage图片VariableBlur
 *
 *  @param mask  蒙版图片
 *  @param blurLevel  模糊数值(默认是10,范围0-100)
 *
 *  @return 重新绘制的新图片
 */
- (UIImage *)coreVariableBlurWithMask:(UIImage *)mask level:(CGFloat)blurLevel imageSize:(CGSize)size
{
    // 创建属性
    CIImage *ciimage = [[CIImage alloc]initWithImage:self];
    
    /**
     *  创建滤镜
     *  滤镜效果 VariableBlur
     *  此滤镜模糊图像具有可变模糊半径。你提供和目标图像相同大小的灰度图像为它指定模糊半径
     *  白色的区域模糊度最高，黑色区域则没有模糊。
     */
    CIFilter *filter = [CIFilter filterWithName:@"CIMaskedVariableBlur"];
    
    // 指定过滤照片
    [filter setValue:ciimage forKey:kCIInputImageKey];
    
    // 指定mask image
    CIImage *maskImage = [[CIImage alloc]initWithImage:mask];
    [filter setValue:maskImage forKey:@"inputMask"];
    
    // 指定模糊度
    [filter setValue:[NSNumber numberWithFloat:blurLevel] forKey:@"inputRadius"];
    
    // 生成context
    CIContext *context = [CIContext contextWithOptions:nil];
    
    // 处理后照片
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage = [context createCGImage:result fromRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *blurImage = [[UIImage alloc]initWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}

+ (void)addCoverAsyCode:(void(^)())asyCodeBlock
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *cover = [[UIView alloc]initWithFrame:keyWindow.bounds];
    cover.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [keyWindow addSubview:cover];
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    activityView.center = cover.center;
    [cover addSubview:activityView];
    [activityView startAnimating];
    
    if (asyCodeBlock) {
        asyCodeBlock();
    }
    
    [activityView stopAnimating];
    [cover removeFromSuperview];
}

/**
 *  vImage模糊图片(模糊后图片周围没有白框,效率高,优先选择)
 *
 *  @param blur  模糊数值(0-1)
 *
 *  @return 重新绘制的新图片
 */
- (UIImage *)boxblurWithBlurNumber:(CGFloat)blur
{
    if (self == nil){
        NSLog(@"error:为图片添加模糊效果时，未能获取原始图片");
        return nil;
    }
    
    //模糊度,
    if (blur < 0.025f) {
        blur = 0.025f;
    } else if (blur > 1.0f) {
        blur = 1.0f;
    }
    
    //boxSize必须大于0
    int boxSize = (int)(blur * 100);
    boxSize -= (boxSize % 2) + 1;
    NSLog(@"boxSize:%i",boxSize);
    
    //图像处理
    CGImageRef img = self.CGImage;
    //需要引入#import <Accelerate/Accelerate.h>
    
    //图像缓存,输入缓存，输出缓存
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    //像素缓存
    void *pixelBuffer;
    
    //数据源提供者，Defines an opaque type that supplies Quartz with data.
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    // provider’s data.
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    //宽，高，字节/行，data
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //像数缓存，字节行*图片高
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    // 第三个中间的缓存区,抗锯齿的效果
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    //Convolves a region of interest within an ARGB8888 source image by an implicit M x N kernel that has the effect of a box filter.
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    //    NSLog(@"字节组成部分：%zu",CGImageGetBitsPerComponent(img));
    //颜色空间DeviceRGB
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //用图片创建上下文,CGImageGetBitsPerComponent(img),7,8
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(self.CGImage));
    
    //根据上下文，处理过的图片，重新组件
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    free(pixelBuffer2);
    CFRelease(inBitmapData);
    //CGColorSpaceRelease(colorSpace);   //多余的释放
    CGImageRelease(imageRef);
    return returnImage;
}

#pragma mark - 毛玻璃效果
/**
 *  iOS8.0以后苹果推出的控件,相当于在imageView上加了一个模糊视图
 *
 *  @param imageView 需要模糊的imageView
 *  @param level 模糊度(0-1)
 *
 */
+ (void)blurWithImageView: (UIImageView *)imageView blurLevel:(CGFloat)level
{
    // 创建effect
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    // 创建effectview,把模糊效果添加到图片上
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:effect];
    effectView.frame = imageView.bounds;
    effectView.alpha = level;
    
    // 添加effectView到图片上
    [imageView addSubview:effectView];
}

/**
 *  用UIToolbar实现模糊,和UIBlurEffect相似,在imageView上添加模糊视图(效果也一样)
 *
 *  @param imageView 需要模糊的imageView
 *
 *  @param level 模糊度
 */
+ (void)blurToolbarWithImageVew:(UIImageView *)imageView blurLevel:(CGFloat)level
{
    // 创建toolbar
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:imageView.bounds];
    
    // 设置style，实现毛玻璃效果
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    toolBar.alpha = level;
    
    // 添加ToolBar到imageView上
    [imageView addSubview:toolBar];
}


@end
