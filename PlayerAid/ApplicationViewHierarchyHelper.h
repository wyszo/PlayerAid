//
//  PlayerAid
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ApplicationViewHierarchyHelper : NSObject

+ (UINavigationController *)mainNavigationController;
+ (UITabBarController *)mainTabBarController;
+ (UITabBarItem *)tabBarItemAtIndex:(NSUInteger)itemIndex;
+ (CGRect)frameForTabBarItemAtIndex:(NSUInteger)itemIndex;

@end
