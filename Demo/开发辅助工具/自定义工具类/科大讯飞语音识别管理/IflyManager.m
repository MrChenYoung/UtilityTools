//
//  IflyManager.m
//  Test
//
//  Created by MrChen on 2017/12/17.
//  Copyright © 2017年 MrChen. All rights reserved.
//

#import "IflyManager.h"
#import <iflyMSC/iflyMSC.h>
#import "ISRDataHelper.h"

#define IflyAppid @"5a365688"

@interface IflyManager ()<IFlySpeechRecognizerDelegate>

//不带界面的识别对象
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;

@end

@implementation IflyManager

#pragma mark - 懒加载
// 语音识别
- (IFlySpeechRecognizer *)iFlySpeechRecognizer
{
    if (_iFlySpeechRecognizer == nil) {
        //创建语音识别对象
        _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
        _iFlySpeechRecognizer.delegate = self;
        //设置识别参数

        [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        //设置为听写模式
        [_iFlySpeechRecognizer setParameter: @"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];

        //语音输入超时时间
//        [_iFlySpeechRecognizer setParameter:@"30000" forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
//
        // VAD后端点超时
        [_iFlySpeechRecognizer setParameter:@"3000" forKey:[IFlySpeechConstant VAD_EOS]];
        // VAD前端点超时
        [_iFlySpeechRecognizer setParameter:@"3000" forKey:[IFlySpeechConstant VAD_BOS]];
//        // 网络连接超时时间
//        [_iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];

        //asr_audio_path 是录音文件名，设置value为nil或者为空取消保存，默认保存目录在Library/cache下。
        [_iFlySpeechRecognizer setParameter:nil forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];

        //设置是否返回标点符号
        [_iFlySpeechRecognizer setParameter:[IFlySpeechConstant ASR_PTT_NODOT] forKey:[IFlySpeechConstant ASR_PTT]];
    }

    return _iFlySpeechRecognizer;
}


#pragma mark - 初始化基本信息
+ (void)load
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        //Appid是应用的身份信息，具有唯一性，初始化时必须要传入Appid。
        NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@", IflyAppid];
        [IFlySpeechUtility createUtility:initString];
    });
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - 语音识别
// 开始语音识别
- (void)startSpeechRecognze
{
    //启动识别服务
    [self.iFlySpeechRecognizer startListening];
}

// 停止录音
- (void)stopSpeechRecogmze
{
    // 停止录音
    [self.iFlySpeechRecognizer stopListening];
}

#pragma mark - IFlySpeechRecognizerDelegate
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [results objectAtIndex:0];
    for (NSString *key in dic){
        [result appendFormat:@"%@",key];//合并结果
    }

    NSString *str = [ISRDataHelper stringFromJson:result];
    
    if (self.recognizeResultBlock) {
        self.recognizeResultBlock(str);
    }
}


/*!
 *  识别结果回调
 *
 *  在进行语音识别过程中的任何时刻都有可能回调此函数，你可以根据errorCode进行相应的处理，当errorCode没有错误时，表示此次会话正常结束；否则，表示此次会话有错误发生。特别的当调用`cancel`函数时，引擎不会自动结束，需要等到回调此函数，才表示此次会话结束。在没有回调此函数之前如果重新调用了`startListenging`函数则会报错误。
 *
 *  @param errorCode 错误描述
 */
- (void) onError:(IFlySpeechError *) errorCode
{
    if (errorCode.errorCode != 0) {
        // 识别出错
//        NSLog(@"speech recognize faile:%@",errorCode.errorDesc);
    }else {
        // 识别结束
        if (self.recognizeEndBlock) {
            self.recognizeEndBlock();
        }
    }
}

@end
