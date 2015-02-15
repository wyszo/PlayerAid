//
//  PlayerAid
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ApplicationViewHierarchyHelper : NSObject

+ (UITabBarController *)applicationTabBarController;
+ (UITabBarItem *)tabBarItemAtIndex:(NSUInteger)itemIndex;
+ (CGRect)frameForTabBarItemAtIndex:(NSUInteger)itemIndex;

@end
