//
//  PlayerAid
//

#import "NSError+PlayerAidErrors.h"

static NSString *const kPlayerAidServerDomain = @"PlayerAidServer";

static const NSInteger kGenericServerResponseErrorCode = 500;
static const NSInteger kIncorrectResponseErrorCode = 501;
static const NSInteger kTutorialStepSubmissionErrorCode = 502;
static const NSInteger kIncorrectParameterErrorCode = 503;
static const NSInteger kAuthenticationTokenParameterErrorCode = 504;
static const NSInteger kEmailAddressAlreadyUsedForRegistration = 505;

#define ErrorMethodServerDomainMake(methodName,errorCode) + (NSError *)methodName { return [[NSError alloc] initWithDomain:kPlayerAidServerDomain code:errorCode userInfo:nil]; }

#define NSErrorMethodMake(methodName,domain,errorCode) + (NSError *)methodName { return [NSError errorWithDomain:domain code:errorCode userInfo:nil]; }

@implementation NSError (PlayerAidErrors)

ErrorMethodServerDomainMake(genericServerResponseError, kGenericServerResponseErrorCode)
ErrorMethodServerDomainMake(incorrectServerResponseError, kIncorrectResponseErrorCode)
ErrorMethodServerDomainMake(tutorialStepSubmissionError, kTutorialStepSubmissionErrorCode)
ErrorMethodServerDomainMake(incorrectParameterError, kIncorrectParameterErrorCode)
ErrorMethodServerDomainMake(authenticationTokenError, kAuthenticationTokenParameterErrorCode)
ErrorMethodServerDomainMake(emailAddressAlreadyUsedForRegistrationError, kEmailAddressAlreadyUsedForRegistration)

#pragma mark - User errors

NSErrorMethodMake(userCancelledURLRequestError, NSURLErrorDomain, NSURLErrorCancelled)

#pragma mark - Other interface methods

- (BOOL)isURLRequestErrorUserCancelled
{
  BOOL urlErrorDomain = [self.domain isEqualToString:NSURLErrorDomain];
  BOOL cancelledErrorCode = (self.code == NSURLErrorCancelled);
  return (urlErrorDomain && cancelledErrorCode);
}

@end
