//
//  PlayerAid
//

IB_DESIGNABLE
@interface CreateTutorialStepButton : UIView

- (void)configureWithTitle:(NSString *)title imageNamed:(NSString *)imageName actionBlock:(VoidBlock)action;

@end
