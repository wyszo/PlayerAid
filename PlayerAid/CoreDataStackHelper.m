//
//  PlayerAid
//

@import KZAsserts;
@import MagicalRecord;
#import "CoreDataStackHelper.h"
#import "SectionsDataSource.h"


@implementation CoreDataStackHelper

+ (void)setupCoreDataStack
{
  [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:self.persistentStoreName];
  [SectionsDataSource setupHardcodedSectionsIfNeedded];
}

+ (void)deleteAndRecreateCoreDataStore
{
  [self deleteCoreDataStore];
  [self setupCoreDataStack];
}

+ (void)deleteCoreDataStore
{
  NSURL *storeURL = [NSPersistentStore MR_urlForStoreName:self.persistentStoreName];
  [MagicalRecord cleanUp];
  
  NSError *error = nil;
  BOOL storeRemoved = [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
  AssertTrueOrReturn(storeRemoved);
}

+ (NSString *)persistentStoreName
{
  return @"PlayerAidStore.sqlite";
}

@end
