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
#import "XYZSwapAnimation.h"
#import "XYZContractExpandAnimation.h"
#import "XYZCircularAnimation.h"

@implementation XYZAnimationContainer

static NSMutableDictionary* allAnimations;

+ (NSDictionary *) getAllAnimations
{
    if(allAnimations == NULL)
        [XYZAnimationContainer loadAllAnimations];
    
    NSLog(@"all Animations : %@", allAnimations);
    
    return allAnimations;
}

+ (void) loadAllAnimations
{
    allAnimations = [[NSMutableDictionary alloc] init];
    
    // can just keep adding new animations as and when they are available
    [XYZAnimationContainer loadAnimation:[[XYZBounceAnimation alloc] init]];
    [XYZAnimationContainer loadAnimation:[[XYZSwapAnimation alloc] init]];
    [XYZAnimationContainer loadAnimation:[[XYZContractExpandAnimation alloc] init]];
    [XYZAnimationContainer loadAnimation:[[XYZCircularAnimation alloc] init]];
    
}

+ (void) loadAnimation: (id<XYZAnimation>) animation
{
    [allAnimations setObject: animation forKey: [NSNumber numberWithInteger: [animation animationID]]];
}

@end
