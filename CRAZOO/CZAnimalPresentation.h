//
//  CZAnimalPresentation.h
//  CRAZOO
//
//  Created by Dr James Monroe on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface CZAnimalPresentation : NSObject{
    UIImageView* image;
    UIImage* fruitImage;
    int animal;
    bool exchanged;
    float leftPositionX;
    float leftPositionY;
    float leftTempPositionX;
    float leftTempPositionY;
    int indexX;
    int indexY;
    AVAudioPlayer *touchSound;
    AVAudioPlayer *completedSound;
}
@property(atomic,strong) UIImageView* image;
@property(atomic,readwrite) int animal;
@property(atomic,readwrite) bool exchanged;
@property(atomic,readwrite) float leftPositionX;
@property(atomic,readwrite) float leftPositionY;
@property(atomic,readwrite) float leftTempPositionTempX;
@property(atomic,readwrite) float leftTempPositionTempY;
@property(atomic,readwrite) int indexX;
@property(atomic,readwrite) int indexY;
@property(atomic,strong) UIImage* FruitImage;

-(void) MoveTo:(float) x y:(float) y;
-(void) MoveToTempPosition:(float) x y:(float)y;
-(void) SetSize: (float) width height:(float) height;
-(void) SetTouchAudioPlayer:(AVAudioPlayer *) audioPlayer; 
-(void) SetCompletedSound:(AVAudioPlayer*) audioPlayer;
-(void) SetFruitImage:(NSString*) imageFile;
-(void) PlayFruitImage;
-(void) PlayTouchSound; 
-(void) PlayCompletedSound;
-(void) Silence;
-(void) Settle;
@end
