//
//  XYZCircularAnimation.m
//  Circles
//
//  Created by Abhijith Padmakumar on 3/18/14.
//  Copyright (c) 2014 Harish Murugasamy. All rights reserved.
//

#import "XYZCircularAnimation.h"
#define DEGREES_TO_RADIANS(degrees)  ((M_PI * degrees)/ 180.0)

@implementation XYZCircularAnimation

- (NSInteger) animationID
{
    return 4;
}

- (NSInteger) minApplicableLevel
{
    return 1;
}

- (SKAction*) returnActionPathForRadius:(CGFloat)radius forCircle:(CGFloat)circleNum withTotalCircles:(CGFloat)totalCircles duration:(CGFloat)speed
{
    NSInteger startingDegValue = (360/totalCircles)*(1 + circleNum);
    NSInteger finaldegValue = startingDegValue+1080;
    //Duration is hard coded to 3, until the shivering bug in other animations is fixed.
    //Creating a circular path with center as center of screen.
    UIBezierPath *aPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(160, 240)
                                                         radius:radius
                                                     startAngle:DEGREES_TO_RADIANS(startingDegValue)
                                                       endAngle:DEGREES_TO_RADIANS(finaldegValue)
                                                      clockwise:YES];
    SKAction *followCircle = [SKAction followPath:aPath.CGPath asOffset:NO orientToPath:YES duration:9];
    SKAction *animateThrice = [SKAction repeatAction:followCircle count:3];
    return animateThrice;
}

- (void) animate: (NSArray *) circles withSpeed: (NSInteger) speed
{
    NSInteger temp = 1;
    //52 refers to size of circle Image. Can be standardized later.
    //TODO: Randomize direction
    CGFloat radius = ([XYZGameConstants screenSize].width-100.0)/2;
    for(XYZCircle* circle in circles)
    {
        //Each circle gets the same path, but different locations on the circle as their initial location
        [circle runAction:[SKAction repeatActionForever:[self returnActionPathForRadius:radius forCircle:temp++ withTotalCircles:circles.count duration:speed]]];
    }
}

@end
