//
//  XunFeiVA.mm
//  XunFeiVA
//
//  Created by George Peng on 27/09/2017.
//  Copyright © 2017 George Peng. All rights reserved.
//

#import "XunFeiVA.h"
#import <iflyMSC/IFlyMSC.h>
#import "XunFeiISRSession.h"
#import "XunFeiVAEventDispatcher.h"

void XunFeiVA_Init(const char* appid, int logLevel, bool logOnConsole)
{
    //设置sdk的log等级，log保存在下面设置的工作路径中
    [IFlySetting setLogFile:logLevel];

    //打开输出在console的log开关
    [IFlySetting showLogcat:logOnConsole];

    //设置sdk的工作路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];

    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%s", appid];

    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
}

void XunFeiVA_ISR_CreateSession()
{
    [[XunFeiISRSession sharedInstance] initRecognizer];
}

bool XunFeiVA_ISR_StartRecording()
{
    return [[XunFeiISRSession sharedInstance] startRecording];
}

void XunFeiVA_ISR_StopRecording()
{
    [[XunFeiISRSession sharedInstance] stopRecording];
}

void XunFeiVA_ISR_SetupCallbacks(XUNFEIVA_ISR_RESULT_CALLBACK resultCallback,
                                 XUNFEIVA_ISR_ERROR_CALLBACK errorCallback,
                                 XUNFEIVA_ISR_VOLUME_CALLBACK volumeCallback,
                                 XUNFEIVA_ISR_SPEECH_BEGIN_CALLBACK speechBeginCallback,
                                 XUNFEIVA_ISR_SPEECH_STOP_CALLBACK speechStopCallback)
{
    XunFeiVAEventDispatcher* dispatcher = [XunFeiVAEventDispatcher sharedInstance];
    dispatcher->_isrResultCallback = resultCallback;
    dispatcher->_isrErrorCallback = errorCallback;
    dispatcher->_isrVolumeCallback = volumeCallback;
    dispatcher->_isrSpeechBeginCallback = speechBeginCallback;
    dispatcher->_isrSpeechStopCallback = speechStopCallback;
}

