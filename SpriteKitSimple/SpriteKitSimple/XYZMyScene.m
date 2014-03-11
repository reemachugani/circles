//
//  XYZMyScene.m
//  SpriteKitSimple
//
//  Created by Harish Murugasamy on 3/7/14.
//  Copyright (c) 2014 Harish Murugasamy. All rights reserved.
//

#import "XYZMyScene.h"
#include <time.h>
#include <stdlib.h>

#define ARC4RANDOM_MAX      0x100000000

@interface XYZMyScene()
@property CGSize screenSize;
@end

@implementation XYZMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.screenSize = size;
        self.backgroundColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:1.0];
        /*
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Hello, World!";
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:myLabel];
        */
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"BlueCircle"];
        
        sprite.position = location;
        
        
        SKAction *moveAroundAction = [SKAction customActionWithDuration:1 actionBlock:^(SKNode *node, CGFloat elapsedTime) {
            
            NSMutableDictionary *oldDirections = node.userData;
            oldDirections = oldDirections == NULL ? [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                     [NSNumber numberWithInt:1], @"x",
                                                     [NSNumber numberWithInt:1], @"y",
                                                     nil] : oldDirections;
            
            CGFloat xDirection = [oldDirections[@"x"] intValue];
            CGFloat yDirection = [oldDirections[@"y"] intValue];
            CGFloat speed = 10;
            
            
            if(node.position.x >= self.screenSize.width)
                xDirection = -fabs(xDirection);
            else if(node.position.x <= 0)
                xDirection = fabs(xDirection);
            
            if(node.position.y >= self.screenSize.height)
                yDirection = -fabs(yDirection);
            else if(node.position.y <= 0)
                yDirection = fabs(yDirection);
            
            CGFloat xDisp = ((CGFloat)arc4random() / ARC4RANDOM_MAX);
            CGFloat yDisp = ((CGFloat)arc4random() / ARC4RANDOM_MAX);
            
            CGFloat xSpeed = xDirection * speed + xDisp;
            CGFloat ySpeed = yDirection * speed + yDisp;
            
            CGPoint position = CGPointMake(node.position.x + xSpeed, node.position.y + ySpeed);
            
            [node setPosition:position];
            oldDirections[@"x"] = [NSNumber numberWithFloat:xDirection];
            oldDirections[@"y"] = [NSNumber numberWithFloat:yDirection];
            node.userData = oldDirections;
            
        }];
        
        [sprite runAction:[SKAction repeatActionForever:moveAroundAction]];
        
        [self addChild:sprite];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
