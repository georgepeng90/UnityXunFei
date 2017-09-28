//
//  XunFeiISRSession.h
//  XunFeiVA
//
//  Created by George Peng on 27/09/2017.
//  Copyright © 2017 George Peng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iflyMSC/IFlyMSC.h>

typedef void (*XUNFEIVA_ISR_RESULT_CALLBACK)(const char* content, bool isLast);
typedef void (*XUNFEIVA_ISR_VOLUME_CALLBACK)(int volume);

@interface XunFeiISRSession : NSObject<IFlySpeechRecognizerDelegate, IFlyPcmRecorderDelegate>

@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;

@property (nonatomic, strong) NSString * result;
@property (nonatomic, assign) bool isCanceled;

@property (nonatomic,strong) IFlyPcmRecorder *pcmRecorder;//录音器，用于音频流识别的数据传入
@property (nonatomic,assign) bool isStreamRec;//是否是音频流识别
@property (nonatomic,assign) bool isBeginOfSpeech;//是否返回BeginOfSpeech回调

+ (XunFeiISRSession *) sharedInstance;

- (void)initRecognizer;
- (bool)startRecording;
- (void)stopRecording;

@end
