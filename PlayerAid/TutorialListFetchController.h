//
//  PlayerAid
//

@import Foundation;
#import <TWCommonLib/TWCommonMacros.h>
#import <TWCommonLib/TWCommonTypes.h>

@interface TutorialListFetchController : NSObject

NEW_AND_INIT_UNAVAILABLE

+ (instancetype)sharedInstance;

/**
 Make /tutorial API request. If request fails retries every 10 seconds.
 If this is the first time we request tutorial data, present non-dismissable alert view until success.
 */
- (void)fetchTimelineTutorialsCompletion:(BlockWithBoolParameter)completion;

/**
 Makes /user/tutorials request (for fetching own in-review tutorials)
 */
- (void)fetchCurrentUserTutorials;

@end
