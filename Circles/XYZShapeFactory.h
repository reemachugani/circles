//
//  XYZShapeFactory.h
//  Circles
//
//  Created by Abhijith Padmakumar on 3/28/14.
//  Copyright (c) 2014 Harish Murugasamy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYZShapeFactory : NSObject

+ (void) generateLine: (NSInteger) size withCircles: (NSMutableArray *) circles atLocation: (CGPoint) location;
+ (void) generateSquare: (NSInteger) size withCircles: (NSMutableArray *) circles atLocation: (CGPoint) location;
//+ (void) generateRectangle: (NSInteger) size withCircles: (NSMutableArray *) circles atLocation: (CGPoint) location;
//+ (void) generateCircle: (NSInteger) size withCircles: (NSMutableArray *) circles atLocation: (CGPoint) location;

@end
