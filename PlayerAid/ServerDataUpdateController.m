//
//  PlayerAid
//

#import "ServerDataUpdateController.h"
#import "UsersController.h"
#import "AuthenticatedServerCommunicationController.h"
#import "NSError+PlayerAidErrors.h"
#import "ServerResponseParsing.h"


#define InvokeCompletionBlockAndReturn(error) if (completion) { completion(error); return; }


@implementation ServerDataUpdateController

+ (void)updateUserAndTutorials
{
  [[UsersController sharedInstance] updateCurrentUserProfile];
  
  // [[TutorialsController sharedInstance] updateTutorialsList];
  // if this is the first time we fetch tutorials - show blocking alert view on failure (and retry)!
}

+ (void)saveTutorial:(Tutorial *)tutorial completion:(SaveCompletionBlock)completion
{
  // TODO: figure out a nice chaining mechanism for this requests
  // TODO: figure out if we even need to chain most of those requests (we could fire them all off asynchronously and wait until execution finished)
  
  [[AuthenticatedServerCommunicationController sharedInstance] createTutorial:tutorial completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
    if (!error) {
      NSString *tutorialID = [ServerResponseParsing tutorialIDFromResponseObject:responseObject];
      if (!tutorialID.length) {
        InvokeCompletionBlockAndReturn([NSError incorrectServerResponseError]);
      }
      tutorial.serverID = [NSNumber numberWithInteger:[tutorialID integerValue]];
      
      [[AuthenticatedServerCommunicationController sharedInstance] submitImageForTutorial:tutorial completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
        if (error) {
          InvokeCompletionBlockAndReturn([NSError genericServerResponseError]);
        }
        else
        {
          // TODO: pack all those tutorial steps upload in a dispatch_group
          [tutorial.consistsOf enumerateObjectsUsingBlock:^(TutorialStep* step, NSUInteger idx, BOOL *stop) {
            // TODO: make network requests to submit tutorial video step(s)
            // TODO: make network requests to submit tutorial image step(s)
            // TODO: make network requests to submit tutorial text step(s)
          }];
          
          [[AuthenticatedServerCommunicationController sharedInstance] submitTutorialForReview:tutorial completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
            if (error) {
              InvokeCompletionBlockAndReturn([NSError genericServerResponseError]);
            }
            else {
              if (completion) {
                completion(nil);
              }
            }
          }];
        }
      }];
    }
    else {
      if (completion) {
        completion(error);
      }
    }
  }];
}

@end
