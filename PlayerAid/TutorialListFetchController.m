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

- (void)fetchTimelineTutorials
{
  defineWeakSelf();
  [[AuthenticatedServerCommunicationController sharedInstance] listTutorialsWithCompletion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
    [weakSelf showGenericError:(error != nil) orParseTutorialsFromDictionariesArray:responseObject];
  }];

  // TODO: 2. implement retrying and showing blocking alert view
  
  // TODO: 3. change the mechanism for blocking alert view so the users request and tutorial request don't override an alert view shown by another
}

- (void)fetchCurrentUserTutorials {
  User *currentUser = [[UsersFetchController sharedInstance] currentUser];
  AssertTrueOrReturn(currentUser.serverID);

  defineWeakSelf();

  ServerCommunicationController *serverCommunicationController = [AuthenticatedServerCommunicationController sharedInstance].serverCommunicationController;
  [serverCommunicationController listTutorialsForUserId:currentUser.serverID completion:^(NSData *data, NSURLResponse *response, NSError *error) {

      // TODO: pass JSON here!
      id responseObject = nil;

      [weakSelf showGenericError:(error != nil) orParseTutorialsFromDictionariesArray:responseObject];
  }];


//  [[AuthenticatedServerCommunicationController sharedInstance] listTutorialsForUserID:currentUser.serverID completion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
//      [weakSelf showGenericError:(error != nil) orParseTutorialsFromDictionariesArray:responseObject];
//  }];
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
