//
//  PlayerAid
//

@import CoreData;
@import KZAsserts;
#import "TutorialCommentParsingHelper.h"
#import "TutorialComment.h"

@implementation TutorialCommentParsingHelper

- (nonnull NSOrderedSet *)orderedSetOfCommentsFromDictionariesArray:(nonnull NSArray *)commentsDictionaries inContext:(nonnull NSManagedObjectContext *)context
{
  AssertTrueOrReturnNil(commentsDictionaries);
  AssertTrueOrReturnNil(context);
  
  if (!commentsDictionaries.count) {
    return nil;
  }
  
  NSMutableOrderedSet *mutableSet = [NSMutableOrderedSet new];
  
  [commentsDictionaries enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    AssertTrueOrReturn([obj isKindOfClass:[NSDictionary class]]);
    NSDictionary *dictionary = (NSDictionary *)obj;
    
    NSNumber *serverID = [TutorialComment serverIDFromTutorialCommentDictionary:dictionary];
    TutorialComment *comment = [TutorialComment findFirstOrCreateByServerID:serverID inContext:context];
    [comment configureFromDictionary:dictionary];
    
    AssertTrueOrReturn(comment.serverID);
    [mutableSet addObject:comment];
  }];
  return [mutableSet copy];
}

@end
