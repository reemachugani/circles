//
//  XYZMyScene.m
//  Circles
//
//  Created by Harish Murugasamy on 3/11/14.
//  Copyright (c) 2014 Harish Murugasamy. All rights reserved.
//

#import "XYZMyScene.h"
#import "XYZLevelManager.h"

@interface XYZMyScene ()
@property XYZLevelManager* manager;
@end

@implementation XYZMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:1.0];
        self.manager = [XYZLevelManager instance];
        
        [XYZLevelManager startNextLevel:self];
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
