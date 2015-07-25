//
//  PlayerAid
//

#import <FacebookSDK.h>
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
  return [self showOKAlertViewWithMessage:@"Please complete tutorial details"];
}

+ (UIAlertView *)showCreateTutorialNoTitleAlertView
{
  return [self showOKAlertViewWithMessage:@"Please name the tutorial"];
}

+ (UIAlertView *)showCreateTutorialNoSectionSelectedAlertView
{
  return [self showOKAlertViewWithMessage:@"Please choose a tutorial category"];
}

+ (UIAlertView *)showCreateTutorialNoImageAlertView
{
  return [self showOKAlertViewWithMessage:@"Please add a tutorial cover photo"];
}

+ (UIAlertView *)showOKCancelAlertViewWithTitle:(NSString *)title message:(NSString *)message okTitle:(NSString *)okTitle okAction:(void (^)())okAction cancelAction:(void (^)())cancelAction
{
  return [self showTwoButtonsAlertViewWithTitle:title message:message firstButtonTitle:okTitle firstButtonAction:okAction secondButtonTitle:@"Cancel" secondAction:cancelAction];
}

+ (UIAlertView *)showTwoButtonsAlertViewWithTitle:(NSString *)title message:(NSString *)message firstButtonTitle:(NSString *)firstButtonTitle firstButtonAction:(VoidBlock)firstAction secondButtonTitle:(NSString *)secondButtonTitle secondAction:(VoidBlock)secondAction
{
  return [TWAlertFactory showTwoButtonsAlertViewWithTitle:title message:message firstButtonTitle:firstButtonTitle firstButtonAction:firstAction secondButtonTitle:secondButtonTitle secondAction:secondAction];
}

+ (UIAlertView *)showRemoveNewTutorialTextStepConfirmationAlertViewWithCompletion:(void (^)(BOOL discard))completionBlock
{
  NSString *message = @"Cancel tutorial step?";
  return [self showTwoButtonsAlertViewWithTitle:nil message:message firstButtonTitle:@"Yes, cancel" firstButtonAction:^{
    CallBlock(completionBlock, YES);
  } secondButtonTitle:@"No, continue editing" secondAction:^{
    CallBlock(completionBlock, NO);
  }];
}

+ (UIAlertView *)showCancelEditingExistingTutorialStepConfirmationAlertViewWithCompletion:(void (^)(BOOL discard))completionBlock
{
  NSString *message = @"Cancel editing tutorial step?";
  return [self showTwoButtonsAlertViewWithTitle:nil message:message firstButtonTitle:@"Yes, cancel" firstButtonAction:^{
    CallBlock(completionBlock, YES);
  } secondButtonTitle:@"No, continue editing" secondAction:^{
    CallBlock(completionBlock, NO);
  }];
}

+ (UIAlertView *)showRemoveNewTutorialConfirmationAlertViewWithCompletion:(void (^)(BOOL discard))completionBlock
{
  NSString *message = @"Do you want to keep your tutorial?";
  
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
  NSString *message = @"This will permanently delete your tutorial. Are you sure?";
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

#pragma mark - Publish tutorial

+ (UIAlertView *)showFirstPublishedTutorialAlertViewWithOKAction:(ActionBlock)okAction
{
  NSString *message = @"Congratulations on creating your first tutorial!\n\nPlease note that once submitted, you will no longer be able to edit your tutorial.";
  
  UIAlertView *alert = [self showOKCancelAlertViewWithTitle:nil message:message okTitle:@"Publish" okAction:okAction cancelAction:nil];
  return alert;
}

+ (UIAlertView *)showTutorialInReviewInfoAlertView
{
  NSString *message = @"Only great tutorials are published on the PlayerAid platform. To maintain that quality, we review every single one. You will hear from the PlayerAid team within two days!";
  return [self showOKAlertViewWithMessage:message okButtonTitle:@"Got it"];
}

+ (UIAlertView *)showPublishingTutorialFailedAlertViewWithSaveAction:(VoidBlock)saveAction retryAction:(VoidBlock)retryAction
{
  NSString *message = @"Struggling to upload tutorial. Please try again now, or save as a draft and try later.";
  return [self showTwoButtonsAlertViewWithTitle:nil message:message firstButtonTitle:@"Save" firstButtonAction:saveAction secondButtonTitle:@"Retry" secondAction:retryAction];
}

#pragma mark - Delete tutorial

+ (UIAlertView *)showDeleteTutorialAlertConfirmationWithOkAction:(VoidBlock)okAction cancelAction:(VoidBlock)cancelAction
{
  NSString *title = @"Delete tutorial?";
  NSString *message = @"This will permanently delete your tutorial.";
  return [self showTwoButtonsAlertViewWithTitle:title message:message firstButtonTitle:@"Delete" firstButtonAction:okAction secondButtonTitle:@"Cancel" secondAction:cancelAction];
}

+ (UIAlertView *)showDeleteTutorialStepAlertConfirmationWithOKAction:(ActionBlock)okAction
{
  NSString *title = @"Delete tutorial step?";
  NSString *message = @"This will permanently delete your tutorial step.";
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
  NSString *message = @"Logging out will permamently delete unsubmitted tutorial drafts [it wipes out all local data]. Continue?";
  UIAlertView *alert = [AlertFactory showOKCancelAlertViewWithTitle:title message:message okTitle:@"Logout" okAction:^{
    CallBlock(okAction);
  } cancelAction:nil];
  return alert;
}

#pragma mark - Facebook
// TODO: this should be extracted to a separate class

// error handling code source: https://developers.facebook.com/docs/facebook-login/ios/v2.2
+ (UIAlertView *)showAlertFromFacebookError:(NSError *)error
{
  NSString *alertMessage, *alertTitle;
  UIAlertView *alertView;
  
  // If the user should perform an action outside of you app to recover,
  // the SDK will provide a message for the user, you just need to surface it.
  // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
  if ([FBErrorUtility shouldNotifyUserForError:error]) {
    alertTitle = @"Facebook error";
    alertMessage = [FBErrorUtility userMessageForError:error];
    
    // This code will handle session closures that happen outside of the app
    // You can take a look at our error handling guide to know more about it
    // https://developers.facebook.com/docs/ios/errors
  } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
    alertTitle = @"Session Error";
    alertMessage = @"Your current session is no longer valid. Please log in again.";
    
    // If the user has cancelled a login, we will do nothing.
    // You can also choose to show the user a message if cancelling login will result in
    // the user not being able to complete a task they had initiated in your app
    // (like accessing FB-stored information or posting to Facebook)
  } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
    NSLog(@"user cancelled login");
    
    // For simplicity, this sample handles other errors with a generic message
    // You can checkout our error handling guide for more detailed information
    // https://developers.facebook.com/docs/ios/errors
  } else {
    alertTitle  = @"Something went wrong";
    alertMessage = @"Please try again later.";
    NSLog(@"Unexpected error:%@", error);
  }
  
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
