//
//  PlayerAid
//

#import "NSError+PlayerAidErrors.h"


static NSString *const kPlayerAidServerDomain = @"PlayerAidServer";

static const NSInteger kGenericServerResponseErrorCode = 500;
static const NSInteger kIncorrectResponseErrorCode = 501;
static const NSInteger kTutorialStepSubmissionErrorCode = 502;
static const NSInteger kIncorrectParameterErrorCode = 503;


#define ErrorMethodMake(methodName,errorCode) + (NSError *)methodName { return [[NSError alloc] initWithDomain:kPlayerAidServerDomain code:errorCode userInfo:nil]; }


@implementation NSError (PlayerAidErrors)

ErrorMethodMake(genericServerResponseError, kGenericServerResponseErrorCode)
ErrorMethodMake(incorrectServerResponseError, kIncorrectResponseErrorCode)
ErrorMethodMake(tutorialStepSubmissionError, kTutorialStepSubmissionErrorCode)
ErrorMethodMake(incorrectParameterError, kIncorrectParameterErrorCode)

@end
