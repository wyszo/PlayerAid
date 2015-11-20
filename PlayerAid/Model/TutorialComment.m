
@import KZPropertyMapper;
@import MagicalRecord;
#import "TutorialComment.h"
#import "UsersHelper.h"

static NSString *const kCommentServerIDAttributeName = @"id";

@implementation TutorialComment

- (void)configureFromDictionary:(nonnull NSDictionary *)dictionary
{
  AssertTrueOrReturn(dictionary);
  
  NSDictionary *mapping = @{
                            kCommentServerIDAttributeName : KZProperty(serverID),
                            @"message" : KZProperty(text),
                            @"createdOn" : KZBox(DateWithTZD, createdOn),
                            @"author" : KZCall(userFromDictionary:, madeBy),
                            @"upvotes" : KZProperty(likesCount),
                            };
  
  [KZPropertyMapper mapValuesFrom:dictionary toInstance:self usingMapping:mapping];
}

- (User *)userFromDictionary:(nonnull NSDictionary *)dictionary
{
  return [[UsersHelper new] userFromDictionary:dictionary inContext:self.managedObjectContext];
}

#pragma mark - Class methods

+ (nullable NSNumber *)serverIDFromTutorialCommentDictionary:(nonnull NSDictionary *)dictionary
{
  AssertTrueOrReturnNil(dictionary.count);
  NSNumber *serverID = dictionary[kCommentServerIDAttributeName];
  AssertTrueOrReturnNil(serverID);
  return serverID;
}

+ (nonnull TutorialComment *)findFirstOrCreateByServerID:(nonnull NSNumber *)serverID inContext:(nonnull NSManagedObjectContext *)context
{
  return [TutorialComment MR_findFirstOrCreateByAttribute:@"serverID" withValue:serverID inContext:context];
}

@end
