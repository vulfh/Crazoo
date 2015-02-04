//
//  CZAppDelegate.h
//  CRAZOO
//
//  Created by Dr James Monroe on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookSDK/FacebookSDK.h"
@class CZViewController;

@interface CZAppDelegate : UIResponder <UIApplicationDelegate>
{

}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CZViewController *viewController;



@end
