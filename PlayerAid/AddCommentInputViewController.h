//
//  PlayerAid
//

@import UIKit;
@import TWCommonLib;
@class User;

NS_ASSUME_NONNULL_BEGIN

@interface AddCommentInputViewController : UIViewController

/**
 @param   completion  Completion block has bool parameter determining if post a comment was successful (if it is, textView is gonna get cleared
 */
@property (nonatomic, copy) void (^postButtonPressedBlock)(NSString *text, BlockWithBoolParameter completion);

NEW_AND_INIT_UNAVAILABLE

- (instancetype)initWithUser:(User *)user;

@end

NS_ASSUME_NONNULL_END