//
//  HYLocationManager.h
//  BaiduPanoDemo
//
//  Created by MrChen on 2018/4/12.
//  Copyright © 2018年 MrChen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface HYLocationManager : NSObject

// update location success
@property (nonatomic, copy) void (^updateLocationSuccess)(CLLocationCoordinate2D coordinate, double altitude);

// update location error
@property (nonatomic, copy) void (^updateLocationError)(void);

// update heading success
// magneticHeading:地磁航向数据  trueHeading:地理航向数据
@property (nonatomic, copy) void (^updateHeadingSuccess)(double magneticHeading,double trueHeading);

// update heading error
@property (nonatomic, copy) void (^updateHeadingError)(void);

// 未授权提示框被点击回调
@property (nonatomic, copy) void (^unAuthorBlock)(void);

+ (instancetype)share;

// 开启定位
- (void)startLocation;

// 开启一次定位
- (void)startOneceLocation;

// 停止定位
- (void)stopUpdateLocation;

// 开启头部方向更新
- (void)startUpdateHead;

// 关闭头部更新
- (void)stopUpdateHead;

@end
