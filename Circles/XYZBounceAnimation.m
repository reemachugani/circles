//
//  XYZBounceAnimation.m
//  Circles
//
//  Created by Harish Murugasamy on 3/12/14.
//  Copyright (c) 2014 Harish Murugasamy. All rights reserved.
//

#import "XYZBounceAnimation.h"
#import "XYZGameConstants.h"

@implementation XYZBounceAnimation

- (void) animate: (NSArray *) circles withSpeed: (NSInteger) speed
{

    SKAction *moveAroundAction = [SKAction customActionWithDuration:1 actionBlock:^(SKNode *node, CGFloat elapsedTime) {
        
        NSMutableDictionary *oldDirections = node.userData;
        oldDirections = oldDirections == NULL ? [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                 [NSNumber numberWithInt:1], @"x",
                                                 [NSNumber numberWithInt:1], @"y",
                                                 nil] : oldDirections;
        
        CGFloat xDirection = [oldDirections[@"x"] intValue];
        CGFloat yDirection = [oldDirections[@"y"] intValue];
        
        
        if(node.position.x >= [XYZGameConstants screenSize].width)
            xDirection = -fabs(xDirection);
        else if(node.position.x <= 0)
            xDirection = fabs(xDirection);
        
        if(node.position.y >= [XYZGameConstants screenSize].height)
            yDirection = -fabs(yDirection);
        else if(node.position.y <= 0)
            yDirection = fabs(yDirection);
        
        CGFloat xSpeed = xDirection * speed;
        CGFloat ySpeed = yDirection * speed;
        
        CGPoint position = CGPointMake(node.position.x + xSpeed, node.position.y + ySpeed);
        
        [node setPosition:position];
        oldDirections[@"x"] = [NSNumber numberWithFloat:xDirection];
        oldDirections[@"y"] = [NSNumber numberWithFloat:yDirection];
        node.userData = oldDirections;
        
    }];
    
    for(XYZCircle* circle in circles){
        [circle runAction:[SKAction repeatActionForever:moveAroundAction]];
    }
}

- (NSInteger) animationID
{
    return 1;
}

- (NSInteger) minApplicableLevel
{
    return 10;
}

@end
