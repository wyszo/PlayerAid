//
//  PlayerAid
//

@import CoreData;
@import Foundation;
@class User;

NS_ASSUME_NONNULL_BEGIN

@interface UsersHelper : NSObject

- (NSSet *)setOfOtherUsersFromDictionariesArray:(id)dictionariesArray inContext:(NSManagedObjectContext *)context;
- (User *)userFromDictionary:(NSDictionary *)userDictionary inContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END
