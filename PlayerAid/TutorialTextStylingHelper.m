//
//  PlayerAid
//

@import KZAsserts;
#import "TutorialTextStylingHelper.h"
#import "ColorsHelper.h"

static const CGFloat kLineSpacing = 4.0f;
static const CGFloat kParagraphAdditionalSpacing = -3.0f;
static const CGFloat kDefaultFontSize = 16.0f;

@implementation TutorialTextStylingHelper

#pragma mark - public

- (NSAttributedString *)textStepFormattedAttributedStringFromText:(NSString *)text
{
  AssertTrueOrReturnNil(text);
  NSDictionary *attributes = [self textStepFormatAttributes];
  return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSDictionary *)textStepFormatAttributes
{
  NSParagraphStyle *paragraphStyle = [self textStepParagaraphStyle];
  UIFont *font = [UIFont fontWithName:@"Palatino" size:kDefaultFontSize];
  
  return @{
           NSParagraphStyleAttributeName : paragraphStyle,
           NSFontAttributeName : font,
           NSForegroundColorAttributeName : [ColorsHelper tutorialTextStepColor]
          };
}

#pragma mark - private

- (NSParagraphStyle *)textStepParagaraphStyle
{
  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  paragraphStyle.lineSpacing = kLineSpacing;
  paragraphStyle.paragraphSpacing = kParagraphAdditionalSpacing;
  
  return [paragraphStyle copy];
}

@end
