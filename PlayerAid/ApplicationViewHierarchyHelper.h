//
//  PlayerAid
//


@interface ApplicationViewHierarchyHelper : NSObject

+ (UITabBarController *)mainTabBarController;

+ (UITabBarItem *)tabBarItemAtIndex:(NSUInteger)itemIndex;
+ (CGRect)frameForTabBarItemAtIndex:(NSUInteger)itemIndex;

/**
 * Can return nil (if a TabBarController is inside a NavigationController)
 */
+ (UIView *)tabBarControllerBackgroundView;

@end
