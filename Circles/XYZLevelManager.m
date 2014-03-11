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

+ (void) startNextLevel: (XYZMyScene*) scene
{
    XYZLevelManager* manager = [XYZLevelManager instance];
    
    for (XYZCircle *circle in manager.allCircles) {
        NSLog(@"adding circle %d", circle.circleID);
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
        _currentLevel = 1;
        _chosenCircleID = -1; // TODO : this may need change
        _allCircles = [NSMutableArray arrayWithArray: @[[[XYZCircle alloc] init], [[XYZCircle alloc] init]]];
        _allMovements = [[NSMutableArray alloc] init];
        _minApplicableLevelForMovement = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}


@end
