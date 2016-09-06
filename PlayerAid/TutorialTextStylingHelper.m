@import KZAsserts;
#import "TutorialTextStylingHelper.h"
#import "ColorsHelper.h"

// TODO: customize html line spacing and paragraph additional spacing

@implementation TutorialTextStylingHelper

#pragma mark - public

- (NSAttributedString *)textStepFormattedAttributedStringFromText:(NSString *)text {
  AssertTrueOrReturnNil(text);
  NSData *htmlData = [text dataUsingEncoding:NSUnicodeStringEncoding];
  NSDictionary *htmlOptions = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType };

  return [[NSAttributedString alloc] initWithData:htmlData options:htmlOptions documentAttributes:nil error: nil];
}

@end
