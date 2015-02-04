//
//  CZGameLogic.m
//  CRAZOO
//
//  Created by Dr James Monroe on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CZGameLogic.h"
#include <stdlib.h>
#import <UIKit/UIKit.h>
#import "Utils.h"

@interface CZGameLogic(){

}

-(BOOL) IsValidShake;
@end

@implementation CZGameLogic

int _gameField [AMOUNT_OF_ANIMALS][AMOUNT_OF_PARTS];
UIImageView* _gameFieldPresentation [AMOUNT_OF_ANIMALS][AMOUNT_OF_PARTS];
int _animals[AMOUNT_OF_ANIMALS];
NSString* _animalNames[AMOUNT_OF_ANIMALS];

BOOL _shaked;

-(void) Init{
    _shaked=NO;
    /*
    for(int i=0;i<AMOUNT_OF_ANIMALS;i++){
        _animals[i]=EMPTY;
    }
    
    for(int i=0;i<AMOUNT_OF_ANIMALS;i++){
        BOOL found = NO;
        while(!found){
            int animalCandidate = arc4random()%AMOUNT_OF_ANIMALS;
            for(int j=0;j<i;j++)
                if(_animals[j]==animalCandidate)
                    continue;
            found=YES;
        }
        
    }
      */  
    for(int j=0;j<AMOUNT_OF_ANIMALS;j++){
        for(int i=0;i< AMOUNT_OF_PARTS;i++){
            _gameField[j][i] = j;
        }

        _animalNames[0] = @"Rabbit";
        _animalNames[1] = @"Mouse";
        _animalNames[2] = @"Monkey";
    //    _animalNames[3] = @"Animal4";
        
        [self DumpGameField];
    }
}
-(void) Swap:(int[AMOUNT_OF_ANIMALS]) animalParts place1:(int) src place2:(int) trg{
    NSLog(@"Swapping Animal at the %i place with animal a the %i place ...",src,trg);
    int temp = animalParts[trg];
    animalParts[trg] = animalParts[src];
    animalParts[src] = temp;
    
}
-(void) Shake{
    _shaked = YES;
    //for(int i=0;i<AMOUNT_OF_ANIMALS;i++){
    do{
        for(int j=0;j<AMOUNT_OF_PARTS;j++){
           
            int newPlace = 1;
            while(1==newPlace){
                    newPlace = arc4random()%(AMOUNT_OF_ANIMALS);
            }
            int temp = _gameField[1][j];
             NSLog(@"Previous place %i new place %i....",j,newPlace);
            _gameField[1][j] = _gameField[newPlace][j];
            _gameField[newPlace][j] = temp;
            //[self Swap: _gameField[i] place1:j place2:newPlace];
        }
    }while ([self IsValidShake] == NO) ;
        
    //}
    NSLog(@"Mixed animals :)...");
    [self DumpGameField];

}
-(int) GetPartOfAnimal:(int)animalId partId:(int) partId{
    int animalIdx = animalId;
    for(int a=0;a<AMOUNT_OF_ANIMALS;a++){
        if(_gameField[a][partId]==animalId)
        {
            animalIdx = a;
            break;
        }
    }
    
    return animalIdx;
}
-(BOOL)Won{
    if(!_shaked)
        return NO;
    for(int j = 1;j < AMOUNT_OF_PARTS;j++){
        if(_gameField[1][j] != _gameField[1][j-1])
            return NO;
    }
    return YES;
}
-(void)Shift:(int)partName direction:(int)direction{

    if(direction == LEFT){
        int leftAnimal = _gameField[0][partName];
        for(int i = 1;i<AMOUNT_OF_ANIMALS ;i++){
            _gameField[i-1][partName] = _gameField[i][partName];
        }
        _gameField[AMOUNT_OF_ANIMALS-1][partName] = leftAnimal;
    }
    else{
        int rightAnimal = _gameField[AMOUNT_OF_ANIMALS-1][partName];
        for(int i = AMOUNT_OF_ANIMALS-2;i>=0;i--){
            _gameField[i+1][partName] = _gameField[i][partName]; 
        }
        _gameField[0][partName] = rightAnimal;
    }
        
    
}


-(int)GetFullAnimal:(int)location{
    int animal = EMPTY;
    if (_gameField[location][TOP] == _gameField[location][MIDDLE] &&
         _gameField[location][MIDDLE] == _gameField[location][BOTTOM]) {
        animal = _gameField[location][TOP];
    }
    
    return animal;
}

-(void)DumpGameField{
    @autoreleasepool {
    NSLog(@"Game field :");
        for(int i=0;i<AMOUNT_OF_PARTS;i++){
            NSMutableString *templateString = [NSMutableString string];
            for(int a=0;a< AMOUNT_OF_ANIMALS;a++)
            {
                [templateString appendFormat:@"%@ ",[self GetAnimalName: _gameField[a][i]]];
            }
       
                NSLog(@"%@",[NSString stringWithFormat:@"%@", templateString]);
            
        }
    }
}

-(BOOL) IsValidShake{
    if(_gameField[1][0] == _gameField[1][1])
        return NO;
    if(_gameField[1][1] == _gameField[1][2])
        return NO;
    if(_gameField[1][0] == _gameField[1][2])
        return NO;
    return YES;
}
-(int)GetAnimalAtLocation:(int) x y:(int) y{
    return _gameField[x][y];
}
-(NSString*)GetAnimalName:(int)animal{
    if(animal >= AMOUNT_OF_ANIMALS)
        return @"Unknown animal";
    return _animalNames[animal];
    
    
}
@end
