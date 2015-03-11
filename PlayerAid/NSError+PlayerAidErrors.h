//
//  PlayerAid
//

@interface NSError (PlayerAidErrors)

+ (NSError *)genericServerResponseError;
+ (NSError *)incorrectServerResponseError;
+ (NSError *)tutorialStepSubmissionError;
+ (NSError *)incorrectParameterError;

@end
