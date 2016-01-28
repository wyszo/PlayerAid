//
//  PlayerAid
//

@import KZAsserts;
@import TWCommonLib;
#import "ServerDataUpdateController.h"
#import "UsersFetchController.h"
#import "TutorialListFetchController.h"
#import "AuthenticatedServerCommunicationController.h"
#import "NSError+PlayerAidErrors.h"
#import "ServerResponseParsing.h"

// TODO: rewrite this to use chained BFTasks instead of manual synchronisation..

#define InvokeCompletionBlockAndUnlockConditionIfErrorAndReturn(condition, error) if(error) { [condition unlock]; if(completion) { completion(error); } return; }

#define InvokeProgressChangedBlockForStepWithSelf(self, stepNumber) [self invokeProgressChagnedBlock:progressChangedBlock withCurrentStepNumber:stepNumber andTotalNumberOfSteps:totalNumberOfProgressSteps];
#define InvokeProgressChangedBlockForStepAndIncrementStepCounter(stepNumber) InvokeProgressChangedBlockForStepWithSelf(self, stepNumber); currentStep++;


@implementation ServerDataUpdateController

+ (void)updateUserAndTutorialsUserLinkedWithFacebook:(BOOL)linkedWithFacebook
{
  [[UsersFetchController sharedInstance] fetchCurrentUserProfileUserLinkedWithFacebook:linkedWithFacebook];
  [[TutorialListFetchController sharedInstance] fetchTimelineTutorialsCompletion:NULL];
}

+ (void)updateUserAndTutorials
{
  [[UsersFetchController sharedInstance] fetchCurrentUserProfile];

  [[TutorialListFetchController sharedInstance] fetchTimelineTutorialsCompletion:^(BOOL success) {
    [[TutorialListFetchController sharedInstance] fetchCurrentUserTutorials];
  }];
}

+ (void)saveTutorial:(Tutorial *)tutorial progressChanged:(BlockWithFloatParameter)progressChangedBlock completion:(SaveCompletionBlock)completion
{
  DISPATCH_ASYNC(QueuePriorityHigh, ^{
    [self privateSaveTutorial:tutorial progressChanged:progressChangedBlock completion:completion];
  });
}

+ (void)privateSaveTutorial:(Tutorial *)tutorial progressChanged:(BlockWithFloatParameter)progressChangedBlock completion:(SaveCompletionBlock)completion
{
  NSCondition *condition = [[NSCondition alloc] init];
  [condition lock];
  __block NSError *topLevelError = nil;
  
  NSInteger currentStep = 0;
  const NSInteger numberOfStandardRequests = 3;
  NSInteger totalNumberOfProgressSteps = numberOfStandardRequests + tutorial.consistsOf.count;
  
  InvokeProgressChangedBlockForStepWithSelf(self, currentStep)
  
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
  
  InvokeProgressChangedBlockForStepAndIncrementStepCounter(currentStep);
  InvokeCompletionBlockAndUnlockConditionIfErrorAndReturn(condition, topLevelError);

  [[AuthenticatedServerCommunicationController sharedInstance] submitImageForTutorial:tutorial completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
    if (error) {
      topLevelError = [NSError genericServerResponseError];
    }
    [self lockSignalAndUnlockCondition:condition];
  }];

  [condition wait];
  InvokeProgressChangedBlockForStepAndIncrementStepCounter(currentStep);
  InvokeCompletionBlockAndUnlockConditionIfErrorAndReturn(condition, topLevelError);
  
  [self saveStepsForTutorial:tutorial progressChanged:progressChangedBlock startFromProgressStep:currentStep totalNumberOfProgressSteps:totalNumberOfProgressSteps completion:^(NSError *error) {
    if (error) {
      topLevelError = [NSError genericServerResponseError];
    }
    [self lockSignalAndUnlockCondition:condition];
  }];
  
  currentStep += tutorial.consistsOf.count;
  
  [condition wait];
  InvokeProgressChangedBlockForStepAndIncrementStepCounter(currentStep);
  InvokeCompletionBlockAndUnlockConditionIfErrorAndReturn(condition, topLevelError);

  [condition unlock];
  
  defineWeakSelf();
  [[AuthenticatedServerCommunicationController sharedInstance] submitTutorialForReview:tutorial completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
    InvokeProgressChangedBlockForStepWithSelf(weakSelf, currentStep);
    
    if (error) {
      topLevelError = [NSError genericServerResponseError];
      InvokeCompletionBlockAndUnlockConditionIfErrorAndReturn(condition, topLevelError) ;
    }
    else {
      CallBlock(completion, nil);
    }
  }];
}

+ (void)invokeProgressChagnedBlock:(BlockWithFloatParameter)progressChangedBlock withCurrentStepNumber:(NSInteger)currentStepNumber andTotalNumberOfSteps:(NSInteger)totalNumberOfSteps
{
  AssertTrueOrReturn(progressChangedBlock);
  AssertTrueOrReturn(totalNumberOfSteps > 0);
  AssertTrueOrReturn(currentStepNumber <= totalNumberOfSteps);
  
  if (progressChangedBlock) {
    CGFloat progress = 1.0f / totalNumberOfSteps * currentStepNumber;
    progressChangedBlock(progress);
  }
}

+ (void)lockSignalAndUnlockCondition:(NSCondition *)condition
{
  AssertTrueOrReturn(condition);
  [condition lock];
  [condition signal];
  [condition unlock];
}

+ (void)saveStepsForTutorial:(Tutorial *)tutorial progressChanged:(BlockWithFloatParameter)progressChangedBlock startFromProgressStep:(NSInteger)currentProgressStep totalNumberOfProgressSteps:(NSInteger)totalNumberOfProgressSteps completion:(SaveCompletionBlock)completion
{
  DISPATCH_ASYNC(QueuePriorityHigh, ^{
    [self privateSaveStepsForTutorial:tutorial progressChanged:progressChangedBlock startFromProgressStep:currentProgressStep totalNumberOfProgressSteps:totalNumberOfProgressSteps completion:completion];
  });
}

+ (void)privateSaveStepsForTutorial:(Tutorial *)tutorial progressChanged:(BlockWithFloatParameter)progressChangedBlock startFromProgressStep:(NSInteger)currentProgressStep totalNumberOfProgressSteps:(NSInteger)totalNumberOfProgressSteps completion:(SaveCompletionBlock)completion
{
  AssertTrueOr(tutorial, if(completion) { completion([NSError incorrectParameterError]); } return;);
  
  dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
  __block NSInteger requestsToComplete = tutorial.consistsOfSet.count;
  
  NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
  operationQueue.maxConcurrentOperationCount = 2;
  __block NSError *topLevelError;
  __block NSInteger progressStep = currentProgressStep;
  
  defineWeakSelf();
  [tutorial.consistsOf enumerateObjectsUsingBlock:^(TutorialStep* step, NSUInteger idx, BOOL *stop) {
    [operationQueue addOperationWithBlock:^{
      [[AuthenticatedServerCommunicationController sharedInstance] submitTutorialStep:step withPosition:(idx+1) completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
        
        [weakSelf invokeProgressChagnedBlock:progressChangedBlock withCurrentStepNumber:progressStep andTotalNumberOfSteps:totalNumberOfProgressSteps];
        progressStep++;
        
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
  CallBlock(completion, topLevelError);
}

@end
