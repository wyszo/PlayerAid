//
//  PlayerAid
//

@import KZAsserts;
#import "ViewControllersFactory.h"

static NSString *const kCommentsStoryboardName = @"Comments";

@implementation ViewControllersFactory

- (TutorialCommentsViewController *)tutorialCommentsViewControllerFromStoryboardWithTutorial:(nonnull Tutorial *)tutorial
{
  AssertTrueOrReturnNil(tutorial);
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kCommentsStoryboardName bundle:[NSBundle mainBundle]];
  UIViewController *viewController = [storyboard instantiateInitialViewController];
  AssertTrueOrReturnNil([viewController isKindOfClass:[TutorialCommentsViewController class]]);
  TutorialCommentsViewController *tutorialCommentsViewController = (TutorialCommentsViewController *)viewController;
  tutorialCommentsViewController.tutorial = tutorial;
  return tutorialCommentsViewController;
}

@end
