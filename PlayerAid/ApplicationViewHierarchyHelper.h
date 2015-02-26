//
//  PlayerAid
//

@class User;


@interface ApplicationViewHierarchyHelper : NSObject

+ (UINavigationController *)navigationControllerWithCreateTutorialViewController;

+ (void (^)(User *))pushProfileViewControllerFromViewControllerBlock:(UIViewController *)viewController allowPushingLoggedInUser:(BOOL)allowPushingLoggedInUser;

@end
