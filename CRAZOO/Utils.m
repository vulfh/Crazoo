//
//  Utils.m
//  CRAZOO
//
//  Created by Dr James Monroe on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"

@implementation Utils
+(void) MoveImage:(UIImageView*)image x: (CGFloat) x y:(CGFloat) y{
    @autoreleasepool{ 
    image.frame = CGRectMake(x, y, image.frame.size.width, image.frame.size.height);
    image.bounds = image.frame;//CGRectMake(x, y, image.frame.size.width, image.frame.size.height);
    }
    
}
+(void)SetImageSize:(UIImageView *)image width:(CGFloat)width height:(CGFloat)height{
    image.frame = CGRectMake(image.frame.origin.x,  image.frame.origin.y, width, height);
}
@end
