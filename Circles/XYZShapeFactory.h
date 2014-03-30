
#import <Foundation/Foundation.h>

@interface XYZShapeFactory : NSObject

//+ (void) generateHorizontalLine: (NSInteger) size withCircles: (NSMutableArray *) circles atLocation: (CGPoint) location;
+ (void) generateHorizontalLine: (id) shapeInfo;
+ (void) generateSquare: (NSInteger) size withCircles: (NSMutableArray *) circles atLocation: (CGPoint) location;
//+ (void) generateRectangle: (NSInteger) size withCircles: (NSMutableArray *) circles atLocation: (CGPoint) location;
//+ (void) generateCircle: (NSInteger) size withCircles: (NSMutableArray *) circles atLocation: (CGPoint) location;
@end
