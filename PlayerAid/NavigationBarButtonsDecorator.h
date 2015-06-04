//
//  PlayerAid
//


@interface NavigationBarButtonsDecorator : NSObject

- (void)addCancelButtonToViewController:(UIViewController *)viewController withSelector:(SEL)cancelSelector;
- (void)addSaveButtonToViewController:(UIViewController *)viewController withSelector:(SEL)saveSelector;

@end
