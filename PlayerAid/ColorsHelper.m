//
//  PlayerAid
//

#import "ColorsHelper.h"
#import "TWCommonMacros.h"


#define UIColorMethodMake(name,r,g,b) +(UIColor *)name { return UIColorMake(r,g,b); }
#define UIColorWithAlphaMethodMake(name,r,g,b,a) +(UIColor *)name { return UIColorWithAlphaMake(r,g,b,a); }


@implementation ColorsHelper

UIColorMethodMake(loginLogInLightBlueBackgroundColor, 236, 238, 241);
UIColorMethodMake(loginSignupLightBlueBackgroundColor, 236, 238, 241);
UIColorMethodMake(signupTermsAndConditionsPrivacyPolicyTextColor, 133, 134, 149);

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
UIColorWithAlphaMethodMake(tutorialGradientBlueColor, 24, 45, 97, 0.8)

UIColorMethodMake(playerAidBlueColor, 44, 72, 134)
UIColorMethodMake(editProfileViewBackgroundColor, 245, 245, 245)
UIColorMethodMake(editProfileSubviewsBorderColor, 200, 199, 204)
UIColorMethodMake(editProfileFacebookButtonColor, 81, 101, 157)

UIColorMethodMake(createTutorialHeaderElementsBorderColor, 141, 141, 141)

@end
