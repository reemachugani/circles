//
//  XYZMyScene.m
//  Circles
//
//  Created by Harish Murugasamy on 3/11/14.
//  Copyright (c) 2014 Harish Murugasamy. All rights reserved.
//

#import "XYZMyScene.h"
#import "XYZLevelManager.h"
#import "XYZGameConstants.h"

@interface XYZMyScene ()
@property XYZLevelManager* manager;
@end

@implementation XYZMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.953 green:0.953 blue:0.9375 alpha:1.0];
        
        [XYZGameConstants initWithConstants:@{
                    @"screenSize" : [NSValue valueWithCGSize:size],
                    @"circleTexture" : [SKTexture textureWithImageNamed: @"BlueCircle.png"]
        }];
        
        NSLog(@"screen Size : width = %f, height = %f", size.width, size.height);
        
        [XYZLevelManager initialize];        
        [XYZLevelManager startNextLevel:self];
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [XYZLevelManager startNextLevel:self];
    
//    Code for Blinking the circle when User selects one.
//    SKAction *fadeOut = [SKAction fadeOutWithDuration: 1];
//    SKAction *fadeIn = [SKAction fadeInWithDuration: 1];
//    SKAction *pulse = [SKAction sequence:@[fadeOut,fadeIn]];
//    SKAction *pulseThreeTimes = [SKAction repeatAction:pulse count:3];
//    SKAction *pulseForever = [SKAction repeatActionForever:pulse];
//    [circle runAction:pulseThreeTimes];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
