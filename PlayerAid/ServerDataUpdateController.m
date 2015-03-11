//
//  PlayerAid
//

#import "ServerDataUpdateController.h"
#import "UsersController.h"
#import "AuthenticatedServerCommunicationController.h"
#import "NSError+PlayerAidErrors.h"
#import "ServerResponseParsing.h"


#define InvokeCompletionBlockAndReturn(error) if (completion) { completion(error); return; }
#define SetBoolToNoAndSignalSemaphore(success,semaphore) { success = NO; dispatch_semaphore_signal(semaphore); }
#define SignalSemaphore(semaphore) { dispatch_semaphore_signal(semaphore); }
#define WaitOnSemaphoreAndReturnIfBooleanIsFalse(semaphore,success) { dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER); if (!success) { return; } }

@implementation ServerDataUpdateController

+ (void)updateUserAndTutorials
{
  [[UsersController sharedInstance] updateCurrentUserProfile];
  
  // [[TutorialsController sharedInstance] updateTutorialsList];
  // if this is the first time we fetch tutorials - show blocking alert view on failure (and retry)!
}


+ (void)saveTutorial:(Tutorial *)tutorial completion:(SaveCompletionBlock)completion
{
  dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
  __block BOOL allRequestsSucceeded = YES;
  
  [[AuthenticatedServerCommunicationController sharedInstance] createTutorial:tutorial completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
    if (!error) {
      NSString *tutorialID = [ServerResponseParsing tutorialIDFromResponseObject:responseObject];
      if (!tutorialID.length) {
        SetBoolToNoAndSignalSemaphore(allRequestsSucceeded, semaphore);
        InvokeCompletionBlockAndReturn([NSError incorrectServerResponseError]);
      }
      tutorial.serverID = [NSNumber numberWithInteger:[tutorialID integerValue]];
    }
    else {
      SignalSemaphore(semaphore);
    }
  }];
  
  WaitOnSemaphoreAndReturnIfBooleanIsFalse(semaphore, allRequestsSucceeded);
  
  [[AuthenticatedServerCommunicationController sharedInstance] submitImageForTutorial:tutorial completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
    if (error) {
      SetBoolToNoAndSignalSemaphore(allRequestsSucceeded, semaphore);
      InvokeCompletionBlockAndReturn([NSError genericServerResponseError]);
    }
    else {
      SignalSemaphore(semaphore);
    }
  }];

  WaitOnSemaphoreAndReturnIfBooleanIsFalse(semaphore, allRequestsSucceeded);
  
  [self saveStepsForTutorial:tutorial completion:^(NSError *error) {
    if (error) {
      SetBoolToNoAndSignalSemaphore(allRequestsSucceeded, semaphore);
      InvokeCompletionBlockAndReturn([NSError genericServerResponseError]);
    }
    else {
      SignalSemaphore(semaphore);
    }
  }];

  WaitOnSemaphoreAndReturnIfBooleanIsFalse(semaphore, allRequestsSucceeded);
  
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

+ (void)saveStepsForTutorial:(Tutorial *)tutorial completion:(SaveCompletionBlock)completion
{
  AssertTrueOr(tutorial, if(completion) { completion([NSError incorrectParameterError]); } return;);
  
  NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
  operationQueue.maxConcurrentOperationCount = 2;
  __block BOOL allRequestsSucceded = YES;
  
  [tutorial.consistsOf enumerateObjectsUsingBlock:^(TutorialStep* step, NSUInteger idx, BOOL *stop) {
    [operationQueue addOperationWithBlock:^{
      [[AuthenticatedServerCommunicationController sharedInstance] submitTutorialStep:step completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
        if (error) {
          allRequestsSucceded = NO;
          [operationQueue cancelAllOperations];
        }
      }];
    }];
  }];
  
  [operationQueue waitUntilAllOperationsAreFinished];
  
  if (completion) {
    NSError *error = nil;
    if (!allRequestsSucceded) {
      error = [NSError genericServerResponseError];
    }
    completion(error);
  }
}

@end
