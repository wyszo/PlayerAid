//
//  PlayerAid
//

#import "Tutorial.h"


@interface TutorialsHelper : NSObject

+ (Tutorial *)tutorialWithServerID:(NSString *)serverID inContext:(NSManagedObjectContext *)localContext;
+ (NSString *)serverIDFromTutorialDictionary:(NSDictionary *)dictionary;

@end
