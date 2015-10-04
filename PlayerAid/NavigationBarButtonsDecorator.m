//
//  PlayerAid
//

@import KZAsserts;
#import "NavigationBarButtonsDecorator.h"

@implementation NavigationBarButtonsDecorator

- (void)addCancelButtonToViewController:(UIViewController *)viewController withSelector:(SEL)cancelSelector
{
  AssertTrueOrReturn(viewController);
  AssertTrueOrReturn(cancelSelector);
  
  UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:viewController action:cancelSelector];
  viewController.navigationItem.leftBarButtonItem = cancelButton;
}

- (void)addSaveButtonToViewController:(UIViewController *)viewController withSelector:(SEL)saveSelector
{
  AssertTrueOrReturn(viewController);
  AssertTrueOrReturn(saveSelector);
  
  UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:viewController action:saveSelector];
  viewController.navigationItem.rightBarButtonItem = saveButton;
}

@end
