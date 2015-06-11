//
//  PlayerAid
//

#import "User.h"


IB_DESIGNABLE @interface PlayerInfoView : UIView

@property (nonatomic, weak) User *user;
@property (nonatomic, copy) VoidBlock editButtonPressed;

@end
