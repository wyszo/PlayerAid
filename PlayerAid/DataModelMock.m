//
//  PlayerAid
//

#import <NSManagedObject+MagicalFinders.h>
#import <NSManagedObject+MagicalRecord.h>
#import <MagicalRecord/MagicalRecord+Actions.h>
#import "DataModelMock.h"
#import "Tutorial.h"
#import "User.h"

@implementation DataModelMock

- (void)addDummyTutorialAndUserObjects
{
  [self addDummyUserObject];
  
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
  }];
}

- (void)addDummyUserObject
{
  [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
    [User MR_truncateAllInContext:localContext];
    
    User *user = [User MR_createInContext:localContext];
    user.username = @"Test user";
    user.userDescription = @"The greatest football player of all time!!";
  }];
}

@end
