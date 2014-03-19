//
//  XYZLevelManager.m
//  Circles
//
//  Created by Harish Murugasamy on 3/11/14.
//  Copyright (c) 2014 Harish Murugasamy. All rights reserved.
//

#include <stdlib.h>

#import "XYZLevelManager.h"
#import "XYZMyScene.h"
#import "XYZCircle.h"
#import "XYZAnimation.h"
#import "XYZAnimationContainer.h"
#import "XYZGameConstants.h"

@implementation XYZLevelManager

static NSNumber* currentLevel;
static NSNumber* chosenCircleID;
static NSMutableDictionary* allCircles;
static NSDictionary* allAnimations;
static NSDictionary* animationsApplicableForLevel;
static NSMutableArray* existingAnimationsForCurLevel;

+ (NSInteger) currentLevel{
    return [currentLevel integerValue];
}

+ (NSInteger) chosenCircleID{
    return [chosenCircleID integerValue];
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
        currentLevel = @(0);
        chosenCircleID = @(-1); // TODO : this may need change
        allCircles = [[NSMutableDictionary alloc] init];
        allAnimations = [XYZAnimationContainer getAllAnimations];
        animationsApplicableForLevel = [XYZAnimationContainer getMinApplicableLevels];
        existingAnimationsForCurLevel = [[NSMutableArray alloc] init];
    }
}

//method to set gravity, speed and physics for scene.
+ (void) setupPhysicsForLevel:(XYZMyScene *)scene
{
    scene.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:scene.frame];
    //No gravity
    scene.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
    scene.physicsWorld.speed = [XYZGameConstants physicsSpeed];
    //The scene is the delegate to be notified when two physics bodies collide
    scene.physicsWorld.contactDelegate = scene;
    scene.physicsBody.categoryBitMask = [[XYZGameConstants getBitMaskForCategory:@"wall"] unsignedIntValue];
}

// method to procede to a new level, it adds a new circle to the scene and applies animation when called
+ (void) startNextLevel: (XYZMyScene*) scene
{
    [XYZLevelManager incrementLevel];
    NSLog(@"at level %@", currentLevel);
    
    [XYZLevelManager prepareNextLevel:scene];
    
    // choose animations applicable for currentLevel
    NSArray* animationsForCurrentLevel = [XYZLevelManager getAnimationsForCurrentLevel];
    
    // choose a random subset of animations to apply to allCircles
    NSArray* chosenAnimations = [XYZLevelManager getRandomAnimationsFrom: animationsForCurrentLevel];
    
    // choose which animation to apply to a circle
    NSDictionary* animationToCircles = [XYZLevelManager distributeCircles: allCircles.allValues toAnimations: chosenAnimations];
    
    // apply animations
    [XYZLevelManager applyAnimations:animationToCircles];
}

/** HELPER METHODS **/

// wrapper to increase game level
+ (void) incrementLevel{
    currentLevel = @([currentLevel integerValue] + 1);
}

// add a new circle to the scene, and clears all animations running in existing circles
+ (void) prepareNextLevel: (XYZMyScene*) scene
{
    
    // if it is the first level, display the circles in the centre of the screen
    if([currentLevel isEqual: @(1)]){
        [XYZLevelManager startFirstLevel: scene];
    }else{
        [XYZLevelManager createCircles: 1 andAddTo: scene];
    }
    
    [XYZLevelManager clearAllAnimations];
    
}

+ (NSMutableArray* ) getAnimationsForCurrentLevel
{
    // add any new animations that are applicable for currentLevel
    [existingAnimationsForCurLevel addObjectsFromArray: [animationsApplicableForLevel objectForKey: currentLevel]];
    
    return existingAnimationsForCurLevel;
}

// get a random subset of animations from all those animations applicable for currentLevel
+ (NSMutableArray* ) getRandomAnimationsFrom: (NSArray *) animationsForCurrentLevel
{
    NSInteger numAnimationsRequired = 5;
    NSInteger numAnimationsForCurrentLevel = [animationsForCurrentLevel count];
    
    numAnimationsRequired = numAnimationsForCurrentLevel < numAnimationsRequired ? numAnimationsForCurrentLevel : numAnimationsRequired;
    
    NSMutableArray* randomAnimations = [[NSMutableArray alloc] initWithCapacity: numAnimationsRequired];
    
    for(NSInteger i = 0; i < numAnimationsRequired; i++){
        [randomAnimations addObject: animationsForCurrentLevel[arc4random() % numAnimationsForCurrentLevel]];
    }
    
    return randomAnimations;
    
}

+ (NSMutableDictionary* ) distributeCircles: (NSArray *) circles toAnimations: (NSArray *) animations
{
    NSInteger numAnimations = [animations count] ;
    NSMutableDictionary* animationToCircles = [[NSMutableDictionary alloc] initWithCapacity: numAnimations];
    
    // TODO : equal distribution or random?
    for( XYZCircle* circle in circles){
        
        NSNumber *animationID = [NSNumber numberWithInteger: [animations[arc4random() % numAnimations] animationID]];
        NSMutableArray* existingCircles = [animationToCircles objectForKey: animationID];
        
        if(existingCircles == NULL){
            existingCircles = [[NSMutableArray alloc] init];
        }
        
        NSLog(@" circle %ld has animation : %@", (long) circle.circleID, animationID);
        
        //Setting contact and collision masks
        circle.physicsBody.categoryBitMask = [[XYZGameConstants getBitMaskForCategory:[animationID stringValue]] unsignedIntValue];
        circle.physicsBody.contactTestBitMask = 0;
        circle.physicsBody.collisionBitMask = [[XYZGameConstants getBitMaskForCategory:[animationID stringValue]] unsignedIntValue]|[[XYZGameConstants getBitMaskForCategory:@"wall"] unsignedIntValue];
        [existingCircles addObject: circle];
        [animationToCircles setObject: existingCircles forKey: animationID];
    }
    
    return animationToCircles;
    
}

+ (void) applyAnimations: (NSDictionary *) animationToCircles
{
    for(NSNumber *animationID in animationToCircles.allKeys){
        id <XYZAnimation> animation  = [allAnimations objectForKey: animationID];
        NSMutableArray* circles = [animationToCircles objectForKey:animationID];
        [animation animate:circles withSpeed:1];
    }
    
}

// remove all animations from each of the circle in the scene
+ (void) clearAllAnimations
{
    for (XYZCircle *circle in allCircles.allValues) {
        [circle removeAllActions];
    }
}

// initializes the first level in the scene
// creates 2 circles and sets their position to centre of the screen
+ (void) startFirstLevel: (XYZMyScene*) scene
{
    [XYZLevelManager createCircles:2 andAddTo: scene];
 
    CGSize screenSize = [XYZGameConstants screenSize];
    for (XYZCircle *circle in allCircles.allValues) {
        
        // just for display purposes
        CGFloat width = (screenSize.width/2) + (circle.circleID % 2 == 0 ? -50 : 50);
        CGFloat height = (screenSize.height/2);
        circle.position = CGPointMake(width, height);
    }
}

// creates given number of circles, assigns physics bodies to them and adds the circles to scene
+ (void) createCircles: (NSInteger) count andAddTo: (XYZMyScene *) scene
{
    for(NSInteger i = 0; i < count; i++){
        XYZCircle* circle = [[XYZCircle alloc] init];
        circle.position = CGPointMake(0, 0);
        circle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(circle.size.width, circle.size.height)];
        circle.physicsBody.dynamic = YES;
        circle.physicsBody.allowsRotation = NO;
        circle.physicsBody.friction = 0.0f;
        circle.physicsBody.linearDamping = 0.0f;
        circle.physicsBody.restitution = 1.0f;
        //This property is computation intensive.
        circle.physicsBody.usesPreciseCollisionDetection = YES;
        NSLog(@"adding circle %ld", (long)circle.circleID);
        [allCircles setObject:circle forKey: [NSNumber numberWithInteger: circle.circleID]];
        [scene addChild: circle];
    }
}

@end
