//
//  PlayerAid
//

#import <NSManagedObject+MagicalFinders.h>
#import <NSManagedObject+MagicalRecord.h>
#import <MagicalRecord/MagicalRecord+Actions.h>
#import <KZAsserts.h>
#import <UIKit/UIKit.h>
#import "DataModelMock.h"
#import "Tutorial.h"
#import "User.h"
#import "Section.h"
#import "TutorialStep.h"
#import "MockedServerResponses.h"


@implementation DataModelMock

- (void)addDummyTutorialUserAndSectionObjects
{
  [self addDummyUserObject];
  [self addDummySections];
  
  [MagicalRecord saveWithBlockAndWait: ^(NSManagedObjectContext *localContext) {
    // delete all tutorial entities
    [Tutorial MR_truncateAllInContext:localContext];
    
    User *user = [User MR_findFirstInContext:localContext];
    
    Tutorial *tutorial = [self tutorialInContext:localContext title:@"Dummy tutorial title" forUser:user];
    TutorialStep *step = [self tutorialStepInContext:localContext];
    [tutorial addConsistsOfObject:step];
    
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
  tutorial.primitiveDraftValue = YES;
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

#pragma mark - Mocking Tutorial Steps

- (TutorialStep *)tutorialStepInContext:(NSManagedObjectContext *)localContext
{
  TutorialStep *step = [TutorialStep MR_createInContext:localContext];
  step.text = @"Sample text tutorial step. Football is all about scoring!";
  return step;
}

#pragma mark - Mocking Users

- (void)addDummyUserObject
{
  NSDictionary *mockedUserDictionary = [MockedServerResponses postUserResponse];
  AssertTrueOrReturn(mockedUserDictionary.count);
  
  [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
    [User MR_truncateAllInContext:localContext];
    
    User *user = [User MR_createInContext:localContext];
    [user configureFromDictionary:mockedUserDictionary];
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
