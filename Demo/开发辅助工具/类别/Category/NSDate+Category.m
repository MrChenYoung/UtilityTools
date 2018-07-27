//
//  NSDate+Catogory.m
//  Test
//
//  Created by MrChen on 2017/12/19.
//  Copyright © 2017年 MrChen. All rights reserved.
//

#import "NSDate+Category.h"

@implementation NSDate (Category)
/**
 * 年
 */
- (NSInteger)year
{
    NSDateFormatter *formate = [[NSDateFormatter alloc]init];
    formate.dateFormat = @"yyyy";
    
    NSInteger year = [[formate stringFromDate:self] integerValue];
    
    return year;
}

/**
 * 月
 */
- (NSInteger)month
{
    NSDateFormatter *formate = [[NSDateFormatter alloc]init];
    formate.dateFormat = @"MM";
    
    NSInteger month = [[formate stringFromDate:self] integerValue];
    
    return month;
}

/**
 * 日
 */
- (NSInteger)day
{
    NSDateFormatter *formate = [[NSDateFormatter alloc]init];
    formate.dateFormat = @"dd";
    
    NSInteger day = [[formate stringFromDate:self] integerValue];
    
    return day;
}

/**
 * 时
 */
- (NSInteger)hour
{
    NSDateFormatter *formate = [[NSDateFormatter alloc]init];
    formate.dateFormat = @"HH";
    
    NSInteger hour = [[formate stringFromDate:self] integerValue];
    
    return hour;
}

/**
 * 分
 */
- (NSInteger)minute
{
    NSDateFormatter *formate = [[NSDateFormatter alloc]init];
    formate.dateFormat = @"mm";
    
    NSInteger minute = [[formate stringFromDate:self] integerValue];
    
    return minute;
}

/**
 * 秒
 */
- (NSInteger)second
{
    NSDateFormatter *formate = [[NSDateFormatter alloc]init];
    formate.dateFormat = @"ss";
    
    NSInteger second = [[formate stringFromDate:self] integerValue];
    
    return second;
}

/**
 * 日期转换为字符串
 * formate 日期格式，默认: 年:月:日 时:分:秒
 */
- (NSString *)toStringWithFormate:(NSString *)formate
{
    NSDateFormatter *dateFormate = [[NSDateFormatter alloc]init];
    dateFormate.dateFormat = (formate.length == 0 ? @"yyyy-MM-dd HH:mm:ss" : formate);
    NSString *str = [dateFormate stringFromDate:self];
    return str;
}

/**
 * 字符串格式日期转换成date格式
 * str 字符串格式日期
 * formate 日期格式,默认: 年:月:日 时:分:秒
 */
+ (NSDate *)dateWithString:(NSString *)str formate:(NSString *)formate
{
    if (str.length == 0) return nil;
    
    NSDateFormatter *stampFormatter = [[NSDateFormatter alloc] init];
    stampFormatter.dateFormat = (formate.length == 0 ? @"yyyy-MM-dd HH:mm:ss" : formate);
    NSDate *date = [stampFormatter dateFromString:str];
    
    return date;
}

/**
 * 日期转换成时间戳
 */
- (NSTimeInterval)timestamp
{
    return [self timeIntervalSince1970];
}

/**
 * 时间戳转换成日期
 * timestamp 时间戳
 * 日期格式:默认: 年:月:日 时:分:秒
 */
+ (NSDate *)dateWithTimestamp:(NSTimeInterval)timestamp formate:(NSString *)formate
{
    NSDateFormatter *stampFormatter = [[NSDateFormatter alloc] init];
    stampFormatter.dateFormat = (formate.length == 0 ? @"yyyy-MM-dd HH:mm:ss" : formate);
    
    //以 1970/01/01 GMT为基准，然后过了secs秒的时间
    NSDate *stampDate2 = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    return stampDate2;
}

/**
 * 给定时间戳，计算多久以前
 */
- (NSString *)timeBeforeInfoWithTimeStamp:(NSTimeInterval)timeIntrval
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //获取此时时间戳长度
    NSTimeInterval nowTimeinterval = [[NSDate date] timeIntervalSince1970];
    int timeInt = nowTimeinterval - timeIntrval; //时间差
    
    int year = timeInt / (3600 * 24 * 30 *12);
    int month = timeInt / (3600 * 24 * 30);
    int day = timeInt / (3600 * 24);
    int hour = timeInt / 3600;
    int minute = timeInt / 60;
    int second = timeInt;
    if (year > 0) {
        return [NSString stringWithFormat:@"%d年以前",year];
    }else if(month > 0){
        return [NSString stringWithFormat:@"%d个月以前",month];
    }else if(day > 0){
        return [NSString stringWithFormat:@"%d天以前",day];
    }else if(hour > 0){
        return [NSString stringWithFormat:@"%d小时以前",hour];
    }else if(minute > 0){
        return [NSString stringWithFormat:@"%d分钟以前",minute];
    }else{
        return [NSString stringWithFormat:@"刚刚"];
    }
}

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
-(NSString *)getConstellationInfo:(NSString *)date
{
    //计算月份
    NSString *retStr=@"";
    NSString *birthStr = [date substringFromIndex:5];
    int month=0;
    NSString *theMonth = [birthStr substringToIndex:2];
    if([[theMonth substringToIndex:0] isEqualToString:@"0"]){
        month = [[theMonth substringFromIndex:1] intValue];
    }else{
        month = [theMonth intValue];
    }
    
    //计算天数
    int day=0;
    NSString *theDay = [birthStr substringFromIndex:3];
    if([[theDay substringToIndex:0] isEqualToString:@"0"]){
        day = [[theDay substringFromIndex:1] intValue];
    }else {
        day = [theDay intValue];
    }
    
    if (month<1 || month>12 || day<1 || day>31){
        return @"错误日期格式!";
    }
    if(month==2 && day>29) {
        return @"错误日期格式!!";
    }else if(month==4 || month==6 || month==9 || month==11) {
        if (day>30) {
            return @"错误日期格式!!!";
        }
    }
    
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    
    retStr=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(month*2-(day < [[astroFormat substringWithRange:NSMakeRange((month-1), 1)] intValue] - (-19))*2,2)]];
    
    return [NSString stringWithFormat:@"%@座",retStr];
}


/**
 * 时长格式化(xx天xx小时xx分钟xx秒)
 * timeInterv 秒数
 */
//+ (NSString *)timeFormate:(NSInteger)timeInterv
//{
//    NSMutableString *str = [NSMutableString string];
//
//    // 传进来的秒数转化成分钟和小时
//    // format of day
//    NSInteger days = timeInterv/(3600 * 24);
//    // format of hour
//    NSInteger hours = (timeInterv - days * 3600 * 24)/3600;
//    //format of minute
//    NSInteger minute = (timeInterv - hours * 3600)/60;
//    //format of second
//    NSInteger second = timeInterv%60;
//    //format of time
//    if (days >= 1) {
//        [str appendFormat:@"%ld",days];
//    }
//
//    if (hours >= 1) {
//        [str appendFormat:@"%ld小时",hours];
//    }
//
//    if (minute >= 1) {
//        [str appendFormat:@"%ld分钟",minute];
//    }
//
//    if (second >= 1) {
//        [str appendFormat:@"%ld秒",second];
//    }
//
//    return str;
//}




//时间戳转化成时间
//+ (NSString *)dateWithTimestamp:(long)timestamp
//{
//    NSDateFormatter *stampFormatter = [[NSDateFormatter alloc] init];
//    [stampFormatter setDateFormat:@"HH:mm:ss"];
//
//    //以 1970/01/01 GMT为基准，然后过了secs秒的时间
//    NSDate *stampDate2 = [NSDate dateWithTimeIntervalSince1970:timestamp];
//
//    return [stampFormatter stringFromDate:stampDate2];
//}
//
///**
// * 获取当前时区的准确时间(没有时区误差)
// */
//- (NSDate *)localDate
//{
//    //zone为当前时区信息  在我的程序中打印的是@"Asia/Shanghai"
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//
//    //28800 所在地区时间与协调世界时差距
//    NSInteger interval = [zone secondsFromGMTForDate:self];
//
//    //加上时差，得到本地时间
//    NSDate *localeDate = [self dateByAddingTimeInterval: interval];
//
//    return localeDate;
//}


@end
