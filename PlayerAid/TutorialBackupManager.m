//
//  PlayerAid
//

@import KZAsserts;
@import CoreData;
@import MagicalRecord;
@import TWCommonLib;
#import "TutorialBackupManager.h"
#import "NSManagedObject+Clone.h"
#import "Tutorial_Clone.h"
#import "User.h"
#import "Section.h"

@interface TutorialBackupManager ()
@property (strong, nonatomic) NSManagedObjectContext *draftBackupContext;
@property (strong, nonatomic) Tutorial *draftBackup;
@end

@implementation TutorialBackupManager

- (void)backupTutorial:(nonnull Tutorial *)tutorial {
  AssertTrueOrReturn(tutorial);
  
  NSArray *entitiesNamesToExclude = [Tutorial entityClassNamesThatAllowOnlyShallowCopy];
  
  self.draftBackupContext = [NSManagedObjectContext MR_context];
  AssertTrueOrReturn(self.draftBackupContext);
  
  self.draftBackup = (Tutorial *)[tutorial cloneInContext:self.draftBackupContext exludeEntities:entitiesNamesToExclude];
  AssertTrueOrReturn(self.draftBackup);
  
  [self.draftBackup tw_shallowCopyRelationshipsWithClasses:[Tutorial entitiesClassesThatAllowOnlyShallowCopy] fromManagedObject:tutorial];
}

- (void)restoreTutorialFromBackup {
  AssertTrueOrReturn(self.draftBackupContext);
  [self.draftBackupContext MR_saveToPersistentStoreAndWait];
}

@end
