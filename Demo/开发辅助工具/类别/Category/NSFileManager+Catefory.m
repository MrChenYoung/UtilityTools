//
//  NSFileManager+Catefory.m
//  test
//
//  Created by sphere on 16/5/19.
//  Copyright © 2016年 sphere. All rights reserved.
//

#import "NSFileManager+Catefory.h"

#define FileManager [NSFileManager defaultManager]

@implementation NSFileManager (Catefory)

#pragma mark - 共有方法
/**
 *  沙盒documents目录下创建新的文件夹
 *
 *  @param directoryName 文件夹名字
 *
 *  @return 是否创建文件夹成功
 */
+ (BOOL)createNewDirectoryWithName:(NSString *)directoryName
{
    NSString *fullPath = [self fullPathWithSufixName:directoryName];
    
    // 创建文件夹
    NSError *error = nil;
    BOOL success = [FileManager createDirectoryAtPath:fullPath withIntermediateDirectories:YES attributes:nil error:&error];

    // 创建文件夹失败
    if (error) {
        HYLog(@"创建文件夹失败:%@",error);
    }else{
        HYLog(@"创建文件夹成功,路径:%@",fullPath);
    }
    
    return success;
}

/**
 *  在documents目录下创建文件
 *
 *  @param fileName 文件名字
 *  @param contents 文件内容
 *
 *  @return 是否创建成功
 */
+ (BOOL)createFileWithFileName:(NSString *)fileName contents:(NSData *)contents
{
    NSString *fullPath = [self fullPathWithSufixName:fileName];
    
    NSError *error = nil;
    BOOL success = [FileManager createFileAtPath:fullPath contents:contents attributes:nil];
    
    // 创建文件失败
    if (error) {
        HYLog(@"创建文件失败:%@",error);
    }else{
        HYLog(@"创建文件成功,路径:%@",fullPath);
    }
    return success;
}

/**
 *  向文件里面写数据
 *
 *  @param filePath 文件路径
 *  @param content  文件内容
 *
 *  @return 是否写入成功
 */
+ (BOOL)writeTofile:(NSString *)filePath content:(id)content
{
    NSError *error = nil;
    BOOL success = NO;
    
    if ([content isKindOfClass:[NSString class]]) {
        success = [content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    }else if([content isKindOfClass:[NSData class]]){
        success = [content writeToFile:filePath options:NSDataWritingAtomic error:&error];
    }
    
    if (error) {
        HYLog(@"写数据失败:%@",error);
    }else{
        HYLog(@"写数据成功,路径:%@",filePath);
    }
    
    return success;
}

/**
 *  读取文件内容
 *
 *  @param filePath 文件路径
 *
 *  @return 读取到的内容
 */
+ (NSString *)readFileContentWithPath:(NSString *)filePath
{
    NSError *error = nil;
    NSString *string = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
        HYLog(@"读取文件内容出错:%@",error);
    }else{
        HYLog(@"读取文件成功,内容是:%@",string);
    }
    
    return string;
}

/**
 *  获取文件信息
 *
 *  @param path 文件路径
 *
 *  @return 获取到的文件信息
 */
+ (NSDictionary *)fileInfoWithPath:(NSString *)path
{
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *fileInfo = [fileManager attributesOfItemAtPath:path error:&error];
    
    if (error) {
        HYLog(@"获取文件信息失败:%@",error);
    }else{
        HYLog(@"获取文件信息成功,内容:%@",fileInfo);
    }
    
    return fileInfo;
}

/**
 *  判断文件是否存在
 *
 *  @param filePath 文件路径
 *
 *  @return 是否存在
 */
+ (BOOL)fileExistWithPath:(NSString *)filePath
{
    BOOL isDirectory = NO;
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL exist = [manager fileExistsAtPath:filePath isDirectory:&isDirectory];
    
    if (exist) {
        if (isDirectory) {
            HYLog(@"此文件是一个文件夹,路径:%@",filePath);
        }else{
            HYLog(@"此文件是一个文件,路径:%@",filePath);
        }
    }
    
    return exist;
}

/**
 *  获取文件的大小(单位字节，转换成kb需要除以1024)
 *
 *  @param path 文件路径
 *
 *  @return 获取到的文件大小
 */
+ (unsigned long long)fileSizeWithPath:(NSString *)path
{
    if ([self fileExistWithPath:path]) {
        unsigned long long size = [[self fileInfoWithPath:path] fileSize];
        HYLog(@"获取文件大小:%llu 路径:%@",size,path);
        return size;
    }else{
        HYLog(@"文件不存在,路径:%@",path);
        return 0;
    }
}

/**
 *  获取文件夹的大小(单位字节)
 *
 *  @param path 文件夹路径
 *
 *  @return 获取到的文件夹的大小
 */
+ (unsigned long long)folderSizeWithPath:(NSString *)path
{
    BOOL exist = [self fileExistWithPath:path];
    
    if (!exist) {
        HYLog(@"文件不存在,路径:%@",path);
        return 0;
    }else{
        NSFileManager *manager = [NSFileManager defaultManager];
        NSEnumerator *fileEnumetator = [[manager subpathsAtPath:path] objectEnumerator];
        
        unsigned long long size = 0;
        NSString *fileName = @"";
        while (fileName = [fileEnumetator nextObject]) {
            NSString *fileFullPath = [path stringByAppendingPathComponent:fileName];
            size += [self fileSizeWithPath:fileFullPath];
        }
        
        HYLog(@"获取文件夹的大小:%llu 路径:%@",size,path);
        return size;
    }
}

/**
 *  获取文件类型(是文件夹还是文件)
 *
 *  @param path 路径
 *
 *  @return 类型
 */
+ (fileType)fileTypeWithPath:(NSString *)path
{
    BOOL isDirectory = NO;
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager fileExistsAtPath:path isDirectory:&isDirectory];
    
    if (isDirectory) {
        return fileTypeFolder;
    }else{
        return fileTypeFile;
    }
}

/**
 *  删除文件/文件夹
 *
 *  @param filePath 文件路径
 *
 *  @return 是否删除成功
 */
+ (BOOL)deleteFileWithPath:(NSString *)filePath
{
    if (![self fileExistWithPath:filePath]) {
        HYLog(@"文件不存在,路径:%@",filePath);
        return NO;
    }
    
    NSError *error = nil;
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL success = [manager removeItemAtPath:filePath error:&error];
    
    if (error) {
        HYLog(@"删除文件失败:%@",error);
    }else{
        HYLog(@"删除文件成功,路径:%@",filePath);
    }
    
    return success;
}

/**
 *  移动文件/文件夹
 *
 *  @param fromPath 原始路径
 *  @param toPath   移动后的路径
 *
 *  @return 是否成功移动文件
 */
+ (BOOL)moveFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath
{
    BOOL exist = [self fileExistWithPath:fromPath];
    if (!exist) {
        HYLog(@"文件不存在,路径:%@",fromPath);
        return NO;
    }
    
    NSError *error = nil;
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL success = [manager moveItemAtPath:fromPath toPath:toPath error:&error];
    
    if (error) {
        HYLog(@"移动文件失败,路径:%@",fromPath);
    }else{
        HYLog(@"移动文件成功,路径:%@",fromPath);
    }
    
    return success;
}

/**
 *  重命名文件/文件夹
 *
 *  @param path    文件路径
 *  @param newName 文件新名字
 *
 *  @return 是否重命名成功
 */
+ (BOOL)renameFileWithPath:(NSString *)path newName:(NSString *)newName
{
    // 获取文件名
    NSArray *fileArr = [path componentsSeparatedByString:@"/"];
    NSString *fileName = [fileArr lastObject];
    
    // 获取除了文件名以外的路径
    NSRange range = [path rangeOfString:fileName];
    NSString *compPath = [path substringToIndex:range.location];
    
    // 新路径
    NSString *newPath = [compPath stringByAppendingPathComponent:newName];
    BOOL success = [self moveFileFromPath:path toPath:newPath];
    
    return success;
}

/**
 *  获取文件夹中所有文件的名字
 *
 *  @param directoryPath 文件夹的路径
 *
 *  @return 文件夹中所有文件的名字
 */
+ (NSArray *)filesInDirectory:(NSString *)directoryPath
{
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:directoryPath error:&error];
    
    if (error) {
        HYLog(@"获取文件夹中所有文件失败,错误:%@ 路径:%@",error,directoryPath);
    }else{
        HYLog(@"获取文件夹中所有文件成功,所有文件名:%@ 路径:%@",contents,directoryPath);
    }
    
    return contents;
}


#pragma mark - 私有方法
/**
 *  得到完整的路径
 *
 *  @param sufixName 文件名
 *
 *  @return 完整路径
 */
+ (NSString *)fullPathWithSufixName:(NSString *)sufixName
{
    // 获取documents路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    // 补全路径
    NSString *fullPath = [path stringByAppendingPathComponent:sufixName];
    
    return fullPath;
}


@end
