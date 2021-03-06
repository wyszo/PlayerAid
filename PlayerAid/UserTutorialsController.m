//
//  PlayerAid
//

#import "UserTutorialsController.h"
#import "UsersFetchController.h"
#import "Tutorial.h"

@implementation UserTutorialsController

- (BOOL)loggedInUserHasAnyPublishedOrInReviewTutorials
{
  User *currentUser = [[UsersFetchController sharedInstance] currentUser];
  return [self userHasInReviewOrPublishedTutorials:currentUser];
}

- (BOOL)userHasInReviewOrPublishedTutorials:(User *)user
{
  __block BOOL anyPublishedOrInReviewTutorials;
  
  [user.createdTutorial enumerateObjectsUsingBlock:^(Tutorial *tutorial, BOOL *stop) {
    if (tutorial.draftValue == 0) // if a tutorial is not draft, it means it's either in review (submitted) or published
    {
      anyPublishedOrInReviewTutorials = YES;
      *stop = YES;
    }
  }];
  return anyPublishedOrInReviewTutorials;
}

@end
