//
//  PlayerAid
//

#import "DataModelMock.h"
#import "Tutorial.h"

#import <NSManagedObject+MagicalFinders.h>
#import <NSManagedObject+MagicalRecord.h>
#import <MagicalRecord/MagicalRecord+Actions.h>


@implementation DataModelMock

- (void)addDummyTutorialObjects
{
  [MagicalRecord saveWithBlockAndWait: ^(NSManagedObjectContext *localContext) {
    // delete all tutorial entities
    [Tutorial MR_truncateAll];
    
    // recreate a dummy tutorial entities
    Tutorial *tutorial = [Tutorial MR_createInContext:localContext];
    tutorial.title = @"Dummy tutorial title";
    
    Tutorial *tutorial2 = [Tutorial MR_createInContext:localContext];
    tutorial2.title = @"Dummy tutorial title 2";
  }];
}

@end
