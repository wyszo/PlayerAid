//
//  PlayerAid
//

@import KZAsserts;
#import "TutorialDetailsHelper.h"
#import "TutorialDetailsViewController.h"

static NSString *const kShowTutorialDetailsSegueName = @"ShowTutorialDetails";


@implementation TutorialDetailsHelper

- (void)performTutorialDetailsSegueFromViewController:(UIViewController *)viewController
{
  AssertTrueOrReturn(viewController);
  [viewController performSegueWithIdentifier:kShowTutorialDetailsSegueName sender:viewController];
}

- (NSString *)tutorialDetailsSegueIdentifier
{
  return kShowTutorialDetailsSegueName;
}

- (void)prepareForTutorialDetailsSegue:(UIStoryboardSegue *)segue pushingTutorial:(Tutorial *)tutorial deallocBlock:(VoidBlock)deallocBlock
{
  AssertTrueOrReturn(tutorial);
  if([segue.identifier isEqualToString:kShowTutorialDetailsSegueName]) {
    UIViewController *destinationController = [segue destinationViewController];
    AssertTrueOrReturn([destinationController isKindOfClass:[TutorialDetailsViewController class]]);
    TutorialDetailsViewController *tutorialDetailsViewController = (TutorialDetailsViewController *)destinationController;
    tutorialDetailsViewController.tutorial = tutorial;
    tutorialDetailsViewController.onDeallocBlock = deallocBlock;
  }
}

@end
