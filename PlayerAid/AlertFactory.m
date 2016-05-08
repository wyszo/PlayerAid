//
//  PlayerAid
//

@import FBSDKCoreKit;
@import TWCommonLib;
@import UIAlertView_Blocks;
@import KZAsserts;
#import "AlertFactory.h"

@implementation AlertFactory

#pragma mark - App Alerts

+ (UIAlertView *)showGenericErrorAlertView
{
  NSString *title = @"Communication Error";
  NSString *message = @"Unable to contact PlayerAid cloud. Please check Airplane Mode is off and you have an active Wi-Fi or mobile network connection. The app will continue to try to connect.";
  
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
  [alert show];
  return alert;
}

+ (UIAlertView *)showGenericErrorAlertViewNoRetry
{
  NSString *title = @"Communication Error";
  NSString *message = @"Unable to contact PlayerAid cloud. Please check Airplane Mode is off and you have an active Wi-Fi or mobile network connection.";
  
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
  [alert show];
  return alert;
}

+ (UIAlertView *)showCreateTutorialFillTutorialDetails
{
  return [self showOKAlertViewWithMessage:@"Please complete guide details"];
}

+ (UIAlertView *)showCreateTutorialSavingTutorialSteps
{
  return [self showOKAlertViewWithMessage:@"We automatically save your Guide as steps are added, so nothing you do is ever lost!"];
}

+ (UIAlertView *)showCreateTutorialNoTitleAlertView
{
  return [self showOKAlertViewWithMessage:@"Please name the guide"];
}

+ (UIAlertView *)showCreateTutorialNoSectionSelectedAlertView
{
  return [self showOKAlertViewWithMessage:@"Please choose a guide category"];
}

+ (UIAlertView *)showCreateTutorialNoImageAlertView
{
  return [self showOKAlertViewWithMessage:@"Please add a guide cover photo"];
}

+ (UIAlertView *)showOKCancelAlertViewWithTitle:(NSString *)title message:(NSString *)message okTitle:(NSString *)okTitle okAction:(void (^)())okAction cancelAction:(void (^)())cancelAction
{
  return [self showTwoButtonsAlertViewWithTitle:title message:message firstButtonTitle:okTitle firstButtonAction:okAction secondButtonTitle:@"Cancel" secondAction:cancelAction];
}

+ (UIAlertView *)showCancelOKAlertViewWithTitle:(NSString *)title message:(NSString *)message okTitle:(NSString *)okTitle cancelAction:(void (^)())cancelAction okAction:(void (^)())okAction
{
  return [self showTwoButtonsAlertViewWithTitle:title message:message firstButtonTitle:@"Cancel" firstButtonAction:cancelAction secondButtonTitle:okTitle secondAction:okAction];
}

+ (UIAlertView *)showTwoButtonsAlertViewWithTitle:(NSString *)title message:(NSString *)message firstButtonTitle:(NSString *)firstButtonTitle firstButtonAction:(VoidBlock)firstAction secondButtonTitle:(NSString *)secondButtonTitle secondAction:(VoidBlock)secondAction
{
  return [TWAlertFactory showTwoButtonsAlertViewWithTitle:title message:message firstButtonTitle:firstButtonTitle firstButtonAction:firstAction secondButtonTitle:secondButtonTitle secondAction:secondAction];
}

+ (UIAlertView *)showRemoveNewTutorialTextStepConfirmationAlertViewWithCompletion:(void (^)(BOOL discard))completionBlock
{
  NSString *message = @"Cancel guide step?";
  return [self showTwoButtonsAlertViewWithTitle:nil message:message firstButtonTitle:@"Yes, cancel" firstButtonAction:^{
    CallBlock(completionBlock, YES);
  } secondButtonTitle:@"No, continue editing" secondAction:^{
    CallBlock(completionBlock, NO);
  }];
}

+ (UIAlertView *)showCancelEditingExistingTutorialStepConfirmationAlertViewWithCompletion:(void (^)(BOOL discard))completionBlock
{
  NSString *message = @"Cancel editing guide step?";
  return [self showTwoButtonsAlertViewWithTitle:nil message:message firstButtonTitle:@"Yes, cancel" firstButtonAction:^{
    CallBlock(completionBlock, YES);
  } secondButtonTitle:@"No, continue editing" secondAction:^{
    CallBlock(completionBlock, NO);
  }];
}

+ (UIAlertView *)showRemoveNewTutorialConfirmationAlertViewWithCompletion:(void (^)(BOOL discard))completionBlock
{
  NSString *message = @"Do you want to keep your guide?";
  
  RIButtonItem *deleteButtonItem = [RIButtonItem itemWithLabel:@"Delete" action:^{
    CallBlock(completionBlock, YES);
  }];
  RIButtonItem *saveButtonItem = [RIButtonItem itemWithLabel:@"Save as draft" action:^{
    CallBlock(completionBlock, NO);
  }];
  RIButtonItem *cancelButtonItem = [RIButtonItem itemWithLabel:@"Cancel" action:nil];
  
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message cancelButtonItem:nil otherButtonItems:deleteButtonItem, saveButtonItem, cancelButtonItem, nil];
  [alertView show];
  return alertView;
}

+ (UIAlertView *)showRemoveNewTutorialFinalConfirmationAlertViewWithCompletion:(void (^)(BOOL delete))completionBlock
{
  NSString *message = @"This will permanently delete your guide. Are you sure?";
  return [self showTwoButtonsAlertViewWithTitle:nil message:message firstButtonTitle:@"Yes" firstButtonAction:^{
    CallBlock(completionBlock, YES);
  } secondButtonTitle:@"Cancel" secondAction:^{
    CallBlock(completionBlock, NO);
  }];
}

#pragma mark - Edit draft tutorial alerts

+ (UIAlertView *)showDraftSaveChangesAlertViewWithYesAction:(VoidBlock)yesAction noAction:(VoidBlock)noAction
{
  NSString *message = @"Do you want to save your changes?";
  return [self showTwoButtonsAlertViewWithTitle:nil message:message firstButtonTitle:@"No" firstButtonAction:noAction secondButtonTitle:@"Yes" secondAction:yesAction];
}

+ (UIAlertView *)showThisWillDeleteChangesWithYesAction:(VoidBlock)yesAction
{
  NSString *message = @"This will permanently delete any changes. Are you sure?";
  return [self showTwoButtonsAlertViewWithTitle:nil message:message firstButtonTitle:@"Yes" firstButtonAction:yesAction secondButtonTitle:@"No" secondAction:nil];
}

#pragma mark - In-review guides

+ (UIAlertView *)showPullInReviewBackToDraftAlertViewWithYesAction:(VoidBlock)yesAction {
  NSString *message = @"This will cancel your Guide review and you'll have to resubmit after you make changes";
  return [self showTwoButtonsAlertViewWithTitle:nil message:message firstButtonTitle:@"Cancel" firstButtonAction:nil secondButtonTitle:@"Continue" secondAction:yesAction];
}

#pragma mark - Publish tutorial

+ (UIAlertView *)showFirstPublishedTutorialAlertViewWithOKAction:(ActionBlock)okAction
{
  NSString *message = @"Congratulations on creating your first guide!\n\nPlease note that once submitted, you will no longer be able to edit your guide.";
  
  UIAlertView *alert = [self showOKCancelAlertViewWithTitle:nil message:message okTitle:@"Publish" okAction:okAction cancelAction:nil];
  return alert;
}

+ (UIAlertView *)showTutorialInReviewInfoAlertView
{
  NSString *message = @"Only great guides are published on the PlayerAid platform. To maintain that quality, we review every single one. You will hear from the PlayerAid team within two days!";
  return [self showOKAlertViewWithMessage:message okButtonTitle:@"Got it"];
}

+ (UIAlertView *)showPublishingTutorialFailedAlertViewWithSaveAction:(VoidBlock)saveAction retryAction:(VoidBlock)retryAction
{
  NSString *message = @"Struggling to upload guide. Please try again now, or save as a draft and try later.";
  return [self showTwoButtonsAlertViewWithTitle:nil message:message firstButtonTitle:@"Save" firstButtonAction:saveAction secondButtonTitle:@"Retry" secondAction:retryAction];
}

#pragma mark - Delete tutorial

+ (UIAlertView *)showDeleteTutorialAlertConfirmationWithOkAction:(VoidBlock)okAction cancelAction:(VoidBlock)cancelAction
{
  NSString *title = @"Delete guide?";
  NSString *message = @"This will permanently delete your guide.";
  return [self showTwoButtonsAlertViewWithTitle:title message:message firstButtonTitle:@"Delete" firstButtonAction:okAction secondButtonTitle:@"Cancel" secondAction:cancelAction];
}

+ (UIAlertView *)showDeleteTutorialStepAlertConfirmationWithOKAction:(ActionBlock)okAction
{
  NSString *title = @"Delete guide step?";
  NSString *message = @"This will permanently delete your guide step.";
  UIAlertView *alert = [AlertFactory showOKCancelAlertViewWithTitle:title message:message okTitle:@"Delete" okAction:^{
    CallBlock(okAction);
  } cancelAction:nil];
  return alert;
}

#pragma mark - Edit profile alerts

+ (UIAlertView *)showUpdateAvatarFromFacebookFailureAlertView
{
  return [self showOKAlertViewWithMessage:@"Can't update from Facebook. Please check Airplane Mode is off and you have an active Wi-Fi or mobile network connection."];
}

#pragma mark - Other alerts

+ (UIAlertView *)showBlockingFirstSyncFailedAlertView
{
  NSString *title = @"Communication Error";
  NSString *message = @"\nUnable to contact PlayerAid cloud. Please check Airplane Mode is off and you have an active Wi-Fi or mobile network connection. The app will continue to try to connect. \n\nThe data has never been sync with PlayerAid cloud, can't continue until synchronisation succeeds! Retrying...";

  return [self blockingAlertWithTitle:title message:message];
}

+ (UIAlertView *)blockingAlertWithTitle:(NSString *)title message:(NSString *)message
{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message cancelButtonItem:nil otherButtonItems:nil];
  [alert show];
  return alert;
}

+ (UIAlertView *)showOKAlertViewWithMessage:(NSString *)message
{
  return [self showOKAlertViewWithMessage:message okButtonTitle:@"OK"];
}

+ (UIAlertView *)showOKAlertViewWithMessage:(NSString *)message okButtonTitle:(NSString *)okTitle
{
  return [TWAlertFactory showOKAlertViewWithMessage:message okButtonTitle:okTitle];
}

+ (UIAlertView *)showLogoutConfirmationAlertViewWithOKAction:(ActionBlock)okAction
{
  NSString *title = @"<DEBUG> Logout?";
  NSString *message = @"Logging out will permamently delete unsubmitted guide drafts [it wipes out all local data]. Continue?";
  UIAlertView *alert = [AlertFactory showOKCancelAlertViewWithTitle:title message:message okTitle:@"Logout" okAction:^{
    CallBlock(okAction);
  } cancelAction:nil];
  return alert;
}

+ (UIAlertView *)showReportTutorialAlertViewWithOKAction:(ActionBlock)okAction
{
  NSString *message = @"You are about to report this guide as inappropriate. Are you sure?";
  return [AlertFactory showTwoButtonsAlertViewWithTitle:nil message:message firstButtonTitle:@"Yes" firstButtonAction:okAction secondButtonTitle:@"No" secondAction:nil];
}

+ (UIAlertView *)showReportCommentAlertViewWithOKAction:(ActionBlock)okAction
{
  NSString *message = @"Are you sure you want to report this comment?";
  return [AlertFactory showTwoButtonsAlertViewWithTitle:nil message:message firstButtonTitle:@"Yes" firstButtonAction:okAction secondButtonTitle:@"No" secondAction:nil];
}

#pragma mark - Facebook errors

+ (UIAlertView *)showAlertFromFacebookError:(NSError *)error
{
  AssertTrueOrReturnNil(error);
  // Online FB errors documentation: https://developers.facebook.com/docs/ios/errors
  
  NSString *alertMessage = error.userInfo[FBSDKErrorLocalizedDescriptionKey];
  NSString *alertTitle = error.userInfo[FBSDKErrorLocalizedTitleKey];
  UIAlertView *alertView;
  
  if (alertMessage) {
    alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                           message:alertMessage
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    [alertView show];
  }
  return alertView;
}

@end
