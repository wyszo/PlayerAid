//
//  PlayerAid
//

@import Foundation;
#import <TWCommonLib/TWCommonTypes.h>

@class Tutorial;

typedef void (^SaveCompletionBlock)(NSError *error);


@interface ServerDataUpdateController : NSObject

+ (void)updateUserAndTutorials;
+ (void)updateUserAndTutorialsUserLinkedWithFacebook:(BOOL)linkedWithFacebook;

// TODO: rewrite this method using promises
+ (void)saveTutorial:(Tutorial *)tutorial progressChanged:(BlockWithFloatParameter)progressChangedBlock completion:(SaveCompletionBlock)completion;

@end
