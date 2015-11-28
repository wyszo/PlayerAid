//
//  PlayerAid
//

@import UIKit;
@import TWCommonLib;
#import "Tutorial.h"
@class TutorialComment;

typedef void (^EditCommentBlock)(NSString * _Nonnull commentText);


NS_ASSUME_NONNULL_BEGIN

@interface TutorialCommentsController : NSObject

- (instancetype)initWithTutorial:(Tutorial *)tutorial commentsCountChangedBlock:(nullable VoidBlock)commentsCountChangedBlock;

- (void)sendACommentWithText:(NSString *)text completion:(nullable BlockWithBoolParameter)completion;

- (UIAlertController *)editOrDeleteCommentActionSheet:(TutorialComment *)comment withTableViewCell:(UITableViewCell *)cell editCommentAction:(EditCommentBlock)editCommentAction;

- (UIAlertController *)reportCommentAlertController:(TutorialComment *)comment;

@end

NS_ASSUME_NONNULL_END
