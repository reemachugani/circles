//
//  XYZRandomSwapAnimation.m
//  Circles
//
//  Created by Harish Murugasamy on 3/15/14.
//  Copyright (c) 2014 Harish Murugasamy. All rights reserved.
//

#import "XYZSwapAnimation.h"
#import "XYZGameConstants.h"

#include <stdlib.h>

@implementation XYZSwapAnimation

- (NSInteger) animationID{
    return 3;
}

//- (NSInteger) minApplicableLevel{
//    return 10;
//}

- (void) animate: (NSArray *) circles withSpeed: (CGFloat) speed
{
    
    NSDictionary* initialPositions = [self getInitialPositionsFor: circles];
    NSDictionary* swappedPositions = [self getSwappedPositionsFor: circles from: initialPositions];
    
    SKAction* swapAction = [SKAction customActionWithDuration:speed actionBlock:^(SKNode *node, CGFloat elapsedTime) {
       
        XYZCircle* curCircle = (XYZCircle*) node;
        CGPoint initialPosition = CGPointFromString(initialPositions[[NSNumber numberWithInteger: curCircle.circleID]]);
        CGPoint swappedPosition = CGPointFromString(swappedPositions[[NSNumber numberWithInteger: curCircle.circleID]]);
        
        if(CGPointEqualToPoint(curCircle.position, initialPosition)){
            [curCircle runAction: [SKAction moveTo: swappedPosition duration: speed]];
        
        } else if(CGPointEqualToPoint(curCircle.position, swappedPosition)){
            [curCircle runAction: [SKAction moveTo: initialPosition duration: speed]];
        }
    }];
    
    for(XYZCircle* circle in circles){
        [circle runAction: [SKAction repeatActionForever: swapAction]];
    }
}

- (NSDictionary*) getInitialPositionsFor: (NSArray*) circles
{
    NSMutableDictionary* initialPositions = [[NSMutableDictionary alloc] init];
    
    for(XYZCircle* circle in circles){
        initialPositions[[NSNumber numberWithInteger: circle.circleID]] = NSStringFromCGPoint(circle.position);
    }
    
    //NSLog(@"Initial Positions : %@", initialPositions);
    
    return initialPositions;
}


- (NSDictionary*) getSwappedPositionsFor: (NSArray *) circles from: (NSDictionary *) initialPositions
{
    NSInteger numCircles = [circles count];
    NSMutableDictionary* swappedPositions = [[NSMutableDictionary alloc] init];
    
    // if there is only one circle assigned for swapping, it has no where to swap. so just swap with centre of screen
    if(numCircles == 1){
        CGSize screenSize = [XYZGameConstants screenSize];
        CGPoint screenCentre = CGPointMake(screenSize.width/2,  screenSize.height/2);
        
        XYZCircle* onlyCircle = (XYZCircle*) circles[0];
        swappedPositions[[NSNumber numberWithInteger: onlyCircle.circleID]] = NSStringFromCGPoint(screenCentre);
        
        return swappedPositions;
    }
    
    
    NSInteger numCircelsToPairUp = numCircles;

    // if there are odd # of circles assigned for swapping, let the last 3 circles swap among them and reduce the numCirclesToPairUp by 3
    if(numCircles % 2 == 1) {
        numCircelsToPairUp = numCircles - 3;
        
        XYZCircle* firstCircle = (XYZCircle*) circles[numCircelsToPairUp];
        XYZCircle* secondCircle = (XYZCircle*) circles[numCircelsToPairUp+1];
        XYZCircle* thirdCircle = (XYZCircle*) circles[numCircelsToPairUp+2];
        
        swappedPositions[[NSNumber numberWithInteger: firstCircle.circleID]] = initialPositions[[NSNumber numberWithInteger: secondCircle.circleID]];
        swappedPositions[[NSNumber numberWithInteger: secondCircle.circleID]] = initialPositions[[NSNumber numberWithInteger: thirdCircle.circleID]];
        swappedPositions[[NSNumber numberWithInteger: thirdCircle.circleID]] = initialPositions[[NSNumber numberWithInteger: firstCircle.circleID]];
    }
    
    // for each circle, find the position of adjacent circle to swap with
    for(NSInteger i = 0; i < numCircelsToPairUp; i += 2){
        
        XYZCircle* firstCircle = (XYZCircle*) circles[i];
        XYZCircle* secondCircle = (XYZCircle*) circles[i+1];
        
        NSString* firstCirclePosition = initialPositions[[NSNumber numberWithInteger: firstCircle.circleID]];
        NSString* secondCirclePosition = initialPositions[[NSNumber numberWithInteger: secondCircle.circleID]];
        
        swappedPositions[[NSNumber numberWithInteger: firstCircle.circleID]] = secondCirclePosition;
        swappedPositions[[NSNumber numberWithInteger: secondCircle.circleID]] = firstCirclePosition;
    }
    
    //NSLog(@"Swapped Positions : %@", swappedPositions);
    
    return swappedPositions;
}


@end
