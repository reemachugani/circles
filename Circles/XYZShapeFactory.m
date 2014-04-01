#import "XYZCircle.h"
#import "XYZGameConstants.h"
#import "XYZShapeFactory.h"

@implementation XYZShapeFactory

static NSMutableSet* observers;

//Generate Line
+ (void) generateHorizontalLine: (id) shapeInfo
{
    CGSize screenSize = [XYZGameConstants screenSize];
    CGFloat lineWidth = [shapeInfo[@"size"] floatValue]*screenSize.width;
    CGFloat startingX = (screenSize.width - lineWidth)/2;
    CGFloat startingY = screenSize.height/2;
    NSInteger numNodes = [shapeInfo[@"nodes"] count];
    NSInteger spacing = lineWidth/(numNodes-1);
    
    // dictionary with circleID as key and its position in template as the value
    NSMutableDictionary* positionsOnScreen = [[NSMutableDictionary alloc] init];
    NSArray* circlesForCurrentShape = shapeInfo[@"nodes"];
    
    NSInteger count = 1;
    for(XYZCircle* circle in circlesForCurrentShape)
    {
        CGPoint startingPosition = CGPointMake(startingX+(count*spacing - spacing), startingY);
        positionsOnScreen[[NSNumber numberWithInteger:circle.circleID]] = NSStringFromCGPoint(startingPosition);
        
        count++;
    }
    
    [XYZShapeFactory moveCircles: circlesForCurrentShape toPositions: positionsOnScreen];
    NSLog(@"Generated Horizontal Line with %ld circles.",(long)numNodes);
}

//Generate Square
+ (void) generateSquare: (NSInteger) size withCircles: (NSMutableArray *) circles atLocation: (CGPoint) location
{
    
}

+ (void) moveCircles: (NSArray*) circles toPositions: (NSDictionary*) positionsOnScreen
{
    for(XYZCircle* circle in circles){
        
        NSString* newPositionStr = positionsOnScreen[[NSNumber numberWithInteger: circle.circleID]];
        CGPoint newPosition = CGPointFromString(newPositionStr);
        
        [circle runAction: [SKAction moveTo: newPosition duration: 1] completion:^{
            
            // run this block on completion of the 'moveTo' action by each circle
            
            // this block waits for all the circles to move to their positions
            // once all circles have moved to their positions notify all the registered observers
            @synchronized (self){
                static NSInteger count = 0;
                
                count++;
                
                // notify all observers if all circles have moved to their positions
                if(count == circles.count){
                    count = 0;
                    NSLog(@"notifying observers. all circles have reached their positions");
                    [XYZShapeFactory notifyAll];
                }
            }
            
        }];
    }
}

+ (void) notifyAll
{
    for(id<XYZObserver> observer in observers){
        [observer notify];
    }
}

+ (void) addObserver: (id <XYZObserver>) newObserver
{
    if(observers == NULL){
        observers = [[NSMutableSet alloc] init];
    }
    
    [observers addObject: newObserver];
}

+ (void) removeObserver: (id <XYZObserver>) exisitingObserver
{
    if(observers == NULL){
        return;
    }
    
    [observers removeObject: exisitingObserver];
}

@end
