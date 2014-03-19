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
    //Need to rethink this. The previous code that was here is not required anymore as the physics bodies take care of collisions, new velocities etc. So the only thing that needs to be done is to apply a force/impulse initially.
    for(SKSpriteNode* circle in circles)
    {
        [circle.physicsBody applyImpulse:CGVectorMake(20, 20)];
    }
}

- (NSInteger) animationID
{
    return 1;
}

- (NSInteger) minApplicableLevel
{
    return 3;
}

//TODO: Add method to restrict maximum speed of any circle.

@end
