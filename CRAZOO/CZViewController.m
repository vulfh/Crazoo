//
//  CZViewController.m
//  CRAZOO
//
//  Created by Dr James Monroe on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>


#import "CZViewController.h"
#import "CZGameLogic.h"

#import "FacebookSDK/FacebookSDK.h"
#import "CZAnimalPresentation.h"
#import "Utils.h"
#import <UIKit/UIKit.h>
@interface CZViewController()<FBLoginViewDelegate>{
    CZGameLogic* gameLogic;
    BOOL isConnected;
    BOOL inGame;

      
}
@property(nonatomic,strong) CZGameLogic* GameLogic;
@property (strong, nonatomic) id<FBGraphUser> loggedInUser;
    
-(void)IndexImages;
-(void)ResetImages;
-(void)ArrangeAnimals;
-(BOOL)AreAllAnimalsInPlace;
-(void)SettleAnimalPart:(int) direction;
-(CZAnimalPresentation*)GetImage:(int) animal part:(int) part;
-(void)ExchangeAnimals: (CZAnimalPresentation*) animal1 animal2:(CZAnimalPresentation*) animal2;
-(void)ShiftAnimal:(int) direction part:(int) part;
-(void)MovePartRel:(float) distance;
-(int)IdentifyMovingPart:(float) y;
-(void)DumpPresentation;
-(void)ShowMessage:(NSString *)text;
-(void)HideMessage;
-(void)WinningDance;
-(void)HideImages;
-(void)ShowImages;
-(void)Silence;
-(void)PlayFruit;
-(void)fruitAnimaionFinished:(NSString*) animationId finished:(bool) finished context:(void*)conext; 
-(AVAudioPlayer*)LoadPlayer:(NSString*) fileName;
- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error;
@end
//////////////////////////////////////////////
@implementation CZViewController

@synthesize  bgImage;

@synthesize  GameLogic;
@synthesize topImage;
@synthesize middleImage;
@synthesize bottomImage;


@synthesize topImageLeft;
@synthesize middleImageLeft;
@synthesize bottomImageLeft;

@synthesize topImageRight;
@synthesize middleImageRight;
@synthesize bottomImageRight;

@synthesize topImage4;
@synthesize middleImage4;
@synthesize bottomImage4;

@synthesize fruit = fruit;
@synthesize message;


@synthesize permissions;
@synthesize btnPublishOnFB;
@synthesize CZFBLoginLogout;
@synthesize loggedInUser;

UIImageView* animalPartsImages [AMOUNT_OF_ANIMALS][3];
CZAnimalPresentation* animals[AMOUNT_OF_ANIMALS][3];
int movingPart;
float motionStartedAtX;
float absoluteMotionStartPointX;
float shiftDistance;
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIAccelerometer *accelometer = [UIAccelerometer sharedAccelerometer];
    accelometer.updateInterval = 1.0f/30.0f;
    accelometer.delegate = self;
    
    [self HideMessage];
    GameLogic = [[CZGameLogic alloc] init];
    [GameLogic Init];
    [self IndexImages];
    [self ResetImages];
    [self HideImages];
    //Face book(id), ...
    // Set the permissions.
    // Without specifying permissions the access to Facebook is imposibble.
    permissions = [NSArray arrayWithObject:@"publish_actions"];
    // Set the Facebook object we declared. We’ll use the declared object from the application
    // delegate.
    
    FBLoginView *loginview = 
    [[FBLoginView alloc] initWithPermissions:[NSArray arrayWithObject:@"publish_actions"]];
    
    
  //  if([FBSession activeSession].state == FBSessionStateOpen)
    //    [[FBSession activeSession] closeAndClearTokenInformation];
    
    //[FBSession openActiveSessionWithPermissions:permissions allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
      //  NSLog(@"error %@", error); 
    //}];
    
    loginview.frame = CGRectOffset(loginview.frame, 5, 5);
    loginview.delegate = self;
    [loginview setHidden: YES];
    [self.view addSubview:loginview];
    
    for (id obj in loginview.subviews)
    {
        if ([obj isKindOfClass:[UIButton class]])
        {
           // UIButton * loginButton =  obj;
   /*         UIImage *loginImage = [UIImage imageNamed:@"YourImg.png"];
            [loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
            [loginButton setBackgroundImage:nil forState:UIControlStateSelected];
            [loginButton setBackgroundImage:nil forState:UIControlStateHighlighted];
            [loginButton sizeToFit];
        }
    */
/*        if ([obj isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel =  obj;
            loginLabel.text = @"Log in to facebook";
            loginLabel.textAlignment = UITextAlignmentCenter;
            loginLabel.frame = CGRectMake(0, 0, 271, 37);
        }

 */
        }
    }

    
    [loginview sizeToFit];

    
    
// Do any additional setup after loading the view, typically from a nib.
}
//////Touch events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    if(inGame == NO){
        NSLog(@"We are not in game !");
        return;
    }
    [self Silence];
    float touchY =[touch locationInView:touch.view].y;
    motionStartedAtX = [touch locationInView:touch.view].x;
    absoluteMotionStartPointX = motionStartedAtX;
    movingPart = [self IdentifyMovingPart:touchY];
    NSLog(@":) You are dragging %i part !",movingPart);
}
////////////////////////////////////////////////////////////////////////////
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if(inGame==NO){
        NSLog(@"We are not in game !");
        return;
    }
    UITouch *touch = [[event allTouches] anyObject];
    float distanceMoved = [touch locationInView:touch.view].x-motionStartedAtX;
    motionStartedAtX = [touch locationInView:touch.view].x ;
    [self MovePartRel:distanceMoved];
    NSLog(@"Dragging of part %i continueded at %f",movingPart,distanceMoved);
     }
////////////////////////////////////////////////////////////////////////////
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(inGame==NO){
        NSLog(@"We are not in game !");
        return;
    }
    NSLog(@"Dragging of part %i ended !!!",movingPart);
    if(ABS(motionStartedAtX - absoluteMotionStartPointX)>=shiftDistance){
        NSLog(@"Shift should be done !!!");
        if(motionStartedAtX - absoluteMotionStartPointX > 0){
            NSLog(@"*****Shifting Right !");
            [GameLogic Shift:movingPart direction:RIGHT];
            [self ShiftAnimal:RIGHT part:movingPart];
        }else{
            NSLog(@"*****Shifting Left !");
            [GameLogic Shift:movingPart direction:LEFT];
            [self ShiftAnimal:LEFT part:movingPart];
            //[self SettleAnimalPart:LEFT];
        }
        [GameLogic DumpGameField];
        [animals[1][movingPart] PlayTouchSound];
        if([GameLogic Won]){
           // [self ShowMessage:@"! ! ! YOU WIN ! ! !"];
            [self WinningDance];
          
        }
                
    }else{
        for(int a = 0; a< AMOUNT_OF_ANIMALS;a++){
            [animals[a][movingPart] Settle];
            
        }
        //[animals[1][movingPart] PlayTouchSound];
    }


}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    return NO;
}
//SHAKING EVENTS HANDLING
-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
    
    if(event.subtype == UIEventSubtypeMotionShake){     
        [self HideMessage];
        [GameLogic Shake];
        NSLog(@"You shaked me :)");
        inGame = YES;
        for(int a=0;a<AMOUNT_OF_ANIMALS;a++)
            for(int p=0;p<AMOUNT_OF_PARTS;p++)
                animals[a][p].exchanged  = FALSE;

        [self ArrangeAnimals];
        [self ShowImages];
        inGame = YES;
    }
    
    if ( [super respondsToSelector:@selector(motionEnded:withEvent:)] )
        [super motionEnded:motion withEvent:event];
}
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if(inGame == YES)
        return;
    [self ShowImages];
    if(event.subtype == UIEventTypeMotion){
        NSLog(@"Shaking began !");
        [self HideImages];
    }
    
    if(event.subtype == UIEventSubtypeMotionShake){
        NSLog(@"You started shaking me :)");
        [GameLogic Init];
       // [self IndexImages];
        [self ResetImages];
    }
    
    if ( [super respondsToSelector:@selector(motionBegan:withEvent::withEvent:)] )
        [super motionBegan:motion withEvent:event];
    
}
- (BOOL)canBecomeFirstResponder
{ return YES; }
//CUSTOM FUNCTIONS

-(void)IndexImages{
    @autoreleasepool{
    shiftDistance = middleImage.frame.size.width / 2.0;
    for(int a=0;a<AMOUNT_OF_ANIMALS;a++){
        for(int p=0;p<AMOUNT_OF_PARTS;p++){
            animals[a][p]=[[CZAnimalPresentation alloc]init];
        }
    }
    
    AVAudioPlayer *rabitTouch = [self LoadPlayer:@"%@/rabbit.wav"];
    AVAudioPlayer *dogTouch = [self LoadPlayer:@"%@/dog.wav"];
    AVAudioPlayer *monkeyTouch =[self LoadPlayer:@"%@/monkey.wav"];
    AVAudioPlayer *victorySound = [self LoadPlayer:@"%@/victory_final.wav"];
    
    animals[0][0].image = topImageLeft;
    animals[0][0].animal = RABBIT;
    animals[0][0].indexX = 0;
    animals[0][0].indexY = 0;
    [animals[0][0] SetTouchAudioPlayer:rabitTouch];
    [animals[0][0] SetCompletedSound:victorySound];
    
    //animals[0][0].FruitImage = [UIImage imageNamed:@"carrot.gif"];
    [animals[0][0] SetFruitImage:@"carrot_big.gif"];
    
    animals[0][1].image = middleImageLeft;
    animals[0][1].animal = RABBIT;
    animals[0][1].indexX = 0;
    animals[0][1].indexY = 1;
    [animals[0][1] SetTouchAudioPlayer:rabitTouch];
    
    
    animals[0][2].image = bottomImageLeft;
    animals[0][2].animal = RABBIT;
    animals[0][2].indexX = 0;
    animals[0][2].indexY = 2;
    [animals[0][2] SetTouchAudioPlayer:rabitTouch];
    
    
    animals[1][0].image = topImage;
    animals[1][0].animal = MOUSE;
    animals[1][0].indexX = 1;
    animals[1][0].indexY = 0;
    [animals[1][0] SetTouchAudioPlayer:dogTouch];
    [animals[1][0] SetCompletedSound:victorySound];
    [animals[1][0] SetFruitImage:@"bone_big.gif"];
    //animals[1][0].FruitImage = [UIImage imageNamed:@"dog_bone.gif"];

    animals[1][1].image = middleImage;
    animals[1][1].animal = MOUSE;    
    animals[1][1].indexX = 1;
    animals[1][1].indexY = 1;
    [animals[1][1] SetTouchAudioPlayer:dogTouch];    
        
    
    animals[1][2].image= bottomImage;
    animals[1][2].animal = MOUSE;
    animals[1][2].indexX = 1;
    animals[1][2].indexY = 2;
    [animals[1][2] SetTouchAudioPlayer:dogTouch];
    
    

    animals[2][0].animal = MONKEY;
    animals[2][0].image = topImageRight;
    animals[2][0].indexX = 2;
    animals[2][0].indexY = 0;
    [animals[2][0] SetTouchAudioPlayer:monkeyTouch];
    [animals[2][0] SetCompletedSound:victorySound];
    [animals[2][0] SetFruitImage:@"banana_big.gif"];
    //animals[2][0].FruitImage = [UIImage imageNamed:@"banana.gif"];
    
    animals[2][1].animal = MONKEY;
    animals[2][1].image = middleImageRight;
    animals[2][1].indexX = 2;
    animals[2][1].indexY = 1;
    [animals[2][1] SetTouchAudioPlayer:monkeyTouch];
    
    animals[2][2].image = bottomImageRight;
    animals[2][2].animal = MONKEY;
    animals[2][2].indexX = 2;
    animals[2][2].indexY = 2;
    [animals[2][2] SetTouchAudioPlayer:monkeyTouch];
    /*
    animals[3][0].animal = ANIMAL4;
    animals[3][0].image = topImage4;
    animals[3][0].indexX = 3;
    animals[3][0].indexY = 0;
    [animals[3][0] SetTouchAudioPlayer:monkeyTouch];
    [animals[3][0] SetCompletedSound:monkeyTouch];
    [animals[3][0] SetFruitImage:@"%@/allOpenPage.jpg"];
     
    animals[3][1].animal = ANIMAL4;
    animals[3][1].image = middleImage4;
    animals[3][1].indexX = 3;
    animals[3][1].indexY = 1;
    [animals[3][1] SetTouchAudioPlayer:monkeyTouch];
    
    animals[3][2].image = bottomImage4;
    animals[3][2].animal = ANIMAL4;
    animals[3][2].indexX = 3;
    animals[3][2].indexY = 2;
    [animals[3][2] SetTouchAudioPlayer:monkeyTouch];
*/
    }

}
-(void)ResetImages{
    [GameLogic DumpGameField];
    [self DumpPresentation];
    
    for(int i=0;i< AMOUNT_OF_ANIMALS;i++){
        for(int j = 0;j< AMOUNT_OF_PARTS;j++){
            
            switch (j) {
                case TOP:
                    [Utils SetImageSize:animals[i][j].image width:320 height:248];
                    [animals[i][j] MoveTo:0 y:0];

                    break;
                case MIDDLE:
                    [Utils SetImageSize:animals[i][j].image width:320 height:120];
                    [animals[i][j] MoveTo:0 y:248];
                    break;
                case BOTTOM:
                    [Utils SetImageSize:animals[i][j].image width:320 height:112];
                    [animals[i][j] MoveTo:0 y:368];
                    break;
            }
        }
    }
        
    
    CGFloat theLeft = -320.0;
    for(int i=0;i<AMOUNT_OF_ANIMALS;i++){
        CGFloat left= theLeft+i*(topImage.frame.size.width);
        for(int j=0;j<AMOUNT_OF_PARTS;j++){
            [animals[i][j] MoveTo:left y:animals[i][j].image.frame.origin.y];
        }
    }
}
-(void)ArrangeAnimals{
    
    @autoreleasepool{
    [GameLogic DumpGameField];
    [self DumpPresentation];
    do{ 
    for(int a = 0;a< AMOUNT_OF_ANIMALS ; a++){
        for(int p=0;p<AMOUNT_OF_PARTS;p++){
            int animal = [GameLogic GetAnimalAtLocation:a y:p];
            
            CZAnimalPresentation* animalImage = animals[a][p];
            int presentedAnimal = animalImage.animal;
            
            
            NSLog(@"*** Exchanging %i with %i ...",animal,presentedAnimal);
            if( animal == presentedAnimal){
                NSLog(@"Animal: %i already in place !!!!",a);
                continue;
            }
            
            
            CZAnimalPresentation* animalImageToExchangeWith = [self GetImage:animal part:p];
            [self ExchangeAnimals:animalImage animal2:animalImageToExchangeWith];
            animals[animal][p].exchanged = TRUE;
            [GameLogic DumpGameField];
            [self DumpPresentation];
        }
    }
    }while ([self AreAllAnimalsInPlace] == NO);
    [self DumpPresentation];
    [GameLogic DumpGameField];
    }
    
}
-(void)SettleAnimalPart:(int) direction{
    for(int a=0;a<AMOUNT_OF_ANIMALS;a++)
        for(int p=0;p<AMOUNT_OF_PARTS;p++)
            animals[a][p].exchanged  = FALSE;
    [self ArrangeAnimals];
}
-(CZAnimalPresentation*)GetImage:(int) animal part:(int) part{
    if(animal>=0 && animal < AMOUNT_OF_ANIMALS){
        if(part>=0 && part < AMOUNT_OF_PARTS){
            for(int a =0 ;a< AMOUNT_OF_ANIMALS;a++){
                if(animals[a][part].animal == animal){
                    NSLog(@"Get animal %i part %i at place %i part %i...",animal,part,a,part);
                    return animals[a][part];                    
                }
            }
        }
    }
    return nil;    
}
-(int)IdentifyMovingPart:(float) y{
    for(int p =0;p<AMOUNT_OF_PARTS;p++){
           if(animals[1][p].image.frame.origin.y<=y &&
              y<= animals[1][p].image.frame.origin.y+animals[1][p].image.frame.size.height)
               return p;
    }
    return -1;
}
-(void)MovePartRel:(float) distance{
    for(int a=0;a<AMOUNT_OF_ANIMALS;a++){
        
        [animals[a][movingPart] MoveToTempPosition:animals[a][movingPart].image.frame.origin.x+distance y:animals[a][movingPart].image.frame.origin.y];
    }
}
-(void)ShiftAnimal:(int) direction part: (int) part{
    CZAnimalPresentation* tempAnimal;
    int tempIndeX;
    float tempPointX;
    float prevPointX;
    @autoreleasepool{
    if(direction == LEFT){
        
        tempAnimal = animals[0][part];
        tempIndeX =  animals[AMOUNT_OF_ANIMALS-1][part].indexX;
        prevPointX = animals[0][part].leftPositionX;
        tempPointX = animals[AMOUNT_OF_ANIMALS-1][part].leftPositionX;
        
        for(int a =0 ; a< AMOUNT_OF_ANIMALS-1;a++){
             animals[a+1][part].indexX--;
            float t = animals[a+1][part].leftPositionX;
            [animals[a+1][part] MoveTo:prevPointX y:animals[a+1][part].leftPositionY];
            prevPointX=t;
            animals[a][part] = animals[a+1][part];
            [GameLogic DumpGameField];
            [self DumpPresentation];
        }
        animals[AMOUNT_OF_ANIMALS-1][part] = tempAnimal;
        animals[AMOUNT_OF_ANIMALS-1][part].indexX = tempIndeX;
        [animals[AMOUNT_OF_ANIMALS-1][part] MoveTo:tempPointX y:animals[AMOUNT_OF_ANIMALS-1][part].leftPositionY];
        [self DumpPresentation];
    }else{
        tempAnimal = animals[AMOUNT_OF_ANIMALS-1][part];
        tempIndeX =  animals[0][part].indexX;
        tempPointX = animals[0][part].leftPositionX;
        prevPointX = animals[AMOUNT_OF_ANIMALS-1][part].leftPositionX;
        
        for(int a =AMOUNT_OF_ANIMALS-2 ; a>=0 ;a--){
            animals[a][part].indexX++;
            float t = animals[a][part].leftPositionX;
            [animals[a][part] MoveTo:prevPointX y:animals[a][part].leftPositionY];
            prevPointX=t;
            animals[a+1][part] = animals[a][part];
            //            [self DumpPresentation];
        }
        
        animals[0][part] = tempAnimal;
        animals[0][part].indexX = tempIndeX;
        [animals[0][part] MoveTo:tempPointX y:animals[0][part].leftPositionY];
        [self DumpPresentation];
    }
    }
}
-(void) ExchangeAnimals:(CZAnimalPresentation *)animal1 animal2:(CZAnimalPresentation *)animal2{
    NSLog(@"Animals for exchange :%i<-->%i",animal1.animal,animal2.animal);
    @autoreleasepool {
        
    
        CGFloat tempX = animal1.leftPositionX;
        CGFloat tempY = animal1.leftPositionY;
        int a1x = animal1.indexX;
        int a1y = animal1.indexY;
        int a2x = animal2.indexX;
        int a2y = animal2.indexY;
        CZAnimalPresentation* tempAnimal = animals[a1x][a1y];
    
        [animal1 MoveTo:animal2.leftPositionX y:animal2.leftPositionY];
        [animal2 MoveTo:tempX y:tempY];
    
        animals[a1x][a1y] = animals[a2x][a2y];
        animals[a1x][a1y].indexX = a1x;
        animals[a1x][a1y].indexY = a1y;
    
        animals[a2x][a2y] = tempAnimal;
        animals[a2x][a2y].indexX = a2x;
        animals[a2x][a2y].indexY = a2y;
    }
//    animal1.animal = animal2.animal;
  //  animal2.animal = tempAnimal;
   // animal1 = animal2;
    //animal2 = tempAnimal;
}
-(void) DumpPresentation{
    NSLog(@"Presentation :");
    @autoreleasepool{
        for(int p =0 ; p < AMOUNT_OF_PARTS ; p++){
            NSMutableString *templateString = [NSMutableString string];
           
            for(int a=0;a<AMOUNT_OF_ANIMALS;a++)
            {
                NSString *animal = [NSString stringWithFormat:@"%@", [GameLogic GetAnimalName: animals[a][p].animal]];
                [templateString appendFormat:@"%@ [%d;%d] ",animal,animals[a][p].indexX,animals[0][p].indexY];
              //  [templateString appendString:@"hello"];
            }
            NSLog(@"%@",[NSString stringWithFormat:@"%@", templateString]);
            
         
        }
    }
}
-(void)ShowMessage:(NSString *)text{
    message.hidden = NO;
    message.text = text;
    
}
-(void)HideMessage{
    message.hidden = YES;
}

-(AVAudioPlayer*) LoadPlayer:(NSString *)fileName{
    //Test player
    //"%@/rabbit.wav",
    @autoreleasepool{
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:fileName, [[NSBundle mainBundle] resourcePath]]];
    
        NSError *error;
        AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        NSLog(@"%@",[NSString stringWithFormat:@"%@",[error description]]);
        return player;
    }
}



-(void)WinningDance{
     //[self showAlert:@"!!! You WON !!!" result:nil error:nil];
    inGame = NO;
    @autoreleasepool {
        
    
    [self PlayFruit];
    [animals[1][0] PlayCompletedSound];
    }
}

/////////////FACEBOOK DELEGATE METHODS
- (IBAction)Publish:(id) Sender {
    

    NSString *fbMessage = [NSString stringWithFormat:@"CraZoo is amazing application !!!", [NSDate date]];
    
    if(FBSession.activeSession.isOpen)
    {
        [FBSession.activeSession closeAndClearTokenInformation];
   
    }
    
    [FBSession openActiveSessionWithPermissions:self.permissions
                                   allowLoginUI:YES
                              completionHandler:^(FBSession * session, FBSessionState state,NSError * error){
                                  ///The message posting
                                  
                                  [FBRequestConnection startForPostStatusUpdate:fbMessage
                                                              completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                                                  
                                                                  [self showAlert:fbMessage result:result error:error];
                                                                  //self.buttonPostStatus.enabled = YES;
                                                              }];
                                  
                              }];

    
    
    
   
  
}
-(void) Silence{
    for(int a =0 ;a< 3;a++){
        for(int p = 0;p<AMOUNT_OF_PARTS;p++){
            [animals[a][p] Silence];
        }
    }
}
- (void)showAlert:(NSString *)localMessage
           result:(id)result
            error:(NSError *)error {
    
    NSString *alertMsg;
    NSString *alertTitle;
    if (error) {
        alertMsg = error.localizedDescription;
        alertTitle = @"Error";
    } else {
        NSDictionary *resultDict = (NSDictionary *)result;
        alertMsg = [NSString stringWithFormat:@"'%@'.\nPost ID: %@", 
                    localMessage, [resultDict valueForKey:@"id"]];
        alertTitle = @"Success";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMsg
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    
    
    [alertView show];
    
    
    
}
- (BOOL) AreAllAnimalsInPlace{
    for(int a =0;a<AMOUNT_OF_ANIMALS;a++)
        for(int p =0;p<AMOUNT_OF_PARTS;p++)
        {
            int presentedAnimal = animals[a][p].animal;
            int animalOnTheField = [GameLogic GetAnimalAtLocation: a y:p];
            if(presentedAnimal!= animalOnTheField )
                return NO;
        }
    return YES;
}
-(void)HideImages{
    for(int a =0; a< AMOUNT_OF_ANIMALS;a++)
        for(int p = 0; p<AMOUNT_OF_PARTS;p++)
            [animals[a][p].image setHidden:YES];
}
-(void)ShowImages{
    for(int a =0; a< AMOUNT_OF_ANIMALS;a++)
        for(int p = 0; p<AMOUNT_OF_PARTS;p++)
            [animals[a][p].image setHidden:NO];    
}
-(void)PlayFruit{
    @autoreleasepool {
        [self Silence];
        fruit.image = animals[1][0].FruitImage;
        [fruit setHidden:NO];
        [Utils MoveImage:fruit x:50 y:0];
        [UIView beginAnimations:nil context:NULL];
    
        [UIView setAnimationDuration:5.0];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationRepeatAutoreverses:NO];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(fruitAnimaionFinished:finished:context:)];
    
        [Utils MoveImage:fruit x:50 y:280];
    
        [UIView commitAnimations];
    }
 //   [fruit setHidden:YES];
    
}
-(void)fruitAnimaionFinished:(NSString*) animationId finished:(bool) finished context:(void*)conext{
    NSLog(@"Finita");
    [self Silence];
    [NSThread sleepForTimeInterval:2];
    [self HideImages];
     [fruit setHidden:YES];
}
//FBLoginViewDelegate protocol methods
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    // first get the buttons set for login mode
   }

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    
    
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
}
@end
