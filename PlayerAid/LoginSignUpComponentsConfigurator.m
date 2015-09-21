//
//  PlayerAid
//

#import <KZAsserts/KZAsserts.h>
#import "LoginSignUpComponentsConfigurator.h"
#import "ColorsHelper.h"

static CGFloat kLineHeightMultiple = 1.25f;
static CGFloat kFontSize = 10.0f;


@implementation LoginSignUpComponentsConfigurator

- (void)configureSignupBottomTermsAndConditionsPrivacyPolicyAttributedLabel:(nonnull TTTAttributedLabel *)attributedLabel
{
  AssertTrueOrReturn(attributedLabel);
  
  [self configureAttributedLabelStyling:attributedLabel];
  
  NSRange termsOfUseRange, privacyPolicyRange;
  NSAttributedString *attributedString = [self attributedStringWithTermsAndConditionsRangeRef:&termsOfUseRange privacyPolicyRangeRef:&privacyPolicyRange];

  attributedLabel.attributedText = attributedString;
  
  [attributedLabel addLinkToURL:[NSURL URLWithString:self.termsAndConditionsStubUrlString] withRange:termsOfUseRange];
  [attributedLabel addLinkToURL:[NSURL URLWithString:self.privacyPolicyStubUrlString] withRange:privacyPolicyRange];
}

- (NSAttributedString *)attributedStringWithTermsAndConditionsRangeRef:(NSRange *)termsAndConditionsRangeRef privacyPolicyRangeRef:(NSRange *)privacyPolicyRangeRef
{
  NSMutableAttributedString *attributedString = [NSMutableAttributedString new];
  
  NSAttributedString *sentenceStartString = [[NSAttributedString alloc] initWithString:@"By creating an account, you agree to the " attributes:self.normalTextAttributes];
  [attributedString appendAttributedString:sentenceStartString];
  
  NSMutableAttributedString *termsAndConditionsString = [[NSMutableAttributedString alloc] initWithString:@"Terms of Use" attributes:self.linkAttributes];
  [attributedString appendAttributedString:termsAndConditionsString];
  
  NSAttributedString *sentenceEndString = [[NSAttributedString alloc] initWithString:@" and you acknowledge that you have read the " attributes:self.normalTextAttributes];
  [attributedString appendAttributedString:sentenceEndString];
  
  NSMutableAttributedString *privacyPolicyString = [[NSMutableAttributedString alloc] initWithString:@"Privacy Policy" attributes:self.linkAttributes];
  [attributedString appendAttributedString:privacyPolicyString];

  (*termsAndConditionsRangeRef) = [[attributedString string] rangeOfString:[termsAndConditionsString string]];
  (*privacyPolicyRangeRef) = [[attributedString string] rangeOfString:[privacyPolicyString string]];
  
  return [attributedString copy];
}

- (void)configureAttributedLabelStyling:(nonnull TTTAttributedLabel *)attributedLabel
{
  attributedLabel.numberOfLines = 0;
  attributedLabel.backgroundColor = [UIColor clearColor];
  
  attributedLabel.linkAttributes = self.linkAttributes;
  attributedLabel.activeLinkAttributes = self.linkAttributes;
}

- (NSDictionary *)normalTextAttributes
{
  return @{ (id)kCTForegroundColorAttributeName : (id)[ColorsHelper signupTermsAndConditionsPrivacyPolicyTextColor].CGColor,
                            NSFontAttributeName : self.font,
                  NSParagraphStyleAttributeName : self.paragraphStyle };
}

- (NSDictionary *)linkAttributes
{
  return @{ (id)kCTForegroundColorAttributeName : (id)[ColorsHelper playerAidBlueColor].CGColor,
                            NSFontAttributeName : self.font,
             (id)kCTUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),
                  NSParagraphStyleAttributeName : self.paragraphStyle };
}

- (NSParagraphStyle *)paragraphStyle
{
  NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
  paragraphStyle.lineHeightMultiple = kLineHeightMultiple;
  return [paragraphStyle copy];
}

- (UIFont *)font
{
  return [UIFont systemFontOfSize:kFontSize];
}

#pragma mark - Class methods

- (NSString *)termsAndConditionsStubUrlString
{
  return @"TermsAndConditionsStubUrl";
}

- (NSString *)privacyPolicyStubUrlString
{
  return @"PrivacyPolicyStubUrl";
}

@end
