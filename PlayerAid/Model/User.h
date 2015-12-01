#import "_User.h"
@import UIKit;
#import <TWCommonLib/TWConfigurableFromDictionary.h>
#import "UsersHelper.h"

extern NSString *const kUserServerIDJSONAttributeName;
extern NSString *const kUserServerIDKey;

@interface User : _User <TWConfigurableFromDictionary>

- (void)placeAvatarInImageView:(nonnull UIImageView *)imageView;
- (void)placeAvatarInImageViewOrDisplayPlaceholder:(nonnull UIImageView *)imageView placeholderSize:(AvatarPlaceholderSize)placeholderSize;

+ (NSString *)serverIDFromUserDictionary:(NSDictionary *)dictionary;

@end
