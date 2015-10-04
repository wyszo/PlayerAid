//
//  PlayerAid
//

@import KZAsserts;
@import MagicalRecord;
#import "SectionsDataSource.h"
#import "Section.h"


NSString *const kServerSectionNameGameKnowledge = @"GameKnowledge";
static NSString *const kServerSectionNameMentality = @"Mentality";
static NSString *const kServerSectionNameTechnique = @"Technique";
static NSString *const kServerSectionNamePhysical = @"Physical";
static const NSInteger kTotalNumberOfSections = 4;


@implementation SectionsDataSource

+ (void)setupHardcodedSectionsIfNeedded
{
  __weak typeof(self) weakSelf = self;
  [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
    
    [weakSelf.class recreateIfNeededSectionNamed:kServerSectionNameGameKnowledge withDescription:@"The finest football knowledge money can buy" inContext:localContext];
    [weakSelf.class recreateIfNeededSectionNamed:kServerSectionNameMentality withDescription:@"How to play without going mental" inContext:localContext];
    [weakSelf.class recreateIfNeededSectionNamed:kServerSectionNameTechnique withDescription:@"How to snapchat while playing" inContext:localContext];
    [weakSelf.class recreateIfNeededSectionNamed:kServerSectionNamePhysical withDescription:@"How to pump iron without getting bulky" inContext:localContext];
  }];
  
  AssertTrueOrReturn([Section MR_findAll].count == kTotalNumberOfSections);
}

+ (Section *)recreateIfNeededSectionNamed:(NSString *)sectionName withDescription:(NSString *)description inContext:(NSManagedObjectContext *)localContext
{
  AssertTrueOrReturnNil(sectionName.length);
  
  Section *section = [Section MR_findFirstByAttribute:@"name" withValue:kServerSectionNameGameKnowledge];
  if (!section) {
    section = [Section MR_createInContext:localContext];
    section.name = sectionName;
    section.sectionDescription = description;
  }
  return section;
}

@end
