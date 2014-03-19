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
static NSDictionary* categoryBitMasks; //For physics

+ (void) initWithConstants: (NSDictionary *) keysAndValues{
    dictionary = keysAndValues;
    categoryBitMasks = [self setCategorybitMasks];
}

//Todo: The below three methods can be made generic so as to retrieve the value based on key name
+ (CGSize) screenSize{
    
    // TODO : need to handle device orientation?
    return [[dictionary objectForKey:@"screenSize"] CGSizeValue];
}

+ (id) circleTexture
{
    return [dictionary objectForKey:@"circleTexture"];
}

+ (CGFloat) physicsSpeed
{
    return [[dictionary objectForKey:@"physicsSpeed"] floatValue];
}

+ (NSNumber*) getBitMaskForCategory: (NSString *) categoryName
{
    return [categoryBitMasks objectForKey:categoryName];
}

//Sets category masks for screen boundary & animations
+ (NSDictionary *) setCategorybitMasks
{
    NSMutableDictionary *bitMasks = [[NSMutableDictionary alloc] init];
    [bitMasks setObject:[NSNumber numberWithUnsignedInt:0x1<<0] forKey:@"wall"];
    //Consider adding special category for chosen ball
    for(int i=1;i<32;i++)
    {
        uint32_t temp = 0x1<<i;
        NSString* key = [NSString stringWithFormat:@"%d",i];
        [bitMasks setObject:[NSNumber numberWithUnsignedInt:temp] forKey:key];
    }
    return bitMasks;
}

@end
