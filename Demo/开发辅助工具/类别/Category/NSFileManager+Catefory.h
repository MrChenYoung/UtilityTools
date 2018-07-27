//
//  NSFileManager+Catefory.h
//  test
//
//  Created by sphere on 16/5/19.
//  Copyright © 2016年 sphere. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYLog.h"

typedef enum {
    fileTypeFolder,
    fileTypeFile
}fileType;

@interface NSFileManager (Catefory)

/**
 *  沙盒documents目录下创建新的文件夹
 *
 *  @param directoryName 文件夹名字
 *
 *  @return 是否创建文件夹成功
 */
+ (BOOL)createNewDirectoryWithName:(NSString *)directoryName;

/**
 *  在documents目录下创建文件
 *
 *  @param fileName 文件名字
 *  @param contents 文件内容
 *
 *  @return 是否创建成功
 */
+ (BOOL)createFileWithFileName:(NSString *)fileName contents:(NSData *)contents;

/**
 *  向文件里面写数据
 *
 *  @param filePath 文件路径
 *  @param content  文件内容
 *
 *  @return 是否写入成功
 */
+ (BOOL)writeTofile:(NSString *)filePath content:(id)content;

/**
 *  读取文件内容
 *
 *  @param filePath 文件路径
 *
 *  @return 读取到的内容
 */
+ (NSString *)readFileContentWithPath:(NSString *)filePath;

/**
 *  获取文件信息
 *
 *  @param path 文件路径
 *
 *  @return 获取到的文件信息
 */
+ (NSDictionary *)fileInfoWithPath:(NSString *)path;

/**
 *  判断文件是否存在
 *
 *  @param filePath 文件路径
 *
 *  @return 是否存在
 */
+ (BOOL)fileExistWithPath:(NSString *)filePath;

/**
 *  获取文件的大小(单位字节，转换成kb需要除以1024)
 *
 *  @param path 文件路径
 *
 *  @return 获取到的文件大小
 */
+ (unsigned long long)fileSizeWithPath:(NSString *)path;

/**
 *  获取文件夹的大小(单位字节)
 *
 *  @param path 文件夹路径
 *
 *  @return 获取到的文件夹的大小
 */
+ (unsigned long long)folderSizeWithPath:(NSString *)path;

/**
 *  获取文件类型(是文件夹还是文件)
 *
 *  @param path 路径
 *
 *  @return 类型
 */
+ (fileType)fileTypeWithPath:(NSString *)path;

/**
 *  删除文件
 *
 *  @param filePath 文件路径
 *
 *  @return 是否删除成功
 */
+ (BOOL)deleteFileWithPath:(NSString *)filePath;

/**
 *  移动文件
 *
 *  @param fromPath 原始路径
 *  @param toPath   移动后的路径
 *
 *  @return 是否成功移动文件
 */
+ (BOOL)moveFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath;

/**
 *  重命名文件/文件夹
 *
 *  @param path    文件路径
 *  @param newName 文件新名字
 *
 *  @return 是否重命名成功
 */
+ (BOOL)renameFileWithPath:(NSString *)path newName:(NSString *)newName;

/**
 *  获取文件夹中所有文件的名字
 *
 *  @param directoryPath 文件夹的路径
 *
 *  @return 文件夹中所有文件的名字
 */
+ (NSArray *)filesInDirectory:(NSString *)directoryPath;

@end
