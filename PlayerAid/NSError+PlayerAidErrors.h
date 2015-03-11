//
//  PlayerAid
//

@interface NSError (PlayerAidErrors)

+ (NSError *)genericServerResponseError;
+ (NSError *)incorrectServerResponseError;

@end
