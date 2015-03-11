//
//  PlayerAid
//

#import "ServerDataUpdateController.h"
#import "UsersController.h"
#import "AuthenticatedServerCommunicationController.h"
#import "NSError+PlayerAidErrors.h"
#import "ServerResponseParsing.h"


#define ReturnIfBooleanFalse(boolValue) if (!boolValue) { return; }


@implementation ServerDataUpdateController

+ (void)updateUserAndTutorials
{
  [[UsersController sharedInstance] updateCurrentUserProfile];
  
  // [[TutorialsController sharedInstance] updateTutorialsList];
  // if this is the first time we fetch tutorials - show blocking alert view on failure (and retry)!
}

+ (void)saveTutorial:(Tutorial *)tutorial completion:(SaveCompletionBlock)completion
{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    [self privateSaveTutorial:tutorial completion:completion];
  });
}

+ (void)privateSaveTutorial:(Tutorial *)tutorial completion:(SaveCompletionBlock)completion
{
  NSCondition *condition = [[NSCondition alloc] init];
  [condition lock];
  __block BOOL allRequestsSucceeded = YES;
  
  [[AuthenticatedServerCommunicationController sharedInstance] createTutorial:tutorial completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
    if (!error) {
      NSString *tutorialID = [ServerResponseParsing tutorialIDFromResponseObject:responseObject];
      if (!tutorialID.length) {
        [self setBoolReferenceToNo:&allRequestsSucceeded andSignalCondition:condition];
        return;
      }
      tutorial.serverID = [NSNumber numberWithInteger:[tutorialID integerValue]];
    }
    [self lockSignalAndUnlockCondition:condition];
  }];
  
  [self waitOnCondition:condition andInvokeCompletionBlockWithGenericError:completion ifBooleanValueIsTrue:(!allRequestsSucceeded)];
  ReturnIfBooleanFalse(allRequestsSucceeded);

  [[AuthenticatedServerCommunicationController sharedInstance] submitImageForTutorial:tutorial completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
    if (error) {
      [self setBoolReferenceToNo:&allRequestsSucceeded andSignalCondition:condition];
      return;
    }
    [self lockSignalAndUnlockCondition:condition];
  }];

  [self waitOnCondition:condition andInvokeCompletionBlockWithGenericError:completion ifBooleanValueIsTrue:(!allRequestsSucceeded)];
  ReturnIfBooleanFalse(allRequestsSucceeded);
  
  [self saveStepsForTutorial:tutorial completion:^(NSError *error) {
    if (error) {
      [self setBoolReferenceToNo:&allRequestsSucceeded andSignalCondition:condition];
      return;
    }
    [self lockSignalAndUnlockCondition:condition];
  }];
  
  [self waitOnCondition:condition andInvokeCompletionBlockWithGenericError:completion ifBooleanValueIsTrue:(!allRequestsSucceeded)];
  ReturnIfBooleanFalse(allRequestsSucceeded);
  
  [[AuthenticatedServerCommunicationController sharedInstance] submitTutorialForReview:tutorial completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
    if (error) {
      if (completion) {
        completion([NSError genericServerResponseError]);
        return;
      }
    }
    else {
      if (completion) {
        completion(nil);
      }
    }
  }];
}

+ (void)waitOnCondition:(NSCondition *)condition andInvokeCompletionBlockWithGenericError:(SaveCompletionBlock)completion ifBooleanValueIsTrue:(BOOL)invokeCompletionBlockWithError
{
  [condition wait];
  
  if (invokeCompletionBlockWithError) {
    if(completion) {
      completion([NSError genericServerResponseError]);
    }
  }
}

+ (void)setBoolReferenceToNo:(BOOL *)boolValue andSignalCondition:(NSCondition *)condition
{
  *boolValue = NO;
  [condition signal];
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
