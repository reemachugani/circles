
#import <Foundation/Foundation.h>
#import "XYZObserver.h"

@interface XYZShapeFactory : NSObject

//+ (void) generateHorizontalLine: (NSInteger) size withCircles: (NSMutableArray *) circles atLocation: (CGPoint) location;
+ (void) generateHorizontalLine: (id) shapeInfo;
+ (void) generateSquare: (NSInteger) size withCircles: (NSMutableArray *) circles atLocation: (CGPoint) location;
//+ (void) generateRectangle: (NSInteger) size withCircles: (NSMutableArray *) circles atLocation: (CGPoint) location;
//+ (void) generateCircle: (NSInteger) size withCircles: (NSMutableArray *) circles atLocation: (CGPoint) location;

+ (void) addObserver: (id <XYZObserver>) newObserver;
+ (void) removeObserver: (id <XYZObserver>) exisitingObserver;

@end
