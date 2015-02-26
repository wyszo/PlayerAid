//
//  PlayerAid
//
//

#import "SectionsDataSource.h"
#import "Section.h"


@implementation SectionsDataSource

+ (void)setupHardcodedSectionsIfNeedded
{
  [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
    
    // TODO: don't truncate! And recreate only when needed!
    [Section MR_truncateAllInContext:localContext];
    
    Section *sectionKnowledge = [Section MR_createInContext:localContext];
    sectionKnowledge.name = @"Game knowledge";
    sectionKnowledge.sectionDescription = @"The finest football knowledge money can buy";
    
    Section *sectionMentality = [Section MR_createInContext:localContext];
    sectionMentality.name = @"Mentality";
    sectionMentality.sectionDescription = @"How to play without going mental";
    
    Section *sectionTechnique = [Section MR_createInContext:localContext];
    sectionTechnique.name = @"Technique";
    sectionTechnique.sectionDescription = @"How to snapchat while playing";

    Section *sectionPhysical = [Section MR_createInContext:localContext];
    sectionPhysical.name = @"Physical";
    sectionPhysical.sectionDescription = @"How to pump iron without getting bulky";
  }];
}

@end
