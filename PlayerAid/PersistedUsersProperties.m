//
//  PlayerAid
//

#import "PersistedUsersProperties.h"
#import "UserDefaultsHelper.h"

static NSString *const kTakePhotoGridEnabledKey = @"TakePhotoGridEnabled";


@implementation PersistedUsersProperties

SHARED_INSTANCE_GENERATE_IMPLEMENTATION

#pragma mark - gridEnabled

- (BOOL)gridEnabled
{
  return [self getUserDefaultsGridEnabled];
}

- (void)setGridEnabled:(BOOL)gridEnabled
{
  [self saveInUserDefaultsGridEnabled:gridEnabled];
}

- (void)saveInUserDefaultsGridEnabled:(BOOL)gridEnabled
{
  [[UserDefaultsHelper new] setObject:@(gridEnabled) forKeyAndSave:kTakePhotoGridEnabledKey];
}

- (BOOL)getUserDefaultsGridEnabled
{
  return [[[UserDefaultsHelper new] getObjectForKey:kTakePhotoGridEnabledKey] boolValue];
}

@end
