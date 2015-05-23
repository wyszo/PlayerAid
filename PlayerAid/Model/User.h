#import "_User.h"
#import <UIKit/UIKit.h>


@interface User : _User <TWConfigurableFromDictionary>

- (void)placeAvatarInImageView:(UIImageView *)imageView;

+ (NSString *)serverIDFromUserDictionary:(NSDictionary *)dictionary;

@end
