//
//  HYLocationManager.m
//  BaiduPanoDemo
//
//  Created by MrChen on 2018/4/12.
//  Copyright © 2018年 MrChen. All rights reserved.
//

#import "HYLocationManager.h"

@interface HYLocationManager ()<CLLocationManagerDelegate>
// location sevice
@property (nonatomic, strong) CLLocationManager *loationMgr;

// 是否是一次定位
@property (nonatomic, assign) BOOL oneceLocation;

@end

@implementation HYLocationManager
#pragma mark - singleTon
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static HYLocationManager *singleTon;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleTon = [super allocWithZone:zone];
        [singleTon createLocationMgr];
    });
    
    return singleTon;
}

+ (instancetype)share
{
    return [[self alloc]init];
}


#pragma mark - 自定
// create location mgr
- (void)createLocationMgr
{
    _loationMgr = [[CLLocationManager alloc]init];
    _loationMgr.delegate = self;
}

// 开启一次定位
- (void)startOneceLocation
{
    // 授权
    BOOL canLocation = [self authorLocation];
    
    if (canLocation) {
        self.oneceLocation = YES;
        [_loationMgr startUpdatingLocation];
    }
}

// 开启定位
- (void)startLocation
{
    // 授权
    BOOL canLocation = [self authorLocation];
    
    if (canLocation) {
        self.oneceLocation = NO;
        [_loationMgr startUpdatingLocation];
    }
}

// 停止定位
- (void)stopUpdateLocation
{
    [self.loationMgr stopUpdatingLocation];
}

// 开启头部方向更新
- (void)startUpdateHead
{
    // 授权
    BOOL canLocation = [self authorLocation];
    
    if (canLocation) {
        self.oneceLocation = NO;
        [_loationMgr startUpdatingHeading];
    }
}

// 关闭头部更新
- (void)stopUpdateHead
{
    [self.loationMgr stopUpdatingHeading];
}

// 授权
- (BOOL)authorLocation
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 请求授权
        [self.loationMgr requestWhenInUseAuthorization];
        
        //        [self.loationMgr requestAlwaysAuthorization];
    }
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status){
        // 没有授权
        [self showTipWitnMsg:@"GPS未开启,请到设置中打开" inController:nil btnClick:^{
            if (self.unAuthorBlock) {
                self.unAuthorBlock();
            }
        }];
        return NO;
    }else {
        return YES;
    }
}

// 提示
- (void)showTipWitnMsg:(NSString *)msg inController:(UIViewController *)vc btnClick:(void (^)(void))click
{
    UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:msg message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertCtr addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (click) {
            click();
        }
    }]];
    
    if (vc == nil) {
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertCtr animated:YES completion:nil];
    }else {
        [vc presentViewController:alertCtr animated:YES completion:nil];
    }
}

#pragma mark - CLLocationManagerDelegate
// 获取位置更新
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    if (self.oneceLocation) {
        [self stopUpdateLocation];
    }
    
    if (locations.count > 0) {
        // success
        CLLocation *location = locations.lastObject;
        
        // 海拔高度
        double altitude = location.altitude;
        
        if (self.updateLocationSuccess) {
            self.updateLocationSuccess(location.coordinate,altitude);
        }
    }else {
        // error
        if (self.updateLocationError) {
            self.updateLocationError();
        }
    }
}

// 获取头部更新
-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    // 判断磁力计是否有效,负数时为无效，越小越精确
    if (newHeading.headingAccuracy > 0){
        if (newHeading) {
            // 更新头部信息成功
            double magneticHeading = newHeading.magneticHeading;
            double trueHeading = newHeading.trueHeading;
            
            if (self.updateHeadingSuccess) {
                self.updateHeadingSuccess(magneticHeading, trueHeading);
            }
        }else {
            // 更新头部信息失败
            if (self.updateHeadingError) {
                self.updateHeadingError();
            }
        }
    }
}

//判断设备是否需要校验，受到外来磁场干扰时
-(BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
    return YES;
}

@end
