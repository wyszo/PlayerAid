//
//  PlayerAid
//

#import "Tutorial.h"


@interface TutorialsHelper : NSObject

+ (Tutorial *)tutorialWithServerID:(NSString *)serverID inContext:(NSManagedObjectContext *)localContext;
+ (NSString *)serverIDFromTutorialDictionary:(NSDictionary *)dictionary;
+ (NSSet *)setOfTutorialsFromDictionariesArray:(id)dictionariesArray parseAuthors:(BOOL)parseAuthors inContext:(NSManagedObjectContext *)context;

@end
