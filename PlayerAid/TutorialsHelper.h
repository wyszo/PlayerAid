//
//  PlayerAid
//

@import CoreData;
@import Foundation;
#import "Tutorial.h"

@interface TutorialsHelper : NSObject

+ (Tutorial *)tutorialWithServerID:(NSString *)serverID inContext:(NSManagedObjectContext *)localContext;
+ (NSString *)serverIDFromTutorialDictionary:(NSDictionary *)dictionary;
+ (NSSet *)setOfTutorialsFromDictionariesArray:(id)dictionariesArray parseAuthors:(BOOL)parseAuthors inContext:(NSManagedObjectContext *)context;

/** tutorials marked as inappropriate won't display for the user who reported them */
+ (void)markTutorialAsInappropriateByCurrentUser:(Tutorial *)tutorial;

@end
