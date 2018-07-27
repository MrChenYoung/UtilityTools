//
//  UITableView+Category.m
//  qqListDemo
//
//  Created by sphere on 16/5/12.
//  Copyright © 2016年 sphere. All rights reserved.
//

#import "UITableView+Category.h"

@implementation UITableView (Category)
// 滚动到底部
- (void)scrollToBottomAnimated:(BOOL)animated
{
    // 总共的行数和section个数
    NSInteger sectionNum = self.numberOfSections;
    NSInteger rowNum = [self numberOfRowsInSection:sectionNum - 1];
    
    NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:rowNum - 1 inSection:sectionNum - 1];
    [self scrollToRowAtIndexPath:lastIndex atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

@end
