//
//  PlayerAid
//

#import "TabBarControllerHandler.h"
#import "CreateTutorialViewController.h"


@interface TabBarControllerHandler ()
@property (copy, nonatomic) void (^createTutorialAction)();
@end


@implementation TabBarControllerHandler

#pragma mark - Initialization

- (instancetype)initWithCreateTutorialItemAction:(void (^)())createTutorialAction
{
  self = [super init];
  if (self) {
    _createTutorialAction = createTutorialAction;
  }
  return self;
}

#pragma mark - Public interface

- (void)showProfileTabBarItemBadge
{
  // grab Profile tab
  
  
  // set badge
  
  UITabBarItem *profileTabBarItem;
  AssertTrueOrReturn(profileTabBarItem);
  profileTabBarItem.badgeValue = @"1";
  
  // TODO: update badgeValue number when saving multiple drafts
}

- (void)hideProfileTabBarItemBadge
{
  NOT_IMPLEMENTED_YET_RETURN
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
  if ([viewController isKindOfClass:[CreateTutorialViewController class]]) {
    
    if (self.createTutorialAction) {
      self.createTutorialAction();
    }
    return NO;
  }
  else {
    [self popViewControllerToRoot:viewController];
  }
  return YES;
}

#pragma mark - Other methods

- (void)popViewControllerToRoot:(UIViewController *)viewController
{
  if ([viewController isKindOfClass:[UINavigationController class]]) {
    UINavigationController *navigationController = (UINavigationController *)viewController;
    [navigationController popToRootViewControllerAnimated:NO];
  }
}

@end
