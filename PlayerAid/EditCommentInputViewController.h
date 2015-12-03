//
//  PlayerAid
//

@import UIKit;
#import <TWCommonLib/TWCommonTypes.h>
@class TutorialComment;

NS_ASSUME_NONNULL_BEGIN

@interface EditCommentInputViewController : UIViewController

@property (nonatomic, copy) VoidBlock cancelButtonAction;
@property (nonatomic, copy) void (^saveButtonAction)(NSString *editedMessageText);
@property (nonatomic, copy) TutorialComment *comment;

- (void)setInputViewToFirstResponder;
- (void)hideKeyboard;

@end

NS_ASSUME_NONNULL_END