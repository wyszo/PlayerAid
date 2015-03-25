//
//  PlayerAid
//

@class Tutorial;

typedef void (^SaveCompletionBlock)(NSError *error);


@interface ServerDataUpdateController : NSObject

+ (void)updateUserAndTutorials;

+ (void)saveTutorial:(Tutorial *)tutorial progressChanged:(BlockWithFloatParameter)progressChangedBlock completion:(SaveCompletionBlock)completion;

@end
