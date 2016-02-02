//
//  PlayerAid
//

@import UIKit;
@import Foundation;
#import "ProfileViewController.h"

@class User;


@interface ApplicationViewHierarchyHelper : NSObject

+ (UINavigationController *)navigationControllerWithCreateTutorialViewController;

// Unnecessary, since this is exactly what UINavigationController.initWithRootViewController does
+ (UINavigationController *)navigationControllerWithViewController:(UIViewController *)viewController;

/**
 * If user != currentUser, will also make a network request to update other user's data
 * TODO: this request shold be moved to another method, this violates SRP
 */
+ (void (^)(User *))pushProfileVCFromNavigationController:(UINavigationController *)navigationController allowPushingLoggedInUser:(BOOL)allowPushingLoggedInUser;

/**
 Presents a navigation controller with CreateTutorial modally,
 Returns CreateTutorialViewController
 */
+ (UIViewController *)presentModalCreateTutorialViewController;

/**
 Presents a navigation controller with CommentRepliesVC
 Returns CommentRepliesViewController
 */
+ (UIViewController *)presentModalCommentReplies:(TutorialComment *)comment fromViewController:(UIViewController *)presentingViewController;

@end
