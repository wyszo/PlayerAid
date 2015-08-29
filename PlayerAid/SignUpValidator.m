//
//  PlayerAid
//

#import "SignUpValidator.h"

static const NSInteger kMinEmailLength = 3;
static const NSInteger kMinPasswordLength = 6;


@implementation SignUpValidator

#pragma mark - Email Validation

- (BOOL)validateEmail:(nonnull NSString *)email
{
  AssertTrueOrReturnNil(email);
  
  BOOL longEnough = (email.length > kMinEmailLength);
  BOOL containsAtCharacter = ([email containsString:@"@"]);
  BOOL hasSufix = [self emailHasAnySufix:email];
  BOOL hasPrefix = [self emailHasAnyPrefix:email];
  
  return (longEnough && containsAtCharacter && hasPrefix && hasSufix);
}

- (BOOL)emailHasAnySufix:(nonnull NSString *)email
{
  BOOL hasSufix = NO;
  
  NSArray *emailComponents = [self emailComponentsSpearatedByAtCharacter:email];
  if (emailComponents.count > 1) {
    NSString *sufix = emailComponents[1];
    BOOL sufixContainsDotCharacter = ([sufix containsString:@"."]);
    if (sufixContainsDotCharacter) {
      hasSufix = YES;
    }
  }
  return hasSufix;
}

- (BOOL)emailHasAnyPrefix:(nonnull NSString *)email
{
  BOOL hasPrefix = NO;
  
  NSArray *emailComponents = [self emailComponentsSpearatedByAtCharacter:email];
  if (emailComponents.count) {
    NSString *prefix = emailComponents[0];
    hasPrefix = (prefix.length > 0);
  }
  return hasPrefix;
}

- (NSArray *)emailComponentsSpearatedByAtCharacter:(nonnull NSString *)email
{
  return [email componentsSeparatedByString:@"@"];
}

#pragma mark - Password Validation

- (BOOL)validatePassword:(nonnull NSString *)password
{
  AssertTrueOrReturnNo(password);
  
  BOOL longEnough = [self passwordLongEnough:password];
  return longEnough;
}

- (BOOL)passwordLongEnough:(nonnull NSString *)password
{
  return (password.length >= kMinPasswordLength);
}

@end
