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

+ (UIAlertView *)showAlertViewWithMessage:(NSString *)message
{
  AssertTrueOrReturnNil(message.length);
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
  [alert show];
  return alert;
}

+ (UIAlertView *)showOKCancelAlertViewWithTitle:(NSString *)title message:(NSString *)message okTitle:(NSString *)okTitle okAction:(void (^)())okAction cancelAction:(void (^)())cancelAction
{
  return [self showTwoButtonsAlertViewWithTitle:title message:message defaultButtonTitle:okTitle defaultButtonAction:okAction secondaryButtonTitle:nil secondaryButtonAction:cancelAction];
}

+ (UIAlertView *)showTwoButtonsAlertViewWithTitle:(NSString *)title message:(NSString *)message defaultButtonTitle:(NSString *)okTitle defaultButtonAction:(void (^)())okAction secondaryButtonTitle:(NSString *)cancelTitle secondaryButtonAction:(void (^)())cancelAction
{
  AssertTrueOrReturnNil(message.length || title.length);
  
  NSString *cancelTitleText = @"Cancel";
  if (cancelTitle.length) {
    cancelTitleText = cancelTitle;
  }
  RIButtonItem *cancelButtonItem = [RIButtonItem itemWithLabel:cancelTitleText action:^{
    CallBlock(cancelAction);
  }];
  
  NSString *okTitleText = @"OK";
  if (okTitleText.length) {
    okTitleText = okTitle;
  }
  RIButtonItem *okButtonItem = [RIButtonItem itemWithLabel:okTitleText action:^{
    CallBlock(okAction);
  }];
  
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message cancelButtonItem:cancelButtonItem otherButtonItems:okButtonItem, nil];
  [alertView show];
  return alertView;
}

+ (UIAlertView *)showRemoveNewTutorialTextStepConfirmationAlertViewWithCompletion:(void (^)(BOOL discard))completionBlock
{
  NSString *message = @"Cancel tutorial step?";
  return [self showTwoButtonsAlertViewWithTitle:nil message:message defaultButtonTitle:@"Yes, cancel" defaultButtonAction:^{
    CallBlock(completionBlock, YES);
  } secondaryButtonTitle:@"No, continue editing" secondaryButtonAction:^{
    CallBlock(completionBlock, NO);
  }];
}

+ (UIAlertView *)showCancelEditingExistingTutorialStepConfirmationAlertViewWithCompletion:(void (^)(BOOL discard))completionBlock
{
  NSString *message = @"Cancel editing tutorial step?";
  return [self showTwoButtonsAlertViewWithTitle:nil message:message defaultButtonTitle:@"Yes, cancel" defaultButtonAction:^{
    CallBlock(completionBlock, YES);
  } secondaryButtonTitle:@"No, continue editing" secondaryButtonAction:^{
    CallBlock(completionBlock, NO);
  }];
}

+ (UIAlertView *)showRemoveNewTutorialConfirmationAlertViewWithCompletion:(void (^)(BOOL discard))completionBlock
{
  NSString *message = @"Do you want to keep your tutorial?";
  return [self showTwoButtonsAlertViewWithTitle:nil message:message defaultButtonTitle:@"Save as draft" defaultButtonAction:^{
    CallBlock(completionBlock, NO);
  } secondaryButtonTitle:@"Delete" secondaryButtonAction:^{
    CallBlock(completionBlock, YES);
  }];
}

+ (UIAlertView *)showRemoveNewTutorialFinalConfirmationAlertViewWithCompletion:(void (^)(BOOL delete))completionBlock
{
  NSString *message = @"This will permanently delete your tutorial. Are you sure?";
  return [self showTwoButtonsAlertViewWithTitle:nil message:message defaultButtonTitle:@"Cancel" defaultButtonAction:^{
    CallBlock(completionBlock, NO);
  } secondaryButtonTitle:@"Yes" secondaryButtonAction:^{
    CallBlock(completionBlock, YES);
  }];
}

#pragma mark - Publish tutorial

+ (UIAlertView *)showFirstPublishedTutorialAlertViewWithOKAction:(ActionBlock)okAction
{
  NSString *message = @"Congratulations on creating your first tutorial!\nPlease note that once submitted, you will no longer be able to edit your tutorial.";
  
  UIAlertView *alert = [self showOKCancelAlertViewWithTitle:nil message:message okTitle:@"Publish" okAction:okAction cancelAction:nil];
  return alert;
}

+ (UIAlertView *)showTutorialInReviewInfoAlertView
{
  NSString *message = @"Only great tutorials are published on the PlayerAid platform.\nTo maintain that quality, we review every single one.\nYou will hear from the PlayerAid team within two days!  ";
  return [self showOKAlertViewWithMessage:message okButtonTitle:@"Got it"];
}

#pragma mark - Delete tutorial

+ (UIAlertView *)showDeleteTutorialAlertConfirmationWithOkAction:(void (^)())okAction cancelAction:(void (^)())cancelAction
{
  NSString *title = @"Delete tutorial?";
  NSString *message = @"This will permanently delete your tutorial.";
  UIAlertView *alert = [AlertFactory showOKCancelAlertViewWithTitle:title message:message okTitle:@"Delete" okAction:^{
    CallBlock(okAction);
  } cancelAction:^{
    CallBlock(cancelAction);
  }];
  return alert;
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
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:okTitle otherButtonTitles:nil];
  [alert show];
  return alert;
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
