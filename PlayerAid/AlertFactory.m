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

+ (UIAlertView *)showCreateTutorialNoTitleAlertView
{
  return [self showAlertViewWithMessage:@"Tutorial needs to have a title"];
}

+ (UIAlertView *)showCreateTutorialNoSectionSelectedAlertView
{
  return [self showAlertViewWithMessage:@"You need to select tutorial category first"];
}

+ (UIAlertView *)showAlertViewWithMessage:(NSString *)message
{
  AssertTrueOrReturnNil(message.length);
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
  [alert show];
  return alert;
}

+ (UIAlertView *)showOKCancelAlertViewWithMessage:(NSString *)message okTitle:(NSString *)okTitle okAction:(void (^)())okAction cancelAction:(void (^)())cancelAction
{
  AssertTrueOrReturnNil(message.length);
  
  RIButtonItem *cancelButtonItem = [RIButtonItem itemWithLabel:@"Cancel" action:^{
    if (cancelAction) {
      cancelAction();
    }
  }];
  
  if (okTitle.length == 0) {
    okTitle = @"OK";
  }
  RIButtonItem *okButtonItem = [RIButtonItem itemWithLabel:okTitle action:^{
    if (okAction) {
      okAction();
    }
  }];
  
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message cancelButtonItem:cancelButtonItem otherButtonItems:okButtonItem, nil];
  [alertView show];
  return alertView;
}

+ (UIAlertView *)showRemoveNewTutorialTextStepConfirmationAlertViewWithCompletion:(void (^)(BOOL discard))completionBlock
{
  RIButtonItem *cancelButtonItem = [RIButtonItem itemWithLabel:@"No" action:^{
    if (completionBlock) {
      completionBlock(NO);
    }
  }];
  RIButtonItem *confirmButtonItem = [RIButtonItem itemWithLabel:@"YES, remove it" action:^{
    if (completionBlock) {
      completionBlock(YES);
    }
  }];
  
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Remove tutorial step?" cancelButtonItem:cancelButtonItem otherButtonItems:confirmButtonItem, nil];
  [alert show];
  return alert;
}

#pragma mark - Delete tutorial

+ (UIAlertView *)showDeleteTutorialAlertConfirmationWithOkAction:(void (^)())okAction cancelAction:(void (^)())cancelAction
{
  NSString *message = @"Are you sure you wish to delete this tutorial? This action cannot be undone!";
  UIAlertView *alert = [AlertFactory showOKCancelAlertViewWithMessage:message okTitle:@"Yes, delete tutorial" okAction:^{
    if (okAction) {
      okAction();
    }
  } cancelAction:^{
    if (cancelAction) {
      cancelAction();
    }
  }];
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
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [alert show];
  return alert;
}

#pragma mark - Facebook

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
