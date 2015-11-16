//
//  PlayerAid
//

@import KZAsserts;
@import MagicalRecord;
#import "UsersHelper.h"
#import "User.h"


@implementation UsersHelper

- (NSSet *)setOfOtherUsersFromDictionariesArray:(id)dictionariesArray inContext:(NSManagedObjectContext *)context;
{
  AssertTrueOrReturnNil(context);
  AssertTrueOrReturnNil([dictionariesArray isKindOfClass:[NSArray class]]);
  NSMutableArray *usersArray = [NSMutableArray new];
  
  [dictionariesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    AssertTrueOrReturn([obj isKindOfClass:[NSDictionary class]]);
    NSDictionary *dictionary = (NSDictionary *)obj;
    
    NSString *userID = [self userIDFromUserDictionary:dictionary];
    User *user = [self userWithUserID:userID inContext:context];
    if (!user) {
      user = [User MR_createEntityInContext:context];
    }
    [user configureFromDictionary:dictionary];
    
    [usersArray addObject:user];
  }];
  
  return [NSSet setWithArray:usersArray];
}

- (NSString *)userIDFromUserDictionary:(NSDictionary *)dictionary
{
  AssertTrueOrReturnNil(dictionary.count);
  NSString *userID = [dictionary[kUserServerIDJSONAttributeName] stringValue];
  AssertTrueOrReturnNil(userID.length);
  return userID;
}

- (User *)userWithUserID:(NSString *)userID inContext:(NSManagedObjectContext *)context
{
  AssertTrueOrReturnNil(userID.length);
  AssertTrueOrReturnNil(context);
  
  NSInteger integerUserID = [userID integerValue];
  AssertTrueOrReturnNil(integerUserID > 0);
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %d", kUserServerIDKey, integerUserID];
  return [User MR_findFirstWithPredicate:predicate inContext:context];
}

#pragma mark - Single user

- (User *)userFromDictionary:(NSDictionary *)userDictionary inContext:(NSManagedObjectContext *)context
{
  AssertTrueOrReturnNil(userDictionary.count);
  AssertTrueOrReturnNil(context);
  
  NSString *userID = [User serverIDFromUserDictionary:userDictionary];
  User *user = [User MR_findFirstOrCreateByAttribute:@"serverID" withValue:userID inContext:context];
  [user configureFromDictionary:userDictionary];
  return user;
}

@end
