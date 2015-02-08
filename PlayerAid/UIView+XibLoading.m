//
//  PlayerAid
//

#import "UIView+XibLoading.h"
#import <Foundation/Foundation.h>
#import <KZAsserts.h>

@implementation UIView (XibLoading)

+ (UIView *)viewFromNibNamed:(NSString *)nibName withOwner:(UIView *)owner
{
  NSBundle *bundle = [NSBundle bundleForClass:[owner class]];
  UINib *nib = [UINib nibWithNibName:nibName bundle:bundle];
  const NSUInteger viewIndexInXib = 0;
  NSArray *nibViews = [nib instantiateWithOwner:owner options:nil];
  AssertTrueOrReturnNil(nibViews.count > viewIndexInXib);
  UIView *view = nibViews[viewIndexInXib];
  return view;
}

- (void)loadView:(UIView *)view fromNibNamed:(NSString *)nibName
{
  AssertTrueOrReturn(nibName.length);
  view = [UIView viewFromNibNamed:nibName withOwner:self];
  view.frame = self.bounds;
  view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  [self addSubview:view];
}

@end
