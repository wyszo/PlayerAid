//
//  PlayerAid
//


typedef void (^ActionBlock)() ;


@interface AlertFactory : NSObject

+ (UIAlertView *)showGenericErrorAlertView;
+ (UIAlertView *)showGenericErrorAlertViewNoRetry;

// Create tutorial alerts
+ (UIAlertView *)showCreateTutorialNoTitleAlertView;
+ (UIAlertView *)showCreateTutorialNoSectionSelectedAlertView;
+ (UIAlertView *)showCreateTutorialNoImageAlertView;
+ (UIAlertView *)showCreateTutorialFillTutorialDetails;
+ (UIAlertView *)showOKCancelAlertViewWithTitle:(NSString *)title message:(NSString *)message okTitle:(NSString *)okTitle okAction:(ActionBlock)okAction cancelAction:(ActionBlock)cancelAction;
+ (UIAlertView *)showRemoveNewTutorialTextStepConfirmationAlertViewWithCompletion:(void (^)(BOOL discard))completionBlock;
+ (UIAlertView *)showRemoveNewTutorialConfirmationAlertViewWithCompletion:(void (^)(BOOL discard))completionBlock;

// Publish tutorial alerts
+ (UIAlertView *)showFirstPublishedTutorialAlertViewWithOKAction:(ActionBlock)okAction;
+ (UIAlertView *)showTutorialInReviewInfoAlertView;

// Delete tutorial alerts
+ (UIAlertView *)showDeleteTutorialAlertConfirmationWithOkAction:(ActionBlock)okAction cancelAction:(ActionBlock)cancelAction;
+ (UIAlertView *)showDeleteTutorialStepAlertConfirmationWithOKAction:(ActionBlock)okAction;

// Other alerts
+ (UIAlertView *)showBlockingFirstSyncFailedAlertView;
+ (UIAlertView *)showOKAlertViewWithMessage:(NSString *)message;
+ (UIAlertView *)showLogoutConfirmationAlertViewWithOKAction:(ActionBlock)okAction;

// Facebook alerts
+ (UIAlertView *)showAlertFromFacebookError:(NSError *)error;

@end