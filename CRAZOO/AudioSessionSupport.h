//
//  AudioSessionSupport.h
//  CRAZOO
//
//  Created by Dr James Monroe on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#include <AudioToolbox/AudioToolbox.h>
#ifndef CRAZOO_AudioSessionSupport_h

#define CRAZOO_AudioSessionSupport_h

bool InitAudioSession(UInt32 session_category,
                      AudioSessionInterruptionListener interruption_callback, void* user_data);

#endif
