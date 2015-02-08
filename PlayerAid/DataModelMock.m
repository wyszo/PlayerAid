//
//  PlayerAid
//

#import <NSManagedObject+MagicalFinders.h>
#import <NSManagedObject+MagicalRecord.h>
#import <MagicalRecord/MagicalRecord+Actions.h>
#import <UIKit/UIKit.h>
#import "DataModelMock.h"
#import "Tutorial.h"
#import "User.h"
#import "Section.h"

@implementation DataModelMock

- (void)addDummyTutorialUserAndSectionObjects
{
  [self addDummyUserObject];
  [self addDummySections];
  
  [MagicalRecord saveWithBlockAndWait: ^(NSManagedObjectContext *localContext) {
    // delete all tutorial entities
    [Tutorial MR_truncateAllInContext:localContext];
    
    User *user = [User MR_findFirstInContext:localContext];
    
    [self tutorialInContext:localContext title:@"Dummy tutorial title" forUser:user];
    
    Tutorial *dummyTutorial2 = [self tutorialInContext:localContext title:@"Dummy tutorial title 2" forUser:nil];
    
    Section *section = [Section MR_findFirstInContext:localContext];
    dummyTutorial2.section = section;
    
    [self tutorialInContext:localContext title:@"Dummy tutorial 3" forUser:user];
    
    [self draftTutorialInContext:localContext forUser:user];
    [self inReviewTutorialInContext:localContext forUser:user];
  }];
}

#pragma mark - Mocking Tutorials

- (Tutorial *)draftTutorialInContext:(NSManagedObjectContext *)localContext forUser:(User *)user
{
  Tutorial *tutorial = [self tutorialInContext:localContext title:@"Dummy draft tutorial" forUser:user];
  [tutorial setDraftValue:YES];
  return tutorial;
}

- (Tutorial *)inReviewTutorialInContext:(NSManagedObjectContext *)localContext forUser:(User *)user
{
  Tutorial *tutorial = [self tutorialInContext:localContext title:@"In Review Tutorial" forUser:user];
  [tutorial setInReviewValue:YES];
  return tutorial;
}

- (Tutorial *)tutorialInContext:(NSManagedObjectContext *)localContext title:(NSString *)title forUser:(User *)user
{
  Tutorial *tutorial = [Tutorial MR_createInContext:localContext];
  tutorial.title = title;
  tutorial.state = kTutorialStatePublished;
  tutorial.createdAt = [NSDate new];
  if (user) {
    [user addCreatedTutorialObject:tutorial];
  }
  return tutorial;
}


#pragma mark - Mocking Users

- (void)addDummyUserObject
{
  [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
    [User MR_truncateAllInContext:localContext];
    
    User *user = [User MR_createInContext:localContext];
    user.username = @"Test user";
    user.userDescription = @"The greatest football player of all time!!";
    
    UIImage *userAvatar = [UIImage imageNamed:@"SampleUserAvatar"];
    [user setAvatar:UIImagePNGRepresentation(userAvatar)];
  }];
}

#pragma mark - Mocking Sections

- (void)addDummySections
{
  [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
    [Section MR_truncateAllInContext:localContext];
    
    Section *section = [Section MR_createInContext:localContext];
    section.name = @"Game knowledge";
    section.sectionDescription = @"The finest football knowledge money can buy";
    
    Section *section2 = [Section MR_createInContext:localContext];
    section2.name = @"Mentality";
    section2.sectionDescription = @"How to play without going mental";
  }];
}

@end
