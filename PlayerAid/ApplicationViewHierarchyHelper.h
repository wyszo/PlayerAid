//
//  PlayerAid
//

@import UIKit;
@import Foundation;
#import "ProfileViewController.h"

@class User;


@interface ApplicationViewHierarchyHelper : NSObject

+ (UINavigationController *)navigationControllerWithCreateTutorialViewController;
+ (UINavigationController *)navigationControllerWithViewController:(UIViewController *)viewController;

/**
 * If user != currentUser, will also make a network request to update other user's data
 * TODO: this request shold be moved to another method, this violates SRP
 */
+ (void (^)(User *))pushProfileViewControllerFromViewController:(UIViewController *)viewController backButtonActionBlock:(VoidBlock)deallocBlock allowPushingLoggedInUser:(BOOL)allowPushingLoggedInUser;

/**
 Presents a navigation controller with CreateTutorial modally,
 Returns CreateTutorialViewController
 */
+ (UIViewController *)presentModalCreateTutorialViewController;

@end
