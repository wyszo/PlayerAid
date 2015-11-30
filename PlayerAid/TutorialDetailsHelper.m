//
//  PlayerAid
//

@import KZAsserts;
@import BlocksKit;
@import MagicalRecord;
#import "TutorialDetailsHelper.h"
#import "TutorialDetailsViewController.h"
#import "AlertFactory.h"
#import "AuthenticatedServerCommunicationController.h"
#import "TutorialsHelper.h"

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
    tutorialDetailsViewController.hidesBottomBarWhenPushed = YES;
  }
}

#pragma mark - UIComponents

- (UIBarButtonItem *)reportTutorialBarButtonItem:(Tutorial *)tutorial
{
  AssertTrueOrReturnNil(tutorial);
  UIButton *reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [reportButton setTitle:@"Report" forState:UIControlStateNormal];
  [reportButton sizeToFit];
  [reportButton bk_addEventHandler:^(id sender) {
    [AlertFactory showReportTutorialAlertViewWithOKAction:^{
      [[AuthenticatedServerCommunicationController sharedInstance] reportTutorial:tutorial completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
        if (error) {
          [AlertFactory showGenericErrorAlertViewNoRetry];
        } else {
          AssertTrueOrReturn([responseObject isKindOfClass:[NSDictionary class]]);
          NSDictionary *reportedTutorialDictionary = (NSDictionary *)responseObject;
          
          [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            [TutorialsHelper tutorialFromDictionary:reportedTutorialDictionary parseAuthors:NO inContext:localContext];
          }];
        }
      }];
    }];
  } forControlEvents:UIControlEventTouchUpInside];
  
  reportButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
  reportButton.titleLabel.alpha = 0.5;

  return [[UIBarButtonItem alloc] initWithCustomView:reportButton];
}

@end
