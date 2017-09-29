#import "XunFeiVACallbackDefine.h"

extern "C"
{
    void XunFeiVA_Init(const char* appid, int logLevel, bool logOnConsole);
    
    void XunFeiVA_ISR_CreateSession();
    bool XunFeiVA_ISR_StartRecording();
    void XunFeiVA_ISR_StopRecording();
    
    void XunFeiVA_ISR_SetupCallbacks(XUNFEIVA_ISR_RESULT_CALLBACK resultCallback,
                                     XUNFEIVA_ISR_ERROR_CALLBACK errorCallback,
                                     XUNFEIVA_ISR_VOLUME_CALLBACK volumeCallback,
                                     XUNFEIVA_ISR_SPEECH_BEGIN_CALLBACK speechBeginCallback,
                                     XUNFEIVA_ISR_SPEECH_STOP_CALLBACK speechStopCallback);
}
