//
//  PlayerAid
//

@import UIKit;
#import <TWCommonLib/TWCommonTypes.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditCommentInputViewController : UIViewController

@property (nonatomic, copy) VoidBlock cancelButtonAction;
@property (nonatomic, copy) void (^saveButtonAction)(NSString *editedMessageText);

- (void)setCommentText:(NSString *)commentText;

@end

NS_ASSUME_NONNULL_END