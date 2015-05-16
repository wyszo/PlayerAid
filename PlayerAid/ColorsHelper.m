//
//  PlayerAid
//

#import "ColorsHelper.h"

#define UIColorMethodMake(name,r,g,b) +(UIColor *)name { return UIColorMake(r,g,b) }


@implementation ColorsHelper

UIColorMethodMake(tabBarSelectedTextColor, 42, 70, 136)
UIColorMethodMake(tabBarUnselectedTextColor, 158, 171, 199)
UIColorMethodMake(tabBarSelectedImageTintColor, 53, 79, 141)
UIColorMethodMake(tabBarCreateTutorialBackgroundColor, 53, 79, 141)
UIColorMethodMake(tabBarCreateTutorialTextColor, 255, 255, 255)

UIColorMethodMake(navigationBarColor, 42, 70, 136)
UIColorMethodMake(navigationBarButtonsColor, 255, 255, 255)
UIColorMethodMake(navigationBarDisabledButtonsColor, 93, 110, 162)

UIColorMethodMake(tutorialsSelectedFilterButtonColor, 20, 35, 66)
UIColorMethodMake(tutorialsSelectedFilterButtonTextColor, 255, 255, 255)
UIColorMethodMake(tutorialsUnselectedFilterButtonColor, 26, 43, 80)
UIColorMethodMake(tutorialsUnselectedFilterButtonTextColor, 91, 103, 129)

UIColorMethodMake(loginAndPlayerInfoViewBackgroundColor, 44, 72, 134)

UIColorMethodMake(createTutorialHeaderElementsBorderColor, 141, 141, 141)

@end
