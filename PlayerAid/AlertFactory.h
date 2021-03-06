//
//  PlayerAid
//

@import UIKit;
#import <TWCommonLib/TWCommonTypes.h>

typedef void (^ActionBlock)() ;

/**
 TODO: Technical debt - using UIAlertViews instead of UIAlertControllers
 */
@interface AlertFactory : NSObject

+ (UIAlertView *)showGenericErrorAlertView;
+ (UIAlertView *)showGenericErrorAlertViewNoRetry;

// Universal alerts
+ (UIAlertView *)showOKCancelAlertViewWithTitle:(NSString *)title message:(NSString *)message okTitle:(NSString *)okTitle okAction:(void (^)())okAction cancelAction:(void (^)())cancelAction;
+ (UIAlertView *)showCancelOKAlertViewWithTitle:(NSString *)title message:(NSString *)message okTitle:(NSString *)okTitle cancelAction:(void (^)())cancelAction okAction:(void (^)())okAction;

// Create tutorial alerts
+ (UIAlertView *)showCreateTutorialNoTitleAlertView;
+ (UIAlertView *)showCreateTutorialNoSectionSelectedAlertView;
+ (UIAlertView *)showCreateTutorialNoImageAlertView;
+ (UIAlertView *)showCreateTutorialFillTutorialDetails;
+ (UIAlertView *)showCreateTutorialSavingTutorialSteps;

+ (UIAlertView *)showRemoveNewTutorialTextStepConfirmationAlertViewWithCompletion:(void (^)(BOOL discard))completionBlock;
+ (UIAlertView *)showCancelEditingExistingTutorialStepConfirmationAlertViewWithCompletion:(void (^)(BOOL discard))completionBlock;

+ (UIAlertView *)showRemoveNewTutorialConfirmationAlertViewWithCompletion:(void (^)(BOOL discard))completionBlock;
+ (UIAlertView *)showRemoveNewTutorialFinalConfirmationAlertViewWithCompletion:(void (^)(BOOL delete))completionBlock;

// Edit draft tutorial alerts
+ (UIAlertView *)showDraftSaveChangesAlertViewWithYesAction:(VoidBlock)yesAction noAction:(VoidBlock)noAction;
+ (UIAlertView *)showThisWillDeleteChangesWithYesAction:(VoidBlock)yesAction;

// Edit in-review/published tutorial alerts
+ (UIAlertView *)showPullInReviewBackToDraftAlertViewWithYesAction:(VoidBlock)yesAction;
+ (UIAlertView *)showPullPublishedBackToDraftAlertViewWithYesAction:(VoidBlock)yesAction;

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

// Reporting content
+ (UIAlertView *)showReportTutorialAlertViewWithOKAction:(ActionBlock)okAction;
+ (UIAlertView *)showReportCommentAlertViewWithOKAction:(ActionBlock)okAction;

// Facebook alerts
+ (nullable UIAlertView *)showAlertFromFacebookError:(nonnull NSError *)error;

@end