//
//  IflyManager.h
//  Test
//
//  Created by MrChen on 2017/12/17.
//  Copyright © 2017年 MrChen. All rights reserved.
//

#import <Foundation/Foundation.h>

// 科大讯飞语音管理
@interface IflyManager : NSObject

// 识别结果回调(识别过程中多次调用)
@property (nonatomic, copy) void (^recognizeResultBlock)(NSString *str);

// 识别结束回调
@property (nonatomic, copy) void (^recognizeEndBlock)(void);

// 开始语音识别
- (void)startSpeechRecognze;

// 停止录音
- (void)stopSpeechRecogmze;

@end
