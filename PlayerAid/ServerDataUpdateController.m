//
//  PlayerAid
//

#import "ServerDataUpdateController.h"
#import "UsersController.h"
#import "AuthenticatedServerCommunicationController.h"
#import "NSError+PlayerAidErrors.h"
#import "ServerResponseParsing.h"


#define InvokeCompletionBlockIfErrorAndReturn(error) if(error) { if(completion) { completion(error); } return; }


@implementation ServerDataUpdateController

+ (void)updateUserAndTutorials
{
  [[UsersController sharedInstance] updateCurrentUserProfile];
  
  // [[TutorialsController sharedInstance] updateTutorialsList];
  // if this is the first time we fetch tutorials - show blocking alert view on failure (and retry)!
}

+ (void)saveTutorial:(Tutorial *)tutorial completion:(SaveCompletionBlock)completion
{
  DISPATCH_ASYNC(QueuePriorityHigh, ^{
    [self privateSaveTutorial:tutorial completion:completion];
  });
}

+ (void)privateSaveTutorial:(Tutorial *)tutorial completion:(SaveCompletionBlock)completion
{
  NSCondition *condition = [[NSCondition alloc] init];
  [condition lock];
  __block NSError *topLevelError = nil;
  
  [[AuthenticatedServerCommunicationController sharedInstance] createTutorial:tutorial completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
    if (error) {
      topLevelError = [NSError genericServerResponseError];
    }
    else {
      NSString *tutorialID = [ServerResponseParsing tutorialIDFromResponseObject:responseObject];
      if (!tutorialID.length) {
        topLevelError = [NSError incorrectServerResponseError];
        [self lockSignalAndUnlockCondition:condition];
        return;
      }
      tutorial.serverID = [NSNumber numberWithInteger:[tutorialID integerValue]];
    }
    [self lockSignalAndUnlockCondition:condition];
  }];
  
  [condition wait];
  InvokeCompletionBlockIfErrorAndReturn(topLevelError);

  [[AuthenticatedServerCommunicationController sharedInstance] submitImageForTutorial:tutorial completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
    if (error) {
      topLevelError = [NSError genericServerResponseError];
    }
    [self lockSignalAndUnlockCondition:condition];
  }];

  [condition wait];
  InvokeCompletionBlockIfErrorAndReturn(topLevelError);
  
  [self saveStepsForTutorial:tutorial completion:^(NSError *error) {
    if (error) {
      topLevelError = [NSError genericServerResponseError];
    }
    [self lockSignalAndUnlockCondition:condition];
  }];
  
  [condition wait];
  InvokeCompletionBlockIfErrorAndReturn(topLevelError);
  
  [[AuthenticatedServerCommunicationController sharedInstance] submitTutorialForReview:tutorial completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
    if (error) {
      topLevelError = [NSError genericServerResponseError];
      InvokeCompletionBlockIfErrorAndReturn(topLevelError)
    }
    else {
      if (completion) {
        completion(nil);
      }
    }
  }];
}

+ (void)lockSignalAndUnlockCondition:(NSCondition *)condition
{
  AssertTrueOrReturn(condition);
  [condition lock];
  [condition signal];
  [condition unlock];
}

+ (void)saveStepsForTutorial:(Tutorial *)tutorial completion:(SaveCompletionBlock)completion
{
  DISPATCH_ASYNC(QueuePriorityHigh, ^{
    [self privateSaveStepsForTutorial:tutorial completion:completion];
  });
}

+ (void)privateSaveStepsForTutorial:(Tutorial *)tutorial completion:(SaveCompletionBlock)completion
{
  AssertTrueOr(tutorial, if(completion) { completion([NSError incorrectParameterError]); } return;);
  
  dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
  __block NSInteger requestsToComplete = tutorial.consistsOfSet.count;
  
  NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
  operationQueue.maxConcurrentOperationCount = 2;
  __block NSError *topLevelError;
  
  [tutorial.consistsOf enumerateObjectsUsingBlock:^(TutorialStep* step, NSUInteger idx, BOOL *stop) {
    [operationQueue addOperationWithBlock:^{
      [[AuthenticatedServerCommunicationController sharedInstance] submitTutorialStep:step withPosition:(idx+1) completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
        if (error) {
          topLevelError = [NSError genericServerResponseError];
          [operationQueue cancelAllOperations];
          dispatch_semaphore_signal(semaphore);
        }
        
        requestsToComplete--;
        if (requestsToComplete == 0) {
          dispatch_semaphore_signal(semaphore);
        }
      }];
    }];
  }];
  
  dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
  
  if (completion) {
    completion(topLevelError);
  }
}

@end
