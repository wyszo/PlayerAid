//
//  PlayerAid
//


@interface TabBarControllerHandler : NSObject <UITabBarControllerDelegate>

NEW_AND_INIT_UNAVAILABLE

- (instancetype)initWithCreateTutorialItemAction:(void (^)())createTutorialAction;

@end
