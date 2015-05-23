//
//  PlayerAid
//

#import "ApplicationViewHierarchyHelper.h"


@implementation ApplicationViewHierarchyHelper

+ (UITabBarController *)mainTabBarController
{
  id<UIApplicationDelegate> appDelegate = [UIApplication sharedApplication].delegate;
  UIViewController *rootViewController = appDelegate.window.rootViewController;
  AssertTrueOrReturnNil([rootViewController isKindOfClass:[UITabBarController class]]);
  return (UITabBarController *)rootViewController;
}

+ (UITabBarItem *)tabBarItemAtIndex:(NSUInteger)itemIndex
{
  UITabBarController *tabBarController = [self.class mainTabBarController];
  AssertTrueOrReturnNil(tabBarController.tabBar.items.count > itemIndex);
  return tabBarController.tabBar.items[itemIndex];
}

+ (CGRect)frameForTabBarItemAtIndex:(NSUInteger)itemIndex
{
  UITabBarController *tabBarController = [self.class mainTabBarController];
  AssertTrueOr(tabBarController.tabBar.items.count > itemIndex, return CGRectZero;);
  
  NSMutableArray *allTabBarButtons = [NSMutableArray new];
  
  for (UIView *subview in tabBarController.tabBar.subviews) {
    if ([subview isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
      [allTabBarButtons addObject:subview];
    }
  }
  
  // Subviews don't have to be in order, sort items by x position first
  NSArray *sortedAllTabBarButtons = [allTabBarButtons sortedArrayUsingComparator:^NSComparisonResult(UIView *view1, UIView *view2) {
    if (view1.frame.origin.x < view2.frame.origin.x) {
      return NSOrderedAscending;
    }
    else if (view1.frame.origin.x > view2.frame.origin.x) {
      return NSOrderedDescending;
    }
    return NSOrderedSame;
  }];
  
  CGRect frame = ((UIView *)sortedAllTabBarButtons[itemIndex]).frame;
  // at this point frame is not correct on iPhone 6 and 6+, recalculating (based on item width)
  
  CGRect screenSize = [UIScreen mainScreen].bounds;
  CGFloat yPos = 0; // frame.origin.y returns 1 which is not what we want
  CGFloat originalYOffset = frame.origin.y;
  frame = CGRectMake((screenSize.size.width - frame.size.width) / 2.0, yPos, frame.size.width, frame.size.height + originalYOffset);
  
  return frame;
  
  AssertTrueOr(NO, return CGRectZero;); // error, couldn't find tabBar item frame!
  return CGRectZero;
}

#pragma mark - Traversing TabBar view hierarchy

+ (UIView *)tabBarControllerBackgroundView
{
  UITabBarController *tabBarController = [ApplicationViewHierarchyHelper mainTabBarController];
  AssertTrueOrReturnNil(tabBarController);
  
  UIView *tabBarBackgroundView;
  for (UIView *subview in tabBarController.tabBar.subviews) {
    if ([subview isKindOfClass:NSClassFromString(@"_UITabBarBackgroundView")]) {
      tabBarBackgroundView = subview;
    }
  }
  return tabBarBackgroundView; // can be nil
}

@end
