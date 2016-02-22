@import UIKit;


@interface CommentRepliesCellConfigurator : NSObject

- (UIView *)moreRepliesBarWithPressedActionTarget:(id)target selector:(SEL)selector;
- (UIView *)dummyHeaderView;

@end
