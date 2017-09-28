//
//  XunFeiISRSession.m
//  XunFeiVA
//
//  Created by George Peng on 27/09/2017.
//  Copyright © 2017 George Peng. All rights reserved.
//

#import "XunFeiISRSession.h"
#import "IATConfig.h"
#import "XunFeiVAEventDispatcher.h"

@implementation XunFeiISRSession

static XunFeiISRSession *instance = nil;

+ (XunFeiISRSession *) sharedInstance
{
    if (instance == nil)
    {
        instance = [[super alloc] init];
    }
    
    return instance;
}

- (void)initRecognizer
{
    NSLog(@"/n====================Init Recognizer Start");
    //单例模式，无UI的实例
    if (_iFlySpeechRecognizer == nil)
    {
        _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
        
        [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        
        //设置听写模式
        [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    }
    _iFlySpeechRecognizer.delegate = self;
    
    if (_iFlySpeechRecognizer != nil)
    {
        IATConfig *instance = [IATConfig sharedInstance];
        
        //设置最长录音时间
        [_iFlySpeechRecognizer setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        //设置后端点
        [_iFlySpeechRecognizer setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
        //设置前端点
        [_iFlySpeechRecognizer setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
        //网络等待时间
        [_iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
        
        //设置采样率，推荐使用16K
        [_iFlySpeechRecognizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
        
        //设置语言
        [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
        //设置方言
        [_iFlySpeechRecognizer setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
        
        //设置是否返回标点符号
        [_iFlySpeechRecognizer setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
    }
    
    //初始化录音器
    if (_pcmRecorder == nil)
    {
        _pcmRecorder = [IFlyPcmRecorder sharedInstance];
    }
    
    _pcmRecorder.delegate = self;
    
    [_pcmRecorder setSample:[IATConfig sharedInstance].sampleRate];
    
    [_pcmRecorder setSaveAudioPath:nil];    //不保存录音文件
    
    NSLog(@"/n====================Init Recognizer End");
}

- (bool)startRecording
{
    NSLog(@"/n====================Start Recording");
    self.isCanceled = NO;
    self.isStreamRec = NO;
    
    if(_iFlySpeechRecognizer == nil)
    {
        [self initRecognizer];
    }
    
    [_iFlySpeechRecognizer cancel];
    
    //设置音频来源为麦克风
    [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    
    //设置听写结果格式为json
    [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
    [_iFlySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    
    [_iFlySpeechRecognizer setDelegate:self];
    
    return [_iFlySpeechRecognizer startListening];
}

- (void)stopRecording
{
    if(self.isStreamRec && !self.isBeginOfSpeech)
    {
        [_pcmRecorder stop];
    }
    
    [_iFlySpeechRecognizer stopListening];
}

#pragma mark - IFlySpeechRecognizerDelegate

- (void) onVolumeChanged: (int)volume
{
    NSLog(@"/n====================onVolumeChanged：%d",volume);
    [[XunFeiVAEventDispatcher sharedInstance] sendISRVolumeEventWithVolume:volume];
}

- (void) onBeginOfSpeech
{
    NSLog(@"/n====================onBeginOfSpeech");
    if (self.isStreamRec == NO)
    {
        self.isBeginOfSpeech = YES;
    }
    [[XunFeiVAEventDispatcher sharedInstance] sendISRSpeechBeginEvent];
}

- (void) onEndOfSpeech
{
    NSLog(@"/n====================onEndOfSpeech");
    [_pcmRecorder stop];
    [[XunFeiVAEventDispatcher sharedInstance] sendISRSpeechStopEvent];
}

/**
 听写结束回调（注：无论听写是否正确都会回调）
 error.errorCode =
 0     听写正确
 other 听写出错
 ****/
- (void)onError:(IFlySpeechError *)errorCode
{
    if ([errorCode errorCode] == 0)
        return;
    
    NSLog(@"/n====================onError: %@", errorCode);
    NSLog(@"/nDescription: %@", [errorCode errorDesc]);
    [[XunFeiVAEventDispatcher sharedInstance] sendISRErrorEventWithCode:[errorCode errorCode] type:[errorCode errorType]];
}

/**
 无界面，听写结果回调
 results：听写结果
 isLast：表示最后一次
 ****/
- (void)onResults:(NSArray *)results isLast:(BOOL)isLast
{
    NSLog(@"/n====================onResults：%@",results);
    [[XunFeiVAEventDispatcher sharedInstance] sendISRResultEventWithResults:results asLast:isLast];
}

#pragma mark - IFlyPcmRecorderDelegate

- (void)onIFlyRecorderBuffer:(const void *)buffer bufferSize:(int)size
{
    NSData *audioBuffer = [NSData dataWithBytes:buffer length:size];
    
    int ret = [self.iFlySpeechRecognizer writeAudio:audioBuffer];
    
    if (!ret)
    {
        [self.iFlySpeechRecognizer stopListening];
    }
}

- (void)onIFlyRecorderError:(IFlyPcmRecorder *)recoder theError:(int)error
{
    
}

@end
