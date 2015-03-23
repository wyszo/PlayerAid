//
//  PlayerAid
//

IB_DESIGNABLE
@interface CreateTutorialStepButton : UIView

@property (nonatomic, assign) BOOL separatorHidden;

- (void)configureWithTitle:(NSString *)title imageNamed:(NSString *)imageName actionBlock:(VoidBlock)action;

@end
