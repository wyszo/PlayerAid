//
//  PlayerAid
//

@import TWCommonLib;
#import "ColorsHelper.h"

#define UIColorMethodMake(name,r,g,b) +(UIColor *)name { return UIColorMake(r,g,b); }
#define UIColorWithAlphaMethodMake(name,r,g,b,a) +(UIColor *)name { return UIColorWithAlphaMake(r,g,b,a); }

#define UIColorFromHexMethodMake(name,hexColor) +(UIColor *)name { return UIColorFromHex(hexColor); }

static const NSInteger kNewPlayerAidBlue = 0x3f68c5;
static const NSInteger kCommentDarkGrey = 0x444444;

@implementation ColorsHelper

UIColorMethodMake(loginLogInLightBlueBackgroundColor, 236, 238, 241)
UIColorMethodMake(loginSignupLightBlueBackgroundColor, 236, 238, 241)
UIColorMethodMake(signupTermsAndConditionsPrivacyPolicyTextColor, 133, 134, 149)

UIColorMethodMake(tabBarSelectedTextColor, 42, 70, 136)
UIColorMethodMake(tabBarUnselectedTextColor, 158, 171, 199)

UIColorFromHexMethodMake(tabBarSelectedImageTintColor, kNewPlayerAidBlue)
UIColorFromHexMethodMake(tabBarCreateTutorialBackgroundColor, kNewPlayerAidBlue)
UIColorMethodMake(tabBarCreateTutorialTextColor, 255, 255, 255)

UIColorFromHexMethodMake(navigationBarColor, kNewPlayerAidBlue)
UIColorMethodMake(navigationBarButtonsColor, 255, 255, 255)
UIColorMethodMake(navigationBarDisabledButtonsColor, 93, 110, 162)

UIColorMethodMake(tutorialsSelectedFilterButtonColor, 0, 184, 255)
UIColorMethodMake(tutorialsSelectedFilterButtonTextColor, 255, 255, 255)
UIColorMethodMake(tutorialsUnselectedFilterBackgroundColor, 44, 73, 147)
UIColorMethodMake(tutorialsUnselectedFilterButtonTextColor, 166, 180, 212)
UIColorWithAlphaMethodMake(tutorialGradientBlueColor, 24, 45, 97, 0.8)
UIColorMethodMake(tutorialTextStepColor, 119, 119, 119)
UIColorMethodMake(tutorialImageBackgroundColor, 236, 238, 241)
UIColorFromHexMethodMake(editTutorialStepsBackgroundColor, kNewPlayerAidBlue)

UIColorFromHexMethodMake(tutorialCommentsBarBackgroundColor, kNewPlayerAidBlue)

UIColorMethodMake(tutorialCellDraftTextBackgroundColor, 73, 73, 84)
UIColorMethodMake(tutorialCellInReviewTextBackgroundColor, 63, 104, 197)
UIColorMethodMake(tutorialCellDraftOverlayBackgroundColor, 73, 73, 84)
UIColorMethodMake(tutorialCellInReviewOverlayBackgroundColor, 63, 104, 197)

UIColorFromHexMethodMake(commentLabelTextColor, kCommentDarkGrey)
UIColorMethodMake(commentsTimeAgoLabelColor, 43, 71, 139)
UIColorMethodMake(commentsSeparatorColor, 236, 237, 237)
UIColorMethodMake(commentReplyBackgroundColor, 247, 248, 250)
UIColorMethodMake(commentRepliesSeparatorColor, 236, 237, 237)
UIColorMethodMake(editedCommentTableViewCellBackgroundColor, 255, 255, 223)
UIColorMethodMake(editedCommentKeyboardInputViewInputTextViewBorderColor, 233, 233, 233)

UIColorMethodMake(makeCommentPostButtonActiveBackgroundColor, 91, 127, 214)
UIColorMethodMake(makeCommentPostButtonInactiveBackgroundColor, 159, 179, 226)
UIColorFromHexMethodMake(makeCommentInputTextViewTextColor, kCommentDarkGrey)
UIColorFromHexMethodMake(makeCommentInputTextViewPlaceholderColor, kCommentDarkGrey)
UIColorWithAlphaMethodMake(makeEditCommentInputViewTopBorderColor, 0, 0, 0, 0.2)
UIColorMethodMake(textStepKeyboardInputAccessoryViewBorderColor, 227, 227, 227)

UIColorFromHexMethodMake(playerAidBlueColor, kNewPlayerAidBlue)
UIColorWithAlphaMethodMake(userProfileBackgroundTintColor, 63, 104, 194, 0.75)
UIColorFromHexMethodMake(userProfileDefaultBackgroundColor, kNewPlayerAidBlue)
UIColorMethodMake(userProfileHeaderOverscrollBackgroundColor, 63, 104, 194)
UIColorFromHexMethodMake(editProfileTextLabelsColor, kNewPlayerAidBlue)
UIColorFromHexMethodMake(editProfileViewBackgroundColor, 0xf5f5f5)
UIColorMethodMake(editProfileSubviewsBorderColor, 200, 199, 204)
UIColorMethodMake(editProfileFacebookButtonColor, 81, 101, 157)

UIColorMethodMake(createTutorialHeaderElementsBorderColor, 141, 141, 141)

@end
