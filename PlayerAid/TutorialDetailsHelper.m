//
//  PlayerAid
//

@import KZAsserts;
@import BlocksKit;
@import MagicalRecord;
#import <TWCommonLib/TWCommonMacros.h>
#import <TWCommonLib/TWDispatchMacros.h>
#import "TutorialDetailsHelper.h"
#import "TutorialDetailsViewController.h"
#import "AlertFactory.h"
#import "AuthenticatedServerCommunicationController.h"
#import "TutorialsHelper.h"
#import "PlayerAid-Swift.h"
#import "DebugSettings.h"

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

- (void)prepareForTutorialDetailsSegue:(UIStoryboardSegue *)segue pushingTutorial:(Tutorial *)tutorial {
  AssertTrueOrReturn(tutorial);
  if([segue.identifier isEqualToString:kShowTutorialDetailsSegueName]) {
    UIViewController *destinationController = [segue destinationViewController];
    AssertTrueOrReturn([destinationController isKindOfClass:[TutorialDetailsViewController class]]);
    TutorialDetailsViewController *tutorialDetailsViewController = (TutorialDetailsViewController *)destinationController;
    tutorialDetailsViewController.tutorial = tutorial;
    tutorialDetailsViewController.hidesBottomBarWhenPushed = YES;
  }
}

#pragma mark - UIComponents

- (UIBarButtonItem *)editTutorialBarButtonItem:(Tutorial *)tutorial completion:(BlockWithBoolParameter)completion {
  AssertTrueOrReturnNil(tutorial.isInReview || tutorial.isPublished);

  // Technical debt: this method's implementation is waaaay too long, need to break it down

  VoidBlock yesAction = ^{
    VoidBlock changeTutorialStateBlock = ^() {
      [TutorialsHelper revertTutorialStateToDraft:tutorial];
      CallBlock(completion, YES);
    };
    
    if (DEBUG_OFFLINE_MODE) {
      changeTutorialStateBlock();
      return;
    }
    
    // TODO: make a network request that changes this tutorial state back to draft (I think this is still how it should work???)
    [[AuthenticatedServerCommunicationController sharedInstance].serverCommunicationController pullGuideBackFromReview:tutorial.serverIDValue completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
      DISPATCH_SYNC_ON_MAIN_THREAD(^{
        if (error) {
          // TODO: show specialised error instead!
          [AlertFactory showGenericErrorAlertViewNoRetry];
          CallBlock(completion, NO);
        } else {
          changeTutorialStateBlock();
        }
      });
    }];
  };

  VoidBlock eventHandler = nil;
  if (tutorial.isInReview) {
    eventHandler = ^{
      // TODO: confirm this alert copy
      [AlertFactory showPullInReviewBackToDraftAlertViewWithYesAction:yesAction];
    };
  } else if (tutorial.isPublished) {
    eventHandler = ^{
      [AlertFactory showPullPublishedBackToDraftAlertViewWithYesAction:yesAction];
    };
  }
  
  UIButton *button = [self customButtonWithTitle:@"Edit" eventHandler:eventHandler];
  return [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (UIBarButtonItem *)reportTutorialBarButtonItem:(Tutorial *)tutorial {
  AssertTrueOrReturnNil(tutorial);

  UIButton *reportButton = [self customButtonWithTitle:@"Report" eventHandler:^{
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
  }];

  reportButton.titleLabel.alpha = 0.5;
  return [[UIBarButtonItem alloc] initWithCustomView:reportButton];
}

- (UIButton *)customButtonWithTitle:(NSString *)title eventHandler:(VoidBlock)handler {
  AssertTrueOrReturnNil(title.length > 0);
  AssertTrueOrReturnNil(handler);

  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setTitle:title forState:UIControlStateNormal];
  button.titleLabel.font = [UIFont systemFontOfSize:15.0];
  [button sizeToFit];

  [button bk_addEventHandler:^(id sender) {
    CallBlock(handler);
  } forControlEvents:UIControlEventTouchUpInside];

  return button;
}

@end
