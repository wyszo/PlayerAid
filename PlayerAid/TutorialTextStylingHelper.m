@import KZAsserts;
#import "TutorialTextStylingHelper.h"
#import "ColorsHelper.h"

@implementation TutorialTextStylingHelper

#pragma mark - public

- (NSAttributedString *)textStepFormattedAttributedStringFromText:(NSString *)text {
  AssertTrueOrReturnNil(text);
  NSData *htmlData = [text dataUsingEncoding:NSUnicodeStringEncoding];
  NSDictionary *htmlOptions = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType };

  return [[NSAttributedString alloc] initWithData:htmlData options:htmlOptions documentAttributes:nil error: nil];
}

@end
