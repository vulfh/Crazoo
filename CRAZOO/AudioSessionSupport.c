#include <AudioToolbox/AudioToolbox.h>
#include "AudioSessionSupport.h"
bool InitAudioSession(UInt32 session_category,
                      AudioSessionInterruptionListener interruption_callback, void* user_data)
{
    AudioSessionInitialize(NULL, NULL, interruption_callback, user_data);
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
                            sizeof(session_category), &session_category);
    AudioSessionSetActive(true);
    return true;
}