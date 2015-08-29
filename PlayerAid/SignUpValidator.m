//
//  PlayerAid
//

#import "SignUpValidator.h"

static const NSInteger kMinEmailLength = 3;


@implementation SignUpValidator

- (BOOL)signUpDataValidWithEmail:(nonnull NSString *)email password:(nonnull NSString *)password {
  AssertTrueOrReturnNo(email);
  AssertTrueOrReturnNo(password);
  
  BOOL emailValid = [self emailValid:email];
  BOOL passwordValid = [self passwordValid:password];
  return (emailValid && passwordValid);
}

#pragma mark - Email Validation

- (BOOL)emailValid:(nonnull NSString *)email {
  AssertTrueOrReturnNil(email);
  
  BOOL longEnough = (email.length > kMinEmailLength);
  BOOL containsAtCharacter = ([email containsString:@"@"]);
  BOOL containsSufix = [self emailHasAnySufix:email];
  
  return (longEnough && containsAtCharacter && containsSufix);
}

- (BOOL)emailHasAnySufix:(nonnull NSString *)email {
  BOOL emailHasSufix = NO;
  
  NSArray *emailComponents = [email componentsSeparatedByString:@"@"];
  if (emailComponents.count > 1) {
    NSString *sufix = emailComponents[2];
    BOOL sufixContainsDotCharacter = ([sufix containsString:@"."]);
    if (sufixContainsDotCharacter) {
      emailHasSufix = YES;
    }
  }
  return emailHasSufix;
}

#pragma mark - Password Validation

- (BOOL)passwordValid:(nonnull NSString *)password {
  NOT_IMPLEMENTED_YET_RETURN_NIL
  
  return NO;
}

@end
