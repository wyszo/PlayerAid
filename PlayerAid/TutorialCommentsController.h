//
//  PlayerAid
//

@import Foundation;
@import TWCommonLib;
#import "Tutorial.h"

@interface TutorialCommentsController : NSObject

- (nonnull instancetype)initWithTutorial:(nonnull Tutorial *)tutorial commentsCountChangedBlock:(nullable VoidBlock)commentsCountChangedBlock;

- (void)sendACommentWithText:(nonnull NSString *)text;

@end
