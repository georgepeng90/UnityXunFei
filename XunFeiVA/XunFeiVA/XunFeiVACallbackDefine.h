//
//  XunFeiVACallbackDefine.h
//  XunFeiVA
//
//  Created by George Peng on 28/09/2017.
//  Copyright © 2017 George Peng. All rights reserved.
//

#ifndef XunFeiVACallbackDefine_h
#define XunFeiVACallbackDefine_h

typedef void (*XUNFEIVA_ISR_RESULT_CALLBACK)(const char* content, bool isLast);
typedef void (*XUNFEIVA_ISR_ERROR_CALLBACK)(int errorCode, int errorType);
typedef void (*XUNFEIVA_ISR_VOLUME_CALLBACK)(int volume);
typedef void (*XUNFEIVA_ISR_SPEECH_BEGIN_CALLBACK)(void);
typedef void (*XUNFEIVA_ISR_SPEECH_STOP_CALLBACK)(void);

#endif /* XunFeiVACallbackDefine_h */
