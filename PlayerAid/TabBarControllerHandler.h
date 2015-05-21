//
//  PlayerAid
//


@interface TabBarControllerHandler : NSObject <UITabBarControllerDelegate>

- (instancetype)new __unavailable;
- (instancetype)init __unavailable;

- (instancetype)initWithCreateTutorialItemAction:(void (^)())createTutorialAction;

@end
