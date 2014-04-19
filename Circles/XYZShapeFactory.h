
#import <Foundation/Foundation.h>
#import "XYZObserver.h"

@interface XYZShapeFactory : NSObject

//+ (void) generateHorizontalLine: (NSInteger) size withCircles: (NSMutableArray *) circles atLocation: (CGPoint) location;
+ (NSDictionary*) generateHorizontalLine: (id) shapeInfo;
+ (NSDictionary*) generateSquare: (NSInteger) size withCircles: (NSMutableArray *) circles atLocation: (CGPoint) location;
//+ (void) generateRectangle: (NSInteger) size withCircles: (NSMutableArray *) circles atLocation: (CGPoint) location;
//+ (void) generateCircle: (NSInteger) size withCircles: (NSMutableArray *) circles atLocation: (CGPoint) location;
@end
