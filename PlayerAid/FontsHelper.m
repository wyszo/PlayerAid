//
//  PlayerAid
//

#import "FontsHelper.h"

#define UIFontMake(fontName,fontSize) [UIFont fontWithName:fontName size:fontSize];
#define UIFontMethodMake(name,fontName,fontSize) +(UIFont *)name { return UIFontMake(fontName,fontSize) }


@implementation FontsHelper

UIFontMethodMake(navbarTitleFont, @"Avenir-Roman", 16.0)
UIFontMethodMake(navbarButtonsFont, @"Avenir-Medium", 16.0)

@end
