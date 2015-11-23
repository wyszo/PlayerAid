//
//  PlayerAid
//

@import Foundation;
@import TWCommonLib;
#import "Tutorial.h"
@class TutorialComment;

NS_ASSUME_NONNULL_BEGIN

@interface TutorialCommentsController : NSObject

- (instancetype)initWithTutorial:(Tutorial *)tutorial commentsCountChangedBlock:(nullable VoidBlock)commentsCountChangedBlock;

- (void)sendACommentWithText:(NSString *)text completion:(nullable BlockWithBoolParameter)completion;

- (void)reportCommentShowConfirmationAlert:(TutorialComment *)comment;

@end

NS_ASSUME_NONNULL_END
