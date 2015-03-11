//
//  PlayerAid
//

@interface NSError (PlayerAidErrors)

+ (NSError *)genericServerResponseError;
+ (NSError *)incorrectServerResponseError;
+ (NSError *)tutorialStepSubmissionError;

@end
