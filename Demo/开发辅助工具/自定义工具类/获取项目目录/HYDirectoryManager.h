//
//  HYDirectoryManager.h
//  test
//
//  Created by sphere on 16/5/19.
//  Copyright © 2016年 sphere. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYDirectoryManager : NSObject

// 获取沙盒根目录
+ (NSString *)sanBoxHomeDirectory;

// 获取documents路径
+ (NSString *)sanBoxDocumentsDirectory;

// 获取documents目录下指定文件名的全路径
+ (NSString *)sanBoxFilePathWithFileName:(NSString *)fileName;

// 获取tmp路径
+ (NSString *)sanBoxTmpDirectory;

// 获取cache路径
+ (NSString *)sanBoxCacheDirectory;

// 获取library路径
+ (NSString *)sanBoxLibraryDirectory;

@end

