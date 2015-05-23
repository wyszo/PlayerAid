//
//  PlayerAid
//

#import "SectionsDataSource.h"
#import "Section.h"


static NSString *const kGameKnowledgeSectionName = @"Game knowledge";
static NSString *const kMentalitySectionName = @"Mentality";
static NSString *const kTechniqueSectionName = @"Technique";
static NSString *const kPhysicalSectionName = @"Physical";
static const NSInteger kTotalNumberOfSections = 4;


@implementation SectionsDataSource

+ (void)setupHardcodedSectionsIfNeedded
{
  __weak typeof(self) weakSelf = self;
  [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
    
    [weakSelf.class recreateIfNeededSectionNamed:kGameKnowledgeSectionName withDescription:@"The finest football knowledge money can buy" inContext:localContext];
    [weakSelf.class recreateIfNeededSectionNamed:kMentalitySectionName withDescription:@"How to play without going mental" inContext:localContext];
    [weakSelf.class recreateIfNeededSectionNamed:kTechniqueSectionName withDescription:@"How to snapchat while playing" inContext:localContext];
    [weakSelf.class recreateIfNeededSectionNamed:kPhysicalSectionName withDescription:@"How to pump iron without getting bulky" inContext:localContext];
  }];
  
  AssertTrueOrReturn([Section MR_findAll].count == kTotalNumberOfSections);
}

+ (Section *)recreateIfNeededSectionNamed:(NSString *)sectionName withDescription:(NSString *)description inContext:(NSManagedObjectContext *)localContext
{
  AssertTrueOrReturnNil(sectionName.length);
  
  Section *section = [Section MR_findFirstByAttribute:@"name" withValue:kGameKnowledgeSectionName];
  if (!section) {
    section = [Section MR_createInContext:localContext];
    section.name = sectionName;
    section.sectionDescription = description;
  }
  return section;
}

@end
