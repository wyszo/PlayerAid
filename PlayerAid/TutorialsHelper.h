//
//  PlayerAid
//

@import CoreData;
@import Foundation;
#import "Tutorial.h"

@interface TutorialsHelper : NSObject

+ (Tutorial *)tutorialWithServerID:(NSString *)serverID inContext:(NSManagedObjectContext *)localContext;
+ (NSString *)serverIDFromTutorialDictionary:(NSDictionary *)dictionary;
+ (void)revertTutorialStateToDraft:(Tutorial *)tutorial;

+ (NSSet *)setOfTutorialsFromDictionariesArray:(id)dictionariesArray parseAuthors:(BOOL)parseAuthors inContext:(NSManagedObjectContext *)context;
+ (Tutorial *)tutorialFromDictionary:(nonnull NSDictionary *)dictionary parseAuthors:(BOOL)parseAuthors inContext:(nonnull NSManagedObjectContext *)context;

+ (BOOL)isOwnTutorial:(nonnull Tutorial *)tutorial;

@end
