//
//  PlayerAid
//

@import TWCommonLib;
#import "ColorsHelper.h"

#define UIColorMethodMake(name,r,g,b) +(UIColor *)name { return UIColorMake(r,g,b); }
#define UIColorWithAlphaMethodMake(name,r,g,b,a) +(UIColor *)name { return UIColorWithAlphaMake(r,g,b,a); }

#define UIColorFromHexMethodMake(name,hexColor) +(UIColor *)name { return UIColorFromHex(hexColor); }

static const NSInteger kNewPlayerAidBlue = 0x3f68c5;

@implementation ColorsHelper

UIColorMethodMake(loginLogInLightBlueBackgroundColor, 236, 238, 241)
UIColorMethodMake(loginSignupLightBlueBackgroundColor, 236, 238, 241)
UIColorMethodMake(signupTermsAndConditionsPrivacyPolicyTextColor, 133, 134, 149)

UIColorMethodMake(tabBarSelectedTextColor, 42, 70, 136)
UIColorMethodMake(tabBarUnselectedTextColor, 158, 171, 199)

UIColorFromHexMethodMake(tabBarSelectedImageTintColor, kNewPlayerAidBlue)
UIColorFromHexMethodMake(tabBarCreateTutorialBackgroundColor, kNewPlayerAidBlue)
UIColorMethodMake(tabBarCreateTutorialTextColor, 255, 255, 255)

UIColorMethodMake(navigationBarColor, 42, 70, 136)
UIColorMethodMake(navigationBarButtonsColor, 255, 255, 255)
UIColorMethodMake(navigationBarDisabledButtonsColor, 93, 110, 162)

UIColorMethodMake(tutorialsSelectedFilterButtonColor, 20, 35, 66)
UIColorMethodMake(tutorialsSelectedFilterButtonTextColor, 255, 255, 255)
UIColorMethodMake(tutorialsUnselectedFilterButtonColor, 26, 43, 80)
UIColorMethodMake(tutorialsUnselectedFilterButtonTextColor, 91, 103, 129)
UIColorWithAlphaMethodMake(tutorialGradientBlueColor, 24, 45, 97, 0.8)

UIColorFromHexMethodMake(tutorialCommentsBarBackgroundColor, kNewPlayerAidBlue)
UIColorMethodMake(commentsTimeAgoLabelColor, 43, 71, 139)

UIColorMethodMake(editedCommentTableViewCellBackgroundColor, 255, 255, 223)
UIColorMethodMake(editedCommentKeyboardInputViewInputTextViewBorderColor, 233, 233, 233)

UIColorMethodMake(makeCommentPostButtonActiveBackgroundColor, 91, 127, 214)
UIColorMethodMake(makeCommentPostButtonInactiveBackgroundColor, 159, 179, 226)
UIColorWithAlphaMethodMake(makeEditCommentInputViewTopBorderColor, 0, 0, 0, 0.2)

UIColorMethodMake(playerAidBlueColor, 44, 72, 134) // old, darker one
UIColorMethodMake(editProfileViewBackgroundColor, 245, 245, 245)
UIColorMethodMake(editProfileSubviewsBorderColor, 200, 199, 204)
UIColorMethodMake(editProfileFacebookButtonColor, 81, 101, 157)

UIColorMethodMake(createTutorialHeaderElementsBorderColor, 141, 141, 141)

@end
