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
    
    // recreate a dummy tutorial entities
    Tutorial *tutorial = [Tutorial MR_createInContext:localContext];
    tutorial.title = @"Dummy tutorial title";
    tutorial.createdAt = [NSDate new];
    
    User *user = [User MR_findFirstInContext:localContext];
    [user addCreatedTutorialObject:tutorial];
    
    Tutorial *tutorial2 = [Tutorial MR_createInContext:localContext];
    tutorial2.title = @"Dummy tutorial title 2";
    tutorial2.createdAt = [NSDate new];
    
    Section *section = [Section MR_findFirstInContext:localContext];
    tutorial2.section = section;
    
    Tutorial *draftTutorial = [Tutorial MR_createInContext:localContext];
    draftTutorial.title = @"Dummy draft tutorial";
    draftTutorial.primitiveDraftValue = YES;
    draftTutorial.createdAt = [NSDate new];
    
    [user addCreatedTutorialObject:draftTutorial];
  }];
}

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
