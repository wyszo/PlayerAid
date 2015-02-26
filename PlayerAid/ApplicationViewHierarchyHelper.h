//
//  PlayerAid
//

@class User;


@interface ApplicationViewHierarchyHelper : NSObject

+ (UINavigationController *)navigationControllerWithCreateTutorialViewController;
+ (void (^)(User *))pushProfileViewControllerFromViewControllerBlock:(UIViewController *)viewController;

@end
