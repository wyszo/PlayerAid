//
//  PlayerAid
//

@import KZAsserts;
#import "TutorialTextStylingHelper.h"

static const CGFloat kLineSpacing = 7.0f;
static const CGFloat kParagraphAdditionalSpacing = 0.0f;
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
  UIFont *font = [UIFont systemFontOfSize:kDefaultFontSize];
  
  return @{
           NSParagraphStyleAttributeName : paragraphStyle,
           NSFontAttributeName : font
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
