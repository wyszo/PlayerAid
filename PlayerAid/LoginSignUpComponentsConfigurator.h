//
//  PlayerAid
//

#import <Foundation/Foundation.h>
#import <TTTAttributedLabel/TTTAttributedLabel.h>

@interface LoginSignUpComponentsConfigurator : NSObject

- (void)configureSignupBottomTermsAndConditionsPrivacyPolicyAttributedLabel:(nonnull TTTAttributedLabel *)attributedLabel;

- (nonnull NSString *)termsAndConditionsStubUrlString;
- (nonnull NSString *)privacyPolicyStubUrlString;

@end
