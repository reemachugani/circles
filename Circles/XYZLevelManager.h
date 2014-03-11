//
//  XYZLevelManager.h
//  Circles
//
//  Created by Harish Murugasamy on 3/11/14.
//  Copyright (c) 2014 Harish Murugasamy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYZMyScene.h"

// Need to make this a singleton class, there should only be one instance of Level Manager
@interface XYZLevelManager : NSObject

@property(readonly) NSInteger currentLevel;
@property(readonly) NSInteger chosenCircleID;
@property(readonly) NSMutableArray* allCircles;
@property(readonly) NSMutableArray* allMovements;
@property(readonly) NSMutableDictionary* minApplicableLevelForMovement;

+ (void) startNextLevel: (XYZMyScene*) scene;
+ (id) instance;

@end
