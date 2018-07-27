//
//  NSDate+Catogory.h
//  Test
//
//  Created by MrChen on 2017/12/19.
//  Copyright © 2017年 MrChen. All rights reserved.
//

/**
 * 功能列表
 * 1> 获取日期的年、月、日、时、分、秒
 * 2> 日期转换成字符串
 * 3> 字符串类型日期转换成NSDate类型日期
 * 4> 通过日期获取时间戳
 * 5> 通过时间戳获取日期
 * 6> 给定日期计算距离现在多久
 * 7> 给定日期计算星座
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSDate (Category)

// 年
@property (nonatomic, assign) NSInteger year;
// 月
@property (nonatomic, assign) NSInteger month;
// 日
@property (nonatomic, assign) NSInteger day;
// 时
@property (nonatomic, assign) NSInteger hour;
// 分
@property (nonatomic, assign) NSInteger minute;
// 秒
@property (nonatomic, assign) NSInteger second;

/**
 * 日期转换为字符串
 * formate 日期格式，默认: 年:月:日 时:分:秒
 */
- (NSString *)toStringWithFormate:(NSString *)formate;

/**
 * 字符串格式日期转换成date格式
 * str 字符串格式日期
 * formate 日期格式,默认: 年:月:日 时:分:秒
 */
+ (NSDate *)dateWithString:(NSString *)str formate:(NSString *)formate;

/**
 * 日期转换成时间戳
 */
- (NSTimeInterval)timestamp;

/**
 * 时间戳转换成日期
 * timestamp 时间戳
 * 日期格式:默认: 年:月:日 时:分:秒
 */
+ (NSDate *)dateWithTimestamp:(NSTimeInterval)timestamp formate:(NSString *)formate;

/**
 * 给定时间戳，计算多久以前
 */
- (NSString *)timeBeforeInfoWithTimeStamp:(NSTimeInterval)timeIntrval;

/**
 * 给出日期计算星座
 * date 日期 格式: 年:月:日
 摩羯座 12月22日------1月19日
 水瓶座 1月20日-------2月18日
 双鱼座 2月19日-------3月20日
 白羊座 3月21日-------4月19日
 金牛座 4月20日-------5月20日
 双子座 5月21日-------6月21日
 巨蟹座 6月22日-------7月22日
 狮子座 7月23日-------8月22日
 处女座 8月23日-------9月22日
 天秤座 9月23日------10月23日
 天蝎座 10月24日-----11月21日
 射手座 11月22日-----12月21日
 */
-(NSString *)getConstellationInfo:(NSString *)date;

@end
