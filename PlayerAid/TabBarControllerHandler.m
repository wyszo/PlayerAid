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
  AssertTrueOrReturnNil(createTutorialAction);
  self = [super init];
  if (self) {
    _createTutorialAction = createTutorialAction;
  }
  return self;
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

#pragma mark - Auxiliary methods

- (void)popViewControllerToRoot:(UIViewController *)viewController
{
  if ([viewController isKindOfClass:[UINavigationController class]]) {
    UINavigationController *navigationController = (UINavigationController *)viewController;
    [navigationController popToRootViewControllerAnimated:NO];
  }
}

@end
