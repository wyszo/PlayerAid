//
//  PlayerAid
//


@interface AlertFactory : NSObject

+ (UIAlertView *)showGenericErrorAlertView;
+ (UIAlertView *)showGenericErrorAlertViewNoRetry;

// Create tutorial alerts
+ (UIAlertView *)showCreateTutorialNoTitleAlertView;
+ (UIAlertView *)showCreateTutorialNoSectionSelectedAlertView;
+ (UIAlertView *)showOKCancelAlertViewWithMessage:(NSString *)message okTitle:(NSString *)okTitle okAction:(void (^)())okAction cancelAction:(void (^)())cancelAction;
+ (UIAlertView *)showRemoveNewTutorialTextStepConfirmationAlertViewWithCompletion:(void (^)(BOOL discard))completionBlock;

// Delete tutorial alerts
+ (UIAlertView *)showDeleteTutorialAlertConfirmationWithOkAction:(void (^)())okAction cancelAction:(void (^)())cancelAction;

// Other alerts
+ (UIAlertView *)showBlockingFirstSyncFailedAlertView;
+ (UIAlertView *)showOKAlertViewWithMessage:(NSString *)message;

// Facebook alerts
+ (UIAlertView *)showAlertFromFacebookError:(NSError *)error;

@end