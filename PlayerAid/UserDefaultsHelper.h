//
//  PlayerAid
//

@interface UserDefaultsHelper : NSObject

- (void)setObject:(id)object forKeyAndSave:(NSString *)key;
- (id)getObjectForKey:(NSString *)key;

@end
