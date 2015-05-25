//
//  PlayerAid
//

#import "TutorialListFetchController.h"
#import "AuthenticatedServerCommunicationController.h"


@implementation TutorialListFetchController

SHARED_INSTANCE_GENERATE_IMPLEMENTATION

- (void)fetchTutorials
{
  [[AuthenticatedServerCommunicationController sharedInstance] listTutorialsWithCompletion:^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
    if (error) {
      // TODO: show error
      // AlertFactory show...
      NOT_IMPLEMENTED_YET_RETURN
    }
    else {
      // TODO: pass responseObject for further parsing... (should be an array of Tutorial objects)
      // can take UsersController for sample implementation
      NOT_IMPLEMENTED_YET_RETURN
    }
  }];
  
  
  // TODO: 2. implement retrying and showing blocking alert view
  
  // TODO: 3. change the mechanism for blocking alert view so the users request and tutorial request don't override an alert view shown by another
}

@end
