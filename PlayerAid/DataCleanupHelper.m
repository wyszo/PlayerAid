//
//  PlayerAid
//

#import "DataCleanupHelper.h"
#import "CoreDataStackHelper.h"

@implementation DataCleanupHelper

#pragma mark - Clearing AppData

- (void)clearUserDefaults
{
  NSString *appBundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
  [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appBundleIdentifier];
}

- (void)deleteAndRecreateCoreDataStore
{
  [CoreDataStackHelper deleteAndRecreateCoreDataStore];
}

@end
