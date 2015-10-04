//
//  PlayerAid
//

@import Foundation;
@import TTTAttributedLabel;

@interface LoginSignUpComponentsConfigurator : NSObject

- (void)configureSignupBottomTermsAndConditionsPrivacyPolicyAttributedLabel:(nonnull TTTAttributedLabel *)attributedLabel;

- (nonnull NSString *)termsAndConditionsStubUrlString;
- (nonnull NSString *)privacyPolicyStubUrlString;

@end
