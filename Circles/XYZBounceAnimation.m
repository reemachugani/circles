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

- (void) animate: (NSArray *) circles withSpeed: (CGFloat) speed
{

    speed = 1/speed;
    
    NSString* xkeyName = @"XYZBounceAnimation.x";
    NSString* ykeyName = @"XYZBounceAnimation.y";
    
    SKAction *moveAroundAction = [SKAction customActionWithDuration:1 actionBlock:^(SKNode *node, CGFloat elapsedTime) {
        
        NSMutableDictionary *oldDirections = node.userData;
        node.userData = oldDirections = oldDirections == NULL ? [[NSMutableDictionary alloc] init] : oldDirections;
        
        if(oldDirections[xkeyName] == NULL){
            oldDirections[xkeyName] = [NSNumber numberWithFloat:1];
            oldDirections[ykeyName] = [NSNumber numberWithFloat:1];
        }
        
        CGFloat xDirection = [oldDirections[xkeyName] floatValue];
        CGFloat yDirection = [oldDirections[ykeyName] floatValue];
        
        
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
        oldDirections[xkeyName] = [NSNumber numberWithFloat:xDirection];
        oldDirections[ykeyName] = [NSNumber numberWithFloat:yDirection];
        
    }];
    
    for(XYZCircle* circle in circles){
        [circle runAction:[SKAction repeatActionForever:moveAroundAction]];
    //Need to rethink this. The previous code that was here is not required anymore as the physics bodies take care of collisions, new velocities etc. So the only thing that needs to be done is to apply a force/impulse initially.
    //for(SKSpriteNode* circle in circles)
    //{
        //[circle.physicsBody applyImpulse:CGVectorMake(20, 20)];
    }
}

- (NSInteger) animationID
{
    return 1;
}

//- (NSInteger) minApplicableLevel
//{
//    return 1;
//}

//TODO: Add method to restrict maximum speed of any circle.

@end
