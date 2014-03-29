//
//  XYZTemplateManager.h
//  Circles
//
//  Created by Abhijith Padmakumar on 3/28/14.
//  Copyright (c) 2014 Harish Murugasamy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYZTemplateManager : NSObject

+ (void) loadAllTemplateData;
+ (void) loadTemplate;
+ (NSArray*) templatesForLevel: (NSInteger) level;

@end
