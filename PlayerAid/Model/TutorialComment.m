
@import KZPropertyMapper;
@import MagicalRecord;
@import KZAsserts;
#import "TutorialComment.h"
#import "UsersHelper.h"
#import "TutorialCommentParsingHelper.h"

static NSString *const kCommentServerIDAttributeName = @"id";

static NSString *const kCommentStatusPublished = @"Published";
static NSString *const kCommentStatusReported = @"Reported";
static NSString *const kCommentStatusDeleted = @"Deleted";

@implementation TutorialComment

- (void)configureFromDictionary:(nonnull NSDictionary *)dictionary
{
  AssertTrueOrReturn(dictionary);
  
  NSDictionary *mapping = @{
                            kCommentServerIDAttributeName : KZProperty(serverID),
                            @"status" : KZCall(commentStatusFromObject:, status),
                            @"message" : KZProperty(text),
                            @"createdOn" : KZBox(DateWithTZD, createdOn),
                            @"author" : KZCall(userFromDictionary:, madeBy),
                            @"upvotes" : KZProperty(likesCount),
                            @"upvotedByUser" : KZProperty(upvotedByUser),
                            @"replies" : KZCall(commentRepliesFromFeed:, hasReplies)
                           };
  
  [KZPropertyMapper mapValuesFrom:dictionary toInstance:self usingMapping:mapping];
}

- (User *)userFromDictionary:(nonnull NSDictionary *)dictionary {
  return [[UsersHelper new] userFromDictionary:dictionary inContext:self.managedObjectContext];
}

- (NSSet *)commentRepliesFromFeed:(NSDictionary *)feed {
  AssertTrueOrReturnNil(feed);
  
  id replies = feed[@"data"];
  AssertTrueOrReturnNil([replies isKindOfClass:[NSArray class]]);
  
  return [[[TutorialCommentParsingHelper new] orderedSetOfCommentsFromDictionariesArray:replies inContext:self.managedObjectContext] set];
}

- (NSNumber *)commentStatusFromObject:(id)object
{
  if ([object isKindOfClass:[NSNumber class]]) {
    if ([(NSNumber *)object isEqual:@(0)]) {
      // some of the old comments on Staging don't have status field filled in, they just return 0
      return @(CommentStatusPublished);
    } else {
      AssertTrueOr(NO && @"Unexpected, should never happen!", return @(CommentStatusDeleted););
    }
  }
  
  AssertTrueOr([object isKindOfClass:[NSString class]], return @(CommentStatusDeleted););
  NSString *statusString = (NSString *)object;
  
  CommentStatus status = CommentStatusUnknown;
  NSDictionary *mapping = @{ kCommentStatusPublished : @(CommentStatusPublished),
                             kCommentStatusReported : @(CommentStatusReported),
                             kCommentStatusDeleted : @(CommentStatusDeleted) };
  
  NSNumber *currentStatus = mapping[statusString];
  if (currentStatus) {
    status = currentStatus.unsignedIntegerValue;
  } else {
    AssertTrueOr(NO && @"unknown comment status value!", return 0;);
  }
  return @(status);
}

#pragma mark - Instance methods

- (BOOL)isCommentDeleted {
  return [self.status isEqualToNumber:@(CommentStatusDeleted)];
}

#pragma mark - Class methods

+ (nullable NSNumber *)serverIDFromTutorialCommentDictionary:(nonnull NSDictionary *)dictionary
{
  AssertTrueOrReturnNil(dictionary.count);
  NSNumber *serverID = dictionary[kCommentServerIDAttributeName];
  AssertTrueOrReturnNil(serverID);
  return serverID;
}

+ (nonnull TutorialComment *)findFirstByServerID:(nonnull NSNumber *)serverID inContext:(nonnull NSManagedObjectContext *)context {
  return [TutorialComment MR_findFirstByAttribute:@"serverID" withValue:serverID inContext:context];
}

+ (nonnull TutorialComment *)findFirstOrCreateByServerID:(nonnull NSNumber *)serverID inContext:(nonnull NSManagedObjectContext *)context{
  return [TutorialComment MR_findFirstOrCreateByAttribute:@"serverID" withValue:serverID inContext:context];
}

@end
