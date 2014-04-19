
#import <Foundation/Foundation.h>
#import "XYZObserver.h"

@interface XYZTemplateManager : NSObject

+ (NSDictionary*) loadAllTemplateData;
+ (NSArray*) getTemplatesForCurrentSet: (NSNumber*) currentSet;
+ (NSDictionary*) getTemplatesBySet;
+ (NSMutableDictionary*) loadTemplate: (NSNumber*) templateId withCircles: (NSArray*) circles;

+ (void) addObserver: (id <XYZObserver>) newObserver;
+ (void) removeObserver: (id <XYZObserver>) exisitingObserver;

@end
