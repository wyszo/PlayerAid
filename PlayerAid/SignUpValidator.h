//
//  PlayerAid
//

/**
 Email validation rules:
 - length > 3
 - contains '@' character
 - has a sufix (meaning: contains dot '.' character after '@'
 
 Password validation rules: 
  TODO
 */
@interface SignUpValidator : NSObject

- (BOOL)signUpDataValidWithEmail:(nonnull NSString *)email password:(nonnull NSString *)password;

@end
