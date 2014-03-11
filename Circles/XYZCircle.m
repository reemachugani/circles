//
//  XYZCircle.m
//  Circles
//
//  Created by Harish Murugasamy on 3/11/14.
//  Copyright (c) 2014 Harish Murugasamy. All rights reserved.
//

#import "XYZCircle.h"

@implementation XYZCircle

@synthesize circleID = _circleID;

- (id) init
{
    
    static NSInteger lastUsedCircleID = 1;
    
    if(self = [super initWithImageNamed:@"BlueCircle.png"]){
        
        // TODO : need to verify if this is thread-safe
        @synchronized(self) {
            _circleID = lastUsedCircleID++;
        }
    }
    
    return self;
}

@end
