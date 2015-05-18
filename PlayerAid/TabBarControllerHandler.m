//
//  PlayerAid
//

#import <UIKit/UIKit.h>
#import "TabBarControllerHandler.h"
#import "CreateTutorialViewController.h"


@interface TabBarControllerHandler ()
@property (copy, nonatomic) void (^createTutorialAction)();
@end

@implementation TabBarControllerHandler

- (instancetype)initWithCreateTutorialItemAction:(void (^)())createTutorialAction
{
  self = [super init];
  if (self) {
    _createTutorialAction = createTutorialAction;
  }
  return self;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
  if ([viewController isKindOfClass:[CreateTutorialViewController class]]) {
    
    if (self.createTutorialAction) {
      self.createTutorialAction();
    }
    return NO;
  }
  return YES;
}

@end
