
#import "XYZTemplateManager.h"
#import "XYZShapeFactory.h"
#import "XYZCircle.h"

@implementation XYZTemplateManager

//Mapping of Set ID to an array of Template IDs
static NSMutableDictionary* templatesBySet;
static NSDictionary* allTemplates;
static NSMutableSet* observers;

//Initial setup of reading from local JSON file
+ (NSDictionary*) loadAllTemplateData
{
    //Reading from local JSON file
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"json"];
    NSError* error;
    NSMutableDictionary* allData = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:filePath] options:kNilOptions error:&error];
    allTemplates = [NSDictionary dictionaryWithDictionary:allData[@"TemplateID"]];

    if(error)
    {
        NSLog(@"oh no! :( %@",[error localizedDescription]);
    }
    else
    {
        NSLog(@"From template file: %@", allTemplates[@"1"]);
        templatesBySet = [[NSMutableDictionary alloc] init];

        for(id key in allTemplates)
        {
            NSDictionary* currentTemplate = [NSDictionary dictionaryWithDictionary:[allTemplates objectForKey:key]];
            NSArray* eligibleSets = [NSArray arrayWithArray:[currentTemplate objectForKey:@"sets"]];
            NSLog(@"Loading template... ");
            for(int i=0;i<[eligibleSets count];i++)
            {
                NSMutableArray* existingTemplatesForSet = [templatesBySet objectForKey:[eligibleSets objectAtIndex:i]];
                if(existingTemplatesForSet == NULL)
                    existingTemplatesForSet = [[NSMutableArray alloc] init];
                //key is the templateId
                [existingTemplatesForSet addObject:key];
                [templatesBySet setValue:existingTemplatesForSet forKey:[eligibleSets objectAtIndex:i]];
            }
        }
        NSLog(@"debugging...");
    }
    
    return allTemplates;
}

// Return a dictionary of <Set ID, Eligible Templates>
+ (NSDictionary*) getTemplatesBySet
{
    return templatesBySet;
}

// Return eligible template IDs for the current set.
+ (NSArray*) getTemplatesForCurrentSet:(NSNumber *)currentSet
{
    return [templatesBySet objectForKey:currentSet];
}

//Setup shapes and move circles to their positions as defined by the template and
//return a copy of the current template
+ (NSMutableDictionary*) loadTemplate: (NSNumber*) templateId withCircles: (NSArray*) circles
{
    NSLog(@"SELECTED TEMPLATE = %d",[templateId intValue]);
    NSDictionary* currentTemplate = [NSDictionary dictionaryWithDictionary:allTemplates[templateId]];
    NSMutableDictionary* shapeInfo = [NSMutableDictionary dictionaryWithDictionary:currentTemplate[@"shapes"]];
    
    // Assign circles to Shapes
    NSInteger remainingCircles = [circles count];
    NSInteger currentCircle = 0;
    
    // Assign minimum number of circles required for each shape
    for(id shape in shapeInfo)
    {
        NSMutableArray* circlesForShape = [[NSArray array] mutableCopy];
        NSNumber* numNodesRequired = [[shapeInfo objectForKey:shape] objectForKey:@"minNodes"];
        while([numNodesRequired integerValue]>0)
        {
            [circlesForShape addObject:circles[currentCircle]];
            currentCircle++; remainingCircles--;
            numNodesRequired = @([numNodesRequired integerValue]-1);
        }
        NSMutableDictionary* currentShape = [NSMutableDictionary dictionaryWithDictionary:[shapeInfo objectForKey:shape]];
        [currentShape setObject:circlesForShape forKey:@"nodes"];
        [shapeInfo setObject:currentShape forKey:shape];
        NSLog(@"%@",[[shapeInfo objectForKey:shape] objectForKey:@"nodes"]);
        NSLog(@"...");
    }
    
    NSMutableDictionary* positionsOnScreen = [[NSMutableDictionary alloc] init];
    // TODO: Handle extra circles
    
    // Call methods of ShapeFactory to move circles to their positions
    
    for(NSString* shapeName in shapeInfo.allKeys)
    {
        NSString* methodToCall = [NSString stringWithFormat:@"%@%@:",@"generate",[shapeName mutableCopy]];
        NSMutableDictionary* positionsForThisShape = [XYZShapeFactory performSelector:NSSelectorFromString(methodToCall) withObject: [shapeInfo objectForKey:shapeName]];
        
        [positionsOnScreen addEntriesFromDictionary: positionsForThisShape];
    }
    
    [XYZTemplateManager moveCircles: circles toPositions: positionsOnScreen];
    
    // Return shape and circle Info
    
    return [[NSDictionary dictionaryWithDictionary:shapeInfo] mutableCopy];
}

+ (void) moveCircles: (NSArray*) circles toPositions: (NSDictionary*) positionsOnScreen
{
    for(XYZCircle* circle in circles){
        
        NSString* newPositionStr = positionsOnScreen[[NSNumber numberWithInteger: circle.circleID]];
        CGPoint newPosition = CGPointFromString(newPositionStr);
        
        [circle runAction: [SKAction moveTo: newPosition duration: 1] completion:^{
            
            // run this block on completion of the 'moveTo' action by each circle
            
            // this block waits for all the circles to move to their positions
            // once all circles have moved to their positions notify all the registered observers
            @synchronized (self){
                static NSInteger count = 0;
                
                count++;
                
                // notify all observers if all circles have moved to their positions
                if(count == circles.count){
                    count = 0;
                    NSLog(@"notifying observers. all circles have reached their positions");
                    [XYZTemplateManager notifyAll];
                }
            }
            
        }];
    }
}


+ (void) notifyAll
{
    for(id<XYZObserver> observer in observers){
        [observer notify];
    }
}

+ (void) addObserver: (id <XYZObserver>) newObserver
{
    if(observers == NULL){
        observers = [[NSMutableSet alloc] init];
    }
    
    [observers addObject: newObserver];
}

+ (void) removeObserver: (id <XYZObserver>) exisitingObserver
{
    if(observers == NULL){
        return;
    }
    
    [observers removeObject: exisitingObserver];
}

@end
