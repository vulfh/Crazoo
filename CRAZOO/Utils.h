//
//  Utils.h
//  CRAZOO
//
//  Created by Dr James Monroe on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utils : NSObject
+(void) MoveImage:(UIImageView*)image x: (CGFloat) x y:(CGFloat) y;
+(void)SetImageSize:(UIImageView*)image width:(CGFloat) width height:(CGFloat) height;
@end
