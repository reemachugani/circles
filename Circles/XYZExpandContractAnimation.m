//
//  XYZExpandContractAnimation.m
//  Circles
//
//  Created by Harish Murugasamy on 3/16/14.
//  Copyright (c) 2014 Harish Murugasamy. All rights reserved.
//

#import "XYZExpandContractAnimation.h"
#import "XYZGameConstants.h"

@implementation XYZExpandContractAnimation

- (NSInteger) animationID{
    return 2;
}

- (NSInteger) minApplicableLevel{
    return 10;
}

- (void) animate: (NSArray *) circles withSpeed: (NSInteger) speed{
    
    NSMutableDictionary* initialPositions = [[NSMutableDictionary alloc] init];
    
    for(XYZCircle* circle in circles){
        [initialPositions setObject: NSStringFromCGPoint(circle.position) forKey: [NSNumber numberWithInteger: circle.circleID]];
    }
    
    CGSize screenSize = [XYZGameConstants screenSize];
    CGPoint screenCentre = CGPointMake( screenSize.width/2,  screenSize.height/2);
    //speed = 0.1;
    
    SKAction *contractAction = [SKAction customActionWithDuration: speed actionBlock:^(SKNode *node, CGFloat elapsedTime) {
        XYZCircle *curCircle = (XYZCircle *)node;
        CGPoint origPosition = CGPointFromString([initialPositions objectForKey: [NSNumber numberWithInteger: curCircle.circleID]]);
        
        if(CGPointEqualToPoint(curCircle.position, origPosition)){
            [curCircle runAction: [SKAction moveTo: screenCentre duration: speed]];
            //NSLog(@"running contract for circle %ld, elapsed : %f", curCircle.circleID, elapsedTime);
        }
    }];
    
    contractAction.timingMode = SKActionTimingEaseInEaseOut;
    
    SKAction *expandAction = [SKAction customActionWithDuration: speed actionBlock:^(SKNode *node, CGFloat elapsedTime) {
        
        if(CGPointEqualToPoint(node.position, screenCentre)){
            XYZCircle *curCircle = (XYZCircle *)node;
            CGPoint origPosition = CGPointFromString([initialPositions objectForKey: [NSNumber numberWithInteger: curCircle.circleID]]);
            [node runAction: [SKAction moveTo: origPosition duration: speed]];
            //NSLog(@"running expand for circle %ld, elapsed : %f", curCircle.circleID, elapsedTime);
        }
        
    }];
    
    expandAction.timingMode = SKActionTimingEaseInEaseOut;
    
    SKAction *expandContractAction = [SKAction sequence: @[contractAction, expandAction]];
    
    for(XYZCircle* circle in circles){
        [circle runAction: [SKAction repeatActionForever: expandContractAction]];
    }
}


@end
