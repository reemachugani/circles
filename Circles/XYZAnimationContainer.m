//
//  XYZAnimationContainer.m
//  Circles
//
//  Created by Harish Murugasamy on 3/15/14.
//  Copyright (c) 2014 Harish Murugasamy. All rights reserved.
//

#import "XYZAnimationContainer.h"
#import "XYZAnimation.h"
#import "XYZBounceAnimation.h"
#import "XYZBounceAnimation2.h"

@implementation XYZAnimationContainer

static NSMutableDictionary* allAnimations;
static NSMutableDictionary* minApplicableLevels;

+ (NSDictionary *) getAllAnimations
{
    if(allAnimations == NULL)
        [XYZAnimationContainer loadAllAnimations];
    
    NSLog(@"all Animations : %@", allAnimations);
    
    return allAnimations;
}

+ (NSDictionary *) getMinApplicableLevels
{
    if(allAnimations == NULL)
        [XYZAnimationContainer loadAllAnimations];
    
     NSLog(@"minApplicableLevels : %@", minApplicableLevels);
    
    return minApplicableLevels;
}

+ (void) loadAllAnimations
{
    allAnimations = [[NSMutableDictionary alloc] init];
    minApplicableLevels = [[NSMutableDictionary alloc] init];
    
    // can just keep adding new animations as and when they are available
    [XYZAnimationContainer loadAnimation:[[XYZBounceAnimation alloc] init]];
    [XYZAnimationContainer loadAnimation:[[XYZBounceAnimation2 alloc] init]];
}

+ (void) loadAnimation: (id<XYZAnimation>) animation
{
    [allAnimations setObject: animation forKey: [NSNumber numberWithInteger: [animation animationID]]];
    
    // add current animation to minApplicableLevels
    NSNumber* minAppLevel = [NSNumber numberWithInteger: [animation minApplicableLevel]];
    NSMutableArray* existingAnimationsForLevel = [minApplicableLevels objectForKey: minAppLevel];
    
    if(existingAnimationsForLevel == NULL)
        existingAnimationsForLevel = [[NSMutableArray alloc] init];
    
    [existingAnimationsForLevel addObject: animation];
    
    [minApplicableLevels setObject: existingAnimationsForLevel forKey: minAppLevel];
}

@end
