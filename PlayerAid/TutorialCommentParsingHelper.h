//
//  PlayerAid
//

@import Foundation;
@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@interface TutorialCommentParsingHelper : NSObject

- (NSOrderedSet *)orderedSetOfCommentsFromDictionariesArray:(NSArray *)commentsDictionaries inContext:(NSManagedObjectContext *)context;
- (void)saveCommentFromDictionary:(NSDictionary *)commentDictionary;
- (void)saveRepliesToCommentWithID:(nonnull NSNumber *)parentCommentId repliesDictionaries:(nonnull NSArray *)replies;

// It's required to save initial comment state, because server only returns id of a new comment, without it's content - we need to initially set it up manually
- (void)saveNewCommentWithID:(NSNumber *)commentID message:(NSString *)message parentTutorialID:(NSNumber *)tutorialID;

@end

NS_ASSUME_NONNULL_END