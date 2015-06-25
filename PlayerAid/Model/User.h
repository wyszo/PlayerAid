#import "_User.h"
#import <UIKit/UIKit.h>


extern NSString *const kUserServerIDJSONAttributeName;
extern NSString *const kUserServerIDKey;


@interface User : _User <TWConfigurableFromDictionary>

- (void)placeAvatarInImageView:(UIImageView *)imageView;

+ (NSString *)serverIDFromUserDictionary:(NSDictionary *)dictionary;

@end
