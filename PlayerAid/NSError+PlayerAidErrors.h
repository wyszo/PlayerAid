//
//  PlayerAid
//

@import Foundation;

@interface NSError (PlayerAidErrors)

+ (NSError *)genericServerResponseError;
+ (NSError *)incorrectServerResponseError;
+ (NSError *)tutorialStepSubmissionError;
+ (NSError *)incorrectParameterError;
+ (NSError *)authenticationTokenError;
+ (NSError *)emailAddressAlreadyUsedForRegistrationError;

@end
