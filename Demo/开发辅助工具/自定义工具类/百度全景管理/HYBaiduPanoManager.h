//
//  HYBaiduPanoManager.h
//  Test
//
//  Created by MrChen on 2018/3/26.
//  Copyright © 2018年 MrChen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduPanoSDK/BaiduPanoramaView.h>

@interface HYBaiduPanoManager : NSObject

// pano view
@property (nonatomic, strong, readonly) BaiduPanoramaView *mainPanoView;

+ (instancetype)share;

// 显示
- (void)showPanoInView:(UIView *)view;

/**
 * 请求指定位置的全景图(异步,可以检测指定位置是否有全景图)
 * coordinate 指定坐标
 * complete 请求完成回调,success为true表示有全景图,success为false表示没有全景图
 */
- (void)loadPanoramaWithCoordinate:(CLLocationCoordinate2D)coordinate complete:(void (^)(BOOL success))complete;

@end
