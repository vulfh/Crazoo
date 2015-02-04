//
//  OpenALSoundController.m
//  CRAZOO
//
//  Created by Dr James Monroe on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OpenALSoundController.h"
#include "AudioSessionSupport.h"

@implementation OpenALSoundController

-(id)init{
    self=[super init];
    if (nil != self) {
        InitAudioSession(kAudioSessionCategory_AmbientSound, NULL, NULL);
    }
    [self initOpenAl];
    return self;
}

-(void) initOpenAl{
    openALDevice = alcOpenDevice(NULL);
    openALContext = alcCreateContext(openALDevice, 0);
    alcMakeContextCurrent(openALContext);
    alGenSources(1, &outputSource);
}

@end
