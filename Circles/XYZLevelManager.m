
#include <stdlib.h>

#import "XYZLevelManager.h"
#import "XYZCircle.h"
#import "XYZAnimation.h"
#import "XYZAnimationContainer.h"
#import "XYZGameConstants.h"
#import "XYZTemplateManager.h"
#import "XYZShapeFactory.h"

@implementation XYZLevelManager

static SKScene* currentScene;
static NSNumber* currentLevel;
static NSNumber* currentSet;
static NSNumber* chosenCircleID;
static NSMutableDictionary* allCircles;
static NSDictionary* allAnimations;
static NSDictionary* allTemplates;
static NSDictionary* templatesBySet;
static NSArray* templatesApplicableForCurrentSet;
static NSMutableDictionary* currentTemplateShapeCircleData;
static XYZLevelManager* instance;

- (id) initSingleton
{
    if(instance == NULL){
        return [super init];
    }
    
    return instance;
}

- (void) clearAllAnimations
{
    [XYZLevelManager clearAllAnimations];
    [XYZLevelManager printNodeLocations];
}

- (void) notify
{
    [XYZLevelManager startCircleAnimations];
}

+ (NSInteger) currentLevel{
    return [currentLevel integerValue];
}

+ (NSInteger) chosenCircleID{
    return [chosenCircleID integerValue];
}

// initialize all the static variables
+ (void) initializeOnScene:(SKScene *)scene
{
    static BOOL isInitialized = false;
    
    // the static variables will be initialized only once by the first thread that executes this method
    @synchronized (self) {
        
        if(isInitialized)
            return;
        
        isInitialized = true;
        currentScene = scene;
        currentSet = @(0);
        currentLevel = @(0);
        chosenCircleID = @(-1); // TODO : this may need change
        allCircles = [[NSMutableDictionary alloc] init];
        allAnimations = [XYZAnimationContainer getAllAnimations];
        
        allTemplates = [XYZTemplateManager loadAllTemplateData];
        templatesBySet = [XYZTemplateManager getTemplatesBySet];
        instance = [[XYZLevelManager alloc] initSingleton];
        
        [XYZLevelManager startNextLevel];
    }
}

+ (void) touchMadeAt:(CGPoint)location
{
    CGPoint locationWithCorrection = location;
    locationWithCorrection.y = [XYZGameConstants screenSize].height - location.y;
    
    SKNode *touchedNode = [currentScene nodeAtPoint: locationWithCorrection];
    XYZCircle *chosenCircle = [allCircles objectForKey:chosenCircleID];
    
    NSLog(@"point x = %f, y = %f. chosenCircleAread = %@", locationWithCorrection.x, locationWithCorrection.y, NSStringFromCGRect([chosenCircle calculateAccumulatedFrame]));
    
    if([touchedNode class] == [XYZCircle class]){
        XYZCircle* touchedCircle = (XYZCircle*) touchedNode;
        NSLog(@"node ID : %ld, chosenCircleID : %@", touchedCircle.circleID, chosenCircleID);
        
        if(touchedCircle.circleID == [chosenCircleID integerValue]){
            [XYZLevelManager startNextLevel];
        }else{
            [XYZLevelManager removeCircle: touchedCircle];
        }
    }

}

// method to procede to a new level.
+ (void) startNextLevel
{
    
    [XYZLevelManager incrementLevel];
    NSLog(@"at level %@", currentLevel);
    
    //Current Set is incremented every 5 levels (At level 1,6,11...)
    if([currentLevel integerValue]%5 == 1)
    {
        currentSet = @([currentSet integerValue]+1);
        [XYZLevelManager prepareNextSet];
    }
    
    [XYZLevelManager prepareNextLevel];
    
    NSInteger numberOfEligibleTemplates = [templatesApplicableForCurrentSet count];
    NSLog(@"SET: %d, LEVEL: %d, ELIGIBLE TEMPLATES: %ld",[currentSet intValue],[currentLevel intValue],numberOfEligibleTemplates);
    
    // Choose a random template to use for the current Level
    // Load the template, move circles to new positions & return shape, circle & animation info
    currentTemplateShapeCircleData = [XYZTemplateManager loadTemplate:templatesApplicableForCurrentSet[arc4random()%numberOfEligibleTemplates] withCircles:allCircles.allValues];
    
    // register as an observer to be notified when ShapeFactory finishes moving the circles to their initial positions
    [XYZShapeFactory addObserver:instance];
}

/** HELPER METHODS **/

// wrapper to increase game level
+ (void) incrementLevel
{
    if([currentLevel intValue] == 0)
    {
        [XYZLevelManager createCircles:1];
    }
    currentLevel = @(([currentLevel integerValue])+1);
}

+ (void) prepareNextLevel
{
    [XYZLevelManager clearAllAnimations];
}

// add a new circle to the scene, and clears all animations running in existing circles
+ (void) prepareNextSet
{
    //Get templates eligible for the this set (5 levels)
    templatesApplicableForCurrentSet = [XYZTemplateManager getTemplatesForCurrentSet:currentSet];
    //Add a circle every set
    [XYZLevelManager createCircles: 1];
}

+ (NSMutableDictionary* ) distributeCircles: (NSArray *) circles toAnimations: (NSDictionary *) allAnimations usingTemplate: (NSDictionary*) currentTemplateShapeCircleData
{
    NSInteger numAnimations = [allAnimations count] ;
    NSMutableDictionary* animationToCircles = [[NSMutableDictionary alloc] initWithCapacity: numAnimations];
    
    //NSMutableDictionary* shapesInTemplate = [NSDictionary dictionaryWithDictionary:currentTemplatNSe[@"shapes"]];
    
    for(id shape in currentTemplateShapeCircleData)
    {
        NSDictionary* currentShape = [currentTemplateShapeCircleData objectForKey:shape];
        NSArray* eligibileAnimations = [NSArray arrayWithArray: [currentShape objectForKey:@"animations"]];
        NSNumber *animationID = eligibileAnimations[arc4random() % [eligibileAnimations count]];
        NSArray* circlesInShape = [NSArray arrayWithArray:currentShape[@"nodes"]];

        for(XYZCircle* circle in circlesInShape)
        {
            NSMutableArray* existingCircles = [animationToCircles objectForKey: animationID];
            if(existingCircles == NULL){
                existingCircles = [[NSMutableArray alloc] init];
            }
            NSLog(@" circle %ld has animation : %@", (long) circle.circleID, animationID);
            [existingCircles addObject: circle];
            [animationToCircles setObject: existingCircles forKey: animationID];
        }
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

+ (void) highlightCircle
{
    NSInteger numCircles = [allCircles count];
    NSArray* allKeys = allCircles.allKeys;
    chosenCircleID = [allKeys objectAtIndex:arc4random() % numCircles];  // dependant on the starting value of _circleID
    
    XYZCircle* chosenCircleToBlink = [allCircles objectForKey: chosenCircleID];
    
    [chosenCircleToBlink blink];
}

// remove all animations from each of the circle in the scene
+ (void) clearAllAnimations
{
    for (XYZCircle *circle in allCircles.allValues) {
        [circle removeAllActions];
        circle.userData = NULL;
    }
}

// creates given number of circles
+ (void) createCircles: (NSInteger) count
{
    for(NSInteger i = 0; i < count; i++){
        XYZCircle* circle = [[XYZCircle alloc] init];
        
        NSLog(@"adding circle %ld", (long)circle.circleID);
        [allCircles setObject:circle forKey: [NSNumber numberWithInteger: circle.circleID]];
        [currentScene addChild: circle];
    }
}

+ (void) printNodeLocations
{
    for (XYZCircle* circle in allCircles.allValues) {
        NSLog(@"circle %ld at location x = %f, y = %f", (long)circle.circleID, circle.position.x, circle.position.y);
    }
}

+ (void) removeCircle: (XYZCircle*) circle
{
    
    [circle removeFromParent];
    [allCircles removeObjectForKey:[NSNumber numberWithInteger:circle.circleID]];
    
    NSString *burstPath = [[NSBundle mainBundle] pathForResource:@"BurstParticle" ofType:@"sks"];
    SKEmitterNode* burstNode = [NSKeyedUnarchiver unarchiveObjectWithFile:burstPath];
    burstNode.position = circle.position;
    
    [currentScene addChild:burstNode];

}

// distribute animations and apply those animations to the circles
//TODO : maybe rename to a more appropriate function name ?
+ (void) startCircleAnimations
{
    NSLog(@"running startAction");
    
    // Choose animations to apply to shapes in the template
    NSDictionary* animationToCircles = [XYZLevelManager distributeCircles:allCircles.allValues toAnimations:allAnimations usingTemplate:currentTemplateShapeCircleData];
    
    // Apply animations
    [XYZLevelManager applyAnimations:animationToCircles];
    
    // hightlight a circle to the user
    [XYZLevelManager highlightCircle];
    
    [instance performSelector:@selector(clearAllAnimations) withObject:nil afterDelay:11];
}


@end
