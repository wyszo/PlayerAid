//
//  PlayerAid
//

@import KZAsserts;
@import BlocksKit;
@import TWCommonLib;
@import MagicalRecord;
#import "TutorialCommentsController.h"
#import "AuthenticatedServerCommunicationController.h"
#import "TutorialsHelper.h"
#import "AlertFactory.h"
#import "AlertControllerFactory.h"
#import "TutorialCommentParsingHelper.h"

@interface TutorialCommentsController()
@property (strong, nonatomic) Tutorial *tutorial;
@property (copy, nonatomic) VoidBlock commentsCountChangedBlock;
@end

@implementation TutorialCommentsController

#pragma mark - Init

- (nonnull instancetype)initWithTutorial:(nonnull Tutorial *)tutorial commentsCountChangedBlock:(nullable VoidBlock)commentsCountChangedBlock
{
  AssertTrueOrReturnNil(tutorial);
  
  self = [super init];
  if (self) {
    _tutorial = tutorial;
    _commentsCountChangedBlock = commentsCountChangedBlock;
    [self setupCommentsChangedCallback];
  }
  return self;
}

- (void)setupCommentsChangedCallback
{
  if (!self.commentsCountChangedBlock) {
    return;
  }
  
  defineWeakSelf();
  [self bk_addObserverForKeyPath:@"tutorial.hasComments" task:^(id target) {
    CallBlock(weakSelf.commentsCountChangedBlock, nil);
  }];
}

#pragma mark - public interface

- (UIAlertController *)reportCommentAlertController:(TutorialComment *)comment
{
  defineWeakSelf();
  return [AlertControllerFactory reportCommentActionControllerWithAction:^() {
    [weakSelf reportCommentShowConfirmationAlert:comment];
  }];
}

- (UIAlertController *)editOrDeleteCommentActionSheet:(TutorialComment *)comment withTableViewCell:(UITableViewCell *)cell editCommentAction:(EditCommentBlock)editCommentAction
{
  AssertTrueOrReturnNil(comment);
  AssertTrueOrReturnNil(cell);
  AssertTrueOrReturnNil(editCommentAction);
  
  UIAlertController *actionSheet = [AlertControllerFactory editDeleteCommentActionControllerWithEditAction:^{
    [cell setSelected:YES];
    
    VoidBlock didFinishEditingCommentCompletionBlock = ^(){
      [cell setSelected:NO];
    };
    
    CallBlock(editCommentAction, comment, didFinishEditingCommentCompletionBlock);
  } removeAction:^{
    [self sendRemoveCommentNetworkRequest:comment];
  }];
  return actionSheet;
}

#pragma mark - private

- (void)sendACommentWithText:(NSString *)text completion:(nullable BlockWithBoolParameter)completion
{
  AssertTrueOrReturn(text.length);
  AssertTrueOrReturn(self.tutorial);
  
  defineWeakSelf();
  [[AuthenticatedServerCommunicationController sharedInstance] addAComment:text toTutorial:self.tutorial completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
    if (error) {
      [AlertFactory showGenericErrorAlertView];
      BOOL success = false;
      CallBlock(completion, success);
    } else {
      AssertTrueOrReturn([responseObject isKindOfClass:[NSDictionary class]]);
      [weakSelf updateTutorialObjectFromDictionary:(NSDictionary *)responseObject];
      BOOL success = true;
      CallBlock(completion, success);
    }
  }];
}

- (void)editComment:(TutorialComment *)comment withText:(NSString *)text completion:(VoidBlockWithError)completion
{
  AssertTrueOrReturn(comment);
  AssertTrueOrReturn(text.length);
  AssertTrueOrReturn(completion);
  
  [[AuthenticatedServerCommunicationController sharedInstance] editComment:comment withText:text completion:^(NSHTTPURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
    if (error) {
      [AlertFactory showGenericErrorAlertViewNoRetry];
      CallBlock(completion, error);
    } else {
      NSDictionary *commentDictionary = (NSDictionary *)responseObject;
      [[TutorialCommentParsingHelper new] saveCommentFromDictionary:commentDictionary];
      CallBlock(completion, nil);
    }
  }];
}

- (void)reportCommentShowConfirmationAlert:(TutorialComment *)comment
{
  AssertTrueOrReturn(comment);
  
  [AlertFactory showReportCommentAlertViewWithOKAction:^{
    [[AuthenticatedServerCommunicationController sharedInstance] reportCommentAsInappropriate:comment completion:^(NSHTTPURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
      if (error) {
        [AlertFactory showGenericErrorAlertViewNoRetry];
      }
      else {
        // TODO: comment text should locally change to 'Comment was removed as inappropriate'
        
        // This needs to persist after fetching new comments! Need to introduce local array of comment ids reported as inappropriate by an user (not recommened). Or even better: handle this server-side, so server always returns the comment as flagged as inappropriate to a current user.
        // So ideally server should return a comment object in here with text changed to 'inappropriate'
      }
    }];
  }];
}

- (void)updateTutorialObjectFromDictionary:(nonnull NSDictionary *)dictionary
{
  [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
    [TutorialsHelper tutorialFromDictionary:dictionary parseAuthors:NO inContext:localContext];
  }];
}

#pragma mark - Removing a comment

- (void)sendRemoveCommentNetworkRequest:(nonnull TutorialComment *)comment
{
  defineWeakSelf();
  [[AuthenticatedServerCommunicationController sharedInstance] deleteComment:comment completion:^(NSHTTPURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
    if (error) {
      [AlertFactory showGenericErrorAlertViewNoRetry];
    } else {
      [weakSelf removeCommentFromCoreData:comment];
    }
  }];
}

- (void)removeCommentFromCoreData:(nonnull TutorialComment *)comment
{
  AssertTrueOrReturn(comment);
  [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
    [comment MR_deleteEntityInContext:localContext];
  }];
}

@end
