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



@implementation XYZLevelManager

// since the properties were declared as readonly in the interface, we cannot directly set the values
// we need some way to set them from within the implementation and this provides it
// setting _currentLevel would set currentLevel
@synthesize currentLevel = _currentLevel;
@synthesize chosenCircleID = _chosenCircleID;
@synthesize allCircles  = _allCircles;
@synthesize allMovements = _allMovements;
@synthesize minApplicableLevelForMovement = _minApplicableLevelForMovement;

// always returns the same instance (singleton)
+ (id) instance
{
    static XYZLevelManager *instance = nil;
    
    @synchronized(self) {
        if (instance == nil)
            instance = [[self alloc] init];
    }
    
    return instance;
}

// method to procede to a new level, it adds a new circle to the scene and applies animation when called
+ (void) startNextLevel: (XYZMyScene*) scene
{
    XYZLevelManager* manager = [XYZLevelManager instance];
    [manager incrementLevel];
    
    NSLog(@"at level %ld", (long)manager.currentLevel);
    
    if(manager.currentLevel == 1){
        [manager startFirstLevel: scene];
    }else{
        
        XYZCircle* circle = [[XYZCircle alloc] init];
        circle.position = CGPointMake(circle.circleID * 10, 250);
        
        NSLog(@"adding circle %ld", (long)circle.circleID);
        [scene addChild: circle];
        [manager.allCircles addObject:circle];
    }
    
    [manager clearAllAnimations];
    
    // the animations should be chosen in random
    id <XYZAnimation> animation = [[XYZBounceAnimation alloc] init];
    [animation animate:manager.allCircles withSpeed:1];
}

// remove all animations from each of the circle in the scene
- (void) clearAllAnimations{
    XYZLevelManager* manager = [XYZLevelManager instance];
    
    for (XYZCircle *circle in manager.allCircles) {
        [circle removeAllActions];
    }
}

// wrapper to increase game level
- (void) incrementLevel{
    _currentLevel = _currentLevel + 1;
}

// initializes the first level in the scene
- (void) startFirstLevel: (XYZMyScene*) scene
{
    XYZLevelManager* manager = [XYZLevelManager instance];
    
    for (XYZCircle *circle in manager.allCircles) {
        NSLog(@"adding circle %ld", (long)circle.circleID);
        [scene addChild: circle];
        
        // just for display purposes
        circle.position = CGPointMake(circle.circleID * 100, 250);
    }
}

// constructor
- (id) init
{
    
    // get a new instance from super class and configure initial values
    if (self = [super init]) {
        _currentLevel = 0;
        _chosenCircleID = -1; // TODO : this may need change
        _allCircles = [NSMutableArray arrayWithArray: @[[[XYZCircle alloc] init], [[XYZCircle alloc] init]]];
        _allMovements = [[NSMutableArray alloc] init];
        _minApplicableLevelForMovement = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}


@end
