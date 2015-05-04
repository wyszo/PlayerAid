//
//  PlayerAid
//

#import "PersistedUsersProperties.h"
#import "UserDefaultsHelper.h"

static NSString *const kTakePhotoGridEnabledKey = @"TakePhotoGridEnabled";


@implementation PersistedUsersProperties

// TODO: move this to CommonMacros!
+ (instancetype)sharedInstance
{
  static id sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

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
