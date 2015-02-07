//
//  PlayerAid
//

#import "UIView+XibLoading.h"
#import <Foundation/Foundation.h>
#import <KZAsserts.h>

@implementation UIView (XibLoading)

+ (UIView *)viewFromNibNamed:(NSString *)nibName withOwner:(UIView *)owner
{
  // TODO: extract this to a separate category
  NSBundle *bundle = [NSBundle bundleForClass:[owner class]];
  UINib *nib = [UINib nibWithNibName:nibName bundle:bundle];
  const NSUInteger viewIndexInXib = 0;
  NSArray *nibViews = [nib instantiateWithOwner:owner options:nil];
  AssertTrueOrReturnNil(nibViews.count > viewIndexInXib);
  UIView *view = nibViews[viewIndexInXib];
  return view;
}

@end