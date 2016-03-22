//
//  PlayerAid
//

@import CoreData;
@import KZAsserts;
@import MagicalRecord;
#import "TutorialCommentParsingHelper.h"
#import "Tutorial.h"
#import "TutorialComment.h"

@implementation TutorialCommentParsingHelper

#pragma mark - public

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
    
    TutorialComment *comment = [self createOrUpdateCommentFromDictionary:dictionary inContext:context];
    AssertTrueOrReturn(comment.serverID);
    [mutableSet addObject:comment];
  }];
  return [mutableSet copy];
}

- (void)saveCommentFromDictionary:(NSDictionary *)commentDictionary
{
  AssertTrueOrReturn(commentDictionary.count);
  
  [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
    [self createOrUpdateCommentFromDictionary:commentDictionary inContext:localContext];
  }];
}

- (void)saveRepliesToCommentWithID:(nonnull NSNumber *)parentCommentId repliesDictionaries:(nonnull NSArray *)replies {
  AssertTrueOrReturn(parentCommentId);
  AssertTrueOrReturn(replies);
  
  [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
    TutorialComment *parent = [TutorialComment findFirstByServerID:parentCommentId inContext:localContext];
    AssertTrueOrReturn(parent);
    
    for (NSDictionary *replyDictionary in replies) {
      TutorialComment *reply = [self createOrUpdateCommentFromDictionary:replyDictionary inContext:localContext];
      AssertTrueOrReturn(reply != nil);
      reply.isReplyTo = parent;
    }
  }];
}

- (void)saveNewCommentWithID:(NSNumber *)commentID message:(NSString *)message parentTutorialID:(NSNumber *)tutorialID {
  AssertTrueOrReturn(commentID);
  AssertTrueOrReturn(tutorialID);
  AssertTrueOrReturn(message.length > 0);
  
  [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
    TutorialComment *comment = [TutorialComment findFirstOrCreateByServerID:commentID inContext:localContext];
    AssertTrueOrReturn(comment);
    
    Tutorial *tutorial = [Tutorial findFirstByServerID:tutorialID inContext:localContext];
    AssertTrueOrReturn(tutorial);
    
    [self fillCommentInitialState:comment message:message];
    comment.belongsToTutorial = tutorial;
  }];
}

- (void)saveNewReplyWithID:(NSNumber *)replyID message:(NSString *)message parentCommentID:(NSNumber *)parentID {
  AssertTrueOrReturn(replyID);
  AssertTrueOrReturn(message.length);
  AssertTrueOrReturn(parentID);
  
  [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
    TutorialComment *parentComment = [TutorialComment findFirstOrCreateByServerID:parentID inContext:localContext];
    AssertTrueOrReturn(parentComment);
    
    TutorialComment *reply = [TutorialComment findFirstOrCreateByServerID:replyID inContext:localContext];
    AssertTrueOrReturn(reply);
    
    [self fillCommentInitialState:reply message:message];
    reply.isReplyTo = parentComment;
  }];
}

#pragma mark - private

- (TutorialComment *)createOrUpdateCommentFromDictionary:(NSDictionary *)commentDictionary inContext:(NSManagedObjectContext *)context
{
  AssertTrueOrReturnNil(commentDictionary.count);
  AssertTrueOrReturnNil(context);
  
  NSNumber *serverID = [TutorialComment serverIDFromTutorialCommentDictionary:commentDictionary];
  TutorialComment *comment = [TutorialComment findFirstOrCreateByServerID:serverID inContext:context];
  [comment configureFromDictionary:commentDictionary];
  return comment;
}

- (void)fillCommentInitialState:(TutorialComment *)comment message:(NSString *)message {
  AssertTrueOrReturn(comment);
  AssertTrueOrReturn(message.length);
  
  comment.createdOn = [NSDate date];
  comment.likesCount = 0;
  comment.status = @(CommentStatusPublished);
  comment.upvotedByUser = @NO;
  comment.text = message;
}

@end
