//
//  PlayerAid
//

#import "ServerDataUpdateController.h"
#import "UsersController.h"
#import "AuthenticatedServerCommunicationController.h"


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
      // TODO: grab tutorial ID for further requests
      
      // TODO: figure out a nice chaining mechanism for this requests
      
      // TODO: make network requests to submit tutorial image step(s)
      // TODO: make network requests to submit tutorial video step(s)
      // TODO: make network requests to submit tutorial text step(s)
      // TODO: make a network request to upload tutorial image
      // TODO: make a network reqeust to submit tutorial to review
      // note all the above have to be atomic operations
    }
    else {
      // TODO: implement error handling...
    }
  }];
}

@end
