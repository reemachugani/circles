
#import <Foundation/Foundation.h>

@interface XYZTemplateManager : NSObject

+ (NSDictionary*) loadAllTemplateData;
+ (NSArray*) getTemplatesForCurrentSet: (NSNumber*) currentSet;
+ (NSDictionary*) getTemplatesBySet;
+ (NSMutableDictionary*) loadTemplate: (NSNumber*) templateId withCircles: (NSArray*) circles;

@end
