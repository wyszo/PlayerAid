@import UIKit;
#import <TWCommonLib/TWCommonTypes.h>

@interface UIImageView (AFNetworkingImageView)

- (void)setImageWithURL:(NSURL *)url completion:(BlockWithBoolParameter)completion;

@end
