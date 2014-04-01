
#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "XYZObserver.h"

// Need to make this a singleton class, there should only be one instance of Level Manager
@interface XYZLevelManager : NSObject <XYZObserver>

+ (NSInteger) currentLevel;
+ (NSInteger) chosenCircleID;

+ (void) initializeOnScene: (SKScene*) scene;
+ (void) touchMadeAt: (CGPoint) location;

// this prevents initialization
- (id) init __unavailable;

@end
