//
//  ViewController.m
//  Demo
//
//  Created by MrChen on 2018/3/19.
//  Copyright © 2018年 MrChen. All rights reserved.
//

#import "ViewController.h"
#import "CreateSubViewHandler.h"
#import "HYNavigationController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开发辅助工具Demo";
    
    HYNavigationController *nav = (HYNavigationController *)self.navigationController;
    nav.canDragBack = YES;
    
    NSArray *titles = @[@"科大讯飞语音识别",@"原生图片选择器(单选)",@"第三方图片选择器(多选)",@"图片压缩"];
    [CreateSubViewHandler createBtn:titles fontSize:16 target:self sel:@selector(btnClick:) superView:self.view baseTag:1000];
}

- (void)btnClick:(UIButton *)btn
{
    NSInteger tag = btn.tag - 1000;
    NSString *className = @"";
    
    switch (tag) {
        case 0:{
            // 科大讯飞语音识别
            className = @"SpeechRecgnizeCtr";
        }
            break;
        case 1:
            // 原生照片选择器
            className = @"OriginalImagePickerCtr";
            break;
        case 2:
            // 第三方选择照片
            className = @"ThirdImagePickerCtr";
            break;
        case 3:
            // 图片压缩
            className = @"ImageCompressCtr";
        default:
            break;
    }
    
    UIViewController *ctr = [[NSClassFromString(className) alloc]init];
    [self.navigationController pushViewController:ctr animated:YES];
}


@end
