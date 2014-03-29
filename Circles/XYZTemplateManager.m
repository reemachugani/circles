//
//  XYZTemplateManager.m
//  Circles
//
//  Created by Abhijith Padmakumar on 3/28/14.
//  Copyright (c) 2014 Harish Murugasamy. All rights reserved.
//

#import "XYZTemplateManager.h"

@implementation XYZTemplateManager

//Mapping of level ID to eligible templates
static NSMutableDictionary* templatesByLevel;
static NSDictionary* allTemplates;

+ (void) loadAllTemplateData
{
    //Reading from local JSON file
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"Templates" ofType:@"json"];
    NSData* templatesData = [NSData dataWithContentsOfFile:filePath];
    NSError* error;
    allTemplates = [NSJSONSerialization JSONObjectWithData:templatesData options:kNilOptions error:&error];

    if(error)
    {
        NSLog(@"oh no! :( %@",[error localizedDescription]);
    }
    else
    {
        NSLog(@"From template file: %@", allTemplates[@"TemplateID"]);
        templatesByLevel = [[NSMutableDictionary alloc] init];
        NSDictionary* template = [NSDictionary dictionaryWithDictionary:allTemplates[@"TemplateID"]];

        for(id key in template)
        {
            NSDictionary* currentTemplate = [NSDictionary dictionaryWithDictionary:[template objectForKey:key]];
            NSArray* eligibleLevels = [NSArray arrayWithArray:[currentTemplate objectForKey:@"levels"]];
            NSLog(@"fff.. ");
            for(int i=0;i<[eligibleLevels count];i++)
            {
                NSMutableArray* existingTemplatesForLevel = [templatesByLevel objectForKey:[eligibleLevels objectAtIndex:i]];
                if(existingTemplatesForLevel == NULL)
                    existingTemplatesForLevel = [[NSMutableArray alloc] init];
                //key is the templateId
                [existingTemplatesForLevel addObject:key];
                [templatesByLevel setValue:existingTemplatesForLevel forKey:[eligibleLevels objectAtIndex:i]];
            }
        }
    }
}

@end
