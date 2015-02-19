#import "_User.h"
#import <UIKit/UIKit.h>

@interface User : _User {}

- (void)configureFromDictionary:(NSDictionary *)dictionary;
- (void)placeAvatarInImageView:(UIImageView *)imageView;

@end
