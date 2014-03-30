//
//  XYZExpandContractAnimation.m
//  Circles
//
//  Created by Harish Murugasamy on 3/16/14.
//  Copyright (c) 2014 Harish Murugasamy. All rights reserved.
//

#import "XYZContractExpandAnimation.h"
#import "XYZGameConstants.h"

@implementation XYZContractExpandAnimation

- (NSInteger) animationID{
    return 2;
}

//- (NSInteger) minApplicableLevel{
//    return 1;
//}

- (void) animate: (NSArray *) circles withSpeed: (CGFloat) speed{
    
    speed = 1;
    
    CGSize screenSize = [XYZGameConstants screenSize];
    CGPoint screenCentre = CGPointMake( screenSize.width/2,  screenSize.height/2);
    CGPoint contractPoint = screenCentre;
    
    NSMutableDictionary* initialPositions = [[NSMutableDictionary alloc] init];
    NSMutableDictionary* initialSpeeds    = [[NSMutableDictionary alloc] init];
    
    for(XYZCircle* circle in circles){
        initialPositions[[NSNumber numberWithInteger: circle.circleID]] = NSStringFromCGPoint(circle.position);
        double dx = contractPoint.x - circle.position.x;
        double dy = contractPoint.y - circle.position.y;
        double speedForCircle = sqrt(dx*dx + dy*dy)/speed;
        initialSpeeds[[NSNumber numberWithInteger: circle.circleID]] = [NSNumber numberWithDouble:speedForCircle];
        NSLog(@"circle %ld has speed : %f", circle.circleID, speedForCircle);
    }
    
    NSString* isContractStarted = @"XYZContractExpandAnimation.isContractStarted";
    NSString* isExpandStared    = @"XYZContractExpandAnimation.isExpandStarted";
    
    //TODO : need to calculate to speed for which each circle moves along a vector, circles with longer distances from centre should have more speed
    SKAction *contractAction = [SKAction customActionWithDuration: speed actionBlock:^(SKNode *node, CGFloat elapsedTime) {
        NSMutableDictionary *oldDirections = node.userData;
        node.userData = oldDirections = oldDirections == NULL ? [[NSMutableDictionary alloc] init]: oldDirections;

        if(oldDirections[isContractStarted] == NULL){
            oldDirections[isContractStarted] = [NSNumber numberWithBool:NO];
        }
        
        if([oldDirections[isContractStarted] boolValue] == NO){
            oldDirections[isContractStarted] = [NSNumber numberWithBool:YES];
            oldDirections[isExpandStared]    = [NSNumber numberWithBool:NO];
            
            XYZCircle *curCircle = (XYZCircle *)node;
            CGPoint origPosition = CGPointFromString([initialPositions objectForKey: [NSNumber numberWithInteger: curCircle.circleID]]);
            
            CGVector contractVector = CGVectorMake(contractPoint.x - origPosition.x, contractPoint.y - origPosition.y);
            
            
            SKAction* moveByVectorAction = [SKAction moveBy:contractVector duration:speed];
            //moveByVectorAction.speed = [initialSpeeds[[NSNumber numberWithInteger: curCircle.circleID]] doubleValue];
            [curCircle runAction: moveByVectorAction];
            //NSLog(@"running contract for circle %ld, elapsed : %f", curCircle.circleID, elapsedTime);
        }
    }];
    
    contractAction.timingMode = SKActionTimingEaseInEaseOut;
    
    SKAction *expandAction = [SKAction customActionWithDuration: speed actionBlock:^(SKNode *node, CGFloat elapsedTime) {
        NSMutableDictionary *oldDirections = node.userData;
        node.userData = oldDirections = oldDirections == NULL ? [[NSMutableDictionary alloc] init]: oldDirections;
        
        if(oldDirections[isExpandStared] == NULL){
            oldDirections[isExpandStared] = [NSNumber numberWithBool:NO];
        }
        
        if([oldDirections[isExpandStared] boolValue] == NO){
            oldDirections[isExpandStared]    = [NSNumber numberWithBool:YES];
            oldDirections[isContractStarted] = [NSNumber numberWithBool:NO];
            
            XYZCircle *curCircle = (XYZCircle *)node;
            CGPoint origPosition = CGPointFromString([initialPositions objectForKey: [NSNumber numberWithInteger: curCircle.circleID]]);
            
            CGVector expandVector = CGVectorMake(origPosition.x - contractPoint.x, origPosition.y - contractPoint.y);
            
            SKAction* moveByVectorAction = [SKAction moveBy:expandVector duration:speed];
            //moveByVectorAction.speed = [initialSpeeds[[NSNumber numberWithInteger: curCircle.circleID]] doubleValue];
            [node runAction: moveByVectorAction];
            //NSLog(@"running expand for circle %ld, elapsed : %f", curCircle.circleID, elapsedTime);
        }
        
    }];
    
    expandAction.timingMode = SKActionTimingEaseInEaseOut;
    
    SKAction *contractExpandAction = [SKAction sequence: @[contractAction, expandAction]];
    
    for(XYZCircle* circle in circles){
        [circle runAction: [SKAction repeatActionForever: contractExpandAction]];
    }
}


@end
