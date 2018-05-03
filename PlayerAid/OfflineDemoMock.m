//
//  OfflineDemoMock.m
//  PlayerAid
//
//  Created by PlayerAid on 14/01/2018.
//

@import MagicalRecord;
#import "OfflineDemoMock.h"
#import "TutorialsHelper.h"
#import "UsersFetchController.h"

@implementation OfflineDemoMock

SHARED_INSTANCE_GENERATE_IMPLEMENTATION

- (NSDictionary *)mockUser {
  return [self JSONFromFile:@"user"];
}

- (NSArray *)mockGuideDictionaries {
  return [self JSONFromFile:@"guides"][@"data"];
}

- (NSDictionary *)JSONFromFile:(NSString *)filename
{
  NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"json"];
  NSData *data = [NSData dataWithContentsOfFile:path];
  return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

- (void)updateCurrentUserName:(NSString *)userName description:(NSString *)description
{
  [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
    User *user = [UsersFetchController.sharedInstance currentUserInContext:localContext];
    NSAssert(user != nil, @"");
    
    [user setLoggedInUserValue:YES];
    
    user.name = userName;
    user.userDescription = description;
  }];
}

- (void)publishTutorial:(Tutorial *)tutorial {
  [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
    Tutorial* tutorialInContext = [tutorial MR_inContext:localContext];
    NSAssert(tutorialInContext != nil, @"");
    
    tutorialInContext.state = kTutorialStateInReview;
  }];
}

@end
