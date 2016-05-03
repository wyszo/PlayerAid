//
//  PlayerAid
//

@import KZAsserts;
@import MagicalRecord;
#import "TutorialListFetchController.h"
#import "AuthenticatedServerCommunicationController.h"
#import "TutorialsHelper.h"
#import "AlertFactory.h"
#import "UsersFetchController.h"
#import "User.h"
#import "PlayerAid-Swift.h"


@implementation TutorialListFetchController

SHARED_INSTANCE_GENERATE_IMPLEMENTATION

- (void)fetchTimelineTutorialsCompletion:(BlockWithBoolParameter)completion {
  defineWeakSelf();
  [[AuthenticatedServerCommunicationController sharedInstance].serverCommunicationController listGuidesWithCompletion:^(id _Nullable responseObject, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    AssertTrueOrReturn([responseObject isKindOfClass:[NSArray class]]);
    [weakSelf showGenericError:(error != nil) orParseTutorialsFromDictionariesArray:(NSArray *)responseObject];
    CallBlock(completion, (error != nil));
  }];

  // TODO: 2. implement retrying and showing blocking alert view
  
  // TODO: 3. change the mechanism for blocking alert view so the users request and tutorial request don't override an alert view shown by another
}

- (void)fetchCurrentUserTutorials {
  User *currentUser = [[UsersFetchController sharedInstance] currentUser];
  NSInteger userId = currentUser.serverIDValue;
  AssertTrueOrReturn(userId != 0);

  defineWeakSelf();
  ServerCommunicationController *serverCommunicationController = [AuthenticatedServerCommunicationController sharedInstance].serverCommunicationController;
  [serverCommunicationController listGuidesForUserId:userId completion:^(NSArray *jsonResponses, NSURLResponse *response, NSError *error) {
    [weakSelf showGenericError:(error != nil) orParseTutorialsFromDictionariesArray:jsonResponses];
  }];
}

#pragma mark - Private

- (void)showGenericError:(BOOL)showError orParseTutorialsFromDictionariesArray:(NSArray *)tutorialDictionaries {
  AssertTrueOrReturn(tutorialDictionaries);

  if (showError) {
    [AlertFactory showGenericErrorAlertViewNoRetry];
  }
  else {
    [self parseTutorialsFromDictionariesArray:tutorialDictionaries];
  }
}

- (void)parseTutorialsFromDictionariesArray:(NSArray *)tutorialDictionaries {
  AssertTrueOrReturn(tutorialDictionaries);
  [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
      [TutorialsHelper setOfTutorialsFromDictionariesArray:tutorialDictionaries parseAuthors:YES inContext:localContext];
  }];
}

@end
