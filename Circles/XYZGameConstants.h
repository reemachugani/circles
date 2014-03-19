//
//  XYZGameConstants.h
//  Circles
//
//  Created by Harish Murugasamy on 3/12/14.
//  Copyright (c) 2014 Harish Murugasamy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYZGameConstants : NSObject

+ (void) initWithConstants: (NSDictionary *) keysAndValues;
+ (CGSize) screenSize;
+ (CGFloat) physicsSpeed;
+ (id) circleTexture;
+ (NSNumber *) getBitMaskForCategory: (NSString *) categoryName;

- (id) init __unavailable;

@end
