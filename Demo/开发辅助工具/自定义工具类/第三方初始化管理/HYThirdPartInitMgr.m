//
//  HYThirdPartInitMgr.m
//  BaiduPanoDemo
//
//  Created by MrChen on 2018/3/29.
//  Copyright © 2018年 MrChen. All rights reserved.
//

#import "HYThirdPartInitMgr.h"
//#import <AMapFoundationKit/AMapFoundationKit.h>
//#import <BaiduMapAPI_Map/BMKMapComponent.h>
//#import <IQKeyboardManager.h>

#define GdAppKey @"3eff51f5536b1b961708a7a7758f8d8b"
#define BdAppkey @"2Hqjdkfbsr0djfEBctXs3Fk2"

@interface HYThirdPartInitMgr () // <BMKGeneralDelegate>

// 百度地图初始化管理
//@property (nonatomic, strong) BMKMapManager *mapManager;
@end

@implementation HYThirdPartInitMgr
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static HYThirdPartInitMgr *singleTon;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleTon = [super allocWithZone:zone];
        
        // 初始化高德地图
        [singleTon initGdMap];
        
        // 初始化百度地图
        [singleTon initBdMap];
        
        // 初始化键盘管理
        [singleTon initIQKeyboardManager];
    });
    
    return singleTon;
}

+ (instancetype)share
{
    return [[self alloc]init];
}

#pragma mark - 初始化高德地图
- (void)initGdMap
{
    // 初始化高德地图服务
//    [AMapServices sharedServices].apiKey = GdAppKey;
}

#pragma mark - 初始化百度地图
- (void)initBdMap
{
//    if (!self.mapManager) {
//        self.mapManager = [[BMKMapManager alloc]init];
//    }
//
//    BOOL success = [self.mapManager start:BdAppkey generalDelegate:self];
//    if (success) {
//        NSLog(@"发送百度地图初始化成功");
//    }else {
//        NSLog(@"发送百度地图初始化失败");
//    }
}

/**
 *返回网络错误
 *@param iError 错误号
 */
- (void)onGetNetworkState:(int)iError
{
    if (iError != 0) {
        NSLog(@"百度地图联网失败");
    }
}

/**
 *返回授权验证错误
 *@param iError 错误号 : 为0时验证通过，具体参加BMKPermissionCheckResultCode
 */
- (void)onGetPermissionState:(int)iError
{
    if (iError != 0) {
        NSLog(@"百度地图授权失败");
    }
}

#pragma mark - IQKeyboardManager
- (void)initIQKeyboardManager
{
    // 获取类库的单例变量
//    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
//    
//    // 控制整个功能是否启用
//    keyboardManager.enable = YES;
//    
//    // 控制点击背景是否收起键盘
//    keyboardManager.shouldResignOnTouchOutside = YES;
//    
//    // 控制键盘上的工具条文字颜色是否用户自定义
//    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES;
//    
//    // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
//    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews;
//    
//    // 控制是否显示键盘上的工具条
//    keyboardManager.enableAutoToolbar = YES;
//    
//    // 是否显示占位文字
//    keyboardManager.shouldShowTextFieldPlaceholder = YES;
//    
//    // 设置占位文字的字体
//    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:17];
//    
//    // 输入框距离键盘的距离
//    keyboardManager.keyboardDistanceFromTextField = 10.0f;
}


@end
