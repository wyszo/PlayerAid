//
//  PlayerAid
//

@import CoreData;
@import Foundation;
@class User;

typedef NS_ENUM(NSUInteger, AvatarPlaceholderSize) {
  AvatarPlaceholderSizeSmall,
  AvatarPlaceholderSizeMedium,
  AvatarPlaceholderSizeLarge
};


NS_ASSUME_NONNULL_BEGIN

@interface UsersHelper : NSObject

- (NSSet *)setOfOtherUsersFromDictionariesArray:(id)dictionariesArray inContext:(NSManagedObjectContext *)context;
- (User *)userFromDictionary:(NSDictionary *)userDictionary inContext:(NSManagedObjectContext *)context;

- (nullable UIImage *)avatarPlaceholderImageForPlaceholderSize:(AvatarPlaceholderSize)placeholderSize;

@end

NS_ASSUME_NONNULL_END
