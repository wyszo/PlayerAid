//
//  PlayerAid
//

#import "UserDefaultsHelper.h"


@interface UserDefaultsHelper ()
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@end


@implementation UserDefaultsHelper

- (void)setObject:(id)object forKeyAndSave:(NSString *)key
{
  AssertTrueOrReturn(object);
  AssertTrueOrReturn(key.length);

  [self.userDefaults setObject:object forKey:key];
  [self.userDefaults synchronize];
}

- (id)getObjectForKey:(NSString *)key
{
  AssertTrueOrReturnNil(key.length);
  return [self.userDefaults objectForKey:key];
}

- (NSUserDefaults *)userDefaults
{
  if (!_userDefaults) {
    _userDefaults = [NSUserDefaults standardUserDefaults];
  }
  return _userDefaults;
}

@end
