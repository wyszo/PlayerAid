//
//  PlayerAid
//


/**
 Generic TabBar utility methods. 
 Try to use PlayerAid TabBarHelper instead of this class directly.
 */
@interface TabBarHelper : NSObject

+ (UITabBarController *)mainTabBarController;

+ (UITabBarItem *)tabBarItemAtIndex:(NSUInteger)itemIndex;
+ (CGRect)frameForTabBarItemAtIndex:(NSUInteger)itemIndex;

+ (NSNumber *)tabBarControllerIndexOfViewControllerWithType:(Class)aClass;

/**
 * Can return nil (if a TabBarController is inside a NavigationController)
 */
+ (UIView *)tabBarControllerBackgroundView;

@end
