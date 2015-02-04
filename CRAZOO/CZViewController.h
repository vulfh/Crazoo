//
//  CZViewController.h
//  CRAZOO
//
//  Created by Dr James Monroe on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookSDK/FacebookSDK.h"



@interface CZViewController : UIViewController<UIAccelerometerDelegate>{
    IBOutlet UIImageView* bgImage;
    
    IBOutlet UIImageView* topImage;
    IBOutlet UIImageView* middleImage;
    IBOutlet UIImageView* bottomImage;
    
    IBOutlet UIImageView* topImageLeft;
    IBOutlet UIImageView* middleImageLeft;
    IBOutlet UIImageView* bottomImageLeft;
    
    IBOutlet UIImageView* topImageRight;
    IBOutlet UIImageView* middleImageRight;
    IBOutlet UIImageView* bottomImageRight;
    
    IBOutlet UIImageView* topImage4;
    IBOutlet UIImageView* middleImage4;
    IBOutlet UIImageView* bottomImage4;
    
    IBOutlet UIImageView* fruit;
    IBOutlet UILabel *message;
    
    IBOutlet  UIButton*    startButton;
    
    
    //Face book
    
    NSArray* permissions;
    IBOutlet UIButton* btnPublishOnFB;
    IBOutlet UIView *CZFBLoginLogout;
}
@property(nonatomic,strong) UIImageView* bgImage;

@property(nonatomic,strong) UIImageView* topImage;
@property(nonatomic,strong) UIImageView* middleImage;
@property(nonatomic,strong) UIImageView* bottomImage;

@property(nonatomic,strong) UIImageView* topImageLeft;
@property(nonatomic,strong) UIImageView* middleImageLeft;
@property(nonatomic,strong) UIImageView* bottomImageLeft;

@property(nonatomic,strong) UIImageView* topImageRight;
@property(nonatomic,strong) UIImageView* middleImageRight;
@property(nonatomic,strong) UIImageView* bottomImageRight;

@property(nonatomic,strong) UIImageView* topImage4;
@property(nonatomic,strong) UIImageView* middleImage4;
@property(nonatomic,strong) UIImageView* bottomImage4;

@property(nonatomic,strong) UIImageView* fruit;

@property(nonatomic,strong) UILabel* message;

@property(nonatomic,strong) NSArray* permissions;
@property(nonatomic,strong) UIButton* btnPublishOnFB;
@property(nonatomic,strong) UIView*  CZFBLoginLogout;
-(IBAction)Publish:(id)sender;
//-(void) sessionStateChanged:(FBSession*) session state:(int)state error:(NSError*) error;


@end
