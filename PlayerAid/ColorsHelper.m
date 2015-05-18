//
//  PlayerAid
//

#import "ColorsHelper.h"


#define UIColorMake(r,g,b) [UIColor colorWithRed:((CGFloat)r)/255.0 green:((CGFloat)g)/255.0 blue:((CGFloat)b)/255 alpha:1.0];
#define UIColorMethodMake(name,r,g,b) +(UIColor *)name { return UIColorMake(r,g,b) }


@implementation ColorsHelper

UIColorMethodMake(tabBarSelectedTextColor, 42, 70, 136)
UIColorMethodMake(tabBarUnselectedTextColor, 158, 171, 199)
UIColorMethodMake(tabBarSelectedImageTintColor, 53, 79, 141)
UIColorMethodMake(tabBarCreateTutorialBackgroundColor, 53, 79, 141)

UIColorMethodMake(navigationBarColor, 42, 70, 136)

UIColorMethodMake(tutorialsSelectedFilterButtonColor, 20, 35, 66)
UIColorMethodMake(tutorialsSelectedFilterButtonTextColor, 255, 255, 255)
UIColorMethodMake(tutorialsUnselectedFilterButtonColor, 26, 43, 80)
UIColorMethodMake(tutorialsUnselectedFilterButtonTextColor, 91, 103, 129)

@end
