//
//  PlayerAid
//

#import "ProfileViewController.h"

@class User;


@interface ApplicationViewHierarchyHelper : NSObject

+ (UINavigationController *)navigationControllerWithCreateTutorialViewController;
+ (UINavigationController *)navigationControllerWithViewController:(UIViewController *)viewController;

/**
 * If user != currentUser, will also make a network request to update other user's data
 * TODO: this request shold be moved to another method, this violates SRP
 */
+ (void (^)(User *))pushProfileViewControllerFromViewController:(UIViewController *)viewController allowPushingLoggedInUser:(BOOL)allowPushingLoggedInUser;

@end
