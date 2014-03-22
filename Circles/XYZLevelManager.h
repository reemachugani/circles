//
//  XYZLevelManager.h
//  Circles
//
//  Created by Harish Murugasamy on 3/11/14.
//  Copyright (c) 2014 Harish Murugasamy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

// Need to make this a singleton class, there should only be one instance of Level Manager
@interface XYZLevelManager : NSObject

+ (NSInteger) currentLevel;
+ (NSInteger) chosenCircleID;

+ (void) initializeOnScene: (SKScene*) scene;
+ (void) touchMadeAt: (CGPoint) location;

// this prevents initialization
- (id) init __unavailable;

@end
