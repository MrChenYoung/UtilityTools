//
//  HYBaiduPanoManager.m
//  Test
//
//  Created by MrChen on 2018/3/26.
//  Copyright © 2018年 MrChen. All rights reserved.
//

#import "HYBaiduPanoManager.h"


#define AppKey @"2Hqjdkfbsr0djfEBctXs3Fk2"

@interface HYBaiduPanoManager ()<BaiduPanoramaViewDelegate>
// pano view
@property (nonatomic, strong, readwrite) BaiduPanoramaView *mainPanoView;

// 加载全景图回调(success 为true表示指定位置有全景图,false表示没有全景图)
@property (nonatomic, copy) void (^loadPanoComplete)(BOOL success);
@end

@implementation HYBaiduPanoManager
#pragma mark - singleTon
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static HYBaiduPanoManager *singleTon;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleTon = [super allocWithZone:zone];
        singleTon.mainPanoView = [[BaiduPanoramaView alloc]initWithFrame:[UIScreen mainScreen].bounds key:AppKey];
        [singleTon.mainPanoView showDirectionArrow:NO];
        singleTon.mainPanoView.delegate = singleTon;
    });
    
    return singleTon;
}

+ (instancetype)share
{
    return [[self alloc]init];
}

#pragma mark - 自定义
// 显示
- (void)showPanoInView:(UIView *)view
{
    [view addSubview:self.mainPanoView];
}


/**
 * 请求指定位置的全景图(异步,可以检测指定位置是否有全景图)
 * coordinate 指定坐标
 * complete 请求完成回调
 */
- (void)loadPanoramaWithCoordinate:(CLLocationCoordinate2D)coordinate complete:(void (^)(BOOL success))complete
{
    [self.mainPanoView setPanoramaWithLon:coordinate.longitude lat:coordinate.latitude];
    self.loadPanoComplete = complete;
}

#pragma mark - BaiduPanoramaViewDelegate
/**
 * @abstract 全景图将要加载
 * @param panoramaView 当前全景视图
 */
- (void)panoramaWillLoad:(BaiduPanoramaView *)panoramaView
{
    
}

/**
 * @abstract 全景图加载完毕
 * @param panoramaView 当前全景视图
 * @param jsonStr 全景单点信息
 *
 */
- (void)panoramaDidLoad:(BaiduPanoramaView *)panoramaView descreption:(NSString *)jsonStr
{
    NSLog(@"%@",jsonStr);
    
    if (self.loadPanoComplete) {
        self.loadPanoComplete(YES);
    }
}

/**
 * @abstract 全景图加载失败
 * @param panoramaView 当前全景视图
 * @param error 加载失败的返回信息
 *
 */
- (void)panoramaLoadFailed:(BaiduPanoramaView *)panoramaView error:(NSError *)error
{
    if (self.loadPanoComplete) {
        self.loadPanoComplete(NO);
    }
}

@end
