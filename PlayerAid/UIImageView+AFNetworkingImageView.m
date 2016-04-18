@import AFNetworking;
#import "UIImageView+AFNetworkingImageView.h"
#import <TWCommonLib/TWCommonMacros.h>

@implementation UIImageView (AFNetworkingImageView)

- (void)setImageWithURL:(NSURL *)url completion:(BlockWithBoolParameter)completion {
  NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
  
  defineWeakSelf();
  [self setImageWithURLRequest:urlRequest placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
    weakSelf.image = image;
    CallBlock(completion, YES);
  } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
    CallBlock(completion, NO);
  }];
}

@end
