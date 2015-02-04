//
//  CZGameLogic.h
//  CRAZOO
//
//  Created by Dr James Monroe on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//apptoit1234

#define EMPTY -1
#define RABBIT 0
#define MOUSE  1
#define MONKEY 2
#define ANIMAL4    3

#define TOP     0
#define MIDDLE  1
#define BOTTOM  2

#define LEFT    0
#define CENTER  1
#define RIGHT   2


#define AMOUNT_OF_ANIMALS   3
#define AMOUNT_OF_PARTS     3

@interface CZGameLogic : NSObject{

}
-(void) Init;
-(void) Shake;
-(void) Swap:(int[AMOUNT_OF_ANIMALS]) animalParts place1:(int) src place2:(int) trg;
-(int) GetPartOfAnimal:(int)animalId partId:(int) partId;
-(BOOL)Won;
-(void)Shift:(int)partName direction:(int) direction;
-(int)GetFullAnimal:(int)location;
-(int)GetAnimalAtLocation:(int) x y:(int) y; 
-(void)DumpGameField;
-(NSString*)GetAnimalName:(int)animal;

@end
