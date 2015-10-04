//
//  PlayerAid
//

@import Foundation;

/**
 Email validation rules:
 - length > 3
 - contains '@' character
 - has a sufix (meaning: contains dot '.' character after '@')
 - contains at least one character before '@'
 
 Password validation rules: 
 - length >= 6
 */
@interface SignUpValidator : NSObject

- (BOOL)validateEmail:(nonnull NSString *)email;
- (BOOL)validatePassword:(nonnull NSString *)password;

@end
