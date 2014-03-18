//
//  XYZAnimation.h
//  Circles
//
//  Created by Harish Murugasamy on 3/12/14.
//  Copyright (c) 2014 Harish Murugasamy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYZCircle.h"


@protocol XYZAnimation <NSObject>

- (NSInteger) animationID;
- (NSInteger) minApplicableLevel;
- (void) animate: (NSArray *) circles withSpeed: (CGFloat) speed;

@end
