//
//  XYZCircle.m
//  Circles
//
//  Created by Harish Murugasamy on 3/11/14.
//  Copyright (c) 2014 Harish Murugasamy. All rights reserved.
//

#import "XYZCircle.h"

@implementation XYZCircle

@synthesize circleID = _circleID;

- (void) blink
{

    //Code for Blinking the circle when User selects one.
    SKAction *fadeOut = [SKAction fadeOutWithDuration: 1];
    SKAction *fadeIn = [SKAction fadeInWithDuration: 1];
    SKAction *pulse = [SKAction sequence:@[fadeOut,fadeIn]];
    SKAction *pulseThreeTimes = [SKAction repeatAction:pulse count:3];
    [self runAction:pulseThreeTimes];
    
}

- (id) init
{
    
    static NSInteger lastUsedCircleID = 1;
    
    if(self = [super initWithImageNamed:@"oc.png"]){
        
        // TODO : need to verify if this is thread-safe
        @synchronized(self) {
            _circleID = lastUsedCircleID++;
        }
        
        self.position = CGPointMake(0, 0);
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width/2];
        self.physicsBody.dynamic = YES;
        self.physicsBody.allowsRotation = NO;
        self.physicsBody.friction = 0.0f;
        self.physicsBody.linearDamping = 0.0f;
        self.physicsBody.restitution = 1.0f;
        //This property is computation intensive.
        self.physicsBody.usesPreciseCollisionDetection = YES;
    
        // [self setCircleID: _circleID];
        // [self setCircleColor: [SKColor colorWithRed:0 green:0 blue:0.7 alpha:1]];
    }
    
    return self;
}

- (void) setCircleID:(NSInteger)circleID
{
    SKLabelNode* nodeLabel = [[SKLabelNode alloc] init];
    nodeLabel.text = [NSString stringWithFormat:@"%ld",  (long)circleID];
    nodeLabel.fontColor = [SKColor blackColor];
    nodeLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    nodeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    
    [self addChild: nodeLabel];
}

- (void) setCircleColor: (SKColor*) color
{
    self.color = color;
    self.colorBlendFactor = 10;
}

@end
