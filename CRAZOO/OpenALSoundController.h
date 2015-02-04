//
//  OpenALSoundController.h
//  CRAZOO
//
//  Created by Dr James Monroe on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioUnit/AudioUnit.h>
#import <AudioUnit/AudioUnit.h>
#import <OpenAL/alc.h>
#import <OpenAL/al.h>
@interface OpenALSoundController : NSObject
{
    ALCdevice* openALDevice;
    ALCcontext* openALContext;
    ALuint outputSource;
}
-(id) init;
-(void) initOpenAl;
@end
