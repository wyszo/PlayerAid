//
//  PlayerAid
//

@import Foundation;
#import "TutorialCommentsViewController.h"
#import "Tutorial.h"

NS_ASSUME_NONNULL_BEGIN

@interface ViewControllersFactory : NSObject

- (TutorialCommentsViewController *)tutorialCommentsViewControllerFromStoryboardWithTutorial:(Tutorial *)tutorial;

@end

NS_ASSUME_NONNULL_END
