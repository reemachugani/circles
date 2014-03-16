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

- (id) init
{
    
    static NSInteger lastUsedCircleID = 1;
    
    if(self = [super initWithImageNamed:@"WhiteCircleMed.png"]){
        
        // TODO : need to verify if this is thread-safe
        @synchronized(self) {
            _circleID = lastUsedCircleID++;
        }
    }
    
    //[self setCircleID: _circleID];
    [self setCircleColor: [SKColor colorWithRed:0 green:0 blue:0.7 alpha:1]];
    
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
