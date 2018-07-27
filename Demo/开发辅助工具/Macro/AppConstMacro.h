//
//  AppConstMacro.h
//  Deppon
//
//  Created by MrChen on 2017/11/30.
//  Copyright © 2017年 MrChen. All rights reserved.
//

#ifndef AppConstMacro_h
#define AppConstMacro_h

#pragma mark - view frame相关
// 主屏幕尺寸
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width
#define Main_Screen_Bounds      [UIScreen mainScreen].bounds
#define Main_Screen_Size        [UIScreen mainScreen].bounds.size

// 状态栏
#define kStatusBarHeight        (Main_Screen_Height == 812.0 ? 44.0 : 20.0)

// 屏幕底部,适配iPhone X(iPhone X底部圆角高度34)
#define KSafeAreaBottomHeight (Main_Screen_Height == 812.0 ? 34 : 0)

// 导航栏高度(适配iPhone X的齐刘海)
#define kNaviBarHeight (Main_Screen_Height == 812.0 ? 88 : 64)
#define kTabBarHeight           (49.f)

// cell默认高度
#define kCellDefaultHeight      (44.f)

// 键盘高度
#define kEnglishKeyboardHeight  (216.f)
#define kChineseKeyboardHeight  (252.f)


// 屏幕适配比例

// 默认以4英寸为准
#define KWScale4inch Main_Screen_Width/320.0
#define KHScale4inch Main_Screen_Height/568.0
#define KW4inch(width) KWScale4inch * width
#define KH4inch(height) KHScale4inch * height

// 默认以4.7英寸为准
#define KWScale47inch Main_Screen_Width/375.0
#define KHScale47inch (Main_Screen_Height == 812.0 ? 667.0/667.0 : Main_Screen_Height/667.0)
#define KW47inch(width) KWScale47inch * width
#define KH47inch(height) KHScale47inch * height

// 默认以5.5英寸为准
#define KWScale55inch Main_Screen_Width/414.0
#define KHScale55inch Main_Screen_Height/736.0
#define KW55inch(width) KWScale55inch * width
#define KH55inch(height) KHScale55inch * height

#pragma mark - 颜色相关
// 颜色(RGB)
#define RgbColor(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RgbaColor(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

// 主色调
#define MainColor               RgbColor(94,109,253)
// 背景灰色
#define GrayBgColor             RgbColor(242, 242, 242)

///常用颜色
#define black_color     [UIColor blackColor]
#define blue_color      [UIColor blueColor]
#define brown_color     [UIColor brownColor]
#define clear_color     [UIColor clearColor]
#define darkGray_color  [UIColor darkGrayColor]
#define darkText_color  [UIColor darkTextColor]
#define white_color     [UIColor whiteColor]
#define yellow_color    [UIColor yellowColor]
#define red_color       [UIColor redColor]
#define orange_color    [UIColor orangeColor]
#define purple_color    [UIColor purpleColor]
#define lightText_color [UIColor lightTextColor]
#define lightGray_color [UIColor lightGrayColor]
#define green_color     [UIColor greenColor]
#define gray_color      [UIColor grayColor]
#define magenta_color   [UIColor magentaColor]
#define clear_color     [UIColor clearColor]

#pragma mark - 字体相关
// 字体大小(常规/粗体)
#define BoldSystemFont(FontSize)[UIFont boldSystemFontOfSize:FontSize]
#define SystemFont(FontSize)    [UIFont systemFontOfSize:FontSize]
#define Font(Name, FontSize)    [UIFont fontWithName:(Name) size:(FontSize)]

#pragma mark - 图片相关
// PNG JPG 图片路径
#define PNGPATH(NAME)           [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:NAME] ofType:@"png"]
#define JPGPATH(NAME)           [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:NAME] ofType:@"jpg"]
#define PATH(NAME, EXT)         [[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]

// 加载图片
#define ImageNamed(imgName) [UIImage imageNamed:imgName]
#define PNGkImg(NAME)          [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"png"]]
#define JPGkImg(NAME)          [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"jpg"]]
#define kImg(NAME, EXT)        [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]]

// 字符串是否相等
#define equalString(str1,str2) [str1 isEqualToString:str2]

#pragma mark - 自定义log
#ifdef DEBUG
#define HYLog(fmt,...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define DebugModel YES  // 开发环境
#else
#define HYLog(...)
#define DebugModel NO   // 发布环境
#endif

#pragma mark - 第三方key
#define BaiDuMapAppKey @"75hNzL0UtkQFBNxq0FHTZgnxVqPTu3Tc"
#define GaoDeMapAppKey @"f7ed9d15296459c2ad38752909863a46"

#pragma mark - 首次启动键值
#define EverlaunchKey @"everLaunch"
#define FirstLaunchKey @"firstLauch"

#endif /* AppConstMacro_h */
