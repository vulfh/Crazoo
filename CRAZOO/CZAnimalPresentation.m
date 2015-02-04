//
//  CZAnimalPresentation.m
//  CRAZOO
//
//  Created by Dr James Monroe on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CZAnimalPresentation.h"
#import "Utils.h"
#import <UIKit/UIKit.h>
@implementation CZAnimalPresentation
@synthesize image;
@synthesize animal;
@synthesize exchanged;
@synthesize leftPositionX;
@synthesize leftPositionY;
@synthesize leftTempPositionTempX;
@synthesize leftTempPositionTempY;
@synthesize indexX;
@synthesize indexY;
@synthesize FruitImage = fruitImage;

-(void) MoveTo:(float) x y:(float) y{
    @autoreleasepool {
        leftTempPositionX = leftPositionX = x;
        leftTempPositionY = leftPositionY = y;
        [Utils MoveImage:image x:leftPositionX y:leftPositionY];
    }
}
-(void) MoveToTempPosition:(float)x y:(float)y{
    leftTempPositionX =x;
    leftTempPositionY = y;
    [Utils MoveImage:image x:leftTempPositionX y:leftTempPositionY];
    
}

-(void) Settle{
    [self MoveTo:leftPositionX y:leftPositionY];
}
-(void) SetSize:(float)width height:(float)height{
    
}

-(void)SetTouchAudioPlayer:(AVAudioPlayer *)audioPlayer{
    @autoreleasepool {
        touchSound= audioPlayer;
    }
}
-(void) SetCompletedSound:(AVAudioPlayer*) audioPlayer{
    completedSound = audioPlayer;
}
-(void) PlayTouchSound{
    if(touchSound != nil){
        [touchSound play];
    }
    else{
        NSLog(@"Touch sound player not defined for this part!");
    }
}
-(void) PlayCompletedSound{
    if(completedSound!=nil){
        [completedSound play];
    }
    else{
        NSLog(@"Completed sound is not defined for this part !");
    }
}
-(void) Silence{
    if(touchSound!= nil){
        [touchSound stop];
    }
    if(completedSound != nil){
        [completedSound stop];
    }
}
-(void)SetFruitImage:(NSString*) imageFile{
    
    fruitImage = [UIImage imageNamed:imageFile];
}
-(void)PlayFruitImage{
    
}
@end
