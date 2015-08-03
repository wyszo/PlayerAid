//
//  PlayerAid
//

#import "TutorialListFetchController.h"
#import "AuthenticatedServerCommunicationController.h"
#import "TutorialsHelper.h"
#import "AlertFactory.h"


@implementation TutorialListFetchController

SHARED_INSTANCE_GENERATE_IMPLEMENTATION

- (void)fetchTutorials
{
  [[AuthenticatedServerCommunicationController sharedInstance] listTutorialsWithCompletion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
    if (error) {
      [AlertFactory showGenericErrorAlertViewNoRetry];
    }
    else {
      [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        [TutorialsHelper setOfTutorialsFromDictionariesArray:responseObject parseAuthors:YES inContext:localContext];
      }];
    }
  }];
  
  
  // TODO: 2. implement retrying and showing blocking alert view
  
  // TODO: 3. change the mechanism for blocking alert view so the users request and tutorial request don't override an alert view shown by another
}

@end
