//
//  XYZGameConstants.m
//  Circles
//
//  Created by Harish Murugasamy on 3/12/14.
//  Copyright (c) 2014 Harish Murugasamy. All rights reserved.
//

#import "XYZGameConstants.h"

@implementation XYZGameConstants

static NSDictionary* dictionary;

+ (void) initWithConstants: (NSDictionary *) keysAndValues{
    dictionary = keysAndValues;
}

+ (CGSize) screenSize{
    
    // TODO : need to handle device orientation?
    return [[dictionary objectForKey:@"screenSize"] CGSizeValue];
}


@end
