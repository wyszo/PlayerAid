//
//  PlayerAid
//


typedef void (^ActionBlock)() ;

/**
 TODO: Technical debt - using UIAlertViews instead of UIAlertControllers
 */
@interface AlertFactory : NSObject

+ (UIAlertView *)showGenericErrorAlertView;
+ (UIAlertView *)showGenericErrorAlertViewNoRetry;

// Universal alerts
+ (UIAlertView *)showOKCancelAlertViewWithTitle:(NSString *)title message:(NSString *)message okTitle:(NSString *)okTitle okAction:(void (^)())okAction cancelAction:(void (^)())cancelAction;
+ (UIAlertView *)showTwoButtonsAlertViewWithTitle:(NSString *)title message:(NSString *)message defaultButtonTitle:(NSString *)okTitle defaultButtonAction:(void (^)())okAction secondaryButtonTitle:(NSString *)cancelTitle secondaryButtonAction:(void (^)())cancelAction;
+ (UIAlertView *)showTwoButtonsAlertViewWithTitle:(NSString *)title message:(NSString *)message firstButtonTitle:(NSString *)firstButtonTitle firstButtonAction:(VoidBlock)firstAction secondButtonTitle:(NSString *)secondButtonTitle secondAction:(VoidBlock)secondAction;

// Create tutorial alerts
+ (UIAlertView *)showCreateTutorialNoTitleAlertView;
+ (UIAlertView *)showCreateTutorialNoSectionSelectedAlertView;
+ (UIAlertView *)showCreateTutorialNoImageAlertView;
+ (UIAlertView *)showCreateTutorialFillTutorialDetails;

+ (UIAlertView *)showRemoveNewTutorialTextStepConfirmationAlertViewWithCompletion:(void (^)(BOOL discard))completionBlock;
+ (UIAlertView *)showCancelEditingExistingTutorialStepConfirmationAlertViewWithCompletion:(void (^)(BOOL discard))completionBlock;

+ (UIAlertView *)showRemoveNewTutorialConfirmationAlertViewWithCompletion:(void (^)(BOOL discard))completionBlock;
+ (UIAlertView *)showRemoveNewTutorialFinalConfirmationAlertViewWithCompletion:(void (^)(BOOL delete))completionBlock;

// Publish tutorial alerts
+ (UIAlertView *)showFirstPublishedTutorialAlertViewWithOKAction:(ActionBlock)okAction;
+ (UIAlertView *)showTutorialInReviewInfoAlertView;
+ (UIAlertView *)showPublishingTutorialFailedAlertViewWithSaveAction:(VoidBlock)saveAction retryAction:(VoidBlock)retryAction;

// Delete tutorial alerts
+ (UIAlertView *)showDeleteTutorialAlertConfirmationWithOkAction:(ActionBlock)okAction cancelAction:(ActionBlock)cancelAction;
+ (UIAlertView *)showDeleteTutorialStepAlertConfirmationWithOKAction:(ActionBlock)okAction;

// Edit profile alerts
+ (UIAlertView *)showUpdateAvatarFromFacebookFailureAlertView;

// Other alerts
+ (UIAlertView *)showBlockingFirstSyncFailedAlertView;
+ (UIAlertView *)showOKAlertViewWithMessage:(NSString *)message;
+ (UIAlertView *)showLogoutConfirmationAlertViewWithOKAction:(ActionBlock)okAction;

// Facebook alerts
+ (UIAlertView *)showAlertFromFacebookError:(NSError *)error;

@end