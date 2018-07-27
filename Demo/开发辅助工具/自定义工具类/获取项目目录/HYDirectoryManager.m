//
//  HYDirectoryManager.m
//  test
//
//  Created by sphere on 16/5/19.
//  Copyright © 2016年 sphere. All rights reserved.
//

#import "HYDirectoryManager.h"

@implementation HYDirectoryManager

// 获取沙盒根目录
+ (NSString *)sanBoxHomeDirectory
{
    // 方法1.
    NSString *path = NSHomeDirectory();
    return path;
    
    // 方法2.
//    NSString *userName = NSUserName();
//    NSString *path = NSHomeDirectoryForUser(userName);
//    return path;
}

// 获取documents路径
+ (NSString *)sanBoxDocumentsDirectory
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return path;
}

// 获取documents目录下指定文件名的全路径
+ (NSString *)sanBoxFilePathWithFileName:(NSString *)fileName
{
    NSString *path = [[self sanBoxDocumentsDirectory] stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]];
    
    return path;
}

// 获取tmp路径
+ (NSString *)sanBoxTmpDirectory
{
    NSString *path = NSTemporaryDirectory();
    return path;
}

// 获取cache路径
+ (NSString *)sanBoxCacheDirectory
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    return path;
}

// 获取library路径
+ (NSString *)sanBoxLibraryDirectory
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    return path;
}


@end
