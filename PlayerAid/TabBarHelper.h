//
//  PlayerAid
//


/**
 Generic TabBar utility methods. 
 */
@interface TabBarHelper : NSObject

+ (nonnull UITabBarController *)mainTabBarController;

+ (nullable UITabBarItem *)tabBarItemAtIndex:(NSUInteger)itemIndex;
+ (CGRect)frameForTabBarItemAtIndex:(NSUInteger)itemIndex;

+ (nullable NSNumber *)tabBarControllerIndexOfViewControllerWithType:(nonnull Class)aClass;

/**
 * Can return nil (if a TabBarController is inside a NavigationController)
 */
+ (nullable UIView *)tabBarControllerBackgroundView;

@end
