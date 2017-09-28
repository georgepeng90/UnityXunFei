//
//  XunFeiVAEventDispatcher.h
//  XunFeiVA
//
//  Created by George Peng on 28/09/2017.
//  Copyright © 2017 George Peng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XunFeiVACallbackDefine.h"

@interface XunFeiVAEventDispatcher : NSObject

{
@public
    XUNFEIVA_ISR_RESULT_CALLBACK _isrResultCallback;
    XUNFEIVA_ISR_VOLUME_CALLBACK _isrVolumeCallback;
}

+ (XunFeiVAEventDispatcher*) sharedInstance;

- (void)sendISRResultEventWithResults:(NSArray *)results asLast:(bool)last;
- (void)sendISRVolumeEventWithVolume:(int)volume;

@end
