//
//  PlayerAid
//

#import <XRSA/XRSA.h>
#import "RSAEncoder.h"
#import "EnvironmentSettings.h"

@implementation RSAEncoder

- (nonnull NSString *)encodeString:(nonnull NSString *)string
{
  AssertTrueOrReturnNil(string.length);
  
  NSString *certificatePath = [[EnvironmentSettings new] serverRSACertificatePath];
  AssertTrueOrReturnNil(certificatePath.length);
  
  XRSA *xRsaEncryptor = [[XRSA alloc] initWithPublicKey:certificatePath];
  
  NSString *encrypted = [xRsaEncryptor encryptToString:string];
  AssertTrueOrReturnNil(encrypted.length);
  return encrypted;
}

@end
