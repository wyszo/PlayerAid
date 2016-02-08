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
    // That doesn't handle a situation when a comment has been marked as deleted - that call is invoked manually
    CallBlock(weakSelf.commentsCountChangedBlock, nil);
  }];
}

#pragma mark - public interface

- (UIAlertController *)otherUserCommentAlertController:(TutorialComment *)comment visitProfileAction:(VoidBlock)visitProfileAction {
  AssertTrueOrReturnNil(comment);
  AssertTrueOrReturnNil(visitProfileAction);

  return [AlertControllerFactory otherUserCommentActionControllerWithReportCommentAction:^() {
    [self reportCommentShowConfirmationAlert:comment];
  } visitProfileAction:visitProfileAction];
}

- (UIAlertController *)editOrDeleteCommentActionSheet:(TutorialComment *)comment withTableViewCell:(UITableViewCell *)cell editCommentAction:(EditCommentBlock)editCommentAction {
  AssertTrueOrReturnNil(comment);
  AssertTrueOrReturnNil(cell);
  AssertTrueOrReturnNil(editCommentAction);
  
  UIAlertController *actionSheet = [AlertControllerFactory editDeleteCommentActionControllerWithEditAction:^{
    [cell setHighlighted:YES];
    
    VoidBlock didFinishEditingCommentCompletionBlock = ^(){
      /**
       Normally comments tableView cells would be reused, so we wouldn't know if the cell reference is pointing to the same cell as initially. However, because comments are in the TutorialDetails tableView footer, cell reuse mechanism is not used. Moreover even if cell reference would be pointing to another cell, setting highlight to NO on another cell is fine. That would also mean that cell reusing is in place. And if that would be the case, correct highlight would also be set on cell reuse (from the viewController that handles comments tableView).
       */      
      [cell setHighlighted:NO];
    };
    
    CallBlock(editCommentAction, comment, cell.frame, didFinishEditingCommentCompletionBlock);
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
      [AlertFactory showGenericErrorAlertViewNoRetry];
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
  
  defineWeakSelf();
  [AlertFactory showReportCommentAlertViewWithOKAction:^{
    [[AuthenticatedServerCommunicationController sharedInstance] reportCommentAsInappropriate:comment completion:^(NSHTTPURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
      if (error) {
        [AlertFactory showGenericErrorAlertViewNoRetry];
      }
      else {
        NSDictionary *commentDictionary = (NSDictionary *)responseObject;
        [[TutorialCommentParsingHelper new] saveCommentFromDictionary:commentDictionary];
        CallBlock(weakSelf.commentsCountChangedBlock); // hasComments property not changed, need to manually invoke callback
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
      NSDictionary *commentDictionary = (NSDictionary *)responseObject;
      [[TutorialCommentParsingHelper new] saveCommentFromDictionary:commentDictionary];
      CallBlock(weakSelf.commentsCountChangedBlock); // hasComments property not changed, need to manually invoke callback
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
