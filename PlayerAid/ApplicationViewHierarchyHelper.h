//
//  PlayerAid
//

#import "ProfileViewController.h"

@class User;


@interface ApplicationViewHierarchyHelper : NSObject

+ (UINavigationController *)navigationControllerWithCreateTutorialViewController;

+ (ProfileViewController *)profileViewControllerFromTabBarController;

/**
 * If user != currentUser, will also make a network request to update other user's data
 * TODO: this request shold be moved to another method, this violates SRP
 */
+ (void (^)(User *))pushProfileViewControllerFromViewControllerBlock:(UIViewController *)viewController allowPushingLoggedInUser:(BOOL)allowPushingLoggedInUser;

@end
