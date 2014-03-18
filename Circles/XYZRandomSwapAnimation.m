//
//  XYZRandomSwapAnimation.m
//  Circles
//
//  Created by Harish Murugasamy on 3/15/14.
//  Copyright (c) 2014 Harish Murugasamy. All rights reserved.
//

#import "XYZRandomSwapAnimation.h"
#import "XYZGameConstants.h"

#include <stdlib.h>

@implementation XYZRandomSwapAnimation

- (NSInteger) animationID{
    return 3;
}

- (NSInteger) minApplicableLevel{
    return 10;
}

- (void) animate: (NSArray *) circles withSpeed: (CGFloat) speed
{
    [self arrange: circles withSpeed: speed];
    
}

- (void) another: (NSArray *) circles withSpeed: (CGFloat) speed
{
    NSMutableArray* initialPositions = [[NSMutableArray alloc] init];
    
    for(XYZCircle* circle in circles){
        [initialPositions addObject: NSStringFromCGPoint(circle.position)];
    }
    
    speed = 1/speed;
    
    SKAction *randomSwapAction = [SKAction customActionWithDuration:1 actionBlock:^(SKNode *node, CGFloat elapsedTime) {
        
        if([initialPositions containsObject: NSStringFromCGPoint(node.position)]){
            NSInteger numPositions = initialPositions.count;
            CGPoint nextPosition =  CGPointFromString(initialPositions[arc4random() % numPositions]);
            
            // FIXME : causes problem if there is only 1 circle to move
            while(numPositions > 1 && CGPointEqualToPoint(nextPosition, node.position)){
                nextPosition =  CGPointFromString(initialPositions[arc4random() % numPositions]);
            }
            
            [node runAction: [SKAction moveTo: nextPosition duration: speed]];
        }
        
    }];
    
    for(XYZCircle* circle in circles){
        [circle runAction: [SKAction repeatActionForever:randomSwapAction]];
    }
}

- (void) arrange: (NSArray *) circles withSpeed : (CGFloat) speed
{
    CGSize screenSize = [XYZGameConstants screenSize];
    NSInteger width = [[NSNumber numberWithFloat: screenSize.width] integerValue];
    NSInteger height = [[NSNumber numberWithFloat: screenSize.height] integerValue];
    
    for(XYZCircle* circle in circles){
        CGPoint newPosition = CGPointMake(arc4random() % width,  arc4random() % height);
        [circle runAction: [SKAction moveTo: newPosition duration: 1] completion:^{
            
            @synchronized (self){
                static NSInteger count = 0;
                
                count++;
                //NSLog(@" count = %ld, expected = %lu", (long)count, (unsigned long)circles.count);
                
                if(count == circles.count){
                    count = 0;
                    [self another: circles withSpeed: speed];
                }
            }
            
        }];
    }
    
}

@end
