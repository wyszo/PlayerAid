//
//  PlayerAid
//

#import "NSError+PlayerAidErrors.h"

static NSString *const kPlayerAidServerDomain = @"PlayerAidServer";
static NSString *const kPlayerAidUserDomain = @"PlayerAidUser";

typedef NS_ENUM(NSUInteger, ServerDomainErrorCodes) {
  GenericServerResponseErrorCode = 500,
  IncorrectServerResopnseErrorCode = 501,
  TutorialStepSumbmissionErrorCode = 502,
  IncorrectParameterErrorCode = 503,
  AuthenticationTokenParameterErrorCode = 504,
  EmailAddressAlreadyUsedForRegistration = 505,
};

NS_ENUM(NSUInteger, UserDomainErrorCodes) {
  NetworkConnectionLostErrorCode = 600,
};

#define ErrorMethodServerDomainMake(methodName,errorCode) + (NSError *)methodName { return [[NSError alloc] initWithDomain:kPlayerAidServerDomain code:errorCode userInfo:nil]; }

#define NSErrorMethodMake(methodName,domain,errorCode) + (NSError *)methodName { return [NSError errorWithDomain:domain code:errorCode userInfo:nil]; }

@implementation NSError (PlayerAidErrors)

ErrorMethodServerDomainMake(genericServerResponseError, GenericServerResponseErrorCode)
ErrorMethodServerDomainMake(incorrectServerResponseError, IncorrectServerResopnseErrorCode)
ErrorMethodServerDomainMake(tutorialStepSubmissionError, TutorialStepSumbmissionErrorCode)
ErrorMethodServerDomainMake(incorrectParameterError, IncorrectParameterErrorCode)
ErrorMethodServerDomainMake(authenticationTokenError, AuthenticationTokenParameterErrorCode)
ErrorMethodServerDomainMake(emailAddressAlreadyUsedForRegistrationError, EmailAddressAlreadyUsedForRegistration)

#pragma mark - User errors

NSErrorMethodMake(userCancelledURLRequestError, NSURLErrorDomain, NSURLErrorCancelled)
NSErrorMethodMake(networkConnectionLostError, kPlayerAidUserDomain, NetworkConnectionLostErrorCode)

#pragma mark - Other interface methods

- (BOOL)isURLRequestErrorUserCancelled
{
  BOOL urlErrorDomain = [self.domain isEqualToString:NSURLErrorDomain];
  BOOL cancelledErrorCode = (self.code == NSURLErrorCancelled);
  return (urlErrorDomain && cancelledErrorCode);
}

@end
