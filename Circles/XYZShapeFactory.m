#import "XYZCircle.h"
#import "XYZGameConstants.h"
#import "XYZShapeFactory.h"

@implementation XYZShapeFactory


//Generate Line
+ (NSDictionary*) generateHorizontalLine: (id) shapeInfo
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
    
    //[XYZShapeFactory moveCircles: circlesForCurrentShape toPositions: positionsOnScreen];
    NSLog(@"Generated Horizontal Line with %ld circles.",(long)numNodes);
    
    return positionsOnScreen;
}

//Generate Square
+ (NSDictionary*) generateSquare: (NSInteger) size withCircles: (NSMutableArray *) circles atLocation: (CGPoint) location
{
    return NULL;
}


@end
