//
//  PlayerAid
//

#import "RSAEncoder.h"
#import "EnvironmentSettings.h"
#import "RSA.h"

@implementation RSAEncoder

- (nonnull NSString *)encodeString:(nonnull NSString *)string
{
  AssertTrueOrReturnNil(string.length);

  NSString *publicKey = [[EnvironmentSettings new] serverRSAPublicKey];
  AssertTrueOrReturnNil(publicKey);
  
  NSString *encrypted = [RSA encryptString:string publicKey:publicKey];
  AssertTrueOrReturnNil(encrypted.length);
  return encrypted;
}

@end
