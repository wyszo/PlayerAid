//
//  PlayerAid
//

#import "ServerDataUpdateController.h"
#import "UsersController.h"
#import "AuthenticatedServerCommunicationController.h"
#import "NSError+PlayerAidErrors.h"
#import "ServerResponseParsing.h"


@implementation ServerDataUpdateController

+ (void)updateUserAndTutorials
{
  [[UsersController sharedInstance] updateCurrentUserProfile];
  
  // [[TutorialsController sharedInstance] updateTutorialsList];
  // if this is the first time we fetch tutorials - show blocking alert view on failure (and retry)!
}

+ (void)saveTutorial:(Tutorial *)tutorial completion:(SaveCompletionBlock)completion
{
  // TODO: make a network request to create a tutorial!
  [[AuthenticatedServerCommunicationController sharedInstance] createTutorial:tutorial completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
    if (!error) {
      NSString *tutorialID = [ServerResponseParsing tutorialIDFromResponseObject:responseObject];
      if (!tutorialID.length) {
        if (completion) {
          completion([NSError incorrectServerResponseError]);
          return;
        }
      }
      
      UIImage *tutorialImage; // TODO: attach tutorial image!!
      [[AuthenticatedServerCommunicationController sharedInstance] submitImage:tutorialImage forTutorialID:tutorialID completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
        // TODO: implement response handling
      }];
      
      // TODO: figure out a nice chaining mechanism for this requests
      // TODO: figure out if we even need to chain most of those requests (we could fire them all off asynchronously and wait until execution finished)
      
      // TODO: make network requests to submit tutorial video step(s)
      // TODO: make network requests to submit tutorial text step(s)
      // TODO: make a network reqeust to submit tutorial to review
      // note all the above have to be atomic operations
    }
    else {
      if (completion) {
        completion(error);
      }
    }
  }];
}

@end
