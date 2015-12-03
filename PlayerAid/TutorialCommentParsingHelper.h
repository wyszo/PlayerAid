//
//  PlayerAid
//

@import Foundation;
@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@interface TutorialCommentParsingHelper : NSObject

- (NSOrderedSet *)orderedSetOfCommentsFromDictionariesArray:(NSArray *)commentsDictionaries inContext:(NSManagedObjectContext *)context;
- (void)saveCommentFromDictionary:(NSDictionary *)commentDictionary;

@end

NS_ASSUME_NONNULL_END