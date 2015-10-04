//
//  PlayerAid
//

@import TWCommonLib;
#import "FontsHelper.h"

#define UIFontMethodMake(name,fontName,fontSize) +(UIFont *)name { return UIFontMake(fontName,fontSize); }

@implementation FontsHelper

UIFontMethodMake(navbarTitleFont, @"Avenir-Roman", 16)
UIFontMethodMake(navbarButtonsFont, @"Avenir-Medium", 16)

@end
