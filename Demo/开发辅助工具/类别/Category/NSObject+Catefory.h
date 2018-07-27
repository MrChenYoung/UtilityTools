//
//  NSObject+Catefory.h
//  Deppon
//
//  Created by MrChen on 2017/12/1.
//  Copyright © 2017年 MrChen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (Catefory)
/**
 * 冒泡排序实现求最大数
 */
+ (CGFloat)maxWithItems:(NSNumber *)numbers,...;

/**
 * 加载bundle文件
 * 文件名
 */
+ (NSData *)fileWithName:(NSString *)fileName;

@end
