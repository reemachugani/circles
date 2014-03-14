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
- (void) animate: (NSMutableArray *) circles withSpeed: (NSInteger) speed;

@end
