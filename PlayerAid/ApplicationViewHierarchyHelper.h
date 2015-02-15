//
//  PlayerAid
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ApplicationViewHierarchyHelper : NSObject

+ (UITabBarController *)applicationTabBarController;
+ (UITabBarItem *)tabBarItemAtIndex:(NSInteger)itemIndex;

@end
