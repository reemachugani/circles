//
//  XYZLevelManager.m
//  Circles
//
//  Created by Harish Murugasamy on 3/11/14.
//  Copyright (c) 2014 Harish Murugasamy. All rights reserved.
//

#import "XYZLevelManager.h"
#import "XYZMyScene.h"
#import "XYZCircle.h"
#import "XYZAnimation.h"
#import "XYZBounceAnimation.h"
#import "XYZGameConstants.h"

@implementation XYZLevelManager

static NSInteger currentLevel;
static NSInteger chosenCircleID;
static NSMutableArray* allCircles;
static NSMutableArray* allMovements;
static NSMutableDictionary* minApplicableLevelForMovement;

+ (NSInteger) currentLevel{
    return currentLevel;
}

+ (NSInteger) chosenCircleID{
    return chosenCircleID;
}

// initialize all the static variables
+ (void) initialize
{
    static BOOL isInitialized = false;
    
    // the static variables will be initialized only once by the first thread that executes this method
    @synchronized (self) {
        
        if(isInitialized)
            return;
        
        isInitialized = true;
        currentLevel = 0;
        chosenCircleID = -1; // TODO : this may need change
        allCircles = [NSMutableArray arrayWithArray: @[[[XYZCircle alloc] init], [[XYZCircle alloc] init]]];
        allMovements = [[NSMutableArray alloc] init];
        minApplicableLevelForMovement = [[NSMutableDictionary alloc] init];
    }
    
}

// method to procede to a new level, it adds a new circle to the scene and applies animation when called
+ (void) startNextLevel: (XYZMyScene*) scene
{
    [XYZLevelManager incrementLevel];
    NSLog(@"at level %ld", (long)currentLevel);
    
    [XYZLevelManager prepareNextLevel:scene];
    
    // choose animations applicable for currentLevel
    
    // choose which animation to apply to a circle
    
    // the animations should be chosen in random
    [XYZLevelManager applyAnimations];
}

/** HELPER METHODS **/

+ (void) applyAnimations
{
    id <XYZAnimation> animation = [[XYZBounceAnimation alloc] init];
    [animation animate:allCircles withSpeed:1];
}

+ (void) prepareNextLevel: (XYZMyScene*) scene
{
    
    if(currentLevel == 1){
        [XYZLevelManager startFirstLevel: scene];
    }else{
        
        XYZCircle* circle = [[XYZCircle alloc] init];
        circle.position = CGPointMake(0, 0);
        
        NSLog(@"adding circle %ld", (long)circle.circleID);
        [scene addChild: circle];
        [allCircles addObject:circle];
    }
    
    [XYZLevelManager clearAllAnimations];
    
}

// remove all animations from each of the circle in the scene
+ (void) clearAllAnimations{
    
    for (XYZCircle *circle in allCircles) {
        [circle removeAllActions];
    }
}

// wrapper to increase game level
+ (void) incrementLevel{
    currentLevel = currentLevel + 1;
}

// initializes the first level in the scene
+ (void) startFirstLevel: (XYZMyScene*) scene
{
    CGSize screenSize = [XYZGameConstants screenSize];
    
    for (XYZCircle *circle in allCircles) {
        
        // just for display purposes
        CGFloat width = (screenSize.width/2) + (circle.circleID % 2 == 0 ? -50 : 50);
        CGFloat height = (screenSize.height/2);
        circle.position = CGPointMake(width, height);
        
        NSLog(@"adding circle %ld", (long)circle.circleID);
        [scene addChild: circle];
    }
}

@end
