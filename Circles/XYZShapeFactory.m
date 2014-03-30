#import "XYZCircle.h"
#import "XYZGameConstants.h"
#import "XYZShapeFactory.h"

@implementation XYZShapeFactory

//Generate Line
+ (void) generateHorizontalLine: (id) shapeInfo
{
    CGSize screenSize = [XYZGameConstants screenSize];
    CGFloat lineWidth = [shapeInfo[@"size"] floatValue]*screenSize.width;
    CGFloat startingX = (screenSize.width - lineWidth)/2;
    CGFloat startingY = screenSize.height/2;
    NSInteger numNodes = [shapeInfo[@"nodes"] count];
    NSInteger spacing = lineWidth/(numNodes-1);
    
    NSInteger count = 1;
    for(XYZCircle* circle in shapeInfo[@"nodes"])
    {
        CGPoint startingPosition = CGPointMake(startingX+(count*spacing - spacing), startingY);
        SKAction* moveToStartingPosition = [SKAction moveTo:startingPosition duration:2.0];
        [circle runAction: moveToStartingPosition];
        count++;
    }
    NSLog(@"Generated Horizontal Line with %ld circles.",(long)numNodes);
}

//Generate Square
+ (void) generateSquare: (NSInteger) size withCircles: (NSMutableArray *) circles atLocation: (CGPoint) location
{
    
}


@end
