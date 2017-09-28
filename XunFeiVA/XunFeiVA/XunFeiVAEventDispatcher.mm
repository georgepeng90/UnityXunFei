//
//  XunFeiVAEventDispatcher.mm
//  XunFeiVA
//
//  Created by George Peng on 28/09/2017.
//  Copyright © 2017 George Peng. All rights reserved.
//

#import "XunFeiVAEventDispatcher.h"
#import "ISRDataHelper.h"

@implementation XunFeiVAEventDispatcher

static XunFeiVAEventDispatcher *instance = nil;
+ (XunFeiVAEventDispatcher*) sharedInstance
{
    if (instance == nil)
    {
        instance = [[super alloc] init];
    }
    
    return instance;
}

- (void)sendISRResultEventWithResults:(NSArray *)results asLast:(bool)last
{
    if (_isrResultCallback == nil)
        return;
    
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    for (NSString *key in dic)
    {
        [resultString appendFormat:@"%@",key];
    }
    NSString *resultFromJson =  [ISRDataHelper stringFromJson:resultString];
    
    _isrResultCallback([resultFromJson UTF8String], last);
}

- (void)sendISRErrorEventWithCode:(int)errorCode type:(int)errorType
{
    if (_isrErrorCallback == nil)
        return;
    
    _isrErrorCallback(errorCode, errorType);
}

- (void)sendISRVolumeEventWithVolume:(int)volume
{
    if (_isrVolumeCallback == nil)
        return;
    _isrVolumeCallback(volume);
}

- (void)sendISRSpeechBeginEvent
{
    if (_isrSpeechBeginCallback == nil)
        return;
    
    _isrSpeechBeginCallback();
}

- (void)sendISRSpeechStopEvent
{
    if (_isrSpeechStopCallback == nil)
        return;
    
    _isrSpeechStopCallback();
}

@end
