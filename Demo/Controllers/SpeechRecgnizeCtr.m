//
//  SpeechRecgnizeCtr.m
//  Demo
//
//  Created by MrChen on 2018/3/19.
//  Copyright © 2018年 MrChen. All rights reserved.
//

#import "SpeechRecgnizeCtr.h"
#import <MBProgressHUD.h>
#import "AppConstMacro.h"
#import "UIView+Category.h"
#import "IflyManager.h"

@interface SpeechRecgnizeCtr ()

// loading
@property (nonatomic, weak) MBProgressHUD *hud;

// 识别结果
@property (nonatomic, weak) UITextView *resultTextView;

// recgnize manager
@property (nonatomic, strong) IflyManager *mgr;

@end

@implementation SpeechRecgnizeCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"语音识别";
    __weak typeof(self) weakSelf = self;
    self.mgr = [[IflyManager alloc]init];
    
    // 说话最大时长到，自动停止说话回调
    self.mgr.recognizeEndBlock = ^{
        [weakSelf.hud hideAnimated:YES];
    };
    
    // 识别完成结果回调
    self.mgr.recognizeResultBlock = ^(NSString *str) {
        weakSelf.resultTextView.textColor = darkText_color;
        weakSelf.resultTextView.text = str;
    };
    
    // create subviews
    [self createSubViews];
    
    // set loading
    [self setLoading];
}

// set loading
- (void)setLoading
{
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    hud.label.text = @"语音识别中...\n(点击屏幕结束识别)";
    [self.view addSubview:hud];
    self.hud = hud;
    [self.view bringSubviewToFront:self.hud];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHud)];
    [self.hud addGestureRecognizer:tap];
}

// create subviews
- (void)createSubViews
{
    // recgnize result
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10 + kNaviBarHeight, Main_Screen_Width - 20, self.view.viewHeight * 0.5)];
    textView.borderColor = lightGray_color;
    textView.borderWidth = 0.5;
    textView.cornerRadius = 3;
    textView.editable = NO;
    textView.textColor = lightGray_color;
    textView.text = @"识别结果";
    [self.view addSubview:textView];
    self.resultTextView = textView;
    
    // begin btn
    NSArray *btnTitles = @[@"开始说话"];
    for (int i = 0; i < btnTitles.count; i++) {
        CGFloat h = KH47inch(40);
        CGFloat y = self.resultTextView.viewMaxY + 10 + (h + 10) * i;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, y, self.resultTextView.viewWidth, h)];
        btn.backgroundColor  = RgbColor(0, 150, 255);
        [btn addTarget:self action:@selector(beginSpeek:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.textColor = [UIColor whiteColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setTitle:btnTitles[0] forState:UIControlStateNormal];
        [self.view addSubview:btn];
    }
}

// begin speek
- (void)beginSpeek:(UIButton *)btn
{
    if (equalString(btn.currentTitle, @"开始说话")) {
        // 开始说话,开始识别
        [self.mgr startSpeechRecognze];
        
        [self.hud showAnimated:YES];
    }else {
        // 停止说话
        [self.mgr stopSpeechRecogmze];
        
        [self.hud hideAnimated:YES];
    }
}

// 点击屏幕停止识别
- (void)tapHud
{
    [self.mgr stopSpeechRecogmze];
    [self.hud hideAnimated:YES];
}


@end
