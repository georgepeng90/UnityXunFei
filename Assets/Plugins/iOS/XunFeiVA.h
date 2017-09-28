

extern "C"
{
    void XunFeiVA_Init(const char* appid);
    
    void XunFeiVA_ISR_CreateSession();
    bool XunFeiVA_ISR_StartRecording();
    void XunFeiVA_ISR_StopRecording();
}
