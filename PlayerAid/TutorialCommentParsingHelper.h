//
//  PlayerAid
//

@import Foundation;
@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@interface TutorialCommentParsingHelper : NSObject

- (NSOrderedSet *)orderedSetOfCommentsFromDictionariesArray:(NSArray *)commentsDictionaries inContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END