//
//  PlayerAid
//

@import UIKit;
@import Foundation;
#import "User.h"
#import <TWCommonLib/TWCommonTypes.h>

IB_DESIGNABLE
@interface PlayerInfoView : UIView

@property (nonatomic, weak) User *user;
@property (nonatomic, copy) VoidBlock editButtonPressed;
@property (nonatomic, copy) VoidBlock backButtonPressed;

- (void)setBackButtonHidden:(BOOL)hidden;

@end
